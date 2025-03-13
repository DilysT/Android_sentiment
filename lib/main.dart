import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentiment Analysis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SentimentAnalysisPage(),
    );
  }
}

class SentimentAnalysisPage extends StatefulWidget {
  const SentimentAnalysisPage({super.key});

  @override
  _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
}

class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
  final TextEditingController _controller = TextEditingController();
  String _sentimentResult = '';
  bool _isLoading = false; // Thêm trạng thái loading

  Future<void> _analyzeSentiment() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
      _sentimentResult = ''; // Xóa kết quả cũ
    });

    final String apiKey = 'AIzaSyCQlXIu13tGakMvZAtZDx245oZrUf7Y5Fo';
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': _controller.text}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _sentimentResult =
              data['candidates'][0]['content']['parts'][0]['text'];
        });
      } else {
        setState(() {
          _sentimentResult = 'Failed to analyze sentiment';
        });
      }
    } catch (e) {
      setState(() {
        _sentimentResult = 'Error: ${e.toString()}';
      });
    }

    setState(() {
      _isLoading = false; // Kết thúc tải
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentiment Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your sentence',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Vòng xoay khi đang tải
                : ElevatedButton(
                    onPressed: _analyzeSentiment,
                    child: const Text('Analyze Sentiment'),
                  ),
            const SizedBox(height: 20),
            Text(
              _sentimentResult,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
