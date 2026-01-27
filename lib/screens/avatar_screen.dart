import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' as ui;
import '../services/health_api_service.dart';
import '../models/health_data.dart';

// Conditional imports for web
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> with TickerProviderStateMixin {
  final HealthApiService _apiService = HealthApiService();
  HealthData? _healthData;
  bool _isLoading = true;
  String _avatarMood = 'calm';
  bool _isViewRegistered = false;
  
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadHealthData();
    
    // Animation for avatar pulsing
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _loadHealthData() async {
    try {
      // Set loading to false after a short delay to ensure UI shows
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
      
      final data = await _apiService.getHealthSummary();
      if (mounted) {
        setState(() {
          _healthData = data;
          _avatarMood = data.avatarMood;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Use mock data if API fails
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Create mock health data
          _healthData = HealthData(
            vitals: Vitals(
              heartRate: 72,
              bloodPressureSystolic: 120,
              bloodPressureDiastolic: 80,
              temperature: 98.6,
              oxygenSaturation: 98,
              lastUpdated: DateTime.now().toIso8601String(),
            ),
            reports: [],
            medications: [],
            consultations: [],
            avatarMood: 'calm',
            overallStatus: 'Good',
            lastUpdated: DateTime.now().toIso8601String(),
          );
          _avatarMood = 'calm';
        });
      }
    }
  }

  Future<void> _onHealthIconTap(String metricType) async {
    try {
      // Update avatar mood based on which metric was tapped
      String newMood = 'calm';
      switch (metricType) {
        case 'vitals':
          newMood = 'focus';
          break;
        case 'reports':
          newMood = 'analyze';
          break;
        case 'medication':
          newMood = 'care';
          break;
        case 'consultations':
          newMood = 'listen';
          break;
      }
      
      await _apiService.updateAvatarMood(newMood);
      setState(() {
        _avatarMood = newMood;
      });
      
      // Show metric details
      _showMetricDetails(metricType);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showMetricDetails(String metricType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFF0f172a),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _getMetricTitle(metricType),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: _buildMetricContent(metricType),
            ),
          ],
        ),
      ),
    );
  }

  String _getMetricTitle(String type) {
    switch (type) {
      case 'vitals':
        return 'Vital Signs';
      case 'reports':
        return 'Medical Reports';
      case 'medication':
        return 'Medications';
      case 'consultations':
        return 'Consultations';
      default:
        return 'Health Metrics';
    }
  }

  Widget _buildMetricContent(String type) {
    if (_healthData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (type) {
      case 'vitals':
        return _buildVitalsContent();
      case 'reports':
        return _buildReportsContent();
      case 'medication':
        return _buildMedicationContent();
      case 'consultations':
        return _buildConsultationsContent();
      default:
        return const SizedBox();
    }
  }

  Widget _buildVitalsContent() {
    final vitals = _healthData!.vitals;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMetricCard('Heart Rate', '${vitals.heartRate} bpm', Icons.favorite, Colors.red),
        _buildMetricCard('Blood Pressure', '${vitals.bloodPressureSystolic}/${vitals.bloodPressureDiastolic} mmHg', Icons.monitor_heart, Colors.blue),
        _buildMetricCard('Temperature', '${vitals.temperature}°F', Icons.thermostat, Colors.orange),
        _buildMetricCard('Oxygen Saturation', '${vitals.oxygenSaturation}%', Icons.air, Colors.green),
      ],
    );
  }

  Widget _buildReportsContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _healthData!.reports.map((report) {
        return Card(
          color: const Color(0xFF1e293b),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.description, color: Colors.blue),
            title: Text(report.type, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '${_formatDate(report.date)}\n${report.summary}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: Chip(
              label: Text(report.status, style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.green.withOpacity(0.2),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicationContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _healthData!.medications.map((med) {
        return Card(
          color: const Color(0xFF1e293b),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.medication, color: Colors.purple),
            title: Text(med.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '${med.dosage} - ${med.frequency}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: Chip(
              label: Text(med.status, style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.purple.withOpacity(0.2),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConsultationsContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _healthData!.consultations.map((consult) {
        return Card(
          color: const Color(0xFF1e293b),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.teal),
            title: Text(consult.doctor, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '${consult.specialty}\n${_formatDate(consult.date)}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: Chip(
              label: Text(consult.status, style: const TextStyle(fontSize: 12)),
              backgroundColor: Colors.teal.withOpacity(0.2),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: const Color(0xFF1e293b),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        trailing: Text(
          value,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
                children: [
                  // Loading indicator overlay (if loading)
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  
                  // Solid background (no gradient)
                  Container(
                    color: const Color(0xFF020617),
                  ),
                  
                  // Avatar at bottom center
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 3D Avatar GLB Model with animation
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.height * 0.7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getMoodColors(_avatarMood)[0].withOpacity(0.3),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: _buildModelViewer(),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Your Digital Twin',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Health metric icons positioned left and right of avatar
                  ..._buildHealthIcons(),
                ],
              ),
    );
  }

  List<Widget> _buildHealthIcons() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarBottom = 60.0;
    final avatarSize = screenWidth * 0.4;
    final avatarCenterY = screenHeight - avatarBottom - avatarSize / 2;
    final avatarCenterX = screenWidth / 2;
    final iconSpacing = 80.0; // Vertical spacing between icons
    final iconOffsetX = 70.0; // Horizontal offset from avatar center

    final leftIcons = [
      {
        'type': 'vitals',
        'icon': Icons.favorite,
        'label': 'Vitals',
        'color': Colors.red,
      },
      {
        'type': 'reports',
        'icon': Icons.description,
        'label': 'Reports',
        'color': Colors.blue,
      },
    ];

    final rightIcons = [
      {
        'type': 'medication',
        'icon': Icons.medication,
        'label': 'Medication',
        'color': Colors.purple,
      },
      {
        'type': 'consultations',
        'icon': Icons.local_hospital,
        'label': 'Consult',
        'color': Colors.teal,
      },
    ];

    final widgets = <Widget>[];

    // Left side icons
    for (int i = 0; i < leftIcons.length; i++) {
      final iconData = leftIcons[i];
      final iconY = avatarCenterY - (iconSpacing * (leftIcons.length - 1) / 2) + (i * iconSpacing);
      
      widgets.add(
        Positioned(
          left: avatarCenterX - avatarSize / 2 - iconOffsetX - 35,
          top: iconY - 35,
          child: GestureDetector(
            onTap: () => _onHealthIconTap(iconData['type'] as String),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Glass morphism effect
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: (iconData['color'] as Color).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconData['icon'] as IconData,
                            color: iconData['color'] as Color,
                            size: 28,
                          ),
                          Text(
                            iconData['label'] as String,
                            style: TextStyle(
                              color: iconData['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ),
        ),
      );
    }

    // Right side icons
    for (int i = 0; i < rightIcons.length; i++) {
      final iconData = rightIcons[i];
      final iconY = avatarCenterY - (iconSpacing * (rightIcons.length - 1) / 2) + (i * iconSpacing);
      
      widgets.add(
        Positioned(
          left: avatarCenterX + avatarSize / 2 + iconOffsetX - 30,
          top: iconY - 30,
          child: GestureDetector(
            onTap: () => _onHealthIconTap(iconData['type'] as String),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Glass morphism effect
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: (iconData['color'] as Color).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconData['icon'] as IconData,
                            color: iconData['color'] as Color,
                            size: 28,
                          ),
                          Text(
                            iconData['label'] as String,
                            style: TextStyle(
                              color: iconData['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ),
        ),
      );
    }

    return widgets;
  }

  List<Color> _getMoodColors(String mood) {
    switch (mood) {
      case 'focus':
        return [const Color(0xFF3b82f6), const Color(0xFF1e40af)];
      case 'analyze':
        return [const Color(0xFF8b5cf6), const Color(0xFF5b21b6)];
      case 'care':
        return [const Color(0xFFec4899), const Color(0xFF9f1239)];
      case 'listen':
        return [const Color(0xFF14b8a6), const Color(0xFF0f766e)];
      default: // calm
        return [const Color(0xFF6366f1), const Color(0xFF4338ca)];
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return isoDate;
    }
  }

  Widget _buildModelViewer() {
    // Primary: Show GLB model (no gradients)
    if (kIsWeb) {
      return _buildWebModelViewer();
    } else {
      // For mobile, show simple icon (no gradient)
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Icon(
          Icons.person,
          size: 150,
          color: Colors.white.withOpacity(0.9),
        ),
      );
    }
  }

  Widget _buildWebModelViewer() {
    try {
      // Create a unique view ID - use a static one to avoid recreating
      final String viewId = 'avatar-model-viewer';
      
      // Register the platform view only once
      if (!_isViewRegistered) {
        ui_web.platformViewRegistry.registerViewFactory(
          viewId,
          (int viewId) {
            // Use blob URL instead of data URI to avoid CORS issues
            final htmlContent = _getHTMLContent();
            final blob = html.Blob([htmlContent], 'text/html');
            final blobUrl = html.Url.createObjectUrlFromBlob(blob);
            
            final iframe = html.IFrameElement()
              ..src = blobUrl
              ..style.border = 'none'
              ..style.width = '100%'
              ..style.height = '100%'
              ..style.background = 'transparent'
              ..allow = 'camera; microphone';
            return iframe;
          },
        );
        _isViewRegistered = true;
      }

      return SizedBox.expand(
        child: HtmlElementView(viewType: viewId),
      );
    } catch (e) {
      // If web viewer fails, show error message
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 8),
              Text(
                'GLB Model Error',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
  }

  String _getHTMLContent() {
    // Get the current origin to construct absolute URLs
    // This works for both dev and production
    final baseUrl = html.window.location.origin;
    
    // Flutter web serves assets from root in production, or with base href in dev
    final pathname = html.window.location.pathname ?? '';
    final baseHref = pathname.replaceAll(RegExp(r'/[^/]*$'), '');
    final assetBase = baseHref.isEmpty ? '' : baseHref;
    
    // Try multiple possible paths
    final modelPaths = [
      '$baseUrl$assetBase/assets/images/avatar.glb',
      '$baseUrl/assets/images/avatar.glb',
      '$baseUrl$assetBase/packages/bodyclone/assets/images/avatar.glb',
    ];
    
    // Use the first path as primary
    final modelPath = modelPaths[0];

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>3D Avatar</title>
    <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.3.0/model-viewer.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html, body {
            width: 100%;
            height: 100%;
            background: transparent;
            overflow: hidden;
        }
        model-viewer {
            width: 100%;
            height: 100%;
            background: transparent;
        }
        #error-message {
            display: none;
            color: white;
            text-align: center;
            padding: 20px;
            font-family: Arial, sans-serif;
        }
    </style>
</head>
<body>
    <model-viewer
        id="avatar-model"
        src="$modelPath"
        alt="3D Avatar"
        auto-rotate
        camera-controls
        interaction-policy="allow-when-focused"
        style="width: 100%; height: 100%; background: transparent;"
        crossorigin="anonymous">
    </model-viewer>
    <div id="error-message">
        <p>Loading GLB model...</p>
        <p>If this persists, check that avatar.glb exists in assets/images/</p>
    </div>
    <script>
        const modelViewer = document.getElementById('avatar-model');
        const errorMsg = document.getElementById('error-message');
        
        // Get the parent window's origin (since we're in an iframe)
        let baseOrigin = '';
        try {
            baseOrigin = window.parent.location.origin;
        } catch (e) {
            // If we can't access parent (cross-origin), use current origin
            baseOrigin = window.location.origin;
        }
        
        // Get the current pathname to determine base path
        let basePath = '';
        try {
            const parentPath = window.parent.location.pathname || '';
            // Remove the last segment (usually index.html or empty)
            const lastSlash = parentPath.lastIndexOf('/');
            basePath = lastSlash > 0 ? parentPath.substring(0, lastSlash) : '';
        } catch (e) {
            const pathname = window.location.pathname || '';
            const lastSlash = pathname.lastIndexOf('/');
            basePath = lastSlash > 0 ? pathname.substring(0, lastSlash) : '';
        }
        
        // Construct paths with absolute URLs - try different Flutter web asset locations
        // Use the same origin to avoid CORS issues
        const paths = [
            baseOrigin + basePath + '/assets/images/avatar.glb',
            baseOrigin + '/assets/images/avatar.glb',
            baseOrigin + basePath + '/packages/bodyclone/assets/images/avatar.glb',
            baseOrigin + '/packages/bodyclone/assets/images/avatar.glb'
        ];
        
        // Filter out any null or invalid paths - ensure they're valid HTTP URLs
        const validPaths = paths.filter(function(p) {
            return p && typeof p === 'string' && p.startsWith('http');
        });
        
        let currentPathIndex = 0;
        const pathsToTry = validPaths.length > 0 ? validPaths : paths;
        
        function tryNextPath() {
            if (currentPathIndex < pathsToTry.length - 1) {
                currentPathIndex++;
                console.log('Trying path:', pathsToTry[currentPathIndex]);
                // Set crossorigin attribute to handle CORS
                modelViewer.setAttribute('crossorigin', 'anonymous');
                modelViewer.src = pathsToTry[currentPathIndex];
            } else {
                errorMsg.style.display = 'block';
                errorMsg.innerHTML = '<p>Could not load GLB model</p><p>Tried paths:</p><ul>' + 
                    pathsToTry.map(p => '<li>' + p + '</li>').join('') + 
                    '</ul><p>Base origin: ' + baseOrigin + '</p><p>Base path: ' + basePath + '</p>';
            }
        }
        
        function handleModelError(event) {
            console.error('Failed to load model from:', pathsToTry[currentPathIndex], event);
            tryNextPath();
        }
        
        // Set crossorigin on initial load
        modelViewer.setAttribute('crossorigin', 'anonymous');
        
        // Try alternative paths if first one fails
        modelViewer.addEventListener('error', handleModelError);
        modelViewer.addEventListener('load', function() {
            console.log('Model loaded successfully from:', modelViewer.src);
            errorMsg.style.display = 'none';
        });
        
        // Also try loading after a delay if still not loaded
        setTimeout(() => {
            if (!modelViewer.loaded) {
                console.log('Model not loaded after 2s, trying alternative paths...');
                tryNextPath();
            }
        }, 2000);
        
        // Log the initial path being tried
        console.log('Initial model path:', pathsToTry[0]);
        console.log('Base origin:', baseOrigin);
        console.log('Base path:', basePath);
        console.log('Valid paths:', pathsToTry);
    </script>
</body>
</html>
''';
  }

}

