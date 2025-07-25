import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/screens/event/models/event_detail_model.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    EventDetailModel event = Get.arguments;

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Membuat body bisa di bawah AppBar transparan
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Tanpa bayangan
        foregroundColor: Colors.white, // Ikon dan teks di AppBar putih
      ),
      body: Stack(
        children: [
          // Background Gradient (Futuristic Touch)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Utils.kPrimaryColor, // Light Blue
                  Utils.kPrimaryMaterialColor,
                  Utils.kSecondaryColor,
                ],
                stops: [0.1, 0.5, 0.9],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: kToolbarHeight + 40, bottom: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title & Status
                _buildHeaderSection(context, event),
                const SizedBox(height: 25),

                // Description Card
                if (event.description != null && event.description!.isNotEmpty)
                  _buildInfoCard(
                    context,
                    title: 'Deskripsi Acara',
                    content: Text(
                      event.description!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white70),
                    ),
                    icon: Icons.info_outline,
                  ),
                const SizedBox(height: 20),

                // Time & Location Card
                _buildInfoCard(
                  context,
                  title: 'Waktu & Lokasi',
                  icon: Icons.access_time_filled,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        Icons.calendar_month,
                        'Tanggal:',
                        _formatDate(event.startTime),
                      ),
                      _buildDetailRow(
                        Icons.schedule,
                        'Pukul:',
                        '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                      ),
                      _buildDetailRow(
                        Icons.timelapse,
                        'Durasi:',
                        _formatDuration(event.startTime, event.endTime),
                      ),
                      const Divider(height: 20, color: Colors.white24),
                      _buildDetailRow(
                        Icons.location_on,
                        'Tempat:',
                        event.locationName,
                      ),
                      _buildDetailRow(
                        Icons.event_note,
                        'Tipe Acara:',
                        event.typeName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Attendance & Eligibility Card
                _buildInfoCard(
                  context,
                  title: 'Statistik Peserta',
                  icon: Icons.bar_chart,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        Icons.group,
                        'Dihadiri:',
                        '${event.attendedCount} peserta',
                      ),
                      _buildDetailRow(
                        Icons.how_to_reg,
                        'Memenuhi Syarat:',
                        '${event.eligibleCount} peserta',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // User Attendance Status
                _buildAttendanceStatusCard(context, event: event),
                const SizedBox(height: 20),

                // Action Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (event.status == EventStatus.active &&
                          !event.isAttended) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Fungsi Absensi Akan Datang!')),
                        );
                      } else if (event.isAttended) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Anda sudah absen di acara ini.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Acara tidak dalam status aktif untuk absensi.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: event.isAttended
                          ? Colors.grey.shade700
                          : Colors.lightGreenAccent,
                      foregroundColor: event.isAttended
                          ? Colors.white
                          : Colors.blueGrey.shade900,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: event.isAttended
                          ? Colors.grey
                          : Colors.lightGreenAccent.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(event.isAttended
                            ? Icons.check_circle_outline
                            : Icons.qr_code_scanner),
                        const SizedBox(width: 10),
                        Text(
                          event.isAttended ? 'Sudah Absen' : 'Absen Sekarang',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Padding di bagian bawah
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membangun baris detail
  Widget _buildHeaderSection(BuildContext context, EventDetailModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(event.status),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor(event.status).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            event.status.toShortString().toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required Widget content,
      required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // Semi-transparent background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: Colors.white.withOpacity(0.2), width: 0.5), // Subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.lightBlueAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const Divider(height: 25, color: Colors.white38),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatusCard(BuildContext context,
      {required EventDetailModel event}) {
    Color statusColor =
        event.isAttended ? Colors.greenAccent : Colors.amberAccent;
    IconData statusIcon =
        event.isAttended ? Icons.check_circle_outline : Icons.pending_actions;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Kehadiran Anda',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  event.isAttended
                      ? 'Anda sudah HADIR di acara ini!'
                      : 'Anda belum HADIR.',
                  style: TextStyle(
                    fontSize: 16,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk mendapatkan warna status
  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return Colors.amber.shade700; // Emas tua
      case EventStatus.active:
        return Colors.green.shade600; // Hijau terang
      case EventStatus.finish:
        return Colors.blueGrey.shade700; // Abu-abu kebiruan
      case EventStatus.canceled:
        return Colors.red.shade600; // Merah
    }
  }

  // Helper method untuk memformat DateTime
  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  // Helper method untuk memformat durasi
  String _formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    String durationString = '';
    if (duration.inDays > 0) {
      durationString += '${duration.inDays} hari ';
    }
    if (duration.inHours % 24 > 0) {
      durationString += '${duration.inHours % 24} jam ';
    }
    if (duration.inMinutes % 60 > 0) {
      durationString += '${duration.inMinutes % 60} menit';
    }
    return durationString.trim().isEmpty
        ? 'Kurang dari 1 menit'
        : durationString.trim();
  }
}
