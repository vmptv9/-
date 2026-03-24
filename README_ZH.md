# 🧊 HVAC 參考應用程式 — 完整專案

> 應用程式用於查詢冷凍空調物料（冷凍空調）  
> 完整版本含 **Admin Panel**、**多語言** 及 **本地存儲**

---

## 🚀 安裝

```bash
cd hvac_app_full
flutter pub get
flutter run
```

---

## 📁 專案結構

```
lib/
├── main.dart                            ← 入口檔，Provider 設定
│
├── models/
│   ├── field_definition.dart            ← 欄位模型
│   ├── category_model.dart              ← 含動態 schema 的分類
│   └── item_model.dart                  ← 物料 (CRUD + JSON)
│
├── data/
│   └── seed_data.dart                   ← 範例資料 (24 個項目，6 個分類)
│
├── services/
│   └── data_service.dart                ← SharedPreferences 持久化
│
├── providers/
│   └── app_state.dart                   ← ChangeNotifier — 全局狀態
│
├── l10n/
│   └── app_strings.dart                 ← 3 種語言：VI / ZH / EN
│
├── theme/
│   └── app_theme.dart                   ← 顏色、字型、裝飾
│
├── widgets/
│   ├── item_card.dart                   ← 顯示物料的卡片
│   └── spec_pill.dart                   ← 小型規格標籤
│
└── screens/
    ├── home_screen.dart                 ← 首頁
    ├── list_screen.dart                 ← 列表 + 搜尋 + 篩選
    ├── detail_screen.dart               ← 規格細節
    ├── settings_screen.dart             ← 語言 + 資料重置
    └── admin/
        ├── admin_screen.dart            ← Admin Dashboard (PIN: 1234)
        ├── add_edit_item_screen.dart    ← 新增/編輯物料表單 (動態)
        ├── schema_editor_screen.dart    ← 管理欄位規格
        └── category_manager_screen.dart ← 新增/編輯分類
```

---

## ✨ 完整功能

### 👁️ 查詢
- 全文搜索（名稱、代碼、規格、品牌）
- 按分類篩選
- 查看完整規格
- 複製 / 分享規格到剪貼簿

### ⚖️ 比較
- 同時比較 2–3 個產品
- 自動標註差異

### 🌐 多語言

| 旗幟 | 語言 |
|------|------|
| 🇻🇳 | 越南語 *(預設)* |
| 🇹🇼 | 繁體中文（台灣） |
| 🇬🇧 | 英語 |

### 🔐 Admin Panel *(PIN: 1234)*

| 功能 | 說明 |
|------|------|
| 管理物料 | 新增 / 編輯 / 刪除 |
| 管理分類 | 新增自訂分類 |
| Schema 編輯器 | 新增 / 刪除 / 排序欄位 |
| 恢復 | 重置為原始資料 |

### 💾 本地存儲
- 使用 **SharedPreferences**，離線可用，無需網路
- 自動保存所有變更

---

## 📦 使用套件

| 套件 | 版本 | 功能 |
|------|------|------|
| `provider` | `^6.1.2` | 狀態管理 |
| `shared_preferences` | `^2.2.3` | 本地持久化 |

---

## 🗺️ 下一步（Phase 3）

- [ ] 🔗 整合 **Supabase** 以同步團隊資料
- [ ] 📷 新增 **QR Code** 掃描功能
- [ ] 📊 從 **Excel 匯入** *(套件: `excel`)*
- [ ] 📄 **匯出 PDF** *(套件: `pdf`)*
- [ ] 👥 **權限管理** Admin / Editor / Viewer

---

*以 Flutter 構建 💙*
