import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/health_api_service.dart';
import '../models/health_data.dart';
import 'voice_report_screen.dart';
import 'report_detail_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final HealthApiService _apiService = HealthApiService();
  List<Report> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload when returning from voice report screen
    final result = ModalRoute.of(context)?.settings.arguments;
    if (result == true) {
      _loadReports();
    }
  }

  Future<void> _loadReports() async {
    try {
      final healthData = await _apiService.getHealthSummary();
      if (mounted) {
        setState(() {
          _reports = healthData.reports;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadFile({bool isPrescription = false}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.single;
        final fileName = file.name;
        final filePath = kIsWeb ? null : file.path;
        
        if (filePath == null && !kIsWeb) {
          throw Exception('File path is null');
        }
        
        // For web, we need to handle bytes differently
        if (kIsWeb && file.bytes != null) {
          // Upload file to backend using bytes
          await _apiService.uploadReportBytes(
            fileBytes: file.bytes!,
            fileName: fileName,
            isPrescription: isPrescription,
          );
        } else if (filePath != null) {
          // Upload file to backend using path
          await _apiService.uploadReport(
            filePath: filePath,
            fileName: fileName,
            isPrescription: isPrescription,
          );
        } else {
          throw Exception('Unable to get file data');
        }

        // Reload reports
        await _loadReports();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isPrescription
                    ? 'Prescription uploaded successfully'
                    : 'Report uploaded successfully',
              ),
              backgroundColor: const Color(0xFF1e293b),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          'Reports',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Column(
              children: [
                // Action buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF0f172a),
                  child: Column(
                    children: [
                      // Voice report button (full width)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const VoiceReportScreen(),
                              ),
                            );
                            if (result == true) {
                              await _loadReports();
                            }
                          },
                          icon: const Icon(Icons.mic),
                          label: const Text('Record Voice Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10b981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Upload buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _uploadFile(isPrescription: false),
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload Report'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3b82f6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _uploadFile(isPrescription: true),
                              icon: const Icon(Icons.description),
                              label: const Text('Upload Prescription'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8b5cf6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Reports list
                Expanded(
                  child: _reports.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 64,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No reports yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload your first report or prescription',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _reports.length,
                          itemBuilder: (context, index) {
                            final report = _reports[index];
                            return Card(
                              color: const Color(0xFF1e293b),
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReportDetailScreen(report: report),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  leading: Container(
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
                                  title: Text(
                                    report.isVoiceReport && report.patientName != null
                                        ? '${report.type} - ${report.patientName}'
                                        : report.type,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    if (report.fileName != null)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.attach_file,
                                              size: 14,
                                              color: Colors.white.withOpacity(0.7),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              report.fileName!,
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Text(
                                      _formatDate(report.date),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (report.summary.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          report.summary,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.6),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Chip(
                                  label: Text(
                                    report.status,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.green.withOpacity(0.2),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ],
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
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return isoDate;
    }
  }
}

