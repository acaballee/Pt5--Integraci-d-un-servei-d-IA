/// Model que representa les dades extretes d'un tiquet de compra.
class ReceiptItem {
  final String name;
  final double price;

  ReceiptItem({required this.name, required this.price});

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name']?.toString() ?? 'Desconegut',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class ReceiptData {
  final String establishment;
  final String date;
  final double total;
  final String category;
  final List<ReceiptItem> items;

  ReceiptData({
    required this.establishment,
    required this.date,
    required this.total,
    required this.category,
    required this.items,
  });

  factory ReceiptData.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
            ?.map((item) => ReceiptItem.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return ReceiptData(
      establishment: json['establishment']?.toString() ?? 'N/A',
      date: json['date']?.toString() ?? 'N/A',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      category: json['category']?.toString() ?? 'N/A',
      items: itemsList,
    );
  }
}
