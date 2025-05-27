import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/providers/auth_provider.dart';

class NoHeroPageRoute<T> extends MaterialPageRoute<T> {
  NoHeroPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      title: 'CRM App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: isAuthenticated ? const MainShell() : const LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return NoHeroPageRoute(builder: (_) => const LoginScreen());
          case '/main':
            return NoHeroPageRoute(builder: (_) => const MainShell());
          default:
            return null;
        }
      },
    );
  }
}
