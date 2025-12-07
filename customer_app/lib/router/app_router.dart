import 'package:go_router/go_router.dart';
import 'package:yutaa_customer_app/features/auth/screens/login_screen.dart';
import 'package:yutaa_customer_app/features/auth/screens/otp_verification_screen.dart';
import 'package:yutaa_customer_app/features/auth/screens/setup_profile_screen.dart';
import 'package:yutaa_customer_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:yutaa_customer_app/features/booking/screens/category_screen.dart';
import 'package:yutaa_customer_app/features/booking/screens/partner_list_screen.dart';
import 'package:yutaa_customer_app/features/booking/screens/booking_details_screen.dart';
import 'package:yutaa_customer_app/features/booking/models/partner_model.dart';
import 'package:yutaa_customer_app/features/booking/models/service_model.dart';
import 'package:yutaa_customer_app/features/bookings/screens/bookings_screen.dart';
import 'package:yutaa_customer_app/features/bookings/screens/booking_status_screen.dart';
import 'package:yutaa_customer_app/features/home/screens/home_screen.dart';
import 'package:yutaa_customer_app/features/home/screens/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:yutaa_customer_app/features/home/screens/services_screen.dart';

final router = GoRouter(
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
        final phoneNumber = state.extra as String?;
        return OtpVerificationScreen(phoneNumber: phoneNumber ?? '');
      },
    ),
    GoRoute(
      path: '/setup-profile',
      builder: (context, state) => const SetupProfileScreen(),
    ),
    GoRoute(
      path: '/category/:name',
      builder: (context, state) {
        final categoryName = state.pathParameters['name']!;
        return CategoryScreen(categoryName: categoryName);
      },
    ),
    GoRoute(
      path: '/partner-list',
      builder: (context, state) {
         final service = state.extra as ServiceModel;
         return PartnerListScreen(service: service);
      },
    ),
    GoRoute(
      path: '/booking-details',
      builder: (context, state) {
         final extras = state.extra as Map<String, dynamic>;
         final service = extras['service'] as ServiceModel;
         final partners = extras['partners'] as List<PartnerModel>;
         return BookingDetailsScreen(service: service, partners: partners);
      },
    ),
    GoRoute(
      path: '/booking-status',
      builder: (context, state) {
        final bookingId = state.extra as String;
        return BookingStatusScreen(bookingId: bookingId);
      },
    ),
    // ShellRoute for Bottom Navigation
    ShellRoute(
      builder: (context, state, child) {
        return MainWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesScreen(),
        ),
      ],
    ),
  ],
);
