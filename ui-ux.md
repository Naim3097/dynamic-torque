# MNA Dynamic Torque — UI/UX Design System

> **Tagline:** DRIVE BEYOND LIMIT  
> **Domain:** B2B & B2C Marketplace for Gearbox Spare Parts  
> **Target Users:** Workshops, Independent Suppliers, Resellers, and End Consumers

---

## 1. Brand Identity

### 1.1 Logo
- **File:** `assets/logo.png` (transparent PNG)
- **Usage:** Always display on dark backgrounds for maximum contrast
- **Minimum clear space:** 16px around all sides
- **Do not:** Stretch, recolor, or place on busy/light backgrounds without a dark overlay

### 1.2 Tagline
- "DRIVE BEYOND LIMIT" — used in hero sections, splash screens, and marketing materials

---

## 2. Color Palette

Extracted from the brand background artwork (hexagonal geometric motif):

### Primary Colors
| Token                  | Hex       | Usage                                      |
|------------------------|-----------|--------------------------------------------|
| `--color-bg-primary`   | `#0B1A2E` | Main background, page base                 |
| `--color-bg-secondary` | `#132D4A` | Cards, panels, sidebar backgrounds         |
| `--color-blue-mid`     | `#1E5F8C` | Interactive borders, hover states          |
| `--color-blue-bright`  | `#2A8FD4` | Primary buttons, links, active states      |
| `--color-blue-light`   | `#6BB8E0` | Highlights, badges, progress bars          |

### Accent Colors
| Token                  | Hex       | Usage                                      |
|------------------------|-----------|--------------------------------------------|
| `--color-red-accent`   | `#D42B2B` | CTA buttons, alerts, sale badges, brand red |
| `--color-red-hover`    | `#B52222` | Red button hover state                     |

### Neutral Colors
| Token                  | Hex       | Usage                                      |
|------------------------|-----------|--------------------------------------------|
| `--color-white`        | `#FFFFFF` | Primary text on dark backgrounds           |
| `--color-text-muted`   | `#A0B4C8` | Secondary text, descriptions, placeholders |
| `--color-steel`        | `#8FAABE` | Dividers, subtle borders                   |
| `--color-surface`      | `#162E48` | Input fields, dropdown backgrounds         |
| `--color-overlay`      | `rgba(11,26,46,0.85)` | Modal/dialog overlays            |

### Semantic Colors
| Token                  | Hex       | Usage                                      |
|------------------------|-----------|--------------------------------------------|
| `--color-success`      | `#22C55E` | Stock in, confirmations, success toasts    |
| `--color-warning`      | `#F59E0B` | Low stock warnings                         |
| `--color-error`        | `#EF4444` | Validation errors, out-of-stock            |
| `--color-info`         | `#2A8FD4` | Informational badges (mirrors blue-bright) |

---

## 3. Typography

### Font Stack
- **Primary (Headings):** `'Rajdhani', 'Barlow Condensed', sans-serif` — industrial, mechanical feel
- **Secondary (Body):** `'Inter', 'Segoe UI', sans-serif` — clean readability
- **Monospace (Codes/SKUs):** `'JetBrains Mono', 'Fira Code', monospace`

### Type Scale
| Level    | Size    | Weight  | Line Height | Usage                         |
|----------|---------|---------|-------------|-------------------------------|
| Display  | 48px    | 700     | 1.1         | Hero headlines                |
| H1       | 36px    | 700     | 1.2         | Page titles                   |
| H2       | 28px    | 600     | 1.25        | Section headers               |
| H3       | 22px    | 600     | 1.3         | Card titles, modal headers    |
| H4       | 18px    | 600     | 1.35        | Subsection headers            |
| Body LG  | 16px    | 400     | 1.5         | Primary body text             |
| Body     | 14px    | 400     | 1.5         | Secondary content             |
| Caption  | 12px    | 400     | 1.4         | Labels, timestamps, metadata  |
| Tiny     | 10px    | 500     | 1.3         | Badges, status indicators     |

---

## 4. Visual Language

### 4.1 Design Philosophy: No AI Aesthetic

This project must look human-designed. The following patterns are banned:

**Banned patterns:**
- Visible borders/strokes on cards. Cards use background fill and shadow only, never outlined boxes.
- Decorative icon usage. No icons paired with labels just to fill space. Icons are functional only (navigation, actions).
- Dash-separated layouts or lists that visually resemble AI-generated content.
- Emoji anywhere in the UI.
- Uniform grid-of-cards with identical icon+title+description patterns (the "SaaS landing page" look).
- Rounded pill badges with bright backgrounds slapped on everything.
- Gradients on buttons.
- Drop shadows on every element. Shadow is used sparingly for depth hierarchy, not decoration.
- Overly symmetrical layouts. Use intentional whitespace asymmetry where it feels natural.
- Generic stock illustration style (isometric people, abstract blobs).

**What to do instead:**
- Let the product photography and typography carry the design.
- Use negative space generously. Not every area needs filling.
- Cards are defined by subtle background color shifts, not borders. A card is just a slightly lighter rectangle.
- Categories are represented by real product images cropped into clean shapes, not by abstract icons.
- Hierarchy is established through font weight and size, not through lines, dividers, or boxes.
- Interactive states are communicated through color opacity shifts, not border additions.
- The overall feel should be editorial, like a well-designed automotive parts catalog, not a SaaS dashboard.

### 4.2 Iconography (Minimal, Functional Only)
- Icons appear only where they serve a navigation or action purpose: cart, search, user menu, close, arrows.
- No decorative icons next to text labels or headings.
- If an icon is used, it is a simple glyph. Lucide React, 20px, 1.5px stroke, `--color-text-muted` default.
- Category cards use cropped product photography, not icons.

### 4.3 Product Imagery
- Clean product photography on neutral backgrounds.
- Images are the visual anchor of every product card and category tile.
- Hero sections use the brand hexagonal artwork as a photographic/atmospheric background, never as a repeating pattern.

---

## 5. Spacing & Grid System

### Spacing Scale (4px base)
| Token   | Value  |
|---------|--------|
| `xs`    | 4px    |
| `sm`    | 8px    |
| `md`    | 16px   |
| `lg`    | 24px   |
| `xl`    | 32px   |
| `2xl`   | 48px   |
| `3xl`   | 64px   |

### Grid
- **Desktop (≥1280px):** 12-column grid, 24px gutter
- **Tablet (768–1279px):** 8-column grid, 16px gutter
- **Mobile (< 768px):** 4-column grid, 16px gutter
- **Max content width:** 1440px, centered

---

## 6. Component Design Specifications

### 6.1 Buttons
| Variant     | Background          | Text      | Border      | Usage                  |
|-------------|---------------------|-----------|-------------|------------------------|
| Primary     | `#2A8FD4`           | `#FFFFFF` | none        | Main actions           |
| Danger/CTA  | `#D42B2B`           | `#FFFFFF` | none        | Add to cart, Buy now   |
| Secondary   | transparent         | `#2A8FD4` | 1px `#2A8FD4`| Cancel, secondary acts|
| Ghost       | transparent         | `#A0B4C8` | none        | Tertiary actions       |
| Disabled    | `#1E5F8C` at 40%    | `#6B7B8D` | none        | Unavailable actions    |

- **Border-radius:** 8px
- **Padding:** 12px 24px (md), 8px 16px (sm)
- **Min-width:** 120px
- **Hover:** brightness(1.1) + subtle translateY(-1px)
- **Active:** brightness(0.95)

### 6.2 Cards (Product Card)
- **Background:** `--color-bg-secondary` (`#132D4A`)
- **Border:** none. Zero. Cards are defined solely by their background fill against the page.
- **Border-radius:** 10px
- **Shadow:** none at rest. On hover: `0 8px 24px rgba(0,0,0,0.25)` to lift the card.
- **Hover:** background lightens slightly to `#17375A`, shadow appears, no scale transform, no border.
- **Layout:** Product image fills the top portion (aspect 4:3, flush to card edges, no internal padding on image). Below image: product name (H3 weight), price in large text, muted SKU text. Availability is communicated by text color only (green/amber/red on the price or a single word), not a badge. No "Add to Cart" button visible on the card grid, it appears on hover as a text link or on the detail page.
- **Spacing:** 16px internal padding on text area only. No padding around image.

### 6.3 Input Fields
- **Background:** `--color-surface` (`#162E48`)
- **Border:** none at rest. The darker fill against the page background defines the input boundary.
- **Border-radius:** 8px
- **Focus:** a single bottom border appears in `#2A8FD4` (2px), no glow, no box-shadow ring.
- **Text color:** `#FFFFFF`
- **Placeholder color:** `#6B7B8D`
- **Height:** 44px (standard), 36px (compact)
- **Labels** sit above the input as small muted text, not inside as floating labels.

### 6.4 Navigation Bar
- **Background:** `#0B1A2E` — solid, no blur effects or transparency gimmicks
- **Height:** 64px (desktop), 56px (mobile)
- **Logo:** Left-aligned, max-height 40px
- **Nav items:** Right-aligned. Text only, no icons next to nav labels. `#A0B4C8` default, `#FFFFFF` on hover (just color change, no underline animation). Active page indicated by white text only, no underline, no bar, no dot.
- **Cart:** The word "Cart" with a number in parentheses, e.g. "Cart (3)". No cart icon. This is cleaner and avoids the icon-with-red-dot pattern that every AI-generated site uses.
- **Sticky on scroll**, no background change on scroll, no shrink animation.

### 6.5 Status Indicators
Status is communicated through text color, not pill badges.

| Status       | Text Color  | Presentation                                  |
|--------------|-------------|-----------------------------------------------|
| In Stock     | `#22C55E`   | Small text below price: "Available"            |
| Low Stock    | `#F59E0B`   | Small text below price: "Limited stock"        |
| Out of Stock | `#EF4444`   | Replaces price: "Out of stock" in error color  |
| New          | `#2A8FD4`   | "New" text next to product name, same line     |
| Sale         | `#D42B2B`   | Original price struck through, sale price in red |

### 6.6 Toast / Notifications
- **Position:** Bottom-center on desktop, top on mobile
- **Background:** `#FFFFFF` text `#0B1A2E` (inverted from page, for contrast and visibility)
- **Border-radius:** 8px
- **No colored side borders, no icons.** Just clear text.
- **Auto-dismiss:** 4 seconds, with a subtle opacity fade-out
- **Firebase push notifications** use the browser's native notification API when backgrounded, and this toast style when foregrounded

### 6.7 Modals / Dialogs
- **Overlay:** `rgba(11,26,46,0.85)`
- **Panel:** `#132D4A`, border-radius 16px, max-width 540px, no border, no outer shadow
- **Close:** Small "Close" text link top-right, not an X icon button

---

## 7. User Flows

### 7.1 B2C Customer Flow
```
Landing Page → Browse Categories → Product Listing → Product Detail
  → Add to Cart → Cart Review → Checkout (Guest / Login)
  → Order Confirmation → Order Tracking
```

### 7.2 B2B Workshop / Reseller Flow
```
Landing Page → Login (B2B Account) → Dashboard
  → Browse / Quick Search (by SKU/part number)
  → Bulk Add to Cart → Request Quote / Place Order
  → Order History → Reorder from Previous
  → Account Settings (business profile, tax info)
```

### 7.3 Shared Flows
```
Search → Filtered Results (by category, vehicle, brand)
Profile → Order History → Invoice Download
Wishlist / Save for Later
Firebase Notification Opt-in
```

---

## 8. Page Layouts

### 8.1 Landing / Home Page

The home page should feel like opening a high-end automotive catalog. Photography-led, minimal text, confident spacing.

**Hero:** Full-viewport height. The hexagonal brand artwork used as a photographic background (darkened). Logo centered vertically. Tagline below. One single CTA button ("Browse Parts"), not two competing buttons. No descriptive paragraph.

**Categories:** 2 rows of 4. Each category is a tall image tile (aspect ~3:4) with the category name in white at the bottom over a dark gradient scrim. No descriptions, no icons, no card borders. The images do all the communication.

**Featured Products:** A simple grid (4 across on desktop). Clean product cards as specced. A section heading ("Featured") in muted uppercase small text, left-aligned above the grid. No "view all" link cluttering the header.

**Trust strip:** A single horizontal line of text: "Trade accounts welcome. Same-day dispatch. Nationwide delivery." Plain white text on the dark background. No icons, no badges, no colored boxes around each point.

**Footer:** Minimal. Three columns: Navigation links, Contact info, Legal. No large logo repeat. No newsletter form in the footer (notification opt-in is handled separately via a non-intrusive prompt).

### 8.2 Product Listing Page
- **Left sidebar:** Filters (category, price range, availability, vehicle compatibility). Filters are plain text lists with checkboxes, not styled chips or colored pills.
- **Main grid:** Product cards (3 cols desktop, 2 tablet, 1 mobile). Cards follow the card spec: no borders, photography-led.
- **Top bar:** Sort dropdown and result count text. No view toggle icon.

### 8.3 Product Detail Page
- **Top:** Large image (left, takes ~60% width) with a simple thumbnail row below. Product info on the right: name in H2, price large, muted SKU, stock as colored text, quantity selector, and a single "Add to Cart" button.
- **Mid:** Specs as a two-column key-value layout (no table borders, just alternating subtle background rows). Compatibility listed as plain comma-separated text.
- **Bottom:** Related products in a 4-column grid. No "Recently Viewed" section (adds visual clutter).

### 8.4 Cart & Checkout
- **Cart:** Clean line items. Each row: small thumbnail, product name, quantity as an editable number input, line total. No borders between rows, just generous vertical spacing. Subtotal and promo code at the bottom, right-aligned.
- **Checkout:** Single-page form with clear sections separated by whitespace (not stepped progress bars with numbered circles — that’s an AI pattern). Sections: Shipping details, Payment, Order summary. One "Place Order" button at the bottom.
- **B2B:** Additional fields appear contextually for verified B2B accounts.

### 8.5 User Dashboard
- Order history as a clean table with colored text for status (no pill badges)
- Saved addresses as a plain list
- Wishlist as a minimal product grid
- Notification preferences as simple toggles, no decorative icons

---

## 9. Responsive Breakpoints

| Breakpoint | Min Width | Columns | Behavior                         |
|------------|-----------|---------|----------------------------------|
| Mobile     | 0px       | 4       | Single column, hamburger nav     |
| Tablet     | 768px     | 8       | Sidebar collapses, 2-col grid    |
| Desktop    | 1280px    | 12      | Full layout, sidebar visible     |
| Wide       | 1536px    | 12      | Max-width container, centered    |

---

## 10. Motion & Animation

Motion should be nearly invisible. If a user notices an animation, it's too much.

- **Transitions:** 150ms ease for interactive states (hover, focus). No bouncing, no elastic easing.
- **Page transitions:** None. Instant page renders. Content simply appears.
- **Loading states:** A simple opacity pulse on a flat rectangle matching the content area shape. No skeleton UIs with fake text lines and circles (that's an AI tell). Just a subtle pulse on the container.
- **Cart count:** Number updates instantly, no bounce or scale animation.
- **Toast:** Fades in from 0 to 1 opacity over 200ms at bottom-center. Fades out the same way.
- **Scroll:** No scroll-triggered animations. Content is present and visible immediately. Scroll animations feel like a template website.

---

## 11. Accessibility (WCAG 2.1 AA)

- All text meets **4.5:1** contrast ratio against backgrounds
- Focus indicators visible on all interactive elements (blue glow ring)
- Alt text required for all product images
- Keyboard-navigable: Tab order, Enter/Space activation, Escape to close modals
- ARIA labels on icon-only buttons (cart, search, menu)
- Skip-to-content link
- Reduced motion preference respected via `prefers-reduced-motion`

---

## 12. Product Categories (Spare Parts Inventory)

Each category is represented by a real product photograph, not an icon. The category tile is a large image with the category name overlaid in white text at the bottom.

| #  | Category        | Visual                                        |
|----|-----------------|-----------------------------------------------|
| 1  | Clutch Plate    | Photo of clutch disc, shot from above          |
| 2  | Steel Plate     | Photo of stacked steel plates, edge-on angle   |
| 3  | Auto Filter     | Photo of transmission filter, clean background |
| 4  | Forward Drum    | Photo of drum assembly, three-quarter view     |
| 5  | Oil Pump        | Photo of oil pump body, studio lit             |
| 6  | Piston Seal     | Photo of seal kit laid out flat                |
| 7  | Overhaul Kit    | Photo of open kit showing all components       |
| 8  | Lubricants      | Photo of ATF bottles, arranged simply          |

---

## 13. Dark Mode (Default Only)

- **Default and only theme is DARK.** This is a brand decision, not a user preference.
- No theme toggle. The dark palette is the identity. Introducing a light mode dilutes the brand and doubles the design QA surface.
- If a light mode is ever introduced in the future, it would be a separate design pass, not a token swap.

---

## 14. Assets Checklist

| Asset               | Status | Path              |
|----------------------|--------|-------------------|
| Logo (transparent)   | ✅     | `assets/logo.png` |
| Brand background     | Needed | `assets/bg-hero.png` (hexagonal artwork) |
| Product placeholder  | Needed | `assets/placeholder-part.png`            |
| Favicon (from logo)  | Needed | `assets/favicon.ico`                     |
| OG image             | Needed | `assets/og-image.png`                    |
