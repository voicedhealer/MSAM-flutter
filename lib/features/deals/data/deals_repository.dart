import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/deal.dart';

class DealsRepository {
  DealsRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Deal>> fetchActiveDeals() async {
    final rows = await _client
        .from('deals')
        .select()
        .eq('is_active', true)
        .order('featured', ascending: false)
        .order('created_at', ascending: false);

    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(Deal.fromJson)
        .toList();
  }
}
