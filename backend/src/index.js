const express = require('express');
const cors = require('cors');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

let devices = [
  {
    id: '1',
    device_name: 'ESP32 Ruang Tamu',
    status: 'online',
    last_seen: new Date().toISOString(),
    battery: 88,
    signal: 76,
  },
  {
    id: '2',
    device_name: 'ESP32 Kamar',
    status: 'offline',
    last_seen: new Date(Date.now() - 1000 * 60 * 12).toISOString(),
    battery: 42,
    signal: 0,
  },
  {
    id: '3',
    device_name: 'NodeMCU Garasi',
    status: 'online',
    last_seen: new Date(Date.now() - 1000 * 35).toISOString(),
    battery: 64,
    signal: 68,
  },
];

app.get('/', (_req, res) => {
  res.json({
    message: 'IoT Device Dashboard API is running',
    endpoints: {
      list: 'GET /api/devices',
      getById: 'GET /api/devices/:id',
      create: 'POST /api/devices',
      update: 'PUT /api/devices/:id',
      delete: 'DELETE /api/devices/:id',
    },
  });
});

app.get('/api/devices', (_req, res) => {
  res.json(devices);
});

app.get('/api/devices/:id', (req, res) => {
  const device = devices.find((d) => d.id === req.params.id);
  if (!device) {
    return res.status(404).json({ message: 'Device not found' });
  }
  res.json(device);
});

app.post('/api/devices', (req, res) => {
  const { device_name, status = 'offline', last_seen, battery = 0, signal = 0 } = req.body;

  if (!device_name) {
    return res.status(400).json({ message: 'device_name is required' });
  }

  const newDevice = {
    id: String(Date.now()),
    device_name,
    status,
    last_seen: last_seen || new Date().toISOString(),
    battery: Number(battery),
    signal: Number(signal),
  };

  devices.push(newDevice);
  return res.status(201).json(newDevice);
});

app.put('/api/devices/:id', (req, res) => {
  const idx = devices.findIndex((d) => d.id === req.params.id);
  if (idx === -1) {
    return res.status(404).json({ message: 'Device not found' });
  }

  const prev = devices[idx];
  const updated = {
    ...prev,
    ...req.body,
    battery: req.body.battery !== undefined ? Number(req.body.battery) : prev.battery,
    signal: req.body.signal !== undefined ? Number(req.body.signal) : prev.signal,
  };

  devices[idx] = updated;
  return res.json(updated);
});

app.delete('/api/devices/:id', (req, res) => {
  const before = devices.length;
  devices = devices.filter((d) => d.id !== req.params.id);

  if (devices.length === before) {
    return res.status(404).json({ message: 'Device not found' });
  }

  return res.json({ message: 'Device deleted' });
});

app.listen(PORT, () => {
  console.log(`API running on http://localhost:${PORT}`);
});
