import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/health_tip_bar.dart';
import '../widgets/app_card.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vitals"),
            Text(
              "Today at a glance",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppCard(
                  padding: const EdgeInsets.all(18),
                  glow: true,
                  glowColor: AppColors.accent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recovery pulse',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _statTile(
                            context,
                            label: "Heart Rate",
                            value: "72",
                            unit: "bpm",
                            color: AppColors.accentRose,
                            icon: Icons.favorite,
                          ),
                          const SizedBox(width: 12),
                          _statTile(
                            context,
                            label: "Steps",
                            value: "5,432",
                            unit: "steps",
                            color: AppColors.accent,
                            icon: Icons.directions_walk,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _statTile(
                            context,
                            label: "Calories",
                            value: "1,280",
                            unit: "kcal",
                            color: AppColors.accentAmber,
                            icon: Icons.local_fire_department,
                          ),
                          const SizedBox(width: 12),
                          _statTile(
                            context,
                            label: "Sleep",
                            value: "7.4",
                            unit: "hrs",
                            color: AppColors.accentBlue,
                            icon: Icons.nightlight_round,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _vitalCard(
                  context,
                  label: "Heart Rate",
                  value: "72 bpm",
                  icon: Icons.favorite,
                  color: AppColors.accentRose,
                  subtitle: "Resting · 10 mins ago",
                ),
                const SizedBox(height: 12),
                _vitalCard(
                  context,
                  label: "Steps",
                  value: "5,432",
                  icon: Icons.directions_walk,
                  color: AppColors.accent,
                  subtitle: "Daily goal 8,000",
                ),
                const SizedBox(height: 12),
                _vitalCard(
                  context,
                  label: "Calories",
                  value: "1,280 kcal",
                  icon: Icons.local_fire_department,
                  color: AppColors.accentAmber,
                  subtitle: "Active burn",
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.watch, color: AppColors.accentBlue),
                    ),
                    title: const Text("Connect Smartwatch"),
                    subtitle: Text(
                      "Sync live vitals from your wearable.",
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
          const HealthTipBar(),
        ],
      ),
    );
  }

  Widget _statTile(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outline.withOpacity(0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              unit,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vitalCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return AppCard(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.16),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
        trailing: Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
