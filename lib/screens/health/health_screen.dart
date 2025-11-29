import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';
import 'food_scanner_screen.dart';

// Health Screen
class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  // State variables
  DateTime _selectedDate = DateTime.now();
  double _waterIntake = 1.5;
  final double _waterGoal = 2.0;
  String _selectedMealTab = 'Breakfast';
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 0);

  // Mock data for food items
  final Map<String, List<Map<String, String>>> _foodItems = {
    'Breakfast': [
      {'name': 'Oatmeal with Berries', 'calories': '350 kcal'},
      {'name': 'Black Coffee', 'calories': '5 kcal'},
    ],
    'Lunch': [
      {'name': 'Grilled Chicken Salad', 'calories': '450 kcal'},
      {'name': 'Apple', 'calories': '80 kcal'},
    ],
    'Dinner': [
      {'name': 'Salmon with Veggies', 'calories': '550 kcal'},
    ],
    'Snacks': [
      {'name': 'Almonds', 'calories': '160 kcal'},
    ],
  };

  void _updateWater(double amount) {
    setState(() {
      _waterIntake = (_waterIntake + amount).clamp(0.0, _waterGoal * 2);
    });
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  Future<void> _showAddFoodDialog() async {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Yummy Food'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'What did you eat?',
                hintText: 'e.g., Banana',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories (optional)',
                hintText: 'e.g., 105',
                suffixText: 'kcal',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  if (_foodItems[_selectedMealTab] == null) {
                    _foodItems[_selectedMealTab] = [];
                  }
                  _foodItems[_selectedMealTab]!.add({
                    'name': nameController.text,
                    'calories': caloriesController.text.isNotEmpty
                        ? '${caloriesController.text} kcal'
                        : 'Unknown',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditSleepDialog() async {
    TimeOfDay tempBedTime = _bedTime;
    TimeOfDay tempWakeTime = _wakeTime;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Sleep Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Bed Time'),
                trailing: Text(tempBedTime.format(context)),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: tempBedTime,
                  );
                  if (time != null) {
                    setDialogState(() => tempBedTime = time);
                  }
                },
              ),
              ListTile(
                title: const Text('Wake Up Time'),
                trailing: Text(tempWakeTime.format(context)),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: tempWakeTime,
                  );
                  if (time != null) {
                    setDialogState(() => tempWakeTime = time);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _bedTime = tempBedTime;
                  _wakeTime = tempWakeTime;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return DateFormat('MMM d').format(date);
  }

  String _calculateSleepDuration() {
    final now = DateTime.now();
    final bed = DateTime(
      now.year,
      now.month,
      now.day,
      _bedTime.hour,
      _bedTime.minute,
    );
    var wake = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    if (wake.isBefore(bed)) {
      wake = wake.add(const Duration(days: 1));
    }

    final duration = wake.difference(bed);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Flowy
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/flowy.svg',
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Healthy Habits',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left, size: 20),
                              onPressed: () => _changeDate(-1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                _formatDate(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF9098A3),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right, size: 20),
                              onPressed: () => _changeDate(1),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Food Section
                    _buildSectionCard(
                      title: 'Yummy Food',
                      icon: SolarIconsBold.hamburgerMenu,
                      color: const Color(0xFFFF9F1C), // Orange
                      child: Column(
                        children: [
                          // Meal Tabs
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildMealTab('Breakfast'),
                                const SizedBox(width: 8),
                                _buildMealTab('Lunch'),
                                const SizedBox(width: 8),
                                _buildMealTab('Dinner'),
                                const SizedBox(width: 8),
                                _buildMealTab('Snacks'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Food List
                          ...(_foodItems[_selectedMealTab] ?? []).map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFF9F1C).withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9F1C).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.restaurant,
                                        size: 16,
                                        color: Color(0xFFFF9F1C),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['calories']!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _showAddFoodDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Food'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9F1C),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FoodScannerScreen(),
                                    ),
                                  );
                                  
                                  if (result != null && result is Map<String, String>) {
                                    setState(() {
                                      if (_foodItems[_selectedMealTab] == null) {
                                        _foodItems[_selectedMealTab] = [];
                                      }
                                      _foodItems[_selectedMealTab]!.add(result);
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9F1C).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFF9F1C),
                                    ),
                                  ),
                                  child: const Icon(
                                    SolarIconsBold.scanner,
                                    color: Color(0xFFFF9F1C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Hydration Section
                    _buildSectionCard(
                      title: 'Water Power',
                      icon: Icons.water_drop,
                      color: const Color(0xFF4ECDC4), // Teal
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_waterIntake.toStringAsFixed(1)}L',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4ECDC4),
                                ),
                              ),
                              const Text(
                                ' / 2.0L',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (_waterIntake / _waterGoal).clamp(0.0, 1.0),
                              minHeight: 20,
                              backgroundColor: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4ECDC4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildWaterButton(Icons.remove, () => _updateWater(-0.25)),
                              const SizedBox(width: 32),
                              _buildWaterButton(Icons.add, () => _updateWater(0.25)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sleep Section
                    _buildSectionCard(
                      title: 'Sleepy Time',
                      icon: SolarIconsBold.moon,
                      color: const Color(0xFF6C5CE7), // Purple
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSleepInfo('Bed Time', _bedTime.format(context)),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey[300],
                              ),
                              _buildSleepInfo('Wake Up', _wakeTime.format(context)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.timelapse, color: Color(0xFF6C5CE7)),
                                const SizedBox(width: 8),
                                Text(
                                  'Total Sleep: ${_calculateSleepDuration()}',
                                  style: const TextStyle(
                                    color: Color(0xFF6C5CE7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _showEditSleepDialog,
                            child: const Text('Change Schedule'),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildMealTab(String label) {
    final isSelected = _selectedMealTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMealTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9F1C) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildWaterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF4ECDC4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildSleepInfo(String label, String time) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }
}
