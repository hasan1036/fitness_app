import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:workoutfitnesstool/common/color_extention.dart';
import 'package:workoutfitnesstool/service/notification_service.dart';
import 'package:workoutfitnesstool/service/language_service.dart';
import 'package:workoutfitnesstool/l10n/app_localizations.dart';
import 'package:workoutfitnesstool/view/login/on_boarding_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.initialize();
  } catch (error, stackTrace) {
    debugPrint(
      'Notification initialize error: $error',
    );

    debugPrintStack(
      stackTrace: stackTrace,
    );
  }

  await LanguageService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LanguageService.localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
      locale: locale,
      supportedLocales: LanguageService.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Fitness Workout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
        ),
        useMaterial3: false,
      ),
      home: const OnBoardingView(),
        );
      },
    );
  }
}