# SmartReceipt AI - Flutter

## PT5 - Integració d'un servei IA (Versió Flutter)

### Alumne: Alex Caballé Arasa

Versió Flutter del projecte SmartReceipt AI, que converteix tiquets de compra en dades estructurades utilitzant IA.

## Patró Strategy

```
lib/
├── config/
│   └── api_keys.dart          # Claus d'API (gitignored)
├── models/
│   └── receipt_data.dart      # Model de dades del tiquet
├── strategies/
│   ├── ai_strategy.dart       # Classe base (interfície)
│   ├── ai_context.dart        # Context del patró Strategy
│   ├── gemini_strategy.dart   # Estratègia Google Gemini
│   └── groq_strategy.dart     # Estratègia Groq (Llama 3)
├── widgets/
│   ├── results_card.dart      # Widget de resultats
│   └── example_buttons.dart   # Botons d'exemple
└── main.dart                  # Punt d'entrada
```

## Com executar

1. Configura les claus d'API a `lib/config/api_keys.dart`
2. Executa:
```bash
cd flutter_app
flutter pub get
flutter run
```

## Proveïdors d'IA disponibles

- **Google Gemini** (Flash 1.5)
- **Groq** (Llama 3)

