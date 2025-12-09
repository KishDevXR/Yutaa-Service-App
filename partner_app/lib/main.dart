import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yutaa_partner_app/features/auth/screens/login_screen.dart';
import 'package:yutaa_partner_app/features/auth/screens/otp_verification_screen.dart';
import 'package:yutaa_partner_app/features/auth/screens/registration_screen.dart';
import 'package:yutaa_partner_app/features/credits/screens/recharge_screen.dart';
import 'package:yutaa_partner_app/features/home/screens/dashboard_screen.dart';
import 'package:yutaa_partner_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: YutaaPartnerApp()));
}

final _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final phoneNumber = extras?['phoneNumber'] as String?;
        final verificationId = extras?['verificationId'] as String?;
        
        return OtpVerificationScreen(
          phoneNumber: phoneNumber ?? '',
          verificationId: verificationId,
        );
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const PartnerMainWrapper(),
    ),
    GoRoute(
      path: '/recharge',
      builder: (context, state) => const RechargeScreen(),
    ),
  ],
);

class YutaaPartnerApp extends StatelessWidget {
  const YutaaPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yutaa Partner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A2BE2),
          primary: const Color(0xFF8A2BE2),
          secondary: const Color(0xFFFFC107),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routerConfig: _router,
    );
  }
}
