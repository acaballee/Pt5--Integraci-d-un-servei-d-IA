import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receipt_data.dart';
import 'ai_strategy.dart';

/// Estratègia per a Groq (Llama 3).
class GroqStrategy extends AIStrategy {
  GroqStrategy(super.apiKey);

  @override
  Future<ReceiptData> processReceipt(String text) async {
    if (apiKey.isEmpty) {
      throw Exception("API Key de Groq no configurada.");
    }

    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {
            'role': 'system',
            'content': 'Ets un expert en extracció de dades de tiquets. Respon sempre en JSON.'
          },
          {'role': 'user', 'content': getPrompt(text)}
        ],
        'response_format': {'type': 'json_object'}
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(
        'Error Groq API: ${error['error']?['message'] ?? response.reasonPhrase}',
      );
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'] as String;

    final parsed = jsonDecode(content) as Map<String, dynamic>;
    return ReceiptData.fromJson(parsed);
  }
}
