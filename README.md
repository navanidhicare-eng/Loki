# ⚡ LOKI HYPERLOCAL SUPER APP PLATFORM
### (Swiggy + Urban Company + Uber + Dunzo in One Unified Platform)

---

## 🏛️ Project Architecture Overview (ఆర్కిటెక్చర్ వివరాలు)

The Loki Hyperlocal platform is built on a high-security, high-concurrency micro-modular architecture:

```
loki/
├── server/               # 🛡️ High-Security Node.js REST API + WebSocket Telemetry Engine (Port 5000)
├── admin-dashboard/      # 📊 Executive Glassmorphism Super Admin Web Dashboard (Port 3000)
├── customer_app/         # 📱 Customer Mobile App (Flutter: Android & iOS)
└── partner_app/          # 👷 Partner / Specialist Mobile App (Flutter: Android & iOS)
```

---

## 🔑 Default Demo Credentials (లాగిన్ వివరాలు)

| Role | Email | Password | Access / Features |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `admin@loki.com` | `admin123` | Complete platform control, Partner KYC approval, Pricing, Telemetry Radar |
| **Customer** | `customer@loki.com` | `customer123` | Book Plumber, Electrician, Delivery, Mechanic, Kirana Shops + ₹750 Wallet |
| **Partner (Plumber)** | `ramesh@loki.com` | `provider123` | Master Plumber, Duty ON/OFF switch, OTP start-work, Net earnings |
| **Partner (Electrician)** | `suresh@loki.com` | `provider123` | Certified Wireman |
| **Partner (Delivery)** | `rajesh@loki.com` | `provider123` | Hyperlocal Rider (Bike TS 09 EA 4521) |

---

## 🚀 How to Run the Ecosystem (ఎలా రన్ చేయాలి)

### 1. Backend Server (Node.js + Sockets)
```bash
cd server
npm start
# Runs on http://localhost:5000
```
- **Health Check**: `http://localhost:5000/api/health`
- **Security**: Equipped with Helmet HTTP security headers, Express Rate Limiter, JWT Auth, and Role-Based Guard.

### 2. Super Admin Web Dashboard
```bash
cd admin-dashboard
npm run dev
# Open in browser: http://localhost:3000
```
- **Features**:
  - Live Radar Telemetry with simulated partner locations
  - 1-Click KYC Approve / Reject queue
  - Dynamic Hyperlocal Services & Pricing manager
  - Live Order Dispatch Simulator button

### 3. Customer Mobile App (Flutter)
```bash
cd customer_app
flutter run
```
- **Supported Verticals**:
  1. 🔧 **Plumbing**: Tap repair, water tank clean, pipeline fittings
  2. ⚡ **Electricians**: Short circuits, fan/light fixing, switchboard
  3. 📦 **Instant Delivery**: 30-minute parcel pickup & drop
  4. 🚗 **Mechanics**: On-spot bike breakdown, puncture, car jumpstart
  5. 🛒 **Local Shops & Kirana**: Daily essentials, fresh produce
  6. 🧹 **Cleaning & Pest Control**: Deep home cleaning, sanitization
  7. 📺 **Appliance Repairs**: AC foam jet service, fridge, washing machine
- **Safety Features**:
  - 4-Digit Secure Start-Work OTP verification
  - Verified specialist profiles with Aadhaar badges
  - Live order timeline & calling option

### 4. Partner / Provider Mobile App (Flutter)
```bash
cd partner_app
flutter run
```
- **Features**:
  - Big "On Duty / Off Duty" toggle
  - Instant job alerts with net earnings preview
  - Turn-by-turn customer navigation shortcut
  - Customer OTP input to begin work
  - Earnings wallet with 90% payout guarantee & instant bank withdraw

---

## 🔒 Security & Data Protection Measures (బేస్‌మెంట్ సెక్యూరిటీ)
- **Role-Based Access Control (RBAC)**: Separate tokens for Admin, Provider, and Customer.
- **Unverified Partner Lockdown**: Providers cannot go online or accept jobs until Super Admin verifies Aadhaar & background check.
- **Start-Work OTP Shield**: Prevents fraudulent service completion claims.
