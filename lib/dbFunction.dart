import 'package:chase_map/Event.dart';
import 'package:supabase/supabase.dart';

class SupabaseServiceDB {
  final SupabaseClient supabaseClient;

  SupabaseServiceDB(this.supabaseClient);

  Future<EventDetails> getAllEvents() async {
    try {
      final response = await supabaseClient
          .from('Event_tbl')
          .select()
          .eq('EventId',6);
           // Execute the query

      // if (response.error != null) {
      //   throw response.error!;
      // }

       print("supabase $response");
       print("supabase ${EventDetails.fromJson(response)}");


      // final data = response.data;
      // print(data);
      return EventDetails.fromJson(response);
    } catch (ex) {
      print('Error fetching data: $ex');
      return EventDetails(claimedWalletAddress: -1, eventId: -1, walletAddress: '', latitude: 0.0, longitude: 0.0, timeDeadline: -1, members: -1, eventName: '');
    }
  }
}