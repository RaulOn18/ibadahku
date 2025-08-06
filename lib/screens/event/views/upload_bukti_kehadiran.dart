import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Untuk GetX
import 'package:ibadahku/utils/utils.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu
import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar
import 'package:file_picker/file_picker.dart'; // Untuk memilih file
import 'dart:io'; // Untuk File
import 'package:supabase_flutter/supabase_flutter.dart'; // Untuk Supabase

// Sesuaikan path model kamu
import 'package:ibadahku/screens/event/models/event_detail_model.dart';

class UploadBuktiKehadiran extends StatefulWidget {
  const UploadBuktiKehadiran({super.key});

  @override
  State<UploadBuktiKehadiran> createState() => _UploadBuktiKehadiranState();
}

class _UploadBuktiKehadiranState extends State<UploadBuktiKehadiran> {
  // Properti untuk menampung data dari Get.arguments
  late final EventDetailModel event;
  late final String userId;
  String? eventAttendanceId; // Opsional: Untuk kasus update kehadiran

  File? _photoFile;
  File? _resumeFile;
  bool _isLoading = false;
  final SupabaseClient supabase =
      Supabase.instance.client; // Inisialisasi Supabase Client

  // Cek apakah event ini memerlukan resume berdasarkan typeName
  // bool get _requiresResume =>
  //     event.typeName.toLowerCase() == 'kajian' ||
  //     event.typeName.toLowerCase() == 'seminar';

  // Resume sekarang opsional untuk semua jenis event
  bool get _showResumeSection =>
      true; // Selalu tampilkan section resume sebagai opsional

  @override
  void initState() {
    super.initState();
    // Mendapatkan argumen dari GetX
    event = Get.arguments as EventDetailModel;
    userId = Supabase.instance.client.auth.currentUser!.id;
    eventAttendanceId = null; // Set default null, bisa diubah jika diperlukan
  }

  Future<void> _pickPhoto() async {
    try {
      // Tampilkan dialog untuk memilih sumber foto
      final choice = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Sumber Foto'),
            content: const Text(
                'Pilih dari mana Anda ingin mengambil foto kehadiran:'),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop('camera'),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Kamera'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop('gallery'),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galeri'),
              ),
            ],
          );
        },
      );

      if (choice == null) return;

      ImageSource source =
          choice == 'camera' ? ImageSource.camera : ImageSource.gallery;

      final XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _photoFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackBar('Gagal memilih foto: $e', isError: true);
    }
  }

  Future<void> _pickResume() async {
    try {
      // Tampilkan dialog untuk memilih sumber file
      final choice = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Sumber File'),
            content: const Text(
                'Pilih dari mana Anda ingin mengambil file resume/catatan:'),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop('camera'),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Kamera'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop('gallery'),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galeri'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop('file'),
                icon: const Icon(Icons.insert_drive_file),
                label: const Text('File PDF'),
              ),
            ],
          );
        },
      );

      if (choice == null) return;

      if (choice == 'camera') {
        final XFile? pickedFile =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() {
            _resumeFile = File(pickedFile.path);
          });
        }
      } else if (choice == 'gallery') {
        final XFile? pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _resumeFile = File(pickedFile.path);
          });
        }
      } else if (choice == 'file') {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        );

        if (result != null && result.files.single.path != null) {
          setState(() {
            _resumeFile = File(result.files.single.path!);
          });
        }
      }
    } catch (e) {
      _showSnackBar('Gagal memilih file: $e', isError: true);
    }
  }

  Future<String?> _uploadFile(File file, String bucketName, String path) async {
    try {
      // Pastikan nama file unik untuk menghindari konflik
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}-${file.path.split('/').last}';
      final String fullPath = '$path/$fileName';
      await supabase.storage.from(bucketName).upload(
            fullPath,
            file,
            fileOptions: const FileOptions(
                upsert: false), // Jangan overwrite jika sudah ada
          );
      return supabase.storage
          .from(bucketName)
          .getPublicUrl(fullPath); // Dapatkan URL publik
    } catch (e) {
      // Periksa apakah error karena file sudah ada (jika upsert false)
      if (e is StorageException && e.message.contains('Duplicate')) {
        _showSnackBar('File sudah ada di penyimpanan.', isError: true);
        // Mungkin ingin ambil URL yang sudah ada, atau minta pengguna ganti nama
        // Untuk contoh ini, kita anggap itu error yang perlu ditangani.
      } else {
        _showSnackBar('Gagal mengunggah file ke $bucketName: $e',
            isError: true);
      }
      return null;
    }
  }

  Future<void> _submitProof() async {
    if (_photoFile == null) {
      _showSnackBar('Silakan unggah bukti foto kehadiran.', isError: true);
      return;
    }
    // Resume sekarang opsional, tidak perlu validasi wajib

    setState(() {
      _isLoading = true;
    });

    try {
      String? photoUrl;
      String? resumeUrl;

      // Unggah foto
      photoUrl = await _uploadFile(_photoFile!, 'event-attachments',
          'photos'); // Ganti 'event-attachments' dengan nama bucket Storage kamu
      if (photoUrl == null) {
        throw Exception('Gagal mengunggah foto.');
      }

      // Unggah resume jika ada file yang dipilih
      if (_resumeFile != null) {
        resumeUrl = await _uploadFile(_resumeFile!, 'event-attachments',
            'resumes'); // Ganti 'event-attachments' dengan nama bucket Storage kamu
        if (resumeUrl == null) {
          throw Exception('Gagal mengunggah resume.');
        }
      }

      final Map<String, dynamic> dataToSubmit = {
        'event_id': event.id,
        'user_id': userId,
        'attended_at': DateTime.now().toIso8601String(), // Waktu kehadiran
        'photo_attachment_url': photoUrl,
        'resume_attachment_url': resumeUrl,
        // created_at akan default now() di database (jika insert)
        // updated_at akan diisi jika ini update
      };

      if (eventAttendanceId != null) {
        // Update data attendance yang sudah ada
        await supabase
            .from('event_attendances')
            .update(dataToSubmit)
            .eq('id', eventAttendanceId!);
        _showSnackBar('Bukti kehadiran berhasil diperbarui!');
      } else {
        // Insert data attendance baru
        await supabase.from('event_attendances').insert(dataToSubmit);
        _showSnackBar('Bukti kehadiran berhasil diunggah!');
      }

      // Kembali ke layar sebelumnya atau navigasi ke layar sukses
      Get.back(result: true); // Mengirimkan 'true' sebagai hasil sukses
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(Get.context!)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          backgroundColor:
              isError ? Colors.red.shade700 : Colors.green.shade700,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading, // Mencegah pop saat isLoading
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Unggah Bukti Kehadiran',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Utils.kSecondaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Utils.kSecondaryColor,
                    Utils.kPrimaryMaterialColor,
                    Utils.kSecondaryColor,
                  ],
                  stops: [0.1, 0.5, 0.9],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Detail Acara'),
                  _buildInfoCard(
                    context,
                    icon: Icons.event,
                    title: event.name,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.calendar_month, 'Tanggal',
                            _formatDate(event.startTime)),
                        _buildDetailRow(
                            Icons.location_on, 'Lokasi', event.locationName),
                        _buildDetailRow(Icons.category, 'Tipe', event.typeName),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle(context, 'Unggah Bukti Foto'),
                  _buildUploadCard(
                    context,
                    title: 'Foto Kehadiran',
                    subtitle:
                        'Ambil foto selfie atau foto kehadiran Anda di lokasi acara. Jika mencatat di HP, screenshot catatan Anda.',
                    file: _photoFile,
                    onPick: _pickPhoto,
                    icon: Icons.camera_alt,
                    buttonText:
                        _photoFile == null ? 'Pilih Foto' : 'Ganti Foto',
                    fileTypeHint: 'Format: JPG, PNG',
                  ),
                  const SizedBox(height: 30),
                  if (_showResumeSection) ...[
                    _buildSectionTitle(
                        context, 'Unggah Resume/Catatan (Opsional)',
                        subtitle:
                            'Anda dapat mengunggah foto catatan, gambar, atau file PDF sebagai dokumentasi tambahan.'),
                    _buildUploadCard(
                      context,
                      title: 'Resume/Catatan (Opsional)',
                      subtitle:
                          'Unggah foto catatan, gambar, atau file PDF sebagai dokumentasi tambahan (opsional).',
                      file: _resumeFile,
                      onPick: _pickResume,
                      icon: Icons.description,
                      buttonText: _resumeFile == null
                          ? 'Pilih File/Foto'
                          : 'Ganti File/Foto',
                      fileTypeHint: 'Format: JPG, PNG, PDF, DOCX, TXT',
                    ),
                    const SizedBox(height: 30),
                  ],
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.lightGreenAccent)
                        : ElevatedButton.icon(
                            onPressed: _submitProof,
                            icon: const Icon(Icons.cloud_upload),
                            label: const Text('Kirim Bukti Kehadiran'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreenAccent,
                              foregroundColor: Colors.deepPurple.shade900,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor:
                                  Colors.lightGreenAccent.withOpacity(0.5),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(BuildContext context, String title,
      {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2.0,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required Widget content,
      required IconData icon}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.lightBlueAccent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
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

  Widget _buildUploadCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required File? file,
    required Function onPick,
    required IconData icon,
    required String buttonText,
    String? fileTypeHint,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.lightGreenAccent, size: 28),
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
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70),
          ),
          if (fileTypeHint != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Tipe file yang diizinkan: $fileTypeHint',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white54, fontStyle: FontStyle.italic),
              ),
            ),
          const SizedBox(height: 20),
          Center(
            child: file == null
                ? ElevatedButton.icon(
                    onPressed: () => onPick(),
                    icon: Icon(icon),
                    label: Text(buttonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                  )
                : Column(
                    children: [
                      // Menampilkan thumbnail untuk gambar (baik foto kehadiran maupun resume)
                      if (RegExp(r'\.(jpeg|jpg|png|gif)$', caseSensitive: false)
                          .hasMatch(file.path.toLowerCase()))
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            file,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (RegExp(r'\.pdf$', caseSensitive: false)
                          .hasMatch(file.path.toLowerCase()))
                        const Icon(Icons.picture_as_pdf,
                            size: 100, color: Colors.red)
                      else // Menampilkan ikon generik untuk file lain
                        const Icon(Icons.insert_drive_file,
                            size: 100, color: Colors.white70),
                      const SizedBox(height: 10),
                      Text(
                        file.path
                            .split('/')
                            .last, // Hanya menampilkan nama file
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () => onPick(),
                        icon: const Icon(Icons.change_circle_outlined,
                            color: Colors.amberAccent),
                        label: const Text('Ganti File',
                            style: TextStyle(color: Colors.amberAccent)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // --- Helper Date/Time Formatter ---
  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
  }

  // String _formatTime(DateTime dateTime) {
  //   return DateFormat('HH:mm').format(dateTime);
  // }
}
