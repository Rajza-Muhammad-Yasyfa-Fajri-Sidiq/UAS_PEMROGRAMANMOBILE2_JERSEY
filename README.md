# JerseyHub — Flutter (REST API + Firebase + PWA + APK)

Aplikasi **katalog & pembelian jersey** dengan tampilan modern dan interaktif. Dibuat untuk memenuhi ketentuan tugas besar: **Flutter + REST API (MockAPI) + Firebase + Deploy PWA (Netlify) + Build APK**.

## Demo

- **PWA (Netlify):** https://luminous-dragon-311c95.netlify.app/

- **APK (Release):** https://drive.google.com/drive/folders/1L6sduvp1KXoq9vCaju6rlGfDl-KJAwO4?usp=drive_link

---

## Ringkasan Aplikasi

**JerseyHub** menampilkan daftar jersey dari **REST API (MockAPI)**, lalu menyimpan data user seperti **Favorites, Cart, Orders** menggunakan **Firebase Firestore**. Autentikasi user menggunakan **Firebase Authentication** (Email/Password).

---

## Fitur Utama

- ✅ **Auth**: Login & Register (Firebase Auth)
- ✅ **Catalog**: List jersey (REST API dari MockAPI)
- ✅ **Category/Filter**: Filter jersey per tim/klub (REST API)
- ✅ **Detail**: Detail jersey + **Hero animation** (bonus animasi)
- ✅ **Favorites**: Simpan favorit user (Firestore)
- ✅ **Cart**: Keranjang + qty (Firestore)
- ✅ **Checkout**: Simulasi pembayaran + create order (Firestore)
- ✅ **Order History**: Riwayat pesanan (Firestore)
- ✅ **Halaman Statis**: Tentang + Informasi

---

## Halaman (Sesuai Ketentuan)

### Dinamis (9 halaman)

1. Login
2. Register
3. Home/Catalog (REST API)
4. Category/Team (REST API)
5. Detail Jersey (REST API)
6. Favorites (Firestore)
7. Cart (Firestore)
8. Checkout (Firestore)
9. Orders/History (Firestore)

### Statis (tidak dihitung)

- Tentang
- Informasi

---

## Tech Stack

- **Flutter** (Material 3)
- **REST API**: MockAPI (list & detail jersey)
- **Firebase**:
  - Authentication (Email/Password)
  - Cloud Firestore (favorites, cart, orders, profile)
- **Deploy Web (PWA)**: Netlify
- **Build Android**: APK release

---

## Requirements

- Flutter SDK (stable)
- Android Studio / VS Code
- Akun Firebase (Firebase Console)
- Akun MockAPI (untuk endpoint REST)
- Akun Netlify (deploy PWA)

---

## Cara Menjalankan (Local)

```bash
git clone <repo_url>
cd jerseyhub
flutter pub get
flutter run
```

Konfigurasi REST API (MockAPI)

Edit base URL di: lib/services/api_service.dart

```bash
static const baseUrl = 'https://YOUR-MOCKAPI-BASE/mock/v1';
```

Contoh endpoint
-GET /jerseys → list jersey
-GET /jerseys/:id → detail jersey
-(opsional) GET /jerseys?team=Barcelona → filter

Contoh field data jersey (MockAPI)

id
name
team
league
season
price
rating
imageUrl
description
Setup Firebase (Auth + Firestore)

1. Buat Firebase Project

Buka Firebase Console → Create project
Tambahkan aplikasi Android (dan iOS jika perlu) 2. Aktifkan Authentication
Authentication → Sign-in method → Email/Password → Enable 3. Aktifkan Firestore
Firestore Database → Create database 4. Konfigurasi FlutterFire (disarankan)
Gunakan FlutterFire CLI agar file config otomatis:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Pastikan file berikut tersedia agar build & auth jalan:
lib/firebase_options.dart
android/app/google-services.json
(iOS jika diperlukan) ios/Runner/GoogleService-Info.plist

Catatan keamanan: file google-services.json bukan “secret key”, tapi tetap disarankan jangan menaruh kredensial sensitif lain di repo.

Struktur Firestore (yang dipakai aplikasi)
users/{uid}
name, email, createdAt
users/{uid}/favorites/{jerseyId}
id, name, team, price, imageUrl, createdAt
users/{uid}/cart/{jerseyId}
id, name, team, price, imageUrl, qty, size, createdAt
orders/{orderId}
uid, items[], total, status, createdAt

Build APK (Android)

```bash
flutter build apk --release
```

Output:
build/app/outputs/flutter-apk/app-release.apk

Build Web (PWA) + Deploy Netlify

1. Tambahkan redirect untuk routing (wajib untuk go_router)
   Buat file:
   web/\_redirects

```bash
/\* /index.html 200
```

2. Build web

```bash
   flutter build web --release
```

Hasil build ada di:
build/web 3. Deploy ke Netlify
Netlify → Add new site → Deploy manually / connect repo
Publish directory: build/web

Struktur Folder (ringkas)
lib/
app/
router.dart
theme.dart
models/
jersey.dart
services/
api_service.dart
firestore_service.dart
state/
auth_controller.dart
ui/
scaffold_with_nav.dart
screens/
login_screen.dart
register_screen.dart
home_screen.dart
category_screen.dart
jersey_detail_screen.dart
favorites_screen.dart
cart_screen.dart
checkout_screen.dart
orders_screen.dart
about_screen.dart
info_screen.dart

Troubleshooting
Blank screen di web saat refresh route → pastikan web/\_redirects sudah ada.
Firebase error saat run → pastikan firebase_options.dart & google-services.json benar, lalu flutter clean + flutter pub get.
Filter team tidak jalan → cek query parameter MockAPI atau lakukan filter di client.

Author
Nama: Rajza Muhammad Yasyfa Fajri Sidiq
Kelas: TIF RP-23 CNS A
NPM : 23552011039
Mata kuliah: Pemrograman Mobile II

```

```
