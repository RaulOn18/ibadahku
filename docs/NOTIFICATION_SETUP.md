# Setup Notifikasi Mutabaah Yaumiyah

## Fitur yang Ditambahkan

Aplikasi Ibadahku sekarang memiliki fitur notifikasi harian untuk mengingatkan pengguna mengisi Mutabaah Yaumiyah setiap hari jam 19:30 (7:30 malam).

## File yang Dibuat/Dimodifikasi

### 1. File Baru:
- `lib/services/notification_service.dart` - Service untuk mengelola notifikasi
- `lib/controllers/mutabaah_controller.dart` - Controller untuk pengaturan notifikasi
- `lib/widgets/mutabaah_notification_setting.dart` - Widget pengaturan notifikasi (opsional)

### 2. File yang Dimodifikasi:
- `pubspec.yaml` - Menambahkan dependency `timezone: ^0.10.1`
- `lib/main.dart` - Inisialisasi NotificationService dan handler notifikasi
- `lib/controllers/home_controller.dart` - Inisialisasi MutabaahController
- `lib/screens/profile_screen.dart` - Menambahkan toggle pengaturan notifikasi

## Cara Kerja

1. **Inisialisasi**: NotificationService diinisialisasi saat aplikasi dimulai
2. **Penjadwalan**: Notifikasi dijadwalkan untuk jam 19:30 setiap hari
3. **Pengaturan**: User dapat mengaktifkan/menonaktifkan notifikasi di halaman Profile
4. **Navigasi**: Ketika notifikasi diklik, aplikasi akan membuka halaman Yaumiyah

## Fitur Utama

### NotificationService
- Mengelola penjadwalan notifikasi harian
- Mengatur timezone untuk Indonesia (Asia/Jakarta)
- Handle tap notifikasi untuk navigasi ke halaman Yaumiyah
- Fungsi test notifikasi

### MutabaahController
- Toggle on/off notifikasi
- Menyimpan pengaturan di local storage
- Test notifikasi
- Feedback snackbar untuk user

### Pengaturan di Profile
- Switch untuk mengaktifkan/menonaktifkan notifikasi
- Tombol test notifikasi
- Informasi waktu notifikasi (19:30)

## Cara Menggunakan

1. Buka halaman Profile
2. Cari bagian "Pengingat Mutabaah"
3. Aktifkan switch untuk mengaktifkan notifikasi harian
4. Gunakan tombol "Test Notifikasi" untuk mencoba notifikasi
5. Notifikasi akan muncul setiap hari jam 19:30
6. Klik notifikasi untuk langsung masuk ke halaman Yaumiyah

## Permissions

Aplikasi akan otomatis meminta permission untuk notifikasi saat pertama kali dijalankan.

### Android Permissions:
- `POST_NOTIFICATIONS` - Untuk menampilkan notifikasi (Android 13+)
- `SCHEDULE_EXACT_ALARM` - Untuk notifikasi tepat waktu (Android 12+)
- `USE_EXACT_ALARM` - Untuk exact alarm (Android 14+)

### Troubleshooting Permission:
Jika muncul error "exact_alarms_not_permitted":
1. Buka Settings > Apps > Ibadahku > Special app access
2. Cari "Alarms & reminders" atau "Schedule exact alarm"
3. Aktifkan permission tersebut
4. Restart aplikasi

## Catatan Teknis

- Menggunakan `flutter_local_notifications` untuk notifikasi lokal
- Menggunakan `timezone` untuk penjadwalan yang akurat
- Notifikasi akan tetap berjalan meskipun aplikasi ditutup
- Pengaturan disimpan menggunakan `GetStorage`
- Kompatibel dengan Android (iOS memerlukan konfigurasi tambahan)
- **Firebase telah dihapus**: Aplikasi tidak lagi menggunakan Firebase untuk notifikasi