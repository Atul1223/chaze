import 'package:chase_map/Event.dart';
import 'package:chase_map/User.dart';
import 'package:supabase/supabase.dart';
import 'dart:convert';

class SupabaseServiceDB {
  final SupabaseClient supabaseClient;

  SupabaseServiceDB(this.supabaseClient);

  Future<List<EventDetails>> getAllEvents() async {
    try {
      final response = await supabaseClient.from('Event_tbl').select();

      List<EventDetails> eventList = [];

      for (var eventData in response) {
        EventDetails eventDetails = EventDetails.fromMap(eventData);
        eventList.add(eventDetails);
      }
      return eventList;
    } catch (ex) {
      print('Error fetching data: $ex');
      List<EventDetails> eventList = [];
      return eventList;
    }
  }

  Future<void> postEvent(EventDetails eventDetails) async {
    try {
       final response = await supabaseClient.from('Event_tbl').insert({
        'claimedWalletAddress': '${eventDetails.claimedWalletAddress}',
        'EventId': '${eventDetails.eventId}',
        'walletaddress':'${eventDetails.walletAddress}',
        'latitude':'${eventDetails.latitude}',
        'longitude':'${eventDetails.longitude}',
        'timedeadline':'${eventDetails.timeDeadline}',
        'members': '${eventDetails.members}',
        'EventName': '${eventDetails.eventName}',
        'TokenValue': '${eventDetails.tokenValue}',
      }).select();
      print("data $response");
    } catch (ex) {
      print('Error sending data: $ex');
    }
  }

  Future<void> createUser(UserData userData) async {
    try {
      final response = await supabaseClient.from('User').insert({
        'walletaddress': '${userData.walletAddress}',
        'username': '${userData.username},'
      });
    }catch (ex) {
      print('Error sending data: $ex');
    }
  }
}
