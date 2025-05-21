# UKL Frontend - Aplikasi Manajemen Mata Kuliah

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![REST API](https://img.shields.io/badge/REST%20API-005571?style=for-the-badge&logo=rest&logoColor=white)

## Deskripsi Proyek

UKL Frontend adalah aplikasi mobile yang dibuat dengan Flutter untuk memudahkan seseorang dalam mengelola profil dan memilih mata kuliah. Aplikasi ini dibangun sebagai hasil dari Ujian Kenaikan Level (UKL) oleh Cipto Yafig Adiwongso dari kelas XI RPL 3 SMK Telkom Malang, dengan fokus pada pengembangan frontend yang terintegrasi dengan API.

## Fitur Utama

- **Autentikasi**: Sistem login dan registrasi yang aman
- **Manajemen Profil**: Melihat dan mengubah data profil pengguna
- **Pemilihan Mata Kuliah**: Memilih mata kuliah yang ingin diambil pada semester berjalan
- **Kalkulasi SKS**: Menghitung total SKS dari mata kuliah yang dipilih

## Teknologi yang Digunakan

- **Flutter**: Framework UI untuk pengembangan aplikasi cross-platform
- **Dart**: Bahasa pemrograman untuk aplikasi Flutter
- **HTTP**: Komunikasi dengan API backend
- **REST API**: Integrasi dengan backend Laravel(Sudah Di Sediakan, jadi disini saya tidak membuatnya)
- **SharedPreferences**: Penyimpanan data lokal untuk manajemen session
- **Google Fonts**: Styling text dengan font Poppins

## Struktur Proyek

```
ukl_frontend_1/
├── lib/
│   ├── models/         # Model data aplikasi
│   │   ├── matkul.dart
│   │   └── user.dart
│   ├── pages/          # Halaman-halaman UI
│   │   ├── login.dart
│   │   ├── register.dart
│   │   ├── profile.dart
│   │   └── matkul.dart
│   ├── services/       # Layanan API dan lainnya
│   │   └── services.dart
│   └── main.dart       # Entry point aplikasi
├── assets/             # Gambar dan resource lainnya
│   └── login.png
└── pubspec.yaml        # Konfigurasi dependencies
```

## Screenshots

### Halaman Login

[Login Page Screenshot]

### Halaman Register

[Register Page Screenshot]

### Halaman Profil

[Profile Page Screenshot]

### Halaman Pemilihan Mata Kuliah

[Course Selection Page Screenshot]

### Dialog Konfirmasi

[Confirmation Dialog Screenshot]

## Cara Menjalankan Proyek

1. **Clone repository**:

   ```bash
   git clone https://github.com/username/ukl_frontend_1.git
   cd ukl_frontend_1
   ```

2. **Persiapan**:

   ```bash
   flutter pub get
   ```

3. **Menjalankan di mode debug**:

   ```bash
   flutter run
   ```

4. **Build aplikasi release**:
   ```bash
   flutter build apk --release
   ```

## Fitur Desain UI/UX

- **Color Palette**: Menggunakan warna utama biru (#032670)
- **Tema Konsisten**: Styling yang konsisten di seluruh aplikasi dengan border radius dan shadow
- **Feedback Visual**: Loading indicator dan dialog konfirmasi yang informatif
- **Validasi Form**: Validasi input untuk memastikan data yang dimasukkan valid
- **Responsive Design**: Layout yang adaptif untuk berbagai ukuran layar
- **Modern Typography**: Penggunaan Google Fonts Poppins untuk keterbacaan yang baik

## Implementasi Teknis

- **State Management**: Penggunaan StatefulWidget dengan manajemen state yang efisien
- **API Integration**: Komunikasi dengan backend menggunakan HTTP client yang dioptimalkan
- **Error Handling**: Penanganan error yang komprehensif dengan feedback visual
- **Form Validation**: Validasi input yang lengkap pada setiap form
- **Session Management**: Penyimpanan dan pengelolaan session pengguna

## Catatan Pengembangan

Aplikasi ini dikembangkan sebagai bagian dari tugas UKL dengan fokus pada:

1. Struktur data dan tata letak UI yang jelas dan intuitif
2. Styling yang modern dan konsisten di seluruh aplikasi
3. Validasi dan interaksi form yang responsif
4. Koneksi ke API yang efektif dan error handling
5. Pengolahan data response untuk pengalaman pengguna yang baik
6. Kerapian kode dan struktur folder yang terorganisir

---

© 2024 Yafig - SMK Telkom Malang
