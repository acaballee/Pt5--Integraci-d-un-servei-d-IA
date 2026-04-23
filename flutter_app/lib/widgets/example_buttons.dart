import 'package:flutter/material.dart';

/// Botons d'exemple per omplir el textarea amb tiquets de mostra.
class ExampleButtons extends StatelessWidget {
  final Function(String) onExampleSelected;

  const ExampleButtons({super.key, required this.onExampleSelected});

  static final List<Map<String, String>> examples = [
    {
      'emoji': '⛽',
      'label': 'Repsol',
      'text':
          'REPSOL TORTOSA\nCtra. de Tortosa a l\'Aldea, s/n\n43500 Tortosa\n--------------------------------\nGASOLINA S/P 95: 45,50 €\n--------------------------------\nTOTAL: 45,50 €\nData: 26/03/2026 14:30',
    },
    {
      'emoji': '🛒',
      'label': 'Mercadona',
      'text':
          'MERCADONA S.A.\nAv. de la Generalitat, 120\n--------------------------------\nLLET 6U: 5,40 €\nPA DE MOLDE: 1,20 €\nPOMES 1KG: 2,30 €\n--------------------------------\nTOTAL: 8,90 €\nData: 10/04/2026 09:15',
    },
    {
      'emoji': '🍽️',
      'label': 'Restaurant',
      'text':
          'RESTAURANT CAN TONET\nPlaça de l\'Ajuntament, 5\n--------------------------------\nMENÚ DEL DIA: 15,00 €\nAIGUA 0.5L: 2,00 €\n--------------------------------\nTOTAL: 17,00 €\nData: 15/04/2026 21:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: examples.map((example) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onExampleSelected(example['text']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${example['emoji']} ${example['label']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
