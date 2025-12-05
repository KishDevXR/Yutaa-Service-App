import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildSectionHeader(context, 'Services', () {}),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3, 
          childAspectRatio: 0.85, 
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildServiceItem(context, 'Electrician', Icons.electric_bolt, Colors.amber),
            _buildServiceItem(context, 'Solar', Icons.solar_power, Colors.orangeAccent),
            _buildServiceItem(context, 'Battery', Icons.battery_charging_full, Colors.redAccent),
            _buildServiceItem(context, 'Plumber', Icons.plumbing, Colors.lightBlue),
            _buildServiceItem(context, 'Carpenter', Icons.carpenter, Colors.brown),
            _buildServiceItem(context, 'Home\nInstallation', Icons.tv, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All'),
        ),
      ],
    );
  }

  Widget _buildServiceItem(BuildContext context, String label, IconData icon, Color color) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        final cleanLabel = label.replaceAll('\n', ' ');
        context.push('/category/$cleanLabel');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
