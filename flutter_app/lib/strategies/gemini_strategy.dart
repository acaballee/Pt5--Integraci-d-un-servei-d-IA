import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receipt_data.dart';
import 'ai_strategy.dart';

/// Estratègia per a Google Gemini (Flash 1.5).
class GeminiStrategy extends AIStrategy {
  GeminiStrategy(super.apiKey);

  @override
  Future<ReceiptData> processReceipt(String text) async {
    if (apiKey.isEmpty || apiKey == 'LA_TEVA_CLAU_GEMINI') {
      throw Exception("API Key de Gemini no configurada.");
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': getPrompt(text)}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(
        'Error Gemini API: ${error['error']?['message'] ?? response.reasonPhrase}',
      );
    }

    final data = jsonDecode(response.body);
    final content = data['candidates'][0]['content']['parts'][0]['text'] as String;

    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
    if (jsonMatch == null) {
      throw Exception("No s'ha pogut extreure JSON de la resposta de Gemini.");
    }

    final parsed = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
    return ReceiptData.fromJson(parsed);
  }
}
