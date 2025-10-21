import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';

class ChatbotRepository {
  final http.Client _client;

  ChatbotRepository(this._client);

  Future<String> sendMessage(String message) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/chatbot/send-message');

    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Backend returns: { "data": { "response": "bot reply" } }
      return data['data']['response'] as String;
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }
}
