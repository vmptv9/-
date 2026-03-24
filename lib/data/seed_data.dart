// lib/data/seed_data.dart
import '../models/category_model.dart';
import '../models/field_definition.dart';
import '../models/item_model.dart';

class SeedData {
  static List<CategoryModel> get categories => [
    CategoryModel(
      id: 'pipe',
      label: '管材', // Hàng Ống
      icon: '〇',
      colorValue: 0xFF0EA5E9,
      fields: _fields([
        '外徑', '厚度', '內徑', '壓力',
        '標準', '卷長', '重量', '材質',
      ], required: ['外徑', '厚度']),
    ),
    CategoryModel(
      id: 'wire',
      label: '電線', // Dây Điện
      icon: '≋',
      colorValue: 0xFFF59E0B,
      fields: _fields([
        '截面', '芯數', '電壓', '護套',
        '標準', '外徑', '用途',
      ], required: ['截面', '芯數']),
    ),
    CategoryModel(
      id: 'fcu',
      label: 'FCU / AHU',
      icon: '❄',
      colorValue: 0xFF10B981,
      fields: _fields([
        '冷量', '熱量', '風量', '過濾等級',
        '液管接頭', '氣管接頭', '電源',
        '尺寸', '重量',
      ], required: ['冷量', '電源']),
    ),
    CategoryModel(
      id: 'chiller',
      label: '冷水機 / 冷卻塔', // Chiller / Tower
      icon: '⬡',
      colorValue: 0xFF8B5CF6,
      fields: _fields([
        '冷量', '冷媒', '冷水流量',
        'COP', '電源', '尺寸', '重量',
        '冷卻能力', '風扇功率',
      ], required: ['冷量']),
    ),
    CategoryModel(
      id: 'fitting',
      label: '配件', // Phụ Kiện
      icon: '⌀',
      colorValue: 0xFFEF4444,
      fields: _fields([
        '類型', '尺寸', '材質', '連接方式',
        '壓力', '溫度', '標準',
      ], required: ['類型', '尺寸']),
    ),
    CategoryModel(
      id: 'ctrl',
      label: '控制器', // Điều Khiển
      icon: '⚙',
      colorValue: 0xFFEC4899,
      fields: _fields([
        '類型', '功率', '輸入電壓', '輸出頻率',
        '防護等級', '通訊協議', '尺寸', '重量',
        'AI', 'AO', 'DI', 'DO',
      ], required: ['類型']),
    ),
  ];

  static List<FieldDefinition> _fields(List<String> keys,
      {List<String> required = const []}) {
    return keys.asMap().entries.map((e) => FieldDefinition(
      key: e.value,
      order: e.key,
      isRequired: required.contains(e.value),
    )).toList();
  }

  static List<MaterialItem> get items {
    final now = DateTime(2024, 1, 1);
    int idx = 0;
    MaterialItem mk(String cat, String name, String brand,
        Map<String, String> specs) =>
        MaterialItem(
          id: '${(++idx).toString().padLeft(4, '0')}',
          categoryId: cat,
          name: name,
          brand: brand,
          specs: specs,
          createdAt: now,
        );

    return [
      mk('pipe', '銅管 ACR Φ6.35', 'Kembla', {
        '外徑': '6.35 mm', '厚度': '0.70 mm', '內徑': '4.95 mm',
        '壓力': '4.2 MPa', '標準': 'JIS H3300', '卷長': '15 m', '重量': '0.148 kg/m',
      }),
      mk('pipe', '銅管 ACR Φ9.52', 'Kembla', {
        '外徑': '9.52 mm', '厚度': '0.80 mm', '內徑': '7.92 mm',
        '壓力': '3.8 MPa', '標準': 'JIS H3300', '卷長': '15 m', '重量': '0.214 kg/m',
      }),
      mk('wire', 'CVV 2×1.5mm²', 'Cadivi', {
        '截面': '1.5 mm²', '芯數': '2', '電壓': '600V',
        '護套': 'PVC', '標準': 'IEC 60502', '外徑': '8.2 mm', '用途': 'FCU電源',
      }),
      mk('fcu', 'Daikin FHQ71KAVEA FCU', 'Daikin', {
        '冷量': '24,000 BTU', '熱量': '27,000 BTU', '風量': '1,500 m³/h', '過濾等級': 'G4',
        '液管接頭': 'Φ15.88 mm', '氣管接頭': 'Φ9.52 mm', '電源': '220V/1Ph/50Hz',
        '尺寸': '1,000×245×700 mm', '重量': '22 kg',
      }),
      mk('chiller', 'Carrier 30XA-0152 冷水機', 'Carrier', {
        '冷量': '150 RT / 527 kW', '冷媒': 'R134a', '冷水流量': '90 m³/h', 'COP': '3.2',
        '電源': '380V/3Ph/50Hz', '尺寸': '4,200×1,800×2,100 mm', '重量': '4,500 kg',
      }),
      mk('fitting', 'Swagelok 球閥 Φ15.88', 'Swagelok', {
        '類型': '球閥 (Globe Valve)', '尺寸': 'Φ15.88 mm', '材質': '銅',
        '連接方式': '焊接', '壓力': '4.0 MPa', '溫度': '−40°C ~ 150°C', '標準': 'ASME B16.22',
      }),
      mk('ctrl', 'Danfoss VLT FC302 變頻器', 'Danfoss', {
        '類型': '變頻器 (Inverter)', '功率': '11 kW', '輸入電壓': '380-480V/3Ph',
        '輸出頻率': '0 ~ 590 Hz', '防護等級': 'IP54', '通訊協議': 'Modbus RTU / BACnet',
        '尺寸': '260×175×206 mm', '重量': '5.8 kg',
      }),
    ];
  }
}