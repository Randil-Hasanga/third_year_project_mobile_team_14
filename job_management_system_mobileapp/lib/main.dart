import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_management_system_mobileapp/Screens/ForgotPassword.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/ProfileJobProvider.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/LogInPage.dart';
import 'package:job_management_system_mobileapp/Screens/change_password.dart';
import 'package:job_management_system_mobileapp/Screens/enter_OTP.dart';
import 'package:job_management_system_mobileapp/Screens/job_matching.dart';
import 'package:job_management_system_mobileapp/Screens/splash_screen.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/firebase_options.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/services/email_services.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/buttons.dart';
import 'package:job_management_system_mobileapp/widgets/richTextWidgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService(),
  );
  GetIt.instance.registerSingleton<EmailService>(
    EmailService(),
  );
  GetIt.instance.registerSingleton<RichTextWidget>(
    RichTextWidget(),
  );
  GetIt.instance.registerSingleton<ButtonWidgets>(
    ButtonWidgets(),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('si', 'LK'),
        Locale('ta', 'LK'),
      ],
      locale: _locale,
      localizationsDelegates: const [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        for (var locale in supportedLocales) {
          for (var preferredLocale in locales!) {
            if (locale.languageCode == preferredLocale.languageCode) {
              return locale;
            }
          }
        }
        // If no match is found return the first supported locale
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      title: 'Job Management System',
      theme: ThemeData(
        scaffoldBackgroundColor: ScaffoldColor,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: 'login',
      routes: {
        'splash': (context) => const SplashScreen(),
        'fogot_pwd': (context) => const ForgotPasswordPage(),
        'login': (context) => const LogInPage(),
        'editProviderProfile': (context) => JobProviderProfile(),
        'provider_dashboard': (context) => JobProviderPage(),
        'seeker_dashboard': (context) => JobSeekerPage(),
        'edit_seeker_profile': (context) => ProfileJobSeeker(),
        'job_matching': (context) => JobMatchingScreen(),
        'change_pwd': (context) => ChangePassword(),
      },
    );
  }
}
