import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../widgets/page_header.dart';
import '../../widgets/flowy_companion.dart';

// Home Screen - Redesigned for beginners with Flowy companion
// Features: Pose-detection workouts, water/food reminders, beginner guidance
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentFlowyMessage = '';

  @override
  void initState() {
    super.initState();
    _updateFlowyMessage();
  }

  void _updateFlowyMessage() {
    final hour = DateTime.now().hour;
    final messages = [
      if (hour < 12) "Good morning! Ready to start your fitness journey today?",
      if (hour >= 12 && hour < 17) "Hey there! Let's keep that energy going!",
      if (hour >= 17) "Evening vibes! Time to wind down with some movement!",
    ];

    setState(() {
      _currentFlowyMessage = messages.first;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getUserName() {
    // TODO: Get from user profile/auth
    return 'Friend';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Friendly header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Greeting
                      Text(
                        '${_getGreeting()}, ${_getUserName()}! 👋',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Flowy Companion - Main feature
                      FlowyCompanion(
                        message: _currentFlowyMessage,
                        size: 200,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Mission Card - Beginner friendly
                  _buildMissionCard(context),

                  const SizedBox(height: 20),

                  // Reminders Section
                  _buildRemindersSection(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mission card for daily goals
  Widget _buildMissionCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              SolarIconsBold.flame,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '5-Day Streak! 🔥',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'re doing amazing! Keep it up!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reminders for water and food
  Widget _buildRemindersSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FlowyMini(size: 32),
              const SizedBox(width: 12),
              Text(
                'Flowy\'s Needs',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildReminderItem(
            context,
            Icons.water_drop,
            'Drink water',
            'Stay hydrated! 8 glasses today',
            Colors.cyan,
            () => Navigator.pushNamed(context, '/wellness-tracker'),
          ),
          const SizedBox(height: 8),
          _buildReminderItem(
            context,
            Icons.restaurant,
            'Healthy snack',
            'Time for a nutritious bite',
            Colors.green,
            () => Navigator.pushNamed(context, '/nutrition-goals'),
          ),
          const SizedBox(height: 8),
          _buildReminderItem(
            context,
            Icons.directions_run,
            'Stay Active',
            'Move your body!',
            Colors.orange,
            () => Navigator.pushNamed(context, '/workout/select-type'),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              SolarIconsBold.bell,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
