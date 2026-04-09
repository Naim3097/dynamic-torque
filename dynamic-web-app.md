# MNA Dynamic Torque — React Web Application Specification

> **Platform:** React JS (Vite + TypeScript)
> **Backend:** Supabase (Postgres + Auth + Storage + Realtime)
> **Notifications:** Firebase Cloud Messaging (FCM) — push delivery only
> **Target:** B2B & B2C Gearbox Spare Parts Marketplace
> **Design System:** See `ui-ux.md`

---

## 1. Tech Stack

| Layer              | Technology                                          |
|--------------------|-----------------------------------------------------|
| Framework          | React 18+ with TypeScript                           |
| Build Tool         | Vite                                                |
| Routing            | React Router v6                                     |
| State Management   | Zustand (global) + React Query / TanStack Query (server state) |
| Styling            | Tailwind CSS + CSS custom properties (design tokens) |
| UI Components      | Radix UI primitives + custom themed components (no icon-heavy component libraries) |
| Forms              | React Hook Form + Zod validation                    |
| Push Notifications | Firebase Cloud Messaging (web push) + React Hot Toast (in-app) |
| Auth               | Supabase Auth (Email/Password, Google OAuth)        |
| Database           | Supabase Postgres (via `@supabase/supabase-js`)     |
| Realtime           | Supabase Realtime (Postgres changes subscriptions)  |
| Storage            | Supabase Storage (product images, invoices)         |
| Row-Level Security | Supabase RLS policies (per-user / per-role access)  |
| Payments           | Stripe / PayPal integration                         |
| Search             | Algolia or Meilisearch (product search)             |
| Charts             | Recharts (for any dashboard analytics)              |
| Testing            | Vitest + React Testing Library + Playwright (E2E)   |
| Linting            | ESLint + Prettier                                   |
| CI/CD              | GitHub Actions → Vercel (hosting) + Supabase (migrations) |

---

## 2. Project Structure

```
dynamic-torque-web/
├── public/
│   ├── favicon.ico
│   └── manifest.json
├── src/
│   ├── assets/
│   │   ├── logo.png
│   │   └── images/
│   ├── components/
│   │   ├── ui/                    # Design system primitives
│   │   │   ├── Button.tsx
│   │   │   ├── Card.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── StatusText.tsx      # Colored text for stock/order status (no badge pills)
│   │   │   ├── Modal.tsx
│   │   │   ├── Toast.tsx
│   │   │   ├── LoadingPulse.tsx     # Simple opacity pulse, no skeleton lines
│   │   │   └── index.ts
│   │   ├── layout/
│   │   │   ├── Navbar.tsx
│   │   │   ├── Footer.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   └── PageWrapper.tsx
│   │   ├── product/
│   │   │   ├── ProductCard.tsx
│   │   │   ├── ProductGrid.tsx
│   │   │   ├── ProductDetail.tsx
│   │   │   ├── ProductFilters.tsx
│   │   │   └── ProductSearch.tsx
│   │   ├── cart/
│   │   │   ├── CartDrawer.tsx
│   │   │   ├── CartItem.tsx
│   │   │   └── CartSummary.tsx
│   │   ├── checkout/
│   │   │   ├── CheckoutPage.tsx       # Single-page layout with sections
│   │   │   ├── ShippingForm.tsx
│   │   │   ├── PaymentForm.tsx
│   │   │   └── OrderSummary.tsx
│   │   ├── auth/
│   │   │   ├── LoginForm.tsx
│   │   │   ├── RegisterForm.tsx
│   │   │   └── ProtectedRoute.tsx
│   │   └── notifications/
│   │       ├── NotificationDropdown.tsx  # Plain text list, no bell icon
│   │       └── NotificationList.tsx
│   ├── pages/
│   │   ├── HomePage.tsx
│   │   ├── CatalogPage.tsx
│   │   ├── CategoryPage.tsx
│   │   ├── ProductPage.tsx
│   │   ├── CartPage.tsx
│   │   ├── CheckoutPage.tsx
│   │   ├── OrderConfirmationPage.tsx
│   │   ├── LoginPage.tsx
│   │   ├── RegisterPage.tsx
│   │   ├── DashboardPage.tsx         # User account dashboard
│   │   ├── OrderHistoryPage.tsx
│   │   ├── WishlistPage.tsx
│   │   ├── NotFoundPage.tsx
│   │   └── AboutPage.tsx
│   ├── hooks/
│   │   ├── useAuth.ts
│   │   ├── useCart.ts
│   │   ├── useProducts.ts
│   │   ├── useOrders.ts
│   │   ├── useNotifications.ts
│   │   └── useDebounce.ts
│   ├── stores/
│   │   ├── cartStore.ts
│   │   ├── authStore.ts
│   │   └── uiStore.ts
│   ├── services/
│   │   ├── supabase.ts                # Supabase client init
│   │   ├── firebaseMessaging.ts       # FCM web push setup (notification delivery only)
│   │   ├── productService.ts
│   │   ├── orderService.ts
│   │   ├── authService.ts             # Wraps supabase.auth
│   │   ├── realtimeService.ts         # Supabase Realtime channel helpers
│   │   └── paymentService.ts
│   ├── types/
│   │   ├── product.ts
│   │   ├── order.ts
│   │   ├── user.ts
│   │   ├── cart.ts
│   │   └── notification.ts
│   ├── utils/
│   │   ├── formatCurrency.ts
│   │   ├── validators.ts
│   │   └── constants.ts
│   ├── styles/
│   │   ├── globals.css               # CSS custom properties (design tokens)
│   │   └── tailwind.css
│   ├── App.tsx
│   ├── main.tsx
│   └── router.tsx
├── .env.example
├── tailwind.config.ts
├── vite.config.ts
├── tsconfig.json
├── package.json
└── README.md
```

---

## 3. Data Models

### 3.1 Product
```typescript
interface Product {
  id: string;
  name: string;
  slug: string;
  sku: string;
  category: ProductCategory;
  description: string;
  specifications: Record<string, string>;  // e.g., { material, dimensions, weight }
  compatibleVehicles: string[];            // e.g., ["Toyota Hilux", "Isuzu D-Max"]
  compatibleGearboxes: string[];           // e.g., ["A750E", "A340"]
  price: number;
  currency: string;                        // "MYR", "USD" etc.
  wholesalePrice?: number;                 // B2B pricing
  minWholesaleQty?: number;
  images: string[];                        // Supabase Storage public URLs
  thumbnailUrl: string;
  stockQty: number;
  stockStatus: 'in_stock' | 'low_stock' | 'out_of_stock';
  lowStockThreshold: number;
  tags: string[];
  isFeatured: boolean;
  isActive: boolean;
  createdAt: string;                       // ISO timestamp (Postgres `timestamptz`)
  updatedAt: string;
}

type ProductCategory =
  | 'clutch_plate'
  | 'steel_plate'
  | 'auto_filter'
  | 'forward_drum'
  | 'oil_pump'
  | 'piston_seal'
  | 'overhaul_kit'
  | 'lubricants';
```

### 3.2 User
```typescript
interface User {
  id: string;                              // Supabase auth.users.id (UUID)
  email: string;
  displayName: string;
  phone: string;
  accountType: 'b2c' | 'b2b';
  // B2B fields
  businessName?: string;
  businessRegNo?: string;
  taxId?: string;
  // Common
  addresses: Address[];
  defaultAddressId?: string;
  wishlist: string[];                      // product IDs
  notificationPreferences: {
    orderUpdates: boolean;
    promotions: boolean;
    stockAlerts: boolean;
  };
  isVerified: boolean;
  createdAt: string;
}

// FCM device tokens live in a separate table so one user can have many devices.
interface FcmToken {
  id: string;
  userId: string;                          // FK → users.id
  token: string;                           // FCM registration token
  platform: 'web' | 'android' | 'ios';
  userAgent?: string;
  createdAt: string;
  lastSeenAt: string;
}

interface Address {
  id: string;
  label: string;                           // "Office", "Warehouse"
  line1: string;
  line2?: string;
  city: string;
  state: string;
  postalCode: string;
  country: string;
  isDefault: boolean;
}
```

### 3.3 Cart
```typescript
interface Cart {
  items: CartItem[];
  subtotal: number;
  discount: number;
  shipping: number;
  tax: number;
  total: number;
  promoCode?: string;
}

interface CartItem {
  productId: string;
  product: Product;                        // denormalized for display
  quantity: number;
  unitPrice: number;                       // resolved (wholesale or retail)
  lineTotal: number;
}
```

### 3.4 Order
```typescript
interface Order {
  id: string;
  orderNumber: string;                     // e.g., "DT-20260408-0001"
  userId: string;
  accountType: 'b2c' | 'b2b';
  items: OrderItem[];
  shippingAddress: Address;
  billingAddress?: Address;
  subtotal: number;
  discount: number;
  shippingCost: number;
  tax: number;
  total: number;
  currency: string;
  paymentMethod: string;
  paymentStatus: 'pending' | 'paid' | 'failed' | 'refunded';
  orderStatus: 'pending' | 'confirmed' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
  trackingNumber?: string;
  notes?: string;
  poNumber?: string;                       // B2B purchase order
  createdAt: string;
  updatedAt: string;
}

interface OrderItem {
  productId: string;
  name: string;
  sku: string;
  quantity: number;
  unitPrice: number;
  lineTotal: number;
  thumbnailUrl: string;
}
```

### 3.5 Notification
```typescript
interface AppNotification {
  id: string;
  userId: string;
  type: 'order_update' | 'promotion' | 'stock_alert' | 'system';
  title: string;
  body: string;
  imageUrl?: string;
  data?: Record<string, string>;           // deep-link data
  isRead: boolean;
  createdAt: string;
}
```

---

## 4. Inventory (Seed Data)

The following categories form the initial product catalog:

| Category       | Sample SKU Pattern | Sample Products                              |
|----------------|--------------------|----------------------------------------------|
| Clutch Plate   | `DT-CP-XXXX`      | AT Clutch Friction Plate, HD Clutch Disc     |
| Steel Plate    | `DT-SP-XXXX`      | Transmission Steel Separator Plate           |
| Auto Filter    | `DT-AF-XXXX`      | ATF Inline Filter, Pan Transmission Filter   |
| Forward Drum   | `DT-FD-XXXX`      | Forward Clutch Drum Assembly, Drum Shell     |
| Oil Pump       | `DT-OP-XXXX`      | Front Oil Pump Body, Oil Pump Gear Assembly  |
| Piston Seal    | `DT-PS-XXXX`      | Bonded Piston Seal, D-Ring Seal Kit          |
| Overhaul Kit   | `DT-OK-XXXX`      | Master Rebuild Kit, Banner Kit, Gasket Set   |
| Lubricants     | `DT-LB-XXXX`      | ATF Dexron VI, CVT Fluid, Assembly Lube      |

---

## 5. Routes

```typescript
const routes = [
  // Public
  { path: '/',                    element: <HomePage /> },
  { path: '/catalog',             element: <CatalogPage /> },
  { path: '/category/:slug',     element: <CategoryPage /> },
  { path: '/product/:slug',      element: <ProductPage /> },
  { path: '/cart',                element: <CartPage /> },
  { path: '/about',               element: <AboutPage /> },

  // Auth
  { path: '/login',               element: <LoginPage /> },
  { path: '/register',            element: <RegisterPage /> },

  // Protected (authenticated)
  { path: '/checkout',            element: <CheckoutPage /> },
  { path: '/order-confirmation/:id', element: <OrderConfirmationPage /> },
  { path: '/dashboard',           element: <DashboardPage /> },
  { path: '/orders',              element: <OrderHistoryPage /> },
  { path: '/wishlist',            element: <WishlistPage /> },

  // 404
  { path: '*',                    element: <NotFoundPage /> },
];
```

---

## 6. Backend Integration (Supabase + FCM)

The stack splits responsibilities between two vendors:

- **Supabase** owns data, auth, storage, realtime, and server-side business logic.
- **Firebase Cloud Messaging (FCM)** is used *only* as the push delivery pipe. No Firestore, no Firebase Auth, no Firebase Storage.

### 6.1 Supabase Services Used
| Service        | Purpose                                                              |
|----------------|----------------------------------------------------------------------|
| Auth           | Email/password + Google OAuth; issues JWTs used by RLS               |
| Postgres       | Products, orders, users, notifications, inventory logs               |
| Storage        | Product images, invoices, PDF exports (buckets with RLS)             |
| Realtime       | Live order status, stock level, and notification updates             |
| Edge Functions | Order processing, stock triggers, FCM send, email sends              |
| RLS Policies   | Enforce per-user and per-role access directly in the database        |

### 6.2 Postgres Schema (tables)
```
public.products              -- catalog
public.categories            -- 8 spare part categories
public.users                 -- profile rows, 1:1 with auth.users
public.addresses             -- FK → users
public.orders                -- header
public.order_items           -- FK → orders
public.notifications         -- in-app feed
public.fcm_tokens            -- device tokens per user
public.promos                -- promo codes
public.inventory_logs        -- stock movement audit trail
```
All tables use `uuid` PKs, `timestamptz` for created/updated, and are owned by the `authenticated` role via RLS. Stock mutations go through a Postgres function (`rpc: place_order`) wrapped in a transaction so quantity checks and decrements are atomic.

### 6.3 Supabase Client Setup
```typescript
// services/supabase.ts
import { createClient } from '@supabase/supabase-js';
import type { Database } from '@/types/database'; // generated via `supabase gen types typescript`

export const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY,
  {
    auth: { persistSession: true, autoRefreshToken: true },
    realtime: { params: { eventsPerSecond: 10 } },
  }
);
```

### 6.4 Realtime Subscriptions
Realtime is a first-class requirement for this project. Customers see live order status; admins see live stock and incoming orders.

```typescript
// services/realtimeService.ts
import { supabase } from './supabase';

export function subscribeToOrder(orderId: string, onChange: (row: any) => void) {
  return supabase
    .channel(`order:${orderId}`)
    .on(
      'postgres_changes',
      { event: 'UPDATE', schema: 'public', table: 'orders', filter: `id=eq.${orderId}` },
      (payload) => onChange(payload.new)
    )
    .subscribe();
}

export function subscribeToUserNotifications(userId: string, onInsert: (row: any) => void) {
  return supabase
    .channel(`notifications:${userId}`)
    .on(
      'postgres_changes',
      { event: 'INSERT', schema: 'public', table: 'notifications', filter: `user_id=eq.${userId}` },
      (payload) => onInsert(payload.new)
    )
    .subscribe();
}
```
Channels are unsubscribed on component unmount. Enable Realtime on each table via `alter publication supabase_realtime add table public.<table>`.

### 6.5 Firebase Cloud Messaging Setup (push delivery only)
FCM is initialized purely to register a device token and receive foreground push payloads. The token is stored in `public.fcm_tokens` keyed by the Supabase user ID.

```typescript
// services/firebaseMessaging.ts
import { initializeApp } from 'firebase/app';
import { getMessaging, getToken, onMessage } from 'firebase/messaging';
import { supabase } from './supabase';

const firebaseApp = initializeApp({
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
});
const messaging = getMessaging(firebaseApp);

export async function registerPushToken(): Promise<string | null> {
  const permission = await Notification.requestPermission();
  if (permission !== 'granted') return null;

  const token = await getToken(messaging, {
    vapidKey: import.meta.env.VITE_FIREBASE_VAPID_KEY,
  });
  if (!token) return null;

  const { data: { user } } = await supabase.auth.getUser();
  if (user) {
    await supabase.from('fcm_tokens').upsert(
      { user_id: user.id, token, platform: 'web', last_seen_at: new Date().toISOString() },
      { onConflict: 'token' }
    );
  }
  return token;
}

export function onForegroundMessage(cb: (payload: any) => void) {
  return onMessage(messaging, cb);
}
```

### 6.6 Notification Triggers (Supabase Edge Functions)
Edge Functions listen for row changes (via database webhooks) and call the FCM HTTP v1 API using a Firebase service account key stored as a Supabase secret.

| Trigger                           | Sent To              | Content                           |
|-----------------------------------|----------------------|-----------------------------------|
| `orders` INSERT                   | Customer             | "Order DT-XXX confirmed!"         |
| `orders` UPDATE (status changed)  | Customer             | "Your order has been shipped"     |
| `products` UPDATE (stock < threshold) | Admin (Flutter app) | "Clutch Plate stock below 5"   |
| `users` INSERT (account_type=b2b) | Admin                | "New B2B account pending review"  |
| Promotion broadcast (manual)      | All opted-in users   | Sale/promotion details            |

Flow: Postgres trigger/webhook → Edge Function → look up recipient FCM tokens → send via FCM HTTP v1 → also insert a row into `public.notifications` so the in-app feed updates via Realtime.

---

## 7. Key Features

### 7.1 Product Browsing
- Category-based navigation (8 spare part categories, image tiles not icon cards)
- Full-text search with autocomplete
- Filter by category, price range, stock status, vehicle compatibility
- Sort by price, newest, popularity
- Grid view only (no grid/list toggle — one considered layout, not user-configurable)
- Pagination (no infinite scroll — gives clearer sense of catalog size)

### 7.2 Cart & Checkout
- Persistent cart (localStorage + Supabase `carts` table sync for logged-in users)
- Quantity adjustment with stock validation
- Promo code / discount application
- Single-page checkout with clear sections (Shipping, Payment, Summary) separated by whitespace, not a multi-step wizard with progress indicators
- Guest checkout (B2C) — prompts account creation after
- B2B: PO number field, wholesale pricing auto-applied

### 7.3 User Account
- Registration (B2C simple, B2B requires business details + verification)
- Order history with status tracking
- Reorder from previous orders (one-click)
- Address book management
- Wishlist / saved items
- Notification preferences

### 7.4 B2B Features
- Tiered wholesale pricing (visible only to verified B2B accounts)
- Minimum order quantities for wholesale pricing
- Request-for-quote flow for large orders
- Credit terms display (Net 30 etc., managed by admin)
- Bulk add-to-cart via CSV/SKU list

### 7.5 Notifications (FCM + Supabase Realtime)
- Push notification permission requested contextually (after first order, not on first visit)
- In-app notification feed is populated via Supabase Realtime; FCM only handles background/OS-level push
- In-app notification center: a simple dropdown list from "Notifications" text in nav, no bell icon
- Order update notifications
- Back-in-stock alerts (wishlist items)
- Promotional notifications

### 7.6 Search
- Debounced search input in navbar
- Search by product name, SKU, vehicle, gearbox model
- Recent searches stored locally
- Search suggestions dropdown

---

## 8. Performance Requirements

| Metric              | Target                |
|---------------------|-----------------------|
| LCP                 | < 2.5s               |
| FID / INP           | < 100ms              |
| CLS                 | < 0.1                |
| Bundle Size (init)  | < 200KB gzipped      |
| Image loading       | Lazy-loaded, WebP     |
| API response        | < 500ms (p95)        |
| Lighthouse score    | > 90 (all categories) |

### Optimization Strategies
- Code splitting per route (React.lazy + Suspense)
- Image optimization: WebP format, srcset for responsive, lazy loading
- Supabase query pagination via `.range(from, to)` with indexed columns
- Use Postgres indexes on `slug`, `sku`, `category`, `is_active`, and full-text search columns
- Service Worker for offline product catalog caching
- Preload critical fonts
- Debounce search queries (300ms)

---

## 9. Security

- Supabase Row-Level Security (RLS) enabled on every table; users can only read/write their own rows
- `service_role` key only used server-side in Edge Functions — never shipped to the browser
- Server-side price validation in Edge Functions / `place_order` RPC (never trust client prices)
- Stock mutations performed atomically inside Postgres transactions
- Input sanitization (XSS prevention via React's default escaping + DOMPurify for rich text)
- Auth state carried via Supabase JWT (refreshed automatically)
- Rate limiting on Edge Functions (Supabase built-in + per-IP checks)
- Environment variables for all API keys (never committed)
- Content Security Policy headers
- HTTPS enforced

---

## 10. Environment Variables

```env
# .env.example

# Supabase (primary backend)
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=

# Firebase Cloud Messaging (push delivery only — NO Firestore/Auth/Storage)
VITE_FIREBASE_API_KEY=
VITE_FIREBASE_PROJECT_ID=
VITE_FIREBASE_MESSAGING_SENDER_ID=
VITE_FIREBASE_APP_ID=
VITE_FIREBASE_VAPID_KEY=

# Payments & Search
VITE_STRIPE_PUBLISHABLE_KEY=
VITE_ALGOLIA_APP_ID=
VITE_ALGOLIA_SEARCH_KEY=

VITE_APP_URL=
```

Server-side secrets (Supabase Edge Functions — never exposed to client):
```
SUPABASE_SERVICE_ROLE_KEY=
FIREBASE_SERVICE_ACCOUNT_JSON=   # for FCM HTTP v1 send
STRIPE_SECRET_KEY=
```

---

## 11. Deployment

| Environment | URL Pattern                        | Branch   |
|-------------|------------------------------------|----------|
| Development | `localhost:5173`                   | `dev`    |
| Staging     | `staging.dynamictorque.com`        | `staging`|
| Production  | `www.dynamictorque.com`            | `main`   |

- **CI/CD:** GitHub Actions
  - On PR → Run lint, type-check, tests
  - On merge to `staging` → Deploy to Vercel (staging) + run `supabase db push` against staging project
  - On merge to `main` → Deploy to Vercel (production) + run `supabase db push` against production project
  - Supabase migrations stored in `supabase/migrations/` and versioned in git

---

## 12. Development Phases

### Phase 1 — MVP (Core Marketplace)
- [ ] Project setup (Vite + React + TypeScript + Tailwind)
- [ ] Design system components (from ui-ux.md tokens)
- [ ] Supabase project setup (Postgres schema, RLS policies, Storage buckets, Auth providers)
- [ ] Firebase project setup (FCM only — no Firestore/Auth/Storage)
- [ ] Product catalog (browse, search, filter, detail)
- [ ] Cart functionality
- [ ] User auth (register, login, profile) via Supabase Auth
- [ ] Checkout flow (B2C)
- [ ] Order placement via `place_order` RPC with atomic stock decrement
- [ ] Realtime order status updates via Supabase Realtime
- [ ] Push notifications (order updates) via Edge Function → FCM
- [ ] Responsive design for all pages
- [ ] Deploy to Vercel

### Phase 2 — B2B & Enhanced Features
- [ ] B2B registration + verification flow
- [ ] Wholesale pricing tier system
- [ ] Request-for-quote
- [ ] Bulk ordering (CSV upload)
- [ ] Reorder from history
- [ ] Back-in-stock alerts
- [ ] Payment gateway integration (Stripe)
- [ ] Invoice generation (PDF)

### Phase 3 — Optimization & Scale
- [ ] Algolia/Meilisearch integration for search
- [ ] Performance optimization (code splitting, image CDN)
- [ ] PWA support (offline catalog browsing)
- [ ] Multi-language support (i18n)
- [ ] Analytics integration
- [ ] SEO optimization (SSR/SSG consideration)
- [ ] A/B testing framework

---

## 13. Tailwind Config (Brand Theme)

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        brand: {
          'bg-primary': '#0B1A2E',
          'bg-secondary': '#132D4A',
          'blue-mid': '#1E5F8C',
          'blue-bright': '#2A8FD4',
          'blue-light': '#6BB8E0',
          'red': '#D42B2B',
          'red-hover': '#B52222',
          'surface': '#162E48',
          'text-muted': '#A0B4C8',
          'steel': '#8FAABE',
        },
      },
      fontFamily: {
        heading: ['Rajdhani', 'Barlow Condensed', 'sans-serif'],
        body: ['Inter', 'Segoe UI', 'sans-serif'],
        mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
      },
      borderRadius: {
        card: '12px',
      },
      boxShadow: {
        card: '0 4px 16px rgba(0,0,0,0.3)',
      },
    },
  },
  plugins: [],
};

export default config;
```
