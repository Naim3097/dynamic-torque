# MNA Dynamic Torque — Flutter Admin Dashboard Specification

> **Platform:** Flutter (Web + Desktop + Mobile)  
> **Purpose:** Internal admin/team dashboard for spare parts management, inventory, sales, and accounting  
> **Relates to:** `dynamic-web-app.md` (customer-facing React app) and `ui-ux.md` (design system)  
> **Status:** Later development phase

---

## 1. Overview

The Flutter admin dashboard is the internal SaaS tool used by the Dynamic Torque team to manage every aspect of the marketplace backend — products, inventory, orders, customers, financials, and notifications. It connects to the same Firebase backend as the React web app.

---

## 2. Tech Stack

| Layer              | Technology                                        |
|--------------------|---------------------------------------------------|
| Framework          | Flutter 3.x (Web primary, Desktop secondary)      |
| Language           | Dart                                              |
| State Management   | Riverpod 2.x (or Bloc)                            |
| Routing            | GoRouter                                          |
| Backend            | Firebase (shared with React web app)              |
| Auth               | Firebase Authentication (Admin role-gated)        |
| Database           | Cloud Firestore                                   |
| Storage            | Firebase Cloud Storage                            |
| Notifications      | Firebase Cloud Messaging (send to customers)      |
| Charts             | fl_chart                                          |
| PDF Generation     | pdf / printing packages                           |
| Excel Export       | syncfusion_flutter_xlsio or csv                   |
| Local Storage      | shared_preferences / Hive                         |
| HTTP               | dio (for any REST endpoints)                      |
| Testing            | flutter_test + integration_test + mockito          |

---

## 3. Project Structure

```
dynamic-torque-admin/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── router.dart
│   ├── config/
│   │   ├── firebase_config.dart
│   │   ├── theme.dart                   # Brand theme from ui-ux.md
│   │   └── constants.dart
│   ├── models/
│   │   ├── product_model.dart
│   │   ├── order_model.dart
│   │   ├── user_model.dart
│   │   ├── inventory_log_model.dart
│   │   ├── transaction_model.dart
│   │   └── notification_model.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── product_provider.dart
│   │   ├── order_provider.dart
│   │   ├── inventory_provider.dart
│   │   ├── customer_provider.dart
│   │   ├── analytics_provider.dart
│   │   └── notification_provider.dart
│   ├── services/
│   │   ├── firebase_service.dart
│   │   ├── auth_service.dart
│   │   ├── product_service.dart
│   │   ├── order_service.dart
│   │   ├── inventory_service.dart
│   │   ├── analytics_service.dart
│   │   ├── notification_service.dart
│   │   └── export_service.dart          # PDF/Excel generation
│   ├── screens/
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart    # Main overview
│   │   ├── products/
│   │   │   ├── product_list_screen.dart
│   │   │   ├── product_detail_screen.dart
│   │   │   └── product_form_screen.dart # Add/Edit
│   │   ├── inventory/
│   │   │   ├── inventory_screen.dart
│   │   │   └── stock_adjustment_screen.dart
│   │   ├── orders/
│   │   │   ├── order_list_screen.dart
│   │   │   └── order_detail_screen.dart
│   │   ├── customers/
│   │   │   ├── customer_list_screen.dart
│   │   │   └── customer_detail_screen.dart
│   │   ├── accounts/
│   │   │   ├── profit_loss_screen.dart
│   │   │   ├── transactions_screen.dart
│   │   │   └── reports_screen.dart
│   │   ├── notifications/
│   │   │   └── notification_composer_screen.dart
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       └── team_management_screen.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── sidebar_nav.dart
│   │   │   ├── top_bar.dart
│   │   │   ├── stat_card.dart
│   │   │   ├── data_table_widget.dart
│   │   │   ├── search_bar_widget.dart
│   │   │   ├── status_badge.dart
│   │   │   └── confirm_dialog.dart
│   │   ├── charts/
│   │   │   ├── sales_chart.dart
│   │   │   ├── revenue_chart.dart
│   │   │   ├── stock_level_chart.dart
│   │   │   └── category_pie_chart.dart
│   │   └── forms/
│   │       ├── product_form.dart
│   │       ├── stock_adjustment_form.dart
│   │       └── notification_form.dart
│   └── utils/
│       ├── formatters.dart
│       ├── validators.dart
│       └── extensions.dart
├── assets/
│   └── logo.png
├── test/
├── pubspec.yaml
└── README.md
```

---

## 4. Admin Roles & Permissions

| Role          | Access                                                        |
|---------------|---------------------------------------------------------------|
| Super Admin   | Full access — all modules, team management, settings          |
| Manager       | Products, inventory, orders, customers, reports (no settings) |
| Sales Staff   | Orders (view/update), customers (view), limited reports       |
| Warehouse     | Inventory only — stock counts, adjustments, receiving         |

### Auth Flow
- Firebase Authentication (email/password only for admin)
- Custom claims in Firebase for role assignment: `{ role: 'super_admin' }`
- Role-based route guards in GoRouter
- Session timeout after 30 minutes of inactivity

---

## 5. Module Specifications

### 5.1 Dashboard (Home)

The main overview screen showing key business metrics at a glance.

**KPI Stat Cards (top row):**
| Card               | Data Source           | Visual                  |
|--------------------|-----------------------|-------------------------|
| Total Revenue      | Sum of paid orders    | Currency + trend arrow  |
| Orders Today       | Today's order count   | Number + comparison     |
| Low Stock Items    | Products below threshold | Red count badge      |
| Pending Orders     | Unprocessed orders    | Amber count badge       |

**Charts:**
- **Sales Over Time:** Line chart (daily/weekly/monthly toggle) — revenue vs orders
- **Revenue by Category:** Pie chart — 8 categories (clutch plate, steel plate, etc.)
- **Stock Levels:** Horizontal bar chart — stock qty per category
- **Top Selling Products:** Ranked list (top 10)

**Quick Actions:**
- Add new product
- View pending orders
- Send notification
- Generate report

**Recent Activity Feed:**
- Last 10 orders with status
- Low stock alerts
- New customer registrations

---

### 5.2 Product Management (CRUD)

**Product List Screen:**
- Searchable, sortable data table
- Columns: Image (thumbnail), Name, SKU, Category, Price, Wholesale Price, Stock Qty, Status, Actions
- Filters: Category, stock status, active/inactive
- Bulk actions: Activate, deactivate, delete (with confirmation)
- Export to CSV/Excel

**Product Form (Add/Edit):**
| Field                | Type              | Validation                      |
|----------------------|-------------------|---------------------------------|
| Name                 | Text              | Required, 3-100 chars           |
| SKU                  | Text              | Required, unique, pattern DT-XX-XXXX |
| Category             | Dropdown          | Required, from 8 categories     |
| Description          | Rich text         | Required                        |
| Specifications       | Key-value pairs   | Dynamic rows                    |
| Compatible Vehicles  | Multi-select/tags | Optional                        |
| Compatible Gearboxes | Multi-select/tags | Optional                        |
| Retail Price         | Number            | Required, > 0                   |
| Wholesale Price      | Number            | Optional, < retail price        |
| Min Wholesale Qty    | Number            | Required if wholesale price set |
| Images               | File upload       | Max 5, max 5MB each, jpg/png/webp |
| Low Stock Threshold  | Number            | Required, default 10            |
| Is Featured          | Toggle            | Default false                   |
| Is Active            | Toggle            | Default true                    |
| Tags                 | Tag input         | Optional                        |

---

### 5.3 Inventory Management

**Inventory Overview Screen:**
- Full product inventory table with real-time stock counts
- Color-coded rows: Green (healthy), Amber (low), Red (out of stock)
- Stock level summary cards per category
- Quick stock adjustment inline

**Stock Adjustment Screen:**
| Field            | Type      | Notes                                    |
|------------------|-----------|------------------------------------------|
| Product          | Search    | Autocomplete by name/SKU                 |
| Adjustment Type  | Dropdown  | Stock In, Stock Out, Correction, Return  |
| Quantity         | Number    | Positive integer                         |
| Reason           | Text      | Required                                 |
| Reference        | Text      | PO number, invoice number, etc.          |
| Date             | Date      | Defaults to today                        |

**Inventory Log:**
- Audit trail of all stock movements
- Filterable by product, date range, adjustment type
- Shows: Date, Product, SKU, Type, Qty Change, New Balance, User, Reason

**Stock Counter Feature:**
| Counter            | Calculation                             |
|--------------------|-----------------------------------------|
| Total SKUs         | Count of active products                |
| Total Units        | Sum of all stock quantities             |
| Low Stock Count    | Products where qty < threshold          |
| Out of Stock Count | Products where qty = 0                  |
| Stock Value        | Sum of (qty × cost price) per product   |

---

### 5.4 Order Management

**Order List Screen:**
- Data table with search, sort, filter
- Columns: Order #, Date, Customer, Type (B2B/B2C), Items Count, Total, Payment Status, Order Status, Actions
- Filters: Status, date range, payment status, customer type
- Quick status update dropdown per row

**Order Detail Screen:**
- Order header: Order #, date, customer info, account type
- Line items table: Product, SKU, Qty, Unit Price, Line Total
- Order summary: Subtotal, discount, shipping, tax, total
- Status timeline (visual stepper): Pending → Confirmed → Processing → Shipped → Delivered
- Actions: Update status, add tracking number, cancel (with reason), generate invoice
- Notes section (internal team notes)

**Order Status Transitions:**
```
Pending → Confirmed → Processing → Shipped → Delivered
              ↓                       ↓
           Cancelled              Cancelled
```
- Each transition triggers FCM push notification to customer (via React web app)

---

### 5.5 Customer Management

**Customer List Screen:**
- Data table: Name, Email, Type (B2B/B2C), Business Name, Total Orders, Total Spent, Verified, Joined Date
- Filter by account type, verification status
- Search by name, email, business name

**Customer Detail Screen:**
- Profile info (read-only, editable by admin)
- B2B verification toggle (approve/reject pending B2B accounts)
- Order history for this customer
- Total spend and order frequency analytics
- Credit terms and notes (B2B)
- Communication log

---

### 5.6 Account Management (Profit & Loss)

**P&L Dashboard:**
| Metric            | Calculation                                     |
|-------------------|-------------------------------------------------|
| Gross Revenue     | Sum of all paid order totals                    |
| Cost of Goods     | Sum of (qty sold × cost price) per product      |
| Gross Profit      | Revenue - COGS                                  |
| Operating Expenses| Manual entries (rent, staff, shipping, etc.)    |
| Net Profit        | Gross Profit - Operating Expenses               |
| Profit Margin     | (Net Profit / Revenue) × 100                    |

**Transactions Screen:**
| Field         | Type                                            |
|---------------|-------------------------------------------------|
| Date          | Timestamp                                       |
| Type          | Income / Expense                                |
| Category      | Sales, Refund, Shipping, Rent, Wages, Utilities, Supplies, Other |
| Description   | Free text                                       |
| Amount        | Number                                          |
| Reference     | Order ID / Invoice number / Receipt              |
| Recorded By   | User ID of admin                                |

**Reports Screen:**
- **P&L Statement:** Date range selector, generates formatted P&L report
- **Sales Report:** Revenue by category, by time period, by customer type
- **Inventory Valuation:** Current stock value by category
- **Top Products Report:** Best sellers by quantity and revenue
- **Customer Report:** New vs returning, B2B vs B2C breakdown
- All reports exportable to **PDF** and **Excel**

**Charts:**
- Revenue vs Expenses (line — monthly)
- Profit Trend (bar — monthly)
- Revenue by Category (pie)
- Expense Breakdown (donut)

---

### 5.7 Notification Composer

Send push notifications to customers via Firebase Cloud Messaging.

**Compose Form:**
| Field         | Type                | Notes                           |
|---------------|---------------------|---------------------------------|
| Title         | Text                | Max 65 chars                    |
| Body          | Text                | Max 240 chars                   |
| Image URL     | URL / Upload        | Optional                        |
| Target        | Radio               | All users, B2B only, B2C only, Specific user |
| Deep Link     | Dropdown + text     | Product page, category, order   |
| Schedule      | DateTime            | Optional — send now or schedule |

**Notification History:**
- List of all sent notifications
- Stats: Sent count, Delivered, Opened (if available via FCM analytics)

---

### 5.8 Settings

- **Business Profile:** Company name, address, tax ID, logo
- **Team Management:** Invite/remove admin users, assign roles
- **Email Templates:** Customize order confirmation, shipping, etc.
- **Tax Settings:** Tax rates per region
- **Shipping Settings:** Shipping methods, rates, free shipping threshold
- **Notification Settings:** Default templates, auto-notification rules
- **Data Export:** Full database export (backup)

---

## 6. Data Models (Dart)

### 6.1 Product Model
```dart
class Product {
  final String id;
  final String name;
  final String slug;
  final String sku;
  final String category; // ProductCategory enum
  final String description;
  final Map<String, String> specifications;
  final List<String> compatibleVehicles;
  final List<String> compatibleGearboxes;
  final double price;
  final double? wholesalePrice;
  final int? minWholesaleQty;
  final String currency;
  final List<String> images;
  final String thumbnailUrl;
  final int stockQty;
  final String stockStatus; // in_stock, low_stock, out_of_stock
  final int lowStockThreshold;
  final double? costPrice; // Admin only — for P&L calculations
  final List<String> tags;
  final bool isFeatured;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### 6.2 Inventory Log Model
```dart
class InventoryLog {
  final String id;
  final String productId;
  final String productSku;
  final String productName;
  final String adjustmentType; // stock_in, stock_out, correction, return
  final int quantityChange;    // +/- value
  final int balanceAfter;
  final String reason;
  final String? reference;
  final String performedBy;    // admin user ID
  final DateTime createdAt;
}
```

### 6.3 Transaction Model (Accounting)
```dart
class Transaction {
  final String id;
  final String type;        // income, expense
  final String category;    // sales, refund, shipping, rent, wages, etc.
  final String description;
  final double amount;
  final String? reference;  // order ID or invoice
  final String currency;
  final String recordedBy;
  final DateTime date;
  final DateTime createdAt;
}
```

---

## 7. Theme Configuration (Flutter)

```dart
// config/theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const bgPrimary = Color(0xFF0B1A2E);
  static const bgSecondary = Color(0xFF132D4A);
  static const blueMid = Color(0xFF1E5F8C);
  static const blueBright = Color(0xFF2A8FD4);
  static const blueLight = Color(0xFF6BB8E0);
  static const redAccent = Color(0xFFD42B2B);
  static const redHover = Color(0xFFB52222);
  static const surface = Color(0xFF162E48);
  static const textMuted = Color(0xFFA0B4C8);
  static const steel = Color(0xFF8FAABE);
  static const white = Color(0xFFFFFFFF);

  // Semantic
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
}

ThemeData buildAdminTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    primaryColor: AppColors.blueBright,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blueBright,
      secondary: AppColors.redAccent,
      surface: AppColors.bgSecondary,
      error: AppColors.error,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgSecondary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.blueMid),
      ),
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.blueMid),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.blueBright, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blueBright,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );
}
```

---

## 8. Admin Layout

```
┌──────────────────────────────────────────────────────────┐
│  Top Bar: [Logo] [Search] [Notifications] [User Avatar]  │
├──────────┬───────────────────────────────────────────────┤
│          │                                               │
│ Sidebar  │          Main Content Area                    │
│          │                                               │
│ ● Dashboard   │  (Renders active screen)                 │
│ ● Products    │                                          │
│ ● Inventory   │                                          │
│ ● Orders      │                                          │
│ ● Customers   │                                          │
│ ● Accounts    │                                          │
│ ● Notifications│                                         │
│ ● Settings    │                                          │
│          │                                               │
│          │                                               │
├──────────┴───────────────────────────────────────────────┤
│  Status Bar: [Connected ●] [v1.0.0] [Last sync: 12:00]  │
└──────────────────────────────────────────────────────────┘
```

- **Sidebar:** Collapsible (icon-only mode on smaller screens)
- **Top bar:** Fixed, includes global search and notification bell
- **Content area:** Scroll-independent from sidebar
- **Responsive:** Sidebar becomes drawer on tablets, bottom nav on mobile

---

## 9. Inventory Seed Data

Based on the spare parts categories from the marketplace:

| Category       | SKU Example    | Product Example                    | Cost   | Retail | Wholesale | Stock |
|----------------|----------------|------------------------------------|--------|--------|-----------|-------|
| Clutch Plate   | DT-CP-0001     | AT Clutch Friction Plate 3.5mm     | 15.00  | 28.00  | 22.00     | 150   |
| Clutch Plate   | DT-CP-0002     | HD Clutch Disc A750E               | 18.00  | 35.00  | 28.00     | 85    |
| Steel Plate    | DT-SP-0001     | Steel Separator Plate 1.8mm        | 8.00   | 16.00  | 12.00     | 200   |
| Steel Plate    | DT-SP-0002     | Waved Steel Plate A340             | 10.00  | 20.00  | 15.00     | 120   |
| Auto Filter    | DT-AF-0001     | ATF Inline Filter Universal        | 5.00   | 12.00  | 9.00      | 300   |
| Auto Filter    | DT-AF-0002     | Pan Transmission Filter Kit        | 12.00  | 25.00  | 19.00     | 95    |
| Forward Drum   | DT-FD-0001     | Forward Clutch Drum A750E          | 65.00  | 120.00 | 95.00     | 25    |
| Forward Drum   | DT-FD-0002     | Forward Drum Shell Assembly        | 55.00  | 105.00 | 85.00     | 18    |
| Oil Pump       | DT-OP-0001     | Front Oil Pump Body A340           | 80.00  | 150.00 | 120.00    | 15    |
| Oil Pump       | DT-OP-0002     | Oil Pump Gear Set                  | 45.00  | 85.00  | 68.00     | 30    |
| Piston Seal    | DT-PS-0001     | Bonded Piston Seal Kit A750E       | 6.00   | 14.00  | 10.00     | 250   |
| Piston Seal    | DT-PS-0002     | D-Ring Seal Assortment             | 4.00   | 10.00  | 7.50      | 400   |
| Overhaul Kit   | DT-OK-0001     | Master Rebuild Kit A750E           | 120.00 | 250.00 | 195.00    | 20    |
| Overhaul Kit   | DT-OK-0002     | Banner Kit A340 (Gaskets + Seals)  | 80.00  | 160.00 | 128.00    | 35    |
| Lubricants     | DT-LB-0001     | ATF Dexron VI (1L)                 | 8.00   | 18.00  | 14.00     | 500   |
| Lubricants     | DT-LB-0002     | CVT Fluid NS-3 (1L)               | 10.00  | 22.00  | 17.00     | 350   |

---

## 10. Firebase Security Rules (Admin)

```javascript
// Firestore rules — admin sections
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper: check if user is admin
    function isAdmin() {
      return request.auth != null &&
             request.auth.token.role in ['super_admin', 'manager', 'sales', 'warehouse'];
    }

    function isSuperAdmin() {
      return request.auth != null &&
             request.auth.token.role == 'super_admin';
    }

    // Products — admins can CRUD, customers can read active only
    match /products/{productId} {
      allow read: if true;  // public catalog
      allow write: if isAdmin();
    }

    // Orders — admins can read all, customers read own
    match /orders/{orderId} {
      allow read: if isAdmin() || request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
      allow update: if isAdmin();
    }

    // Inventory logs — admin only
    match /inventoryLogs/{logId} {
      allow read, write: if isAdmin();
    }

    // Transactions — admin only
    match /transactions/{txId} {
      allow read, write: if isAdmin();
    }

    // Users — admin can read all, user can read/write own
    match /users/{userId} {
      allow read: if isAdmin() || request.auth.uid == userId;
      allow write: if request.auth.uid == userId;
      allow update: if isAdmin();  // for B2B verification etc.
    }

    // Settings — super admin only
    match /settings/{doc} {
      allow read: if isAdmin();
      allow write: if isSuperAdmin();
    }
  }
}
```

---

## 11. Development Phases (Flutter Admin)

### Phase 1 — Core Admin MVP
- [ ] Flutter project setup + Firebase integration
- [ ] Admin authentication + role-based routing
- [ ] Dashboard screen with KPI cards
- [ ] Product CRUD (list, add, edit, deactivate)
- [ ] Basic inventory view with stock counts
- [ ] Order list + detail + status updates
- [ ] Deploy to Firebase Hosting (Flutter web)

### Phase 2 — Inventory & Customers
- [ ] Stock adjustment module with audit log
- [ ] Low stock alerts and threshold management
- [ ] Customer list + B2B verification workflow
- [ ] Stock counters and inventory valuation
- [ ] Notification composer (send FCM to customers)

### Phase 3 — Accounting & Reports
- [ ] Transaction entry (income/expense)
- [ ] P&L statement generator
- [ ] Sales reports with date range
- [ ] Inventory valuation reports
- [ ] PDF and Excel export
- [ ] Dashboard charts (sales, revenue, stock)

### Phase 4 — Polish & Advanced
- [ ] Team management (invite, roles, permissions)
- [ ] Settings module (tax, shipping, templates)
- [ ] Audit log for all admin actions
- [ ] Desktop app build (Windows/macOS)
- [ ] Mobile-optimized responsive layout
- [ ] Data backup and restore
- [ ] Multi-language admin interface

---

## 12. Integration Points (React ↔ Flutter)

Both apps share the same Firebase project:

| Shared Resource        | Used By                 |
|------------------------|-------------------------|
| Firestore `/products`  | React (read), Flutter (CRUD) |
| Firestore `/orders`    | React (create), Flutter (manage) |
| Firestore `/users`     | React (own profile), Flutter (all users) |
| Firebase Storage       | React (display), Flutter (upload) |
| FCM                    | React (receive), Flutter (send) |
| Firebase Auth          | Both (different user pools via custom claims) |

**Rule:** The React web app is the **customer-facing storefront**. The Flutter app is the **back-office**. No admin features should exist in the React app. No shopping/checkout features should exist in the Flutter app.
