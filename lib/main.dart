import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'data/local_storage.dart';
import 'data/user_session.dart';

/// Point d'entrée Guidik — Bloc 0.
///
/// Pipeline de démarrage :
///   1. WidgetsFlutterBinding initialisé (requis avant Hive).
///   2. Hive initialisé (box `guidik_app`).
///   3. UserSession.init() : génère ou recharge l'UUID local (debugPrint).
///   4. Lancement de l'app via MultiProvider (Provider) + MaterialApp.router
///      (go_router) avec RTL forcé pour l'arabe / Darija.
Future<void> main() async {
  // 1.
  WidgetsFlutterBinding.ensureInitialized();

  // 2.
  await LocalStorage.init();

  // 3.
  final userSession = UserSession();
  await userSession.init();

  // 4.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserSession>.value(value: userSession),
      ],
      child: const GuidikApp(),
    ),
  );
}

class GuidikApp extends StatelessWidget {
  const GuidikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Guidik',
      debugShowCheckedModeBanner: false,
      theme: GuidikTheme.light,
      darkTheme: GuidikTheme.dark,

      // ── RTL par défaut (arabe / Darija) ───────────────────────────────
      // On force TextDirection.rtl via le `builder` pour que toute l'app
      // soit en RTL quel que soit le device (pas besoin de package de
      // localisation supplémentaire, ce qui respecte la liste stricte
      // des dépendances autorisées du contrat Bloc 0).
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      // ── go_router ─────────────────────────────────────────────────────
      routerConfig: GuidikRouter.config,
    );
  }
}
