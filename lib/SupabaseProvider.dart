import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseProvider extends ChangeNotifier {
  late SupabaseClient _supabaseClient;

  SupabaseClient get supabaseClient => _supabaseClient;

  Future<void> initializeSupabase() async {
    _supabaseClient = (await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    )) as SupabaseClient;
    notifyListeners();
  }
}