import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yutaa_partner_app/features/auth/screens/login_screen.dart';
import 'package:yutaa_partner_app/features/auth/screens/otp_screen.dart';
import 'package:yutaa_partner_app/features/auth/screens/registration_screen.dart';
import 'package:yutaa_partner_app/features/credits/screens/recharge_screen.dart';
import 'package:yutaa_partner_app/features/home/screens/dashboard_screen.dart';
import 'package:yutaa_partner_app/features/onboarding/screens/onboarding_screen.dart';

void main() {
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
        final phone = state.extra as String? ?? '';
        return OtpScreen(phoneNumber: phone);
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
