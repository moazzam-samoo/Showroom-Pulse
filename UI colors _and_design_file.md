


# Tahir Showroom Design System
Windows 11 Fluent UI inspired design language for motorcycle dealership management.

---

## Color Palette

### Primary Colors
| Color | Hex | Usage |
|-------|-----|-------|
| **Primary Blue** | `#0078D4` | Buttons, links, active states, progress bars, key metrics |
| **Primary Blue Hover** | `#106EBE` | Button hover states |
| **Primary Blue Light** | `#E8F4FD` | Active nav backgrounds, subtle highlights |

### Gradient Colors
| Color | Hex | Usage |
|-------|-----|-------|
| **Gradient Dark** | `#1a5276` | KPI cards gradient start, header gradient start |
| **Gradient Light** | `#2980b9` | KPI cards gradient end, header gradient end, section headers |

### Background Colors
| Color | Hex | Usage |
|-------|-----|-------|
| **App Background** | `#F3F3F3` | Main app background (mica effect) |
| **Card Background** | `#FFFFFF` | Cards, panels, sidebar |
| **Form Background** | `#E3F2FD → #BBDEFB` | Form screens gradient background |
| **Row Alternate** | `#F9FAFB` | Table row backgrounds, list items |

### Text Colors
| Color | Hex | Usage |
|-------|-----|-------|
| **Text Primary** | `#1F2937` (gray-800) | Headings, primary content |
| **Text Secondary** | `#6B7280` (gray-500) | Labels, descriptions, metadata |
| **Text Muted** | `#9CA3AF` (gray-400) | Placeholders, timestamps, hints |
| **Text White** | `#FFFFFF` | Text on dark/gradient backgrounds |
| **Text White Muted** | `rgba(255,255,255,0.8)` | Secondary text on dark backgrounds |

### Semantic Colors
| Color | Hex | Usage |
|-------|-----|-------|
| **Success** | `#16A34A` (green-600) | Paid status, positive amounts, completed |
| **Success Light** | `#DCFCE7` (green-100) | Available badges background |
| **Warning** | `#F97316` (orange-500) | Remaining amounts, pending states |
| **Error** | `#DC2626` (red-600) | Error states, delete actions |

### Border Colors
| Color | Hex | Usage |
|-------|-----|-------|
| **Border Default** | `#E5E7EB` (gray-200) | Input borders, card borders |
| **Border Light** | `#F3F4F6` (gray-100) | Table rows, dividers |
| **Border Dashed** | `#D1D5DB` (gray-300) | Upload areas, empty states |

---

## Dark Theme Color Palette (Executive Command Center)

### Primary Colors (Dark)
| Color | Hex | Usage |
|-------|-----|-------|
| **Cyan Primary** | `#06b6d4` | Buttons, accents, active states, charts |
| **Cyan Hover** | `#0891b2` | Button hover states |
| **Cyan Light** | `rgba(6,182,212,0.1)` | Active nav backgrounds |

### Background Colors (Dark)
| Color | Hex | Usage |
|-------|-----|-------|
| **App Background** | `#0a0e17` | Main app background (darkest) |
| **Card Background** | `#0f172a` | Cards, panels, modals |
| **Elevated Surface** | `#1e293b` | Inputs, dropdowns, hover states |
| **Border Dark** | `#1e293b` | Card borders, dividers |
| **Border Input** | `#334155` | Input field borders |

### Text Colors (Dark)
| Color | Hex | Usage |
|-------|-----|-------|
| **Text Primary** | `#FFFFFF` | Headings, primary content |
| **Text Secondary** | `#cbd5e1` (slate-300) | Labels, descriptions |
| **Text Muted** | `#94a3b8` (slate-400) | Secondary info |
| **Text Disabled** | `#64748b` (slate-500) | Placeholders, timestamps |

### Semantic Colors (Dark)
| Color | Hex | Usage |
|-------|-----|-------|
| **Success/Emerald** | `#10b981` | Completed, available, positive |
| **Warning/Amber** | `#f59e0b` | Alerts, remaining amounts |
| **Error/Red** | `#ef4444` | Critical, overdue |
| **Info/Cyan** | `#06b6d4` | Highlights, progress |

### Chart Colors (Dark)
| Element | Color |
|---------|-------|
| **Area Fill Gradient** | `#06b6d4` → transparent |
| **Line Stroke** | `#06b6d4` |
| **Bar Fill** | `#06b6d4` |
| **Axis Text** | `#64748b` |

### Component States (Dark)
| Component | Default | Hover | Active |
|-----------|---------|-------|--------|
| **Sidebar Nav** | `#64748b` | `#1e293b` bg | `cyan-500/10` bg + `#06b6d4` text |
| **Button Primary** | `#06b6d4` | `#0891b2` | — |
| **Button Secondary** | `#1e293b` | `#334155` | — |
| **Input** | `#1e293b` bg, `#334155` border | — | `#06b6d4` ring |
| **Card** | `#0f172a` | shadow increase | — |

---

## Typography

### Font Family
```
Primary: Segoe UI, Roboto, sans-serif
```

### Type Scale

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| **Display** | 30px (text-3xl) | Bold (700) | 1.2 | Hero titles, main page headers |
| **Heading 1** | 24px (text-2xl) | Bold (700) | 1.3 | Page titles, form headers |
| **Heading 2** | 20px (text-xl) | Bold (700) | 1.4 | Section titles |
| **Heading 3** | 16px (text-base) | Semibold (600) | 1.5 | Card titles, panel headers |
| **Body** | 14px (text-sm) | Regular (400) | 1.5 | Body text, descriptions |
| **Body Medium** | 14px (text-sm) | Medium (500) | 1.5 | Table cells, form values |
| **Caption** | 12px (text-xs) | Regular (400) | 1.4 | Timestamps, metadata, hints |
| **Micro** | 10px (text-[10px]) | Regular (400) | 1.3 | Navigation labels, badges |

### Text Styles by Context

**Headers & Titles**
```css
/* Page Title */
font-size: 24px; font-weight: 700; color: #1F2937;

/* Section Header (on blue bg) */
font-size: 16px; font-weight: 600; color: #FFFFFF;

/* Card Title */
font-size: 14px; font-weight: 600; color: #1F2937;
```

**KPI Cards**
```css
/* KPI Label */
font-size: 14px; font-weight: 400; color: rgba(255,255,255,0.8);

/* KPI Value */
font-size: 24px; font-weight: 700; color: #FFFFFF;
```

**Form Elements**
```css
/* Input Label */
font-size: 14px; font-weight: 400; color: #6B7280;

/* Input Value */
font-size: 14px; font-weight: 400; color: #1F2937;

/* Placeholder */
font-size: 14px; font-weight: 400; color: #9CA3AF;
```

**Tables**
```css
/* Table Header */
font-size: 14px; font-weight: 500; color: #6B7280;

/* Table Cell */
font-size: 14px; font-weight: 400; color: #1F2937;

/* Table Cell Emphasis */
font-size: 14px; font-weight: 600; color: #16A34A;
```

---

## Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| **xs** | 4px | Icon gaps, tight spacing |
| **sm** | 8px | Compact element spacing |
| **md** | 12px | Form field padding |
| **base** | 16px | Card padding, section gaps |
| **lg** | 24px | Section padding, major gaps |
| **xl** | 32px | Page padding |
| **2xl** | 48px | Large section separation |

---

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| **sm** | 4px | Small buttons, badges |
| **md** | 8px | Inputs, small cards |
| **lg** | 12px | Cards, panels |
| **xl** | 16px | Large cards, modals |
| **2xl** | 24px | Hero cards |
| **full** | 9999px | Avatars, progress bars, toggles |

---

## Shadow System

| Token | Value | Usage |
|-------|-------|-------|
| **sm** | `0 1px 2px rgba(0,0,0,0.05)` | Cards, subtle elevation |
| **md** | `0 4px 6px rgba(0,0,0,0.1)` | Dropdowns, popovers |
| **lg** | `0 10px 15px rgba(0,0,0,0.1)` | Modals, hero cards on hover |

---

## Component Tokens

### Buttons
| State | Background | Text | Border |
|-------|------------|------|--------|
| **Primary** | `#0078D4` | `#FFFFFF` | none |
| **Primary Hover** | `#106EBE` | `#FFFFFF` | none |
| **Secondary** | `#FFFFFF` | `#1F2937` | `#E5E7EB` |
| **Secondary Hover** | `#F9FAFB` | `#1F2937` | `#E5E7EB` |

### Inputs
| State | Background | Border | Text |
|-------|------------|--------|------|
| **Default** | `#FFFFFF` | `#E5E7EB` | `#1F2937` |
| **Focus** | `#FFFFFF` | `#0078D4` | `#1F2937` |
| **Disabled** | `#F3F4F6` | `#E5E7EB` | `#9CA3AF` |

### Navigation
| State | Background | Text |
|-------|------------|------|
| **Default** | transparent | `#6B7280` |
| **Hover** | `#F3F4F6` | `#6B7280` |
| **Active** | `#E8F4FD` | `#0078D4` |

### Status Badges
| Status | Background | Text |
|--------|------------|------|
| **Available** | `#DCFCE7` | `#16A34A` |
| **Pending** | `#FEF3C7` | `#D97706` |
| **Sold** | `#DBEAFE` | `#2563EB` |

### Progress Bars
| State | Track | Fill |
|-------|-------|------|
| **Default** | `#E5E7EB` | `#0078D4` |
| **On Dark** | `rgba(255,255,255,0.2)` | `#FFFFFF` |
| **Complete** | `#E5E7EB` | `#16A34A` |

---

## Iconography

**Library:** Lucide React

**Sizes:**
| Context | Size | Class |
|---------|------|-------|
| Navigation | 20px | `w-5 h-5` |
| Buttons | 16px | `w-4 h-4` |
| KPI Decorative | 64px | `w-16 h-16` |
| Form Icons | 20px | `w-5 h-5` |

**Key Icons Used:**
- `LayoutGrid` - Dashboard
- `Package` - Inventory
- `ShoppingCart` - Sales
- `Users` - Customers
- `BarChart3` - Reports
- `Settings` - Settings
- `Bike` - Motorcycle/Vehicle
- `DollarSign` - Financial
- `Clock` - Pending/Time
- `CreditCard` - Payments

---

## Layout Specifications

### Sidebar
- Width: 64px (collapsed)
- Background: `#FFFFFF`
- Border: 1px solid `#E5E7EB`

### Title Bar
- Height: 32px
- Background: `#FFFFFF`
- Border: 1px solid `#E5E7EB`

### Content Area
- Padding: 24px
- Max Width: Fluid
- Background: `#F3F3F3`

### Cards
- Padding: 16-24px
- Border Radius: 12px
- Shadow: sm
- Background: `#FFFFFF`

### Grid
- Columns: 2-4 (responsive)
- Gap: 16-24px


