import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yutaa_customer_app/router/app_router.dart';

import 'package:yutaa_customer_app/theme/app_theme.dart';
import 'package:yutaa_customer_app/theme/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: YutaaCustomerApp()));
}

class YutaaCustomerApp extends ConsumerWidget {
  const YutaaCustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Yutaa Customer App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
