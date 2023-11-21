import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bus Track'),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController timeController = TextEditingController();
  final TextEditingController stopController = TextEditingController();

  Future<void> sendPostRequest() async {
    final url = Uri.parse(
        'http://192.168.69.149:5000/get_data'); // Replace with your server's URL
    final response = await http.post(
      url,
      body: {
        'time': timeController.text,
        'stop': stopController.text,
      },
    );

    if (response.statusCode == 200) {
      String bus_no=response.body;
      showResponseDialog(bus_no);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void showResponseDialog(String responseText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bus number'),
          content: Text(responseText),
          actions: <Widget>[

            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: timeController,
            decoration: InputDecoration(labelText: 'Time'),
          ),
          TextFormField(
            controller: stopController,
            decoration: InputDecoration(labelText: 'Stop'),
          ),
          ElevatedButton(
            onPressed: sendPostRequest,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
