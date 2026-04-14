# IoT Device Dashboard Monorepo (ETS)

Project ETS sekarang dijadikan **satu folder** dengan pemisahan:

- `frontend/` -> Flutter app (UI + state management + cache)
- `backend/` -> Express.js API buatan sendiri

## Struktur

```bash
iot_device_dashboard/
├── frontend/
│   ├── lib/
│   ├── pubspec.yaml
│   └── ...
└── backend/
    ├── src/index.js
    └── package.json
```

---

## 1) Jalankan Backend (Express API)

```bash
cd backend
npm install
npm run dev
```

Default API berjalan di:
- `http://localhost:3000`
- endpoint data: `http://localhost:3000/api/devices`

Endpoint tersedia:
- `GET /api/devices`
- `GET /api/devices/:id`
- `POST /api/devices`
- `PUT /api/devices/:id`
- `DELETE /api/devices/:id`

---

## 2) Jalankan Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

File API config frontend:
- `frontend/lib/services/device_api_service.dart`

Default sekarang:
- `http://10.0.2.2:3000/api/devices` (untuk Android Emulator)

Kalau pakai device fisik, ganti ke IP LAN server, contoh:
- `http://192.168.1.20:3000/api/devices`

---

## Contoh JSON Device

```json
{
  "id": "1",
  "device_name": "ESP32 Ruang Tamu",
  "status": "online",
  "last_seen": "2026-04-14T08:00:00Z",
  "battery": 88,
  "signal": 76
}
```
