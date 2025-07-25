import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/constants/routes.dart';
import 'package:ibadahku/screens/event/models/event_detail_model.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Kelas argumen untuk Tampilan Pemindaian QR
class ScanQrArgs {
  final String title;
  final String description;
  final String qrValue;

  ScanQrArgs({
    required this.title,
    required this.description,
    required this.qrValue,
  });
}

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>
    with SingleTickerProviderStateMixin {
  Barcode? _barcode; // Menyimpan barcode yang terdeteksi
  late AnimationController
      _animationController; // Mengontrol animasi garis pemindaian
  late Animation<double> _animation; // Animasi itu sendiri
  // Variabel _isScanningDown tidak lagi diperlukan untuk perhitungan posisi,
  // karena _animation.value secara otomatis mencerminkan arah.
  // Namun, kita bisa tetap menyimpannya jika ada logika lain yang membutuhkannya.

  final SupabaseClient client = Supabase.instance.client;
  MobileScannerController? _scannerController;
  bool _isProcessing = false; // Flag untuk mencegah multiple scan

  @override
  void initState() {
    super.initState();
    // Inisialisasi scanner controller
    _scannerController = MobileScannerController();

    // Inisialisasi AnimationController dengan durasi untuk satu lintasan pemindaian.
    // Durasi ini dapat disesuaikan untuk kecepatan yang berbeda.
    _animationController = AnimationController(
      vsync:
          this, // 'this' adalah TickerProvider, penting untuk efisiensi animasi.
      duration: const Duration(seconds: 1), // Sesuaikan durasi sesuai kebutuhan
    );

    // Buat animasi Tween yang bergerak dari 0.0 (atas) ke 1.0 (bawah).
    // Ini adalah nilai normalisasi yang akan kita petakan ke posisi piksel.
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Tambahkan listener ke pengontrol animasi untuk membalikkan atau mengulang animasi.
    // Ini menciptakan efek pemindaian bolak-balik yang mulus.
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        // Ketika animasi selesai (mencapai bawah), balikkan untuk bergerak ke atas.
        _animationController.reverse();
      } else if (_animationController.status == AnimationStatus.dismissed) {
        // Ketika animasi dihentikan (mencapai atas), ulangi untuk bergerak ke bawah.
        _animationController.forward();
      }
    });

    // Mulai animasi setelah bingkai pertama dirender.
    // Ini adalah praktik terbaik untuk memastikan semua variabel yang diinisialisasi 'late'
    // sudah siap dan mencegah kesalahan inisialisasi.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    // Buang pengontrol animasi untuk mencegah kebocoran memori.
    // Ini sangat penting untuk aplikasi yang berkinerja baik.
    _animationController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  // Widget pembantu untuk menampilkan informasi barcode
  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const Text(
        'Pindai QR Event',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'Tidak ada nilai tampilan.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<EventDetailModel?> checkIsValidQr(String qrValue) async {
    try {
      final response = await client.rpc(
        "get_event_detail_with_user_attendance",
        params: {
          "p_user_id": client.auth.currentUser!.id,
          "p_event_id": qrValue,
        },
      );

      log("response: $response");

      if (response.isNotEmpty) {
        return EventDetailModel.fromJson(response);
      }
      return null;
    } catch (e, stackTrace) {
      log("Error: when check qr $e $stackTrace");
      return null;
    }
  }

  // Callback untuk ketika barcode terdeteksi oleh MobileScanner
  void _handleBarcode(BarcodeCapture barcodes) async {
    // Cegah multiple processing
    if (_isProcessing || !mounted) return;

    final barcode = barcodes.barcodes.firstOrNull;
    if (barcode?.displayValue == null) return;

    setState(() {
      _isProcessing = true;
      _barcode = barcode;
    });

    try {
      // Stop scanner sementara untuk mencegah scan berulang
      await _scannerController?.stop();

      final isValid = await checkIsValidQr(barcode!.displayValue!);

      if (isValid != null) {
        if (isValid.isAttended) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text("Anda sudah absen, Terima kasih telah hadir."),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ),
            );
          Get.back();
          Get.toNamed(Routes.eventDetail, arguments: isValid);
          return;
        }
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content:
                  Text("Anda berhasil absen, Silahkan upload bukti kehadiran."),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
        Get.back();
        Get.toNamed(Routes.uploadBuktiKehadiran, arguments: isValid);
        return;
      } else {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text("QR Code Tidak Valid"),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );

        // Restart scanner setelah delay jika QR tidak valid
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          await _scannerController?.start();
          setState(() {
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      log("Error processing barcode: $e");
      // Restart scanner jika ada error
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        await _scannerController?.start();
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil argumen yang diteruskan ke rute
    // ScanQrArgs args = Get.arguments;

    // Hitung tinggi area pemindaian.
    // Kita mengurangi tinggi AppBar dan tinggi container bawah
    // untuk memastikan garis pemindaian bergerak di dalam area pemindaian QR yang terlihat.
    final double appBarHeight = AppBar().preferredSize.height;
    const double bottomContainerHeight =
        100.0; // Tinggi container pratinjau barcode
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scanAreaHeight = screenHeight -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        bottomContainerHeight;

    return Scaffold(
      appBar: AppBar(
        title: null,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcode,
          ),
          Positioned(
            top: appBarHeight,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.asset(
                "assets/images/logo-stai.png",
                opacity: const AlwaysStoppedAnimation(0.8),
              ),
            ),
          ),
          // AnimatedBuilder membangun kembali anaknya setiap kali nilai animasi berubah.
          // Ini lebih efisien daripada setState untuk animasi berkelanjutan
          // karena hanya membangun kembali bagian pohon widget yang terpengaruh.
          _isProcessing
              ? const SizedBox()
              : AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    // Hitung posisi atas berdasarkan nilai animasi dan tinggi area pemindaian.
                    // Ketika _animation.value bergerak dari 0.0 ke 1.0 (forward),
                    // topPosition bergerak dari 0 ke scanAreaHeight (turun).
                    // Ketika _animation.value bergerak dari 1.0 ke 0.0 (reverse),
                    // topPosition bergerak dari scanAreaHeight ke 0 (naik).
                    double topPosition = _animation.value * scanAreaHeight;

                    return Positioned(
                      top: topPosition,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 6,
                        children: [
                          Container(
                            height: 2.0, // Tinggi garis pemindaian merah
                            decoration: BoxDecoration(
                              color: Utils.kSecondaryColor.withOpacity(.4),
                              boxShadow: [
                                BoxShadow(
                                  color: Utils.kSecondaryColor
                                      .withValues(alpha: 0.5),
                                  blurRadius: 8.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 2.0, // Tinggi garis pemindaian merah
                            decoration: BoxDecoration(
                              color: Utils.kSecondaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Utils.kSecondaryColor
                                      .withValues(alpha: 0.5),
                                  blurRadius: 8.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 2.0, // Tinggi garis pemindaian merah
                            decoration: BoxDecoration(
                              color: Utils.kSecondaryColor.withOpacity(0.4),
                              boxShadow: [
                                BoxShadow(
                                  color: Utils.kSecondaryColor
                                      .withValues(alpha: 0.5),
                                  blurRadius: 8.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

          // Container bawah untuk menampilkan informasi barcode
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: bottomContainerHeight,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _barcodePreview(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
