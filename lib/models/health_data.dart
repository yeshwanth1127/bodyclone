class HealthData {
  final Vitals vitals;
  final List<Report> reports;
  final List<Medication> medications;
  final List<Consultation> consultations;
  final String avatarMood;
  final String overallStatus;
  final String lastUpdated;

  HealthData({
    required this.vitals,
    required this.reports,
    required this.medications,
    required this.consultations,
    required this.avatarMood,
    required this.overallStatus,
    required this.lastUpdated,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      vitals: Vitals.fromJson(json['vitals'] ?? {}),
      reports: (json['reports'] as List<dynamic>? ?? [])
          .map((r) => Report.fromJson(r))
          .toList(),
      medications: (json['medications'] as List<dynamic>? ?? [])
          .map((m) => Medication.fromJson(m))
          .toList(),
      consultations: (json['consultations'] as List<dynamic>? ?? [])
          .map((c) => Consultation.fromJson(c))
          .toList(),
      avatarMood: json['avatar_mood'] ?? 'calm',
      overallStatus: json['overall_status'] ?? 'Good',
      lastUpdated: json['last_updated'] ?? '',
    );
  }
}

class Vitals {
  final int heartRate;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final double temperature;
  final int oxygenSaturation;
  final String lastUpdated;

  Vitals({
    required this.heartRate,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.temperature,
    required this.oxygenSaturation,
    required this.lastUpdated,
  });

  factory Vitals.fromJson(Map<String, dynamic> json) {
    final bp = json['blood_pressure'] ?? {};
    return Vitals(
      heartRate: json['heart_rate'] ?? 0,
      bloodPressureSystolic: bp['systolic'] ?? 0,
      bloodPressureDiastolic: bp['diastolic'] ?? 0,
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      oxygenSaturation: json['oxygen_saturation'] ?? 0,
      lastUpdated: json['last_updated'] ?? '',
    );
  }
}

class Report {
  final int id;
  final String type;
  final String date;
  final String status;
  final String summary;

  Report({
    required this.id,
    required this.type,
    required this.date,
    required this.status,
    required this.summary,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      summary: json['summary'] ?? '',
    );
  }
}

class Medication {
  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final String nextDose;
  final String status;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.nextDose,
    required this.status,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      nextDose: json['next_dose'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Consultation {
  final int id;
  final String doctor;
  final String specialty;
  final String date;
  final String status;
  final String notes;

  Consultation({
    required this.id,
    required this.doctor,
    required this.specialty,
    required this.date,
    required this.status,
    required this.notes,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] ?? 0,
      doctor: json['doctor'] ?? '',
      specialty: json['specialty'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}

