// AUTO-GENERATED from Supabase schema. Do not edit by hand.
// Regenerate with: supabase gen types typescript --project-id qhgrwuvbebxykqhenjyd > src/types/database.ts

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      addresses: {
        Row: {
          city: string
          country: string
          created_at: string
          id: string
          is_default: boolean
          label: string
          line1: string
          line2: string | null
          postal_code: string
          state: string
          user_id: string
        }
        Insert: {
          city: string
          country?: string
          created_at?: string
          id?: string
          is_default?: boolean
          label?: string
          line1: string
          line2?: string | null
          postal_code: string
          state: string
          user_id: string
        }
        Update: {
          city?: string
          country?: string
          created_at?: string
          id?: string
          is_default?: boolean
          label?: string
          line1?: string
          line2?: string | null
          postal_code?: string
          state?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "addresses_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      admin_users: {
        Row: { created_at: string; role: string; user_id: string }
        Insert: { created_at?: string; role: string; user_id: string }
        Update: { created_at?: string; role?: string; user_id?: string }
        Relationships: []
      }
      cart_items: {
        Row: {
          cart_id: string
          created_at: string
          id: string
          product_id: string
          quantity: number
          unit_price: number
        }
        Insert: {
          cart_id: string
          created_at?: string
          id?: string
          product_id: string
          quantity: number
          unit_price: number
        }
        Update: {
          cart_id?: string
          created_at?: string
          id?: string
          product_id?: string
          quantity?: number
          unit_price?: number
        }
        Relationships: []
      }
      carts: {
        Row: { id: string; promo_code: string | null; updated_at: string; user_id: string }
        Insert: { id?: string; promo_code?: string | null; updated_at?: string; user_id: string }
        Update: { id?: string; promo_code?: string | null; updated_at?: string; user_id?: string }
        Relationships: []
      }
      categories: {
        Row: {
          created_at: string
          description: string | null
          id: string
          name: string
          slug: string
          sort_order: number
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          name: string
          slug: string
          sort_order?: number
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          name?: string
          slug?: string
          sort_order?: number
        }
        Relationships: []
      }
      fcm_tokens: {
        Row: {
          created_at: string
          id: string
          last_seen_at: string
          platform: string
          token: string
          user_agent: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          last_seen_at?: string
          platform: string
          token: string
          user_agent?: string | null
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          last_seen_at?: string
          platform?: string
          token?: string
          user_agent?: string | null
          user_id?: string
        }
        Relationships: []
      }
      inventory_logs: {
        Row: {
          adjustment_type: string
          balance_after: number
          created_at: string
          id: string
          performed_by: string | null
          product_id: string
          product_name: string
          product_sku: string
          quantity_change: number
          reason: string
          reference: string | null
        }
        Insert: {
          adjustment_type: string
          balance_after: number
          created_at?: string
          id?: string
          performed_by?: string | null
          product_id: string
          product_name: string
          product_sku: string
          quantity_change: number
          reason?: string
          reference?: string | null
        }
        Update: {
          adjustment_type?: string
          balance_after?: number
          created_at?: string
          id?: string
          performed_by?: string | null
          product_id?: string
          product_name?: string
          product_sku?: string
          quantity_change?: number
          reason?: string
          reference?: string | null
        }
        Relationships: []
      }
      notification_broadcasts: {
        Row: {
          body: string
          created_at: string
          created_by: string | null
          deep_link: string | null
          id: string
          image_url: string | null
          scheduled_at: string | null
          sent_at: string | null
          target: string
          target_user_id: string | null
          title: string
        }
        Insert: {
          body: string
          created_at?: string
          created_by?: string | null
          deep_link?: string | null
          id?: string
          image_url?: string | null
          scheduled_at?: string | null
          sent_at?: string | null
          target: string
          target_user_id?: string | null
          title: string
        }
        Update: {
          body?: string
          created_at?: string
          created_by?: string | null
          deep_link?: string | null
          id?: string
          image_url?: string | null
          scheduled_at?: string | null
          sent_at?: string | null
          target?: string
          target_user_id?: string | null
          title?: string
        }
        Relationships: []
      }
      notifications: {
        Row: {
          body: string
          created_at: string
          data: Json
          id: string
          image_url: string | null
          is_read: boolean
          title: string
          type: string
          user_id: string
        }
        Insert: {
          body: string
          created_at?: string
          data?: Json
          id?: string
          image_url?: string | null
          is_read?: boolean
          title: string
          type: string
          user_id: string
        }
        Update: {
          body?: string
          created_at?: string
          data?: Json
          id?: string
          image_url?: string | null
          is_read?: boolean
          title?: string
          type?: string
          user_id?: string
        }
        Relationships: []
      }
      order_items: {
        Row: {
          created_at: string
          id: string
          line_total: number
          name: string
          order_id: string
          product_id: string
          quantity: number
          sku: string
          thumbnail_url: string | null
          unit_price: number
        }
        Insert: {
          created_at?: string
          id?: string
          line_total: number
          name: string
          order_id: string
          product_id: string
          quantity: number
          sku: string
          thumbnail_url?: string | null
          unit_price: number
        }
        Update: {
          created_at?: string
          id?: string
          line_total?: number
          name?: string
          order_id?: string
          product_id?: string
          quantity?: number
          sku?: string
          thumbnail_url?: string | null
          unit_price?: number
        }
        Relationships: []
      }
      orders: {
        Row: {
          account_type: string
          billing_address: Json | null
          created_at: string
          currency: string
          discount: number
          id: string
          notes: string | null
          order_number: string
          order_status: string
          payment_method: string | null
          payment_status: string
          po_number: string | null
          shipping_address: Json
          shipping_cost: number
          subtotal: number
          tax: number
          total: number
          tracking_number: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          account_type: string
          billing_address?: Json | null
          created_at?: string
          currency?: string
          discount?: number
          id?: string
          notes?: string | null
          order_number: string
          order_status?: string
          payment_method?: string | null
          payment_status?: string
          po_number?: string | null
          shipping_address: Json
          shipping_cost?: number
          subtotal: number
          tax?: number
          total: number
          tracking_number?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          account_type?: string
          billing_address?: Json | null
          created_at?: string
          currency?: string
          discount?: number
          id?: string
          notes?: string | null
          order_number?: string
          order_status?: string
          payment_method?: string | null
          payment_status?: string
          po_number?: string | null
          shipping_address?: Json
          shipping_cost?: number
          subtotal?: number
          tax?: number
          total?: number
          tracking_number?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      products: {
        Row: {
          category_slug: string
          compatible_gearboxes: string[]
          compatible_vehicles: string[]
          cost_price: number | null
          created_at: string
          currency: string
          description: string
          id: string
          images: string[]
          is_active: boolean
          is_featured: boolean
          low_stock_threshold: number
          min_wholesale_qty: number | null
          name: string
          price: number
          sku: string
          slug: string
          specifications: Json
          stock_qty: number
          stock_status: string
          tags: string[]
          thumbnail_url: string | null
          updated_at: string
          wholesale_price: number | null
        }
        Insert: {
          category_slug: string
          compatible_gearboxes?: string[]
          compatible_vehicles?: string[]
          cost_price?: number | null
          created_at?: string
          currency?: string
          description?: string
          id?: string
          images?: string[]
          is_active?: boolean
          is_featured?: boolean
          low_stock_threshold?: number
          min_wholesale_qty?: number | null
          name: string
          price: number
          sku: string
          slug: string
          specifications?: Json
          stock_qty?: number
          stock_status?: string
          tags?: string[]
          thumbnail_url?: string | null
          updated_at?: string
          wholesale_price?: number | null
        }
        Update: {
          category_slug?: string
          compatible_gearboxes?: string[]
          compatible_vehicles?: string[]
          cost_price?: number | null
          created_at?: string
          currency?: string
          description?: string
          id?: string
          images?: string[]
          is_active?: boolean
          is_featured?: boolean
          low_stock_threshold?: number
          min_wholesale_qty?: number | null
          name?: string
          price?: number
          sku?: string
          slug?: string
          specifications?: Json
          stock_qty?: number
          stock_status?: string
          tags?: string[]
          thumbnail_url?: string | null
          updated_at?: string
          wholesale_price?: number | null
        }
        Relationships: []
      }
      promos: {
        Row: {
          code: string
          created_at: string
          description: string | null
          discount_type: string
          discount_value: number
          ends_at: string | null
          id: string
          is_active: boolean
          max_uses: number | null
          min_order_total: number
          starts_at: string | null
          uses_count: number
        }
        Insert: {
          code: string
          created_at?: string
          description?: string | null
          discount_type: string
          discount_value: number
          ends_at?: string | null
          id?: string
          is_active?: boolean
          max_uses?: number | null
          min_order_total?: number
          starts_at?: string | null
          uses_count?: number
        }
        Update: {
          code?: string
          created_at?: string
          description?: string | null
          discount_type?: string
          discount_value?: number
          ends_at?: string | null
          id?: string
          is_active?: boolean
          max_uses?: number | null
          min_order_total?: number
          starts_at?: string | null
          uses_count?: number
        }
        Relationships: []
      }
      settings: {
        Row: { key: string; updated_at: string; updated_by: string | null; value: Json }
        Insert: { key: string; updated_at?: string; updated_by?: string | null; value: Json }
        Update: { key?: string; updated_at?: string; updated_by?: string | null; value?: Json }
        Relationships: []
      }
      transactions: {
        Row: {
          amount: number
          category: string
          created_at: string
          currency: string
          description: string
          id: string
          occurred_at: string
          recorded_by: string | null
          reference: string | null
          type: string
        }
        Insert: {
          amount: number
          category: string
          created_at?: string
          currency?: string
          description?: string
          id?: string
          occurred_at?: string
          recorded_by?: string | null
          reference?: string | null
          type: string
        }
        Update: {
          amount?: number
          category?: string
          created_at?: string
          currency?: string
          description?: string
          id?: string
          occurred_at?: string
          recorded_by?: string | null
          reference?: string | null
          type?: string
        }
        Relationships: []
      }
      users: {
        Row: {
          account_type: string
          business_name: string | null
          business_reg_no: string | null
          created_at: string
          default_address_id: string | null
          display_name: string
          email: string
          id: string
          is_verified: boolean
          notification_preferences: Json
          phone: string | null
          tax_id: string | null
          updated_at: string
          wishlist: string[]
        }
        Insert: {
          account_type?: string
          business_name?: string | null
          business_reg_no?: string | null
          created_at?: string
          default_address_id?: string | null
          display_name?: string
          email: string
          id: string
          is_verified?: boolean
          notification_preferences?: Json
          phone?: string | null
          tax_id?: string | null
          updated_at?: string
          wishlist?: string[]
        }
        Update: {
          account_type?: string
          business_name?: string | null
          business_reg_no?: string | null
          created_at?: string
          default_address_id?: string | null
          display_name?: string
          email?: string
          id?: string
          is_verified?: boolean
          notification_preferences?: Json
          phone?: string | null
          tax_id?: string | null
          updated_at?: string
          wishlist?: string[]
        }
        Relationships: []
      }
    }
    Views: { [_ in never]: never }
    Functions: {
      admin_role: { Args: Record<string, never>; Returns: string }
      is_admin: { Args: Record<string, never>; Returns: boolean }
      is_super_admin: { Args: Record<string, never>; Returns: boolean }
      place_order: {
        Args: {
          p_billing_address?: Json
          p_items: Json
          p_notes?: string
          p_payment_method?: string
          p_po_number?: string
          p_promo_code?: string
          p_shipping_address: Json
        }
        Returns: string
      }
    }
    Enums: { [_ in never]: never }
    CompositeTypes: { [_ in never]: never }
  }
}

export type Tables<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Row']
export type TablesInsert<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Insert']
export type TablesUpdate<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Update']
