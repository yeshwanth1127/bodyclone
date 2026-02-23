import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/digital_twin_logo.dart';
import '../widgets/particle_background.dart';
import 'avatar_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          const ParticleBackground(
            particleCount: 70,
            particleColor: Colors.white,
            particleSpeed: 0.6,
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 700),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 12),
                            child: child,
                          ),
                        );
                      },
                      child: const DigitalTwinLogo(
                        size: 140,
                        animated: true,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 900),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 10),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Digital Twin',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your biometric world, alive in one elegant timeline.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _FeaturePill(label: 'Secure sync'),
                        _FeaturePill(label: 'AI summaries'),
                        _FeaturePill(label: 'Daily insights'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const AvatarScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.ink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Enter your virtual world'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.surface,
                              title: const Text('Digital Twin'),
                              content: Text(
                                'A living, secure view of your health story, updated by your devices, reports, and clinical notes.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Got it'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Learn what a digital twin is'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String label;

  const _FeaturePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outline.withOpacity(0.7)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}
