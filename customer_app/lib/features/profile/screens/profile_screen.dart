import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';
import 'package:yutaa_customer_app/theme/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.person, size: 50, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'yousif Johnson',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        context.push('/edit-profile');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade600),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // General Section
              const Text(
                'General',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildMenuItem(context, icon: Icons.location_on_outlined, title: 'My addresses', subtitle: 'Save and manage locations', onTap: () {
                context.push('/addresses');
              }),
              _buildMenuItem(context, icon: Icons.account_balance_wallet_outlined, title: 'Payment methods', subtitle: 'Add new method or remove', onTap: () {}),
              _buildMenuItem(context, icon: Icons.favorite_border, title: 'Favourites', subtitle: 'Access your saved services anytime', onTap: () {}),
              _buildMenuItem(context, icon: Icons.chat_bubble_outline, title: 'My reviews', subtitle: 'View and manage your feedback', onTap: () {}),
              _buildMenuItem(context, icon: Icons.notifications_none, title: 'My notifications', subtitle: 'Manage your alerts and updates', onTap: () {}),
              
              // Dark Mode Toggle
               Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F222A) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
                  ),
                  title: Text(
                    'Dark mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  subtitle: Text(
                    'Toggle light or dark theme',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                    activeColor: AppTheme.primaryPurple,
                  ),
                ),
              ),

              _buildMenuItem(context, icon: Icons.security_outlined, title: 'Security', subtitle: 'Password, authentication, etc', onTap: () {}),
              _buildMenuItem(context, icon: Icons.settings_outlined, title: 'Settings', subtitle: 'Customize your app preferences', onTap: () {}),

              const SizedBox(height: 24),

              // Others Section
              const Text(
                'Others',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              _buildMenuItem(context, icon: Icons.help_outline, title: 'Help center', subtitle: 'Help & Info in one place', onTap: () {}),
              _buildMenuItem(context, icon: Icons.share_outlined, title: 'Share the app', subtitle: 'Invite friends to try the app', onTap: () {}),
              _buildMenuItem(context, icon: Icons.feedback_outlined, title: 'Feedback', subtitle: 'Share your feedback with us', onTap: () {}),
              _buildMenuItem(context, icon: Icons.star_border, title: 'Rate the app', subtitle: 'Give us your feedback', onTap: () {}),
              
              // Logout
               Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0), // Light red bg
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.logout, color: Colors.red),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    // Logic for logout
                    context.go('/login');
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F222A) : const Color(0xFFF5F5F5), // Adjust based on theme
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryPurple),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: theme.colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
