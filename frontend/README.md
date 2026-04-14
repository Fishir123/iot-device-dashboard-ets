# IoT Device Status Dashboard (ETS)

Project Flutter untuk ETS Workshop Pemrograman Perangkat Bergerak.

## Tema
Opsi E — IoT Device Status Dashboard

## Fitur
- Menampilkan daftar device
- Status online/offline
- Last seen
- Battery & signal level
- Fetch data dari API
- Cache lokal (Hive) saat koneksi gagal

## Stack
- Flutter
- Provider (state management)
- HTTP (API)
- Hive (local cache)

## Struktur
- `lib/models` -> model data
- `lib/services` -> API + cache service
- `lib/providers` -> state management
- `lib/screens` -> UI halaman
- `lib/widgets` -> komponen UI reusable

## Setup
1. Install Flutter SDK
2. Jalankan:
   ```bash
   flutter pub get
   flutter run
   ```
3. Ganti `baseUrl` di `lib/services/device_api_service.dart` dengan endpoint MockAPI kamu.

## Contoh JSON API
```json
[
  {
    "id": "1",
    "device_name": "Sensor Ruang 1",
    "status": "online",
    "last_seen": "2026-04-14T07:30:00Z",
    "battery": 86,
    "signal": 74
  }
]
```
