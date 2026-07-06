import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'local_storage.dart';

/// Session utilisateur locale (anonyme).
///
/// - Aucun compte, aucun login, aucun mot de passe.
/// - Au premier lancement de l'app, un UUID v4 est généré et persisté
///   dans Hive (clé `user_uuid`).
/// - Aux lancements suivants, le même UUID est relu depuis Hive.
/// - Exposé en `ChangeNotifier` via `Provider` pour que l'UI puisse
///   réagir si l'UUID change (rare, mais possible en cas de reset).
///
/// Critère de validation Bloc 0 :
///   debugPrint('#️⃣ ...') au démarrage confirme la génération/persistance.
class UserSession extends ChangeNotifier {
  UserSession();

  static const String _uuidKey = 'user_uuid';
  static const Uuid _uuidGen = Uuid();

  String? _uuid;
  bool _initialized = false;

  /// UUID local (null tant que `init()` n'a pas été appelé).
  String? get uuid => _uuid;

  /// True après le premier `init()` réussi.
  bool get isInitialized => _initialized;

  /// Génère ou recharge l'UUID local. À appeler dans `main()` après
  /// `LocalStorage.init()`.
  Future<void> init() async {
    final existing = LocalStorage.readString(_uuidKey);

    if (existing != null && existing.isNotEmpty) {
      _uuid = existing;
      debugPrint('🆔 UserSession — UUID existant rechargé : $_uuid');
    } else {
      _uuid = _uuidGen.v4();
      await LocalStorage.writeString(_uuidKey, _uuid!);
      debugPrint('🆕 UserSession — Nouvel UUID généré + sauvegardé : $_uuid');
    }

    _initialized = true;
    notifyListeners();
  }

  /// Pour tests / reset manuel. Efface l'UUID stocké et en génère un nouveau.
  Future<void> regenerate() async {
    _uuid = _uuidGen.v4();
    await LocalStorage.writeString(_uuidKey, _uuid!);
    debugPrint('♻️ UserSession — UUID régénéré : $_uuid');
    notifyListeners();
  }
}
