# 🧊 HVAC Reference App — Full Project

Ứng dụng tra cứu vật tư lạnh - điều hòa không khí (冷凍空調)
Phiên bản đầy đủ với Admin Panel, đa ngôn ngữ, lưu trữ local.

## Cài đặt

```bash
cd hvac_app_full
flutter pub get
flutter run
```

## Cấu trúc project

```
lib/
├── main.dart                          ← Entry point, Provider setup
├── models/
│   ├── field_definition.dart          ← Schema field model
│   ├── category_model.dart            ← Category với dynamic schema
│   └── item_model.dart                ← Vật tư (CRUD + JSON)
├── data/
│   └── seed_data.dart                 ← Dữ liệu mẫu (24 items, 6 cats)
├── services/
│   └── data_service.dart              ← SharedPreferences persistence
├── providers/
│   └── app_state.dart                 ← ChangeNotifier — toàn bộ state
├── l10n/
│   └── app_strings.dart               ← 3 ngôn ngữ: VI / ZH / EN
├── theme/
│   └── app_theme.dart                 ← Colors, TextStyles, Decorations
├── widgets/
│   ├── item_card.dart                 ← Card hiển thị vật tư
│   └── spec_pill.dart                 ← Badge thông số nhỏ
└── screens/
    ├── home_screen.dart               ← Trang chủ
    ├── list_screen.dart               ← Danh sách + search + filter
    ├── detail_screen.dart             ← Chi tiết thông số
    ├── settings_screen.dart           ← Ngôn ngữ + reset data
    └── admin/
        ├── admin_screen.dart          ← Dashboard admin (PIN: 1234)
        ├── add_edit_item_screen.dart  ← Form thêm/sửa vật tư (dynamic)
        ├── schema_editor_screen.dart  ← Quản lý trường thông số
        └── category_manager_screen.dart ← Thêm/sửa danh mục
```

## Tính năng đầy đủ

### 👁️ Tra cứu
- Tìm kiếm toàn văn (tên, mã, thông số, hãng)
- Filter theo danh mục
- Xem chi tiết thông số đầy đủ
- Copy/chia sẻ thông số qua clipboard

### ⚖️ So sánh
- So sánh 2-3 sản phẩm song song
- Tự động highlight điểm khác nhau

### 🌐 Đa ngôn ngữ
- 🇻🇳 Tiếng Việt (mặc định)
- 🇹🇼 繁體中文（台灣）
- 🇬🇧 English

### 🔐 Admin Panel (PIN: 1234)
- **Quản lý vật tư**: Thêm / Sửa / Xóa
- **Quản lý danh mục**: Thêm danh mục mới tùy chỉnh
- **Schema Editor**: Thêm/xóa/sắp xếp trường thông số
- **Khôi phục**: Reset về dữ liệu gốc

### 💾 Lưu trữ
- SharedPreferences — lưu offline, không cần internet
- Tự động lưu mọi thay đổi

## Packages sử dụng

| Package | Mục đích |
|---------|---------|
| `provider ^6.1.2` | State management |
| `shared_preferences ^2.2.3` | Local persistence |

## Bước tiếp theo (Phase 3)

- Tích hợp **Supabase** để đồng bộ team
- Thêm **QR Code** scanner
- **Import từ Excel** (package: excel)
- **Export ra PDF** (package: pdf)
- **Phân quyền** Admin / Editor / Viewer
