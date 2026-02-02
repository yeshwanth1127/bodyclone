import 'package:flutter/material.dart';
import '../models/health_data.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({
    super.key,
    required this.report,
  });

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
        title: Text(
          report.isVoiceReport ? 'Voice Report' : 'Report Details',
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report header
            Card(
              color: const Color(0xFF1e293b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: report.isVoiceReport
                                ? const Color(0xFF10b981).withOpacity(0.2)
                                : const Color(0xFF3b82f6).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            report.isVoiceReport ? Icons.mic : Icons.description,
                            color: report.isVoiceReport
                                ? const Color(0xFF10b981)
                                : const Color(0xFF3b82f6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.type,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(report.date),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            report.status,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.green.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Voice report specific fields
            if (report.isVoiceReport) ...[
              if (report.patientName != null)
                _buildSection(
                  'Patient Name',
                  report.patientName!,
                  Icons.person,
                ),
              
              if (report.complaints != null && report.complaints!.isNotEmpty)
                _buildSection(
                  'Complaints / Symptoms',
                  report.complaints!,
                  Icons.medical_services,
                ),
              
              if (report.diagnosis != null && report.diagnosis!.isNotEmpty)
                _buildSection(
                  'Diagnosis',
                  report.diagnosis!,
                  Icons.assignment,
                  color: const Color(0xFF3b82f6),
                ),
              
              if (report.notes != null && report.notes!.isNotEmpty)
                _buildSection(
                  'Notes',
                  report.notes!,
                  Icons.note,
                ),
              
              if (report.prescription != null && report.prescription!.isNotEmpty)
                _buildSection(
                  'Prescription',
                  report.prescription!,
                  Icons.medication,
                  color: const Color(0xFF8b5cf6),
                ),
              
              if (report.rawTranscript != null && report.rawTranscript!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  color: const Color(0xFF1e293b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: const Text(
                      'Raw Transcript',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.text_fields,
                      color: Colors.grey,
                    ),
                    iconColor: Colors.grey,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          report.rawTranscript!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else ...[
              // Regular report fields
              if (report.summary.isNotEmpty)
                _buildSection(
                  'Summary',
                  report.summary,
                  Icons.summarize,
                ),
              
              if (report.fileName != null)
                _buildSection(
                  'File',
                  report.fileName!,
                  Icons.attach_file,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: const Color(0xFF1e293b),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: color ?? Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: color ?? Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
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

