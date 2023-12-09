import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Heading Text',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Subheading Text',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 16),
              TextFieldWithLabel(label: 'Field 1', hint: 'Enter value'),
              TextFieldWithLabel(label: 'Field 2', hint: 'Enter value'),
              TextFieldWithLabel(label: 'Field 3', hint: 'Enter value'),
              TextFieldWithLabel(label: 'Field 4', hint: 'Enter value'),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Some Text'),
                  SizedBox(width: 8),
                  Switch(
                    value: true,
                    onChanged: (bool value) {
                      // Handle switch state change
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final String hint;

  const TextFieldWithLabel({
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
