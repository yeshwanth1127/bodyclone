import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: AppCard(
                      padding: const EdgeInsets.all(20),
                      glow: true,
                      glowColor: AppColors.accentRose,
                      gradient: AppDecorations.heroGradient,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recovery pulse',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '72 bpm',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Resting · 10 mins ago',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.muted,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.accentRose.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite, color: AppColors.accentRose),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _miniStat('Steps', '5,432', 'goal 8k', AppColors.accent),
                        _miniStat('Calories', '1,280', 'active', AppColors.accentAmber),
                        _miniStat('Sleep', '7.4h', 'last night', AppColors.accentBlue),
                        _miniStat('O2', '98%', 'stable', AppColors.accentViolet),
                      ],
                    ).animate().fadeIn(delay: 120.ms, duration: 450.ms),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: AppCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Momentum',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your resting heart rate is trending lower this week.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.muted,
                                ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSoft,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.outline.withOpacity(0.5)),
                            ),
                            child: Row(
                              children: List.generate(
                                7,
                                (index) => Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                      height: 18 + index * 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 220.ms, duration: 450.ms),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: AppCard(
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
                    ).animate().fadeIn(delay: 320.ms, duration: 450.ms),
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

  Widget _miniStat(String label, String value, String hint, Color color) {
    return SizedBox(
      width: 160,
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.bolt, color: color, size: 16),
                ),
                const SizedBox(width: 8),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              hint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
