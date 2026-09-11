import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleai_dart/googleai_dart.dart';

class Message {
  final String message;
  final bool isSender;
  final DateTime date;

  Message({required this.message, required this.isSender, required this.date});
}

final List<Message> messages = [];
final String _baseUrl = dotenv.get('AI_API');

Future<bool> query(String prompt) async {
  final client = GoogleAIClient(
    config: GoogleAIConfig.googleAI(authProvider: ApiKeyProvider(_baseUrl)),
  );
  

  try {
    final response = await client.models.generateContent(
      model: 'gemini-2.5-flash',
      request: GenerateContentRequest(contents: [Content.text(prompt)]),
    );

    if (response.text != null) {
      messages.add(
        Message(message: response.text!, isSender: false, date: DateTime.now()),
      );
    }

    debugPrint("AI Response: ${response.text}");
  } catch (e) {
    debugPrint("Error: $e");
  } finally {
    client.close();
  }
  return true;
}


/*class ChatStorage {
  ChatStorage._internal();
  static final ChatStorage instance = ChatStorage._internal();

  final List<Message> messages = [];
}*/

/*final data = {
    "contents": [
      {
        "parts": [
          {"text": prompt},
        ],
      },
    ],
  };*/

  /* try {
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
      ),
      headers: {"Content-Type": "application/json", 'x-goog-api-key': _baseUrl},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      messages.add(
        Message(
          message: responseData['candidates'][0]['content']['parts'][0]['text'],
          isSender: false,
          date: DateTime.now(),
        ),
      );
    }
  } */