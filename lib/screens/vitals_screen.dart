import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import '../services/health_connect_service.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  final HealthConnectService _healthService = HealthConnectService();
  bool _isLoading = true;
  bool _hasPermissions = false;
  bool _isAvailable = false;
  Map<String, dynamic> _vitals = {};

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Health Connect is not available on web
      setState(() {
        _isLoading = false;
        _isAvailable = false;
      });
    } else {
      _initializeHealthConnect();
    }
  }

  Future<void> _initializeHealthConnect() async {
    try {
      // Check if Health Connect is available
      final available = await _healthService.checkAvailability();
      
      if (mounted) {
        setState(() {
          _isAvailable = available;
        });
      }

      if (available) {
        // Request permissions
        final granted = await _healthService.requestPermissions();
        
        if (mounted) {
          setState(() {
            _hasPermissions = granted;
          });
        }

        if (granted) {
          await _loadVitals();
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Health Connect: $e');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadVitals() async {
    try {
      final vitals = await _healthService.getAllVitals();
      if (mounted) {
        setState(() {
          _vitals = vitals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading vitals: $e');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshVitals() async {
    setState(() {
      _isLoading = true;
    });
    await _loadVitals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f172a),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Vitals',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (kIsWeb) {
      return _buildWebPlaceholder();
    }

    if (!_isAvailable) {
      return _buildNotAvailable();
    }

    if (!_hasPermissions) {
      return _buildPermissionRequest();
    }

    if (_vitals.isEmpty) {
      return _buildNoData();
    }

    return _buildVitalsDisplay();
  }

  Widget _buildWebPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Health Connect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Health Connect is available on Android devices.\nConnect your Galaxy Watch or other health devices.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotAvailable() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Health Connect Not Available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please install Health Connect from Google Play Store to sync vitals from your Galaxy Watch or Samsung Health.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Permission Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We need permission to read your health data from Health Connect.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final granted = await _healthService.requestPermissions();
                if (granted && mounted) {
                  setState(() {
                    _hasPermissions = true;
                  });
                  await _loadVitals();
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permissions denied. Please grant permissions in settings.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3b82f6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Grant Permissions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Data Available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sync your Galaxy Watch or Samsung Health to see your vitals here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _refreshVitals,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3b82f6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsDisplay() {
    return RefreshIndicator(
      onRefresh: _refreshVitals,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_vitals['heartRate'] != null)
            _buildVitalCard(
              'Heart Rate',
              '${_vitals['heartRate']} bpm',
              Icons.favorite,
              Colors.red,
            ),
          if (_vitals['bloodOxygen'] != null)
            _buildVitalCard(
              'Blood Oxygen (SpO₂)',
              '${_vitals['bloodOxygen']}%',
              Icons.air,
              Colors.blue,
            ),
          if (_vitals['bloodPressureSystolic'] != null &&
              _vitals['bloodPressureDiastolic'] != null)
            _buildVitalCard(
              'Blood Pressure',
              '${_vitals['bloodPressureSystolic']?.toInt()}/${_vitals['bloodPressureDiastolic']?.toInt()} mmHg',
              Icons.monitor_heart,
              Colors.purple,
            ),
          if (_vitals['temperature'] != null)
            _buildVitalCard(
              'Temperature',
              '${_vitals['temperature']?.toStringAsFixed(1)}°F',
              Icons.thermostat,
              Colors.orange,
            ),
          if (_vitals['steps'] != null)
            _buildVitalCard(
              'Steps Today',
              '${_vitals['steps']} steps',
              Icons.directions_walk,
              Colors.green,
            ),
          if (_vitals['calories'] != null)
            _buildVitalCard(
              'Calories Burned',
              '${_vitals['calories']} kcal',
              Icons.local_fire_department,
              Colors.deepOrange,
            ),
          if (_vitals['sleepHours'] != null)
            _buildVitalCard(
              'Sleep Last Night',
              '${_vitals['sleepHours']} hours',
              Icons.bedtime,
              Colors.indigo,
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Last updated: ${_formatDateTime(_vitals['lastUpdated'] ?? '')}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: const Color(0xFF1e293b),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final hours = date.hour.toString().padLeft(2, '0');
      final minutes = date.minute.toString().padLeft(2, '0');
      return '${months[date.month - 1]} ${date.day}, ${date.year} at $hours:$minutes';
    } catch (e) {
      return isoDate;
    }
  }
}

