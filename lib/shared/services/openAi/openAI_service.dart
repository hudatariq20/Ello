import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  // final List<Map<String, String>> messages = [];
  final APIKEY = dotenv.env['API_KEY'];

  // Keeps track of the ongoing chat messages
  final List<Map<String, String>> messages = [
    {
      "role": "system",
      "content": "You are a helpful assistant.",
    }
  ];

  Future<String> ChatGPTAPI(String message) async {
    messages.add({'role': 'user', 'message': message});

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $APIKEY'
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": message}
          ]
        }),
      );

      if (res.statusCode == 200) {
        final responseData = jsonDecode(res.body);
        final reply = responseData['choices'][0]['message']['content'];
        messages.add(
            {'role': 'assistant', 'message': reply}); //save assistant's reply
        return reply;
      } else {
        return "Error: ${res.statusCode} - ${res.body}";
      }
    } catch (e) {
      return e.toString();
    }
  }

  /// Streams the response from OpenAI's API chunk by chunk, providing real-time updates
  /// as the AI generates its response.
  ///
  /// Parameters:
  /// - message: The user's input message
  /// - onDelta: Callback function that receives each new chunk of the response
  /// - onDone: Callback function called when the stream is complete
  Future<void> streamChatGPTAPI(
      {required String message,
      required Function(String) onDelta,
      required VoidCallback onDone}) async {
    // Add user's message to the conversation history
    messages.add({'role': 'user', 'message': message});

    // Prepare the HTTP request with streaming enabled
    final request = http.Request(
        'POST', Uri.parse('https://api.openai.com/v1/chat/completions'));
    request.headers.addAll({
      'Authorization': 'Bearer $APIKEY',
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'stream': true,
      'messages': [
        {'role': 'user', 'content': message}
      ]
    });

    final client = http.Client();
    try {
      // Send the request and get the response stream
      final response = await client.send(request);
      if (response.statusCode != 200) {
        onDelta('Error: ${response.statusCode}');
        onDone();
        return;
      }

      // Process the response stream line by line
      final stream =
          response.stream.transform(utf8.decoder).transform(LineSplitter());
      String fullResponse = '';

      // Process each line of the stream
      await for (final line in stream) {
        // Skip empty lines and non-data lines
        if (line.isEmpty || !line.startsWith('data:')) continue;

        final content = line
            .substring(5)
            .trim(); //remove the data: prefix and trim the whitespace

        // Check for stream completion
        if (content == '[DONE]') {
          messages.add({'role': 'assistant', 'content': fullResponse});
          onDone();
          break;
        }

        // Extract and process the delta content
        final jsonData = jsonDecode(content);
        final delta = jsonData['choices'][0]['delta']['content'];

        if (delta != null) {
          fullResponse += delta;
          onDelta(delta);
        }
      }
    } catch (e) {
      onDelta(' Exception: $e');
      onDone();
    } finally {
      client.close();
    }
  }
}
