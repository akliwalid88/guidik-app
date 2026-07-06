import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Wrapper léger autour de Hive.
///
/// - Initialise Hive (`Hive.initFlutter`) une seule fois au démarrage.
/// - Ouvre une box unique `guidik_app` pour stocker les paires clé/valeur
///   simples (UUID, flags onboarding, préférences, etc.).
/// - Expose des helpers typés `readString` / `writeString` pour éviter de
///   propager le type `dynamic` partout dans l'app.
///
/// Aucune dépendance Firebase / réseau : tout est 100% local.
class LocalStorage {
  LocalStorage._();

  static const String _appBoxName = 'guidik_app';

  static Box<dynamic>? _appBox;
  static bool _initialized = false;

  /// À appeler une seule fois dans `main()` avant toute autre utilisation.
  static Future<void> init() async {
    if (_initialized) {
      return;
    }
    await Hive.initFlutter();
    _appBox = await Hive.openBox<dynamic>(_appBoxName);
    _initialized = true;
    debugPrint('📦 Hive initialisé — box "$_appBoxName" ouverte.');
  }

  static Box<dynamic> get appBox {
    final box = _appBox;
    if (box == null || !_initialized) {
      throw StateError(
        'LocalStorage non initialisé. Appeler LocalStorage.init() dans main() '
        'avant toute lecture/écriture.',
      );
    }
    return box;
  }

  // ── Helpers typés (chaîne) ────────────────────────────────────────────
  static String? readString(String key) {
    final value = appBox.get(key);
    return value is String ? value : null;
  }

  static Future<void> writeString(String key, String value) async {
    await appBox.put(key, value);
  }

  // ── Helpers génériques ────────────────────────────────────────────────
  static Future<void> write(String key, dynamic value) async {
    await appBox.put(key, value);
  }

  static T? read<T>(String key) {
    final value = appBox.get(key);
    return value is T ? value : null;
  }

  static bool containsKey(String key) => appBox.containsKey(key);

  static Future<void> remove(String key) async {
    await appBox.delete(key);
  }

  /// Pour debug / reset manuel (tests). À utiliser avec parcimonie.
  static Future<void> clearAll() async {
    await appBox.clear();
  }
}
