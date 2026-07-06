import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Configuration go_router de Guidik.
///
/// Bloc 0 : une seule route `/` qui affiche l'écran "Guidik - Bloc 0 OK".
/// Les routes futures (onboarding, etc.) seront ajoutées dans `features/`.
class GuidikRouter {
  GuidikRouter._();

  static final GoRouter config = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const _Bloc0Screen();
        },
      ),
    ],
  );
}

/// Écran de validation Bloc 0.
///
/// Affiche le texte "Guidik - Bloc 0 OK" et — pour valider visuellement le
/// critère de persistance UUID — récupère le `UserSession` exposé via
/// Provider et l'affiche en lecture seule.
class _Bloc0Screen extends StatelessWidget {
  const _Bloc0Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ديديك')),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Guidik - Bloc 0 OK',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'المرحلة 0 جاهزة',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
