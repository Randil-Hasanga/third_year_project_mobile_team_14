import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_management_system_mobileapp/Screens/ForgotPassword.dart';
import 'package:job_management_system_mobileapp/Screens/LogInPage.dart';
import 'package:job_management_system_mobileapp/Screens/enter_OTP.dart';
import 'package:job_management_system_mobileapp/Screens/splash_screen.dart';
import 'package:job_management_system_mobileapp/firebase_options.dart';
import 'package:job_management_system_mobileapp/services/email_services.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

// void main() => runApp(const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ,
//       home: SplashScreen(),
//     ));

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
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Management System',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: 'splash',
      routes: {
        'splash': (context) => const SplashScreen(),
        'fogot_pwd': (context) => const ForgotPasswordPage(),
        // 'register': (context) => RegisterPage(),
        'login': (context) =>  const LogInPage(),
        // 'home': (context) => HomePage(),
        // 'profile': (context) => ProfilePage(),
        
      },
    );
  }
}
