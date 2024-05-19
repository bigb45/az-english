import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/features/levels/screens/level_selection_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, LevelSelectionViewmodel>(
          update: (context, auth, levels) => levels!..update(auth),
          create: (BuildContext context) => LevelSelectionViewmodel(),
        ),
      ],
      child: child,
    );
  }
}
