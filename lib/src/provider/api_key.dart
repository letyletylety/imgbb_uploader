import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// key from env
final apiKeyDevProvider = Provider<String>((ref) {
  const apiKey = String.fromEnvironment('API_KEY');
  return apiKey;
});

final apiKeyProvider = StateNotifierProvider<ApiKeyNotifier, String>(
  (ref) => ApiKeyNotifier(
    ref.watch(apiKeyDevProvider),
    ref.read(secureStorageProvider),
  )..loadApiKey(),
);

class ApiKeyNotifier extends StateNotifier<String> {
  ApiKeyNotifier(String def, this.storage) : super(def);

  final FlutterSecureStorage storage;

  loadApiKey() async {
    var key = await storage.read(key: 'API_KEY');
    state = key ?? "";
  }

  Future changeApiKey(String newKey) async {
    state = newKey;
    await storage.write(key: 'API_KEY', value: newKey);
  }
}

// class ApiKeyStorage {}
