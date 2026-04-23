import '../models/receipt_data.dart';
import 'ai_strategy.dart';

/// Context class que utilitza les estratègies d'IA.
/// Seguint el patró Strategy per a la PT5.
class AIContext {
  AIStrategy? _strategy;

  /// Estableix l'estratègia actual.
  void setStrategy(AIStrategy strategy) {
    _strategy = strategy;
  }

  /// Processa el tiquet amb l'estratègia seleccionada.
  Future<ReceiptData> process(String text) async {
    if (_strategy == null) {
      throw Exception("Cap estratègia d'IA seleccionada.");
    }
    return await _strategy!.processReceipt(text);
  }
}
