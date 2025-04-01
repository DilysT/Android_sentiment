import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  @override
  _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
}

class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
  final TextEditingController _controller = TextEditingController();
  String _sentimentResult = '';
  bool _isLoading = false;

  Future<void> _analyzeSentiment() async {
    setState(() {
      _isLoading = true;
      _sentimentResult = '';
    });

    final String apiUrl = 'https://044e-34-82-241-130.ngrok-free.app/predict';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': _controller.text}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _sentimentResult = data['sentiment'];
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
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentiment Analysis'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your sentence',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _analyzeSentiment,
              child: Text('Analyze Sentiment'),
            ),
            SizedBox(height: 20),
            Text(
              _sentimentResult,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
