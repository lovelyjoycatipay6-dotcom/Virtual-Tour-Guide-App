import 'package:flutter/material.dart';

import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/app_screens.dart';
import 'screens/auth_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();
  runApp(YGuideApp(state: state));
}

class YGuideApp extends StatefulWidget {
  const YGuideApp({required this.state, super.key});

  final AppState state;

  @override
  State<YGuideApp> createState() => _YGuideAppState();
}

class _YGuideAppState extends State<YGuideApp> {
  bool _isAuthenticated = false;

  Future<void> _signIn(String name, String email) async {
    await widget.state.updateProfile(name: name, email: email);
    if (mounted) setState(() => _isAuthenticated = true);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'YGUIDE – Virtual Tour Guide',
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    home: _isAuthenticated
        ? AppShell(
            state: widget.state,
            onLogout: () => setState(() => _isAuthenticated = false),
          )
        : AuthScreen(onAuthenticated: _signIn),
  );
}
