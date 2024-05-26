import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance => _instance!;

  LocalStorageService._() : _storage = LocalStorage(_filename);

  factory LocalStorageService() {
    if (_instance != null) {
      throw StateError('LocalStorageService already created.');
    }

    _instance = LocalStorageService._();
    return _instance!;
  }

  static const String _filename = 'fans_heart_storage.json';
  static const String _keyAuthProvider = 'auth_provider';

  final LocalStorage _storage;

  Future<void> initialize() async {
    await _storage.ready;
  }

  String? getAuthProvider() {
    return _storage.getItem(_keyAuthProvider);
  }

  Future<void> saveAuthProvider(String? provider) {
    return _storage.setItem(_keyAuthProvider, provider);
  }

  Future<void> deleteAuthProvider() {
    return _storage.deleteItem(_keyAuthProvider);
  }
}
