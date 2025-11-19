# Fix Upload File di Web

## Masalah
Error `Unsupported operation: _Namespace` terjadi saat upload file di web karena:
1. `dart:io` File tidak support di web
2. Extension `.webp` tidak ada di allowed extensions
3. Method `file.lengthSync()` tidak tersedia di web

## Solusi yang Diterapkan

### 1. Import Tambahan
```dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
```

### 2. Deteksi Platform
Menggunakan `kIsWeb` untuk membedakan antara web dan mobile:
```dart
if (kIsWeb) {
  // Logic untuk web
} else {
  // Logic untuk mobile
}
```

### 3. Upload Method yang Berbeda
- **Web**: Menggunakan `uploadBinary()` dengan bytes
- **Mobile**: Menggunakan `upload()` dengan File object

### 4. Tambahan Extension
Menambahkan `.webp` ke allowed extensions untuk support format web

### 5. File Picker yang Adaptif
- **Web**: Langsung ke file picker (tidak ada camera)
- **Mobile**: Dialog untuk memilih camera/gallery/file

## Perubahan File

### `lib/screens/event/views/upload_bukti_kehadiran.dart`

#### Imports
```dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
```

#### Helper Method
```dart
File _createFileFromXFile(XFile xFile) {
  if (kIsWeb) {
    return File(xFile.path);
  } else {
    return File(xFile.path);
  }
}
```

#### Upload Method
```dart
Future<String?> _uploadFile(File file, String bucketName, String path) async {
  // ...
  if (kIsWeb) {
    final bytes = await file.readAsBytes();
    await supabase.storage.from(bucketName).uploadBinary(
      fullPath,
      bytes,
      fileOptions: const FileOptions(upsert: false),
    );
  } else {
    await supabase.storage.from(bucketName).upload(
      fullPath,
      file,
      fileOptions: const FileOptions(upsert: false),
    );
  }
  // ...
}
```

#### Pick Methods
- `_pickPhoto()`: Langsung gallery di web, dialog di mobile
- `_pickResume()`: File picker di web, dialog di mobile

## Testing

### Web
1. Buka aplikasi di browser
2. Pilih foto/file untuk upload
3. Submit form
4. Verifikasi file berhasil diupload ke Supabase

### Mobile
1. Install APK di device
2. Test camera, gallery, dan file picker
3. Submit form
4. Verifikasi file berhasil diupload

## Allowed Extensions
- Images: `jpg`, `jpeg`, `png`, `webp`
- Documents: `pdf`, `doc`, `docx`, `txt`

## Ukuran Maksimal
- 10 MB untuk semua file

## Catatan
- Web tidak support camera access via ImagePicker
- Web menggunakan bytes untuk upload, bukan File object
- Extension `.webp` adalah format default untuk web images