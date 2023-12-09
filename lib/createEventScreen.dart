import 'package:chase_map/Event.dart';
import 'package:chase_map/dbFunction.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateEvent extends StatelessWidget {
  final SupabaseClient supabaseClient;

  const CreateEvent({super.key, required this.supabaseClient});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
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
                createEventInDb();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void createEventInDb() async{
    // await Supabase.initialize(
    //   url: 'https://ehwrhfywdqhjweqtytuy.supabase.co',
    //   anonKey:
    //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVod3JoZnl3ZHFoandlcXR5dHV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk5MDA5NDMsImV4cCI6MjAxNTQ3Njk0M30.pkQkYz1LQQhLLqOUv4Wf9JySZj9iBRt1_l2pK0vsFPA',
    // );

    // final supabase = Supabase.instance.client;

    print("supabase $Supabase");
    final SupabaseServiceDB supabaseServiceDB = SupabaseServiceDB(supabaseClient);
    final EventDetails eventDetails = EventDetails(claimedWalletAddress: 123, eventId: 23, walletAddress: '3BoatSLRHtKNngkdXEeobR76b53LETtpyT', latitude: 13.0564, longitude: 14.0892, timeDeadline: 24, members: 5, eventName: 'Atul Ka event', tokenValue: 4.056);
    await supabaseServiceDB.postEvent(eventDetails);
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
