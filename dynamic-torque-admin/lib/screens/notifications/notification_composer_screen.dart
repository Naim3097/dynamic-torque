import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../utils/formatters.dart';

class NotificationComposerScreen extends StatefulWidget {
  const NotificationComposerScreen({super.key});

  @override
  State<NotificationComposerScreen> createState() =>
      _NotificationComposerScreenState();
}

class _NotificationComposerScreenState
    extends State<NotificationComposerScreen> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String _target = 'all'; // all, b2b, b2c
  bool _sending = false;
  String? _result;
  String? _error;

  // History
  List<Map<String, dynamic>> _history = [];
  bool _loadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final data = await NotificationService.instance.fetchBroadcasts();
      if (!mounted) return;
      setState(() {
        _history = data;
        _loadingHistory = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loadingHistory = false);
    }
  }

  Future<void> _send() async {
    if (_titleCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Title and body are required');
      return;
    }

    setState(() {
      _sending = true;
      _error = null;
      _result = null;
    });

    try {
      final auth = context.read<AuthService>();
      final res = await NotificationService.instance.sendPush(
        target: _target,
        title: _titleCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
        type: 'promotion',
      );

      await NotificationService.instance.recordBroadcast(
        title: _titleCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
        target: _target,
        createdBy: auth.currentAdmin?.id,
      );

      final recipients = res['recipients'] ?? 0;
      final tokens = res['tokens_pushed'] ?? 0;

      setState(() {
        _result = 'Sent to $recipients recipients ($tokens device tokens)';
        _titleCtrl.clear();
        _bodyCtrl.clear();
      });

      _loadHistory();
    } catch (e) {
      setState(() => _error = 'Failed: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compose form
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x10FFFFFF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Compose Notification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Send push notifications to customers',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 24),

                // Title
                const Text('Title',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted)),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleCtrl,
                  maxLength: 65,
                  style:
                      const TextStyle(color: AppColors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Notification title',
                    counterStyle:
                        TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 16),

                // Body
                const Text('Body',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted)),
                const SizedBox(height: 8),
                TextField(
                  controller: _bodyCtrl,
                  maxLength: 240,
                  maxLines: 3,
                  style:
                      const TextStyle(color: AppColors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Notification body text',
                    counterStyle:
                        TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 16),

                // Target
                const Text('Target audience',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _targetChip('all', 'All Users'),
                    _targetChip('b2b', 'B2B Only'),
                    _targetChip('b2c', 'B2C Only'),
                  ],
                ),

                const SizedBox(height: 24),

                if (_error != null) ...[
                  Text(_error!,
                      style: const TextStyle(
                          color: AppColors.error, fontSize: 13)),
                  const SizedBox(height: 12),
                ],

                if (_result != null) ...[
                  Text(_result!,
                      style: const TextStyle(
                          color: AppColors.success, fontSize: 13)),
                  const SizedBox(height: 12),
                ],

                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _sending ? null : _send,
                    child: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.white),
                          )
                        : const Text('Send Notification'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // History
          const Text(
            'Broadcast History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),

          if (_loadingHistory)
            const Center(child: CircularProgressIndicator())
          else if (_history.isEmpty)
            const Text('No broadcasts sent yet.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted))
          else
            ..._history.map((b) {
              final sentAt = b['sent_at'] != null
                  ? formatDateTime(DateTime.parse(b['sent_at'] as String))
                  : 'Scheduled';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x10FFFFFF)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b['title'] as String? ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            b['body'] as String? ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.blueBright.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            (b['target'] as String? ?? 'all').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blueBright,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sentAt,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _targetChip(String value, String label) {
    final selected = _target == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _target = value),
      selectedColor: AppColors.blueBright,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        fontSize: 13,
        color: selected ? AppColors.white : AppColors.textMuted,
      ),
      side: BorderSide(
        color: selected ? AppColors.blueBright : const Color(0x10FFFFFF),
      ),
    );
  }
}
