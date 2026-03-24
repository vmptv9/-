// lib/l10n/app_strings.dart

enum AppLanguage { vi, zh, en }

class AppStrings {
  final AppLanguage language;
  const AppStrings(this.language);

  // ── META ──────────────────────────────────────────────────────
  String get appName => _t('HVAC Reference', 'HVAC 參考手冊', 'HVAC Reference');
  String get appSub  => _t('冷凍空調 · Vật tư kỹ thuật', '冷凍空調 · 技術物料', '冷凍空調 · Technical Materials');

  // ── HOME ──────────────────────────────────────────────────────
  String get greeting    => _t('Xin chào 👷', '哈囉 👷', 'Hello 👷');
  String get greetingSub => _t('Tra cứu vật tư lạnh - điều hòa nhanh chóng',
                               '快速查詢冷凍空調物料規格', 'Quick HVAC material reference');
  String get categoryTitle => _t('DANH MỤC VẬT TƯ', '物料類別', 'CATEGORIES');
  String get recentTitle   => _t('GẦN ĐÂY', '最近查詢', 'RECENT');
  String get searchHint    => _t('Tìm tên, mã, kích thước, hãng...', '搜尋名稱、規格、廠牌…', 'Search name, size, brand...');
  String get itemCount     => _t('mục', '項', 'items');

  // ── LIST ──────────────────────────────────────────────────────
  String get allFilter    => _t('Tất cả', '全部', 'All');
  String get results      => _t('kết quả', '筆結果', 'results');
  String get resultsFor   => _t('cho', '關於', 'for');
  String get noResults    => _t('Không tìm thấy kết quả', '找不到結果', 'No results found');
  String get noResultsSub => _t('Thử từ khóa khác', '請嘗試其他關鍵字', 'Try a different keyword');

  // ── DETAIL ────────────────────────────────────────────────────
  String get specTitle  => _t('THÔNG SỐ KỸ THUẬT', '技術規格', 'SPECIFICATIONS');
  String get brand      => _t('Hãng sản xuất', '製造廠牌', 'Brand');
  String get addCompare => _t('+ So sánh', '+ 加入比較', '+ Compare');
  String get inCompare  => _t('✓ Đã thêm', '✓ 已加入', '✓ Added');
  String get share      => _t('Chia sẻ', '分享', 'Share');
  String get copied     => _t('Đã copy thông số ✓', '已複製規格 ✓', 'Specs copied ✓');
  String get edit       => _t('Chỉnh sửa', '編輯', 'Edit');
  String get delete     => _t('Xóa', '刪除', 'Delete');

  // ── COMPARE ───────────────────────────────────────────────────
  String get compareTitle    => _t('So sánh sản phẩm', '產品比較', 'Compare Products');
  String get compareEmpty    => _t('Chọn ít nhất 2 sản phẩm', '請選擇至少 2 項產品', 'Select at least 2 items');
  String get compareEmptySub => _t('Bấm + trên mỗi sản phẩm', '點選 + 按鈕', 'Tap + on each item');
  String get compareParam    => _t('Thông số', '規格項目', 'Parameter');
  String get compareBar      => _t('So sánh', '比較', 'Compare');
  String get compareView     => _t('Xem →', '查看 →', 'View →');
  String get maxCompare      => _t('Tối đa 3 sản phẩm', '最多比較 3 項', 'Maximum 3 items');

  // ── NAV ───────────────────────────────────────────────────────
  String get navHome    => _t('Trang chủ', '首頁', 'Home');
  String get navCatalog => _t('Danh mục', '目錄', 'Catalog');
  String get navCompare => _t('So sánh', '比較', 'Compare');
  String get navAdmin   => _t('Admin', '管理', 'Admin');

  // ── SETTINGS ──────────────────────────────────────────────────
  String get settingsTitle    => _t('Cài đặt', '設定', 'Settings');
  String get languageTitle    => _t('Ngôn ngữ', '語言', 'Language');
  String get languageSubtitle => _t('Chọn ngôn ngữ hiển thị', '選擇顯示語言', 'Select display language');
  String get apply            => _t('Áp dụng', '套用', 'Apply');
  String get resetData        => _t('Khôi phục dữ liệu gốc', '還原預設資料', 'Reset to default data');
  String get resetConfirm     => _t('Xác nhận khôi phục? Tất cả thay đổi sẽ bị mất.',
                                    '確定要還原？所有變更將會遺失。', 'Confirm reset? All changes will be lost.');
  String get confirm          => _t('Xác nhận', '確認', 'Confirm');
  String get cancel           => _t('Hủy', '取消', 'Cancel');

  // ── ADMIN ─────────────────────────────────────────────────────
  String get adminTitle      => _t('Quản trị', '管理介面', 'Admin Panel');
  String get adminSubtitle   => _t('Quản lý vật tư & danh mục', '管理物料與類別', 'Manage materials & categories');
  String get adminPin        => _t('Nhập mã PIN', '輸入密碼', 'Enter PIN');
  String get adminPinHint    => _t('Mã PIN admin (mặc định: 1234)', '管理員密碼（預設：1234）', 'Admin PIN (default: 1234)');
  String get adminPinError   => _t('Mã PIN không đúng', '密碼錯誤', 'Incorrect PIN');
  String get adminUnlock     => _t('Đăng nhập', '登入', 'Login');
  String get adminLock       => _t('Đăng xuất Admin', '登出管理介面', 'Logout Admin');
  String get manageItems     => _t('Quản lý Vật tư', '管理物料', 'Manage Items');
  String get manageCategories => _t('Quản lý Danh mục', '管理類別', 'Manage Categories');
  String get schemaEditor    => _t('Chỉnh sửa Schema', '編輯欄位架構', 'Edit Schema');
  String get addItem         => _t('Thêm vật tư', '新增物料', 'Add Item');
  String get editItem        => _t('Chỉnh sửa vật tư', '編輯物料', 'Edit Item');
  String get deleteItem      => _t('Xóa vật tư', '刪除物料', 'Delete Item');
  String get deleteItemConfirm => _t('Xác nhận xóa vật tư này?', '確定要刪除此物料？', 'Delete this item?');
  String get addCategory     => _t('Thêm danh mục', '新增類別', 'Add Category');
  String get editCategory    => _t('Chỉnh sửa danh mục', '編輯類別', 'Edit Category');
  String get deleteCategoryConfirm => _t('Xóa danh mục sẽ xóa tất cả vật tư trong đó!',
                                         '刪除類別將同時刪除其中所有物料！', 'Deleting category removes all its items!');
  String get save            => _t('Lưu', '儲存', 'Save');
  String get itemName        => _t('Tên vật tư', '物料名稱', 'Item Name');
  String get itemBrand       => _t('Hãng sản xuất', '製造廠牌', 'Brand');
  String get selectCategory  => _t('Chọn danh mục', '選擇類別', 'Select Category');
  String get fieldName       => _t('Tên trường', '欄位名稱', 'Field Name');
  String get addField        => _t('+ Thêm trường', '+ 新增欄位', '+ Add Field');
  String get requiredField   => _t('Bắt buộc', '必填', 'Required');
  String get categoryLabel   => _t('Tên danh mục', '類別名稱', 'Category Name');
  String get categoryIcon    => _t('Biểu tượng (emoji)', '圖示（表情符號）', 'Icon (emoji)');
  String get categoryColor   => _t('Màu sắc', '顏色', 'Color');
  String get schemaTitle     => _t('Quản lý trường thông số', '管理規格欄位', 'Manage Spec Fields');
  String get totalItems      => _t('vật tư', '項物料', 'items');

  // ── CATEGORY NAMES ────────────────────────────────────────────
  String get catPipe    => _t('Hàng Ống',       '管材類',     'Pipes & Tubes');
  String get catWire    => _t('Dây Điện',        '電線電纜',   'Wiring');
  String get catFcu     => _t('FCU / AHU',       'FCU / AHU', 'FCU / AHU');
  String get catChiller => _t('Chiller / Tower', '冰水機',    'Chiller / Tower');
  String get catFitting => _t('Phụ Kiện',        '配件類',    'Fittings');
  String get catCtrl    => _t('Điều Khiển',      '控制設備',  'Controls');

  String catName(String id, [String? fallback]) {
    switch (id) {
      case 'pipe':    return catPipe;
      case 'wire':    return catWire;
      case 'fcu':     return catFcu;
      case 'chiller': return catChiller;
      case 'fitting': return catFitting;
      case 'ctrl':    return catCtrl;
      default:        return fallback ?? id; // 有fallback就用或用id
    }
  }

  // ── SPEC KEY TRANSLATION ──────────────────────────────────────
  String specKey(String raw) {
    if (language == AppLanguage.vi) return raw;
    const zhMap = {
      'Φ Ngoài': 'Φ 外徑', 'Φ Trong': 'Φ 內徑', 'Độ dày': '管壁厚度',
      'Áp suất': '工作壓力', 'Tiêu chuẩn': '適用規範', 'Chiều dài cuộn': '捲長',
      'Chiều dài': '長度', 'Trọng lượng': '重量', 'Vật liệu': '材質',
      'Tiết diện': '導體截面積', 'Số lõi': '芯數', 'Điện áp': '額定電壓',
      'Vỏ bọc': '絕緣護套', 'Đường kính ngoài': '外徑', 'Ứng dụng': '適用場合',
      'Công suất lạnh': '冷房能力', 'Công suất nhiệt': '暖房能力',
      'Công suất': '功率', 'Lưu lượng gió': '風量', 'Cấp lọc': '過濾等級',
      'Kết nối lỏng': '液管接頭', 'Kết nối gas': '氣管接頭',
      'Kết nối ống nước': '冷凍水配管', 'Nguồn điện': '電源規格',
      'Kích thước': '外形尺寸', 'Áp tĩnh': '靜壓',
      'Lưu lượng nước lạnh': '冷凍水流量', 'Môi chất': '冷媒種類', 'COP': 'COP',
      'Công suất giải nhiệt': '散熱能力', 'Công suất quạt': '風機功率',
      'Loại kết nối': '接頭型式', 'Kết nối': '接頭', 'Loại': '類型',
      'Nhiệt độ': '使用溫度', 'Điện áp vào': '輸入電壓',
      'Tần số ra': '輸出頻率', 'IP Rating': '防護等級', 'Giao thức': '通訊協定',
      'AI': 'AI（類比輸入）', 'AO': 'AO（類比輸出）',
      'DI': 'DI（數位輸入）', 'DO': 'DO（數位輸出）',
    };
    const enMap = {
      'Φ Ngoài': 'Outer Dia.', 'Φ Trong': 'Inner Dia.', 'Độ dày': 'Wall Thick.',
      'Áp suất': 'Pressure', 'Tiêu chuẩn': 'Standard', 'Chiều dài cuộn': 'Coil Length',
      'Chiều dài': 'Length', 'Trọng lượng': 'Weight', 'Vật liệu': 'Material',
      'Tiết diện': 'Cross Section', 'Số lõi': 'Cores', 'Điện áp': 'Voltage',
      'Vỏ bọc': 'Insulation', 'Đường kính ngoài': 'Outer Dia.', 'Ứng dụng': 'Application',
      'Công suất lạnh': 'Cooling Cap.', 'Công suất nhiệt': 'Heating Cap.',
      'Công suất': 'Power', 'Lưu lượng gió': 'Airflow', 'Cấp lọc': 'Filter Grade',
      'Kết nối lỏng': 'Liquid Line', 'Kết nối gas': 'Gas Line',
      'Kết nối ống nước': 'Chilled Water', 'Nguồn điện': 'Power Supply',
      'Kích thước': 'Dimensions', 'Áp tĩnh': 'Static Pressure',
      'Lưu lượng nước lạnh': 'CHW Flow', 'Môi chất': 'Refrigerant', 'COP': 'COP',
      'Công suất giải nhiệt': 'Heat Rejection', 'Công suất quạt': 'Fan Power',
      'Loại kết nối': 'Connection Type', 'Kết nối': 'Connection', 'Loại': 'Type',
      'Nhiệt độ': 'Temperature', 'Điện áp vào': 'Input Voltage',
      'Tần số ra': 'Output Freq.', 'IP Rating': 'IP Rating', 'Giao thức': 'Protocol',
      'AI': 'AI (Analog In)', 'AO': 'AO (Analog Out)',
      'DI': 'DI (Digital In)', 'DO': 'DO (Digital Out)',
    };
    return language == AppLanguage.zh
        ? zhMap[raw] ?? raw
        : enMap[raw] ?? raw;
  }

  String _t(String vi, String zh, String en) {
    switch (language) {
      case AppLanguage.vi: return vi;
      case AppLanguage.zh: return zh;
      case AppLanguage.en: return en;
    }
  }

  static String languageName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.vi: return '🇻🇳  Tiếng Việt';
      case AppLanguage.zh: return '🇹🇼  繁體中文';
      case AppLanguage.en: return '🇬🇧  English';
    }
  }
}
