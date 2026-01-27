import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/health_data.dart';

class HealthApiService {
  // Update this to match your backend URL
  // For local development, use: http://localhost:5000
  // For Android emulator, use: http://10.0.2.2:5000
  // For iOS simulator, use: http://localhost:5000
  // For physical device, use your computer's IP: http://192.168.x.x:5000
  static const String baseUrl = 'http://localhost:5000';

  Future<HealthData> getHealthSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health/summary'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Fetch individual endpoints to get full data
        final reportsResponse = await http.get(Uri.parse('$baseUrl/api/reports'));
        final medicationResponse = await http.get(Uri.parse('$baseUrl/api/medication'));
        final consultationsResponse = await http.get(Uri.parse('$baseUrl/api/consultations'));
        
        final reportsData = reportsResponse.statusCode == 200 
            ? json.decode(reportsResponse.body)['reports'] as List<dynamic>? ?? []
            : <dynamic>[];
        final medicationsData = medicationResponse.statusCode == 200
            ? json.decode(medicationResponse.body)['medications'] as List<dynamic>? ?? []
            : <dynamic>[];
        final consultationsData = consultationsResponse.statusCode == 200
            ? json.decode(consultationsResponse.body)['consultations'] as List<dynamic>? ?? []
            : <dynamic>[];
        
        // Transform the response to match our model
        return HealthData(
          vitals: Vitals.fromJson(jsonData['vitals'] ?? {}),
          reports: reportsData.map((r) => Report.fromJson(r)).toList(),
          medications: medicationsData.map((m) => Medication.fromJson(m)).toList(),
          consultations: consultationsData.map((c) => Consultation.fromJson(c)).toList(),
          avatarMood: jsonData['avatar_mood'] ?? 'calm',
          overallStatus: jsonData['overall_status'] ?? 'Good',
          lastUpdated: jsonData['last_updated'] ?? '',
        );
      } else {
        throw Exception('Failed to load health data: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data if API is unavailable (for testing)
      return _getMockHealthData();
    }
  }

  Future<void> updateAvatarMood(String mood) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/avatar/mood'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'mood': mood}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update avatar mood: ${response.statusCode}');
      }
    } catch (e) {
      // Silently fail for now - could add retry logic
      print('Error updating avatar mood: $e');
    }
  }

  Future<Vitals> getVitals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/vitals'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Vitals.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load vitals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching vitals: $e');
    }
  }

  // Mock data for testing when backend is unavailable
  HealthData _getMockHealthData() {
    return HealthData(
      vitals: Vitals(
        heartRate: 72,
        bloodPressureSystolic: 120,
        bloodPressureDiastolic: 80,
        temperature: 98.6,
        oxygenSaturation: 98,
        lastUpdated: DateTime.now().toIso8601String(),
      ),
      reports: [
        Report(
          id: 1,
          type: 'Blood Test',
          date: DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
          status: 'Normal',
          summary: 'All parameters within normal range',
        ),
      ],
      medications: [
        Medication(
          id: 1,
          name: 'Vitamin D',
          dosage: '1000 IU',
          frequency: 'Once daily',
          nextDose: DateTime.now().add(const Duration(hours: 8)).toIso8601String(),
          status: 'active',
        ),
      ],
      consultations: [
        Consultation(
          id: 1,
          doctor: 'Dr. Sarah Johnson',
          specialty: 'General Medicine',
          date: DateTime.now().add(const Duration(days: 5)).toIso8601String(),
          status: 'scheduled',
          notes: 'Annual checkup',
        ),
      ],
      avatarMood: 'calm',
      overallStatus: 'Good',
      lastUpdated: DateTime.now().toIso8601String(),
    );
  }
}

