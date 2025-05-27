# Flutter CRM Task

A modern CRM (Customer Relationship Management) application built with Flutter, featuring customer management, real-time messaging, and VoIP call simulation.

## Features

### Core Features
- **Customer Management**
  - List, add, edit, and delete customers
  - Search and filter customers
  - Local storage using Hive
  - Status tracking (Active/Inactive)

- **Messaging Module**
  - WhatsApp-like chat interface
  - Real-time messaging simulation
  - Message delivery status indicators
  - Timestamps and read receipts

- **VoIP Call Simulation**
  - Call screen with mute and speaker options
  - Call duration tracking
  - Call history with detailed logs
  - Simulated incoming/outgoing calls

- **Authentication**
  - Role-based access (Admin/Agent)
  - Secure login system
  - User session management

### UI/UX Features
- Modern, clean design
- Responsive layout for both mobile and tablet
- Bottom navigation for quick access
- Navigation drawer with additional options
- Dark/light theme support

## Technical Details

### Architecture
- Clean Architecture pattern
- Separation of concerns (data, domain, presentation layers)
- State management using Riverpod
- Local storage with Hive

### Dependencies
- `flutter_riverpod`: State management
- `hive`: Local storage
- `intl`: Internationalization and formatting
- `firebase_core` & `cloud_firestore`: Backend services
- `uuid`: Unique ID generation
- `shared_preferences`: Local settings storage
- `google_fonts`: Custom typography

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/yourusername/flutter_crm_task.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Demo Credentials
- Admin:
  - Email: admin@crm.com
  - Password: admin123
- Agent:
  - Email: agent@crm.com
  - Password: agent123

## Project Structure
```
lib/
├── data/
│   ├── models/
│   │   └── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   └── repositories/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/
└── core/
    └── theme/
```

## Future Improvements
- [ ] Implement actual WebRTC for real VoIP calls
- [ ] Add push notifications
- [ ] Integrate with a real backend service
- [ ] Add analytics dashboard
- [ ] Implement file sharing in chat
- [ ] Add voice messages support
- [ ] Create customer pipeline view
- [ ] Add contact sync feature
- [ ] Implement data export (PDF/CSV)
