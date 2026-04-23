import 'package:flutter/material.dart';
import '../models/receipt_data.dart';

/// Widget que mostra les dades extretes del tiquet.
class ResultsCard extends StatelessWidget {
  final ReceiptData data;

  const ResultsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Títol
          Row(
            children: [
              Icon(Icons.assignment_outlined,
                  color: Colors.white.withValues(alpha: 0.9), size: 22),
              const SizedBox(width: 8),
              const Text(
                'Dades Extretes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grid de dades
          Row(
            children: [
              Expanded(child: _DataCell(label: 'Establiment', value: data.establishment)),
              const SizedBox(width: 12),
              Expanded(child: _DataCell(label: 'Data', value: data.date)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DataCell(
                  label: 'Total',
                  value: '${data.total.toStringAsFixed(2)} €',
                  valueColor: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _DataCell(label: 'Categoria', value: data.category)),
            ],
          ),

          const SizedBox(height: 24),

          // Llista de productes
          const Text(
            'Productes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...data.items.map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${item.price.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DataCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
