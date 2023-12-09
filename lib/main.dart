import 'package:chase_map/connect_wallet.dart';
import 'package:chase_map/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:chase_map/SupabaseProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


Future<void> main() async {
  print("supabase 2");
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  print("supabase 1");

  final SupabaseClient supabaseClient = (await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  )) as SupabaseClient;

  print("supabase $supabaseClient");
  try {
      final response = await supabaseClient
          .from('Event_tbl')
          .select()
          .execute(); // Execute the query

      // if (response.error != null) {
      //   throw response.error!;
      // }
      print("supabase $response");

      final data = response.data;
      print(data);
    } catch (ex) {
      print('Error fetching data: $ex');
    }
  
  runApp(const MyApp());
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapWidget(),
    );
  }
}
