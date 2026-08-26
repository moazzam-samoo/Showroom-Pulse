# 🧠 Showroom Pulse – AI Design Memory System

> **Purpose:** Ensure AI remembers and preserves the Showroom Pulse design language.  
> **Rule:** NO UI drift, NO random colors, NO foreign typography.

---

## Design Identity Lock 🔒

### Brand Essence

- **Name:** Showroom Pulse
- **Tagline:** Inventory Management System
- **Domain:** Motorcycle Dealership ERP
- **Platform:** Windows Desktop (Flutter)

### Logo & Icon

- Motorcycle/Bike icon in rounded square container
- Primary color icon on light background (Light Theme)
- Cyan icon on dark card (Dark Theme)

---

## Color Memory

### Light Theme (Windows 11 Fluent)

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#0078D4` | Buttons, links, active states |
| `primaryHover` | `#106EBE` | Button hover |
| `primaryLight` | `#E8F4FD` | Active nav backgrounds |
| `gradientDark` | `#1a5276` | KPI card gradient start |
| `gradientLight` | `#2980b9` | KPI card gradient end |
| `background` | `#F3F3F3` | App background (Mica) |
| `surface` | `#FFFFFF` | Cards, sidebar |
| `textPrimary` | `#1F2937` | Headings |
| `textSecondary` | `#6B7280` | Labels |
| `textMuted` | `#9CA3AF` | Placeholders |
| `success` | `#16A34A` | Available, positive |
| `warning` | `#F97316` | Remaining, pending |
| `error` | `#DC2626` | Errors, delete |

### Dark Theme (Executive Command Center)

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#06b6d4` | Buttons, accents, charts |
| `primaryHover` | `#0891b2` | Button hover |
| `background` | `#0a0e17` | App background (darkest) |
| `surface` | `#0f172a` | Cards, panels |
| `elevated` | `#1e293b` | Inputs, hover states |
| `border` | `#334155` | Input borders |
| `textPrimary` | `#FFFFFF` | Headings |
| `textSecondary` | `#cbd5e1` | Labels |
| `textMuted` | `#94a3b8` | Secondary info |
| `success` | `#10b981` | Emerald positive |
| `warning` | `#f59e0b` | Amber alerts |
| `error` | `#ef4444` | Red critical |

---

## Typography Memory

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| Display | 30px | 700 | Hero titles |
| H1 | 24px | 700 | Page titles |
| H2 | 20px | 700 | Section titles |
| H3 | 16px | 600 | Card titles |
| Body | 14px | 400 | Content |
| Body Medium | 14px | 500 | Table cells |
| Caption | 12px | 400 | Timestamps |
| Micro | 10px | 400 | Nav labels, badges |

**Font Family:** `Segoe UI`, `Roboto`, sans-serif

---

## Spacing Memory

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Icon gaps |
| sm | 8px | Compact spacing |
| md | 12px | Form padding |
| base | 16px | Card padding |
| lg | 24px | Section padding |
| xl | 32px | Page padding |
| 2xl | 48px | Large separation |

---

## Border Radius Memory

| Token | Value | Usage |
|-------|-------|-------|
| sm | 4px | Small buttons, badges |
| md | 8px | Inputs, small cards |
| lg | 12px | Cards, panels |
| xl | 16px | Large cards, modals |
| 2xl | 24px | Hero cards |
| full | 9999px | Avatars, toggles |

---

## Component Patterns

### KPI Cards (Dashboard)

- Blue gradient background (`#1a5276` → `#2980b9`)
- White text for values and labels
- Small icon (right-aligned, semi-transparent)
- Border radius: 12px
- Shadow: subtle

### Data Cards (Inventory, Sales)

- White background (Light) / `#0f172a` (Dark)
- Top image with rounded corners
- Status badge (top-right of image)
- Details section with muted labels
- Border radius: 12px

### Customer Cards

- Colored avatar circle with initials
- Progress bar for payment status
- Bike model tag

### Sidebar Navigation

- 64px width (collapsed)
- Icon only, no labels visible
- Active state: light blue background (Light) / cyan glow (Dark)

### Buttons

- Primary: Solid color with white text
- Secondary: Outline with colored text
- Border radius: 8px
- Height: 40-44px

### Inputs

- White background with gray border
- Focus: Primary color ring
- Border radius: 8px
- Padding: 12px 16px

---

## Behavioral Rules

### When User Says "Is jaisa change kro" (Change like this)

1. Extract the **behavior/functionality** only
2. **Preserve** Showroom Pulse theme
3. Apply change using design tokens above
4. ❌ Do NOT introduce new colors
5. ❌ Do NOT use random fonts

### When User Says "Change complete theme"

1. Then and ONLY then may theme be modified
2. Require explicit new color palette
3. Update this REMEMBERING.md file

---

## Consistency Checklist (Before Every UI Code)

- [ ] Using colors from design tokens only?
- [ ] Using typography scale correctly?
- [ ] Using spacing tokens?
- [ ] Border radius matches component type?
- [ ] Icons from Lucide library?
- [ ] Dark theme variant considered?
- [ ] Component follows established patterns?

---

*Memory System – Authored by: Moazzam Samoo*
