import '../models/receipt_data.dart';

/// Classe base per a l'estratègia d'IA.
/// Seguint el patró Strategy per a la PT5.
abstract class AIStrategy {
  final String apiKey;

  AIStrategy(this.apiKey);

  /// Processa el text d'un tiquet i retorna dades estructurades.
  Future<ReceiptData> processReceipt(String text);

  /// Prompt comú per garantir consistència entre proveïdors.
  String getPrompt(String text) {
    return '''
Actua com un extractor de dades de tiquets de compra. 
Analitza el següent text i retorna UNICAMENT un objecte JSON amb aquest format exactament:
{
  "establishment": "Nom de la botiga o restaurant",
  "date": "DD/MM/YYYY",
  "total": 0.00,
  "category": "Alimentació | Transport | Oci | Altres",
  "items": [{"name": "producte", "price": 0.00}]
}

Text del tiquet:
"$text"
''';
  }
}
