# 🎨 PLAN: Fix Light Mode Visibility (App-Wide)

> **Goal:** Resolve "White-on-White" visibility issues by establishing a High-Contrast Light Theme strategy.

## 🔍 Diagnosis
The current Light Theme likely uses `#FFFFFF` for both Background and Surface, or lacks sufficient border/shadow definition, causing widgets to blend into the background.

## 🛠️ Remediation Strategy (Frontend Specialist)

### 1. **Color System Update (`AppColors`)**
-   **Background:** Shift from White to `Colors.grey[100]` / `#F3F4F6` (Mica/Off-white).
-   **Surfaces:** Keep Cards/Sidebar as `#FFFFFF` (Pure White) to pop against the off-white background.
-   **Borders:** Enforce `Colors.grey[300]` (not 200) for better definition.
-   **Shadows:** Increase opacity to 10-15% for Light Mode depth.

### 2. **Component Audit & Fix**
| Component | Issue | Fix |
|-----------|-------|-----|
| **Sidebar** | Blends with bg | Add Right Border `grey[300]` + White BG |
| **Bike Card** | Invisible boundaries | Ensure White BG + Stronger Shadow |
| **KPI Cards** | Text contrast | Verify gradient text colors |
| **Tables** | Row distinction | Add zebra-striping or border separators |

### 3. **Screen-by-Screen Turnaround**
-   [ ] **Dashboard:** Sidebar, Header, KPI, Charts
-   [ ] **Inventory:** Filter Bar, Bike Cards, Dialogs
-   [ ] **Procurement:** Supplier Cards, History Lists

## ✅ Verification (Test Engineer)
-   **Manual Walkthrough:** Toggle Theme -> Check every page.
-   **Automated Check:** Run `checklist.py` to ensure no broken consts.

## 🤖 Agent Assignments
1.  **`frontend-specialist`**: Execute Color & Component updates.
2.  **`test-engineer`**: Run verifications.
