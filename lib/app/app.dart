import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class MergeChaosApp extends ConsumerWidget {
  const MergeChaosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Merge Chaos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
    );
  }
}
