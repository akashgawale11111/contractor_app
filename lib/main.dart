import 'package:contractor_app/language/lib/l10n/app_localizations.dart';
import 'package:contractor_app/language/lib/l10n/language_provider.dart';
import 'package:contractor_app/utils/theme/app_theme.dart';
import 'package:contractor_app/utils/theme/theme_provider.dart';
import 'package:contractor_app/ui_screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contractor_app/utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MMPrecise Attendance',
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Global responsive text scaling
      builder: (context, child) {
        SizeConfig.init(context);
        final mq = MediaQuery.of(context);
        final width = mq.size.width;
        final scale = (width / 375.0).clamp(0.85, 1.25);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}
