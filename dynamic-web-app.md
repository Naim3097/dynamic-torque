# MNA Dynamic Torque — React Web Application Specification

> **Platform:** React JS (Vite + TypeScript)  
> **Notifications:** Firebase Cloud Messaging (FCM)  
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
| Notifications      | Firebase Cloud Messaging (push) + React Hot Toast (in-app) |
| Auth               | Firebase Authentication (Email/Password, Google)    |
| Database           | Firebase Firestore (or REST API to backend)         |
| Storage            | Firebase Storage (product images)                   |
| Payments           | Stripe / PayPal integration                         |
| Search             | Algolia or Meilisearch (product search)             |
| Charts             | Recharts (for any dashboard analytics)              |
| Testing            | Vitest + React Testing Library + Playwright (E2E)   |
| Linting            | ESLint + Prettier                                   |
| CI/CD              | GitHub Actions → Firebase Hosting / Vercel          |

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
│   │   ├── firebase.ts               # Firebase config & init
│   │   ├── firebaseMessaging.ts       # FCM setup
│   │   ├── productService.ts
│   │   ├── orderService.ts
│   │   ├── authService.ts
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
  images: string[];                        // Firebase Storage URLs
  thumbnailUrl: string;
  stockQty: number;
  stockStatus: 'in_stock' | 'low_stock' | 'out_of_stock';
  lowStockThreshold: number;
  tags: string[];
  isFeatured: boolean;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
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
  uid: string;
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
  fcmTokens: string[];                     // Firebase Cloud Messaging tokens
  notificationPreferences: {
    orderUpdates: boolean;
    promotions: boolean;
    stockAlerts: boolean;
  };
  isVerified: boolean;
  createdAt: Timestamp;
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
  createdAt: Timestamp;
  updatedAt: Timestamp;
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
  createdAt: Timestamp;
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

## 6. Firebase Integration

### 6.1 Firebase Services Used
| Service               | Purpose                                         |
|-----------------------|-------------------------------------------------|
| Authentication        | Email/password + Google sign-in                 |
| Firestore             | Products, orders, users, notifications          |
| Cloud Storage         | Product images, invoices                        |
| Cloud Messaging (FCM) | Push notifications (order updates, promos)      |
| Hosting               | Static web app deployment                       |
| Cloud Functions       | Order processing, stock triggers, email sends   |

### 6.2 Firestore Collections
```
/products/{productId}
/users/{userId}
/orders/{orderId}
/notifications/{notificationId}
/categories/{categoryId}
/promos/{promoId}
```

### 6.3 Firebase Cloud Messaging Setup
```typescript
// services/firebaseMessaging.ts

import { getMessaging, getToken, onMessage } from 'firebase/messaging';
import { app } from './firebase';

const messaging = getMessaging(app);

export async function requestNotificationPermission(): Promise<string | null> {
  const permission = await Notification.requestPermission();
  if (permission === 'granted') {
    const token = await getToken(messaging, {
      vapidKey: import.meta.env.VITE_FIREBASE_VAPID_KEY,
    });
    return token;
  }
  return null;
}

export function onForegroundMessage(callback: (payload: any) => void) {
  return onMessage(messaging, callback);
}
```

### 6.4 Notification Triggers (Cloud Functions)
| Trigger                  | Notification Sent To | Content                           |
|--------------------------|----------------------|-----------------------------------|
| Order placed             | Customer             | "Order DT-XXX confirmed!"        |
| Order status changed     | Customer             | "Your order has been shipped"     |
| Low stock alert          | Admin (Flutter app)  | "Clutch Plate stock below 5"     |
| New B2B registration     | Admin                | "New B2B account pending review" |
| Promotion broadcast      | All opted-in users   | Sale/promotion details           |

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
- Persistent cart (localStorage + Firestore sync for logged-in users)
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

### 7.5 Notifications (Firebase)
- Push notification permission requested contextually (after first order, not on first visit)
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
- Firestore query pagination (limit + startAfter cursors)
- Service Worker for offline product catalog caching
- Preload critical fonts
- Debounce search queries (300ms)

---

## 9. Security

- Firebase Security Rules on all collections (user can only read/write own data)
- Server-side price validation in Cloud Functions (never trust client prices)
- Input sanitization (XSS prevention via React's default escaping + DOMPurify for rich text)
- CSRF protection via Firebase Auth tokens
- Rate limiting on Cloud Functions endpoints
- Environment variables for all API keys (never committed)
- Content Security Policy headers
- HTTPS enforced

---

## 10. Environment Variables

```env
# .env.example
VITE_FIREBASE_API_KEY=
VITE_FIREBASE_AUTH_DOMAIN=
VITE_FIREBASE_PROJECT_ID=
VITE_FIREBASE_STORAGE_BUCKET=
VITE_FIREBASE_MESSAGING_SENDER_ID=
VITE_FIREBASE_APP_ID=
VITE_FIREBASE_VAPID_KEY=
VITE_STRIPE_PUBLISHABLE_KEY=
VITE_ALGOLIA_APP_ID=
VITE_ALGOLIA_SEARCH_KEY=
VITE_APP_URL=
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
  - On merge to `staging` → Deploy to Firebase Hosting (staging)
  - On merge to `main` → Deploy to Firebase Hosting (production)

---

## 12. Development Phases

### Phase 1 — MVP (Core Marketplace)
- [ ] Project setup (Vite + React + TypeScript + Tailwind)
- [ ] Design system components (from ui-ux.md tokens)
- [ ] Firebase project setup (Auth, Firestore, Storage, FCM)
- [ ] Product catalog (browse, search, filter, detail)
- [ ] Cart functionality
- [ ] User auth (register, login, profile)
- [ ] Checkout flow (B2C)
- [ ] Order placement + Firestore order storage
- [ ] Push notifications (order updates)
- [ ] Responsive design for all pages
- [ ] Deploy to Firebase Hosting

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
