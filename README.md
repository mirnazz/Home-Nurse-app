# HomeNurse - Smart Care. Right at Home.

## Overview

HomeNurse is a healthcare platform designed to connect patients with qualified nurses for on-demand home nursing services.

The platform simplifies the process of finding trusted healthcare professionals, booking appointments, managing services, making secure payments, and receiving quality care at home.

This project was developed as a Graduation Project.

---

## Features

### Patient Features

* User registration and authentication
* Browse available nurses
* Search nurses by specialty and location
* View nurse profiles and availability
* Book healthcare services
* Track appointments
* Secure online payments
* Appointment history
* Ratings and reviews
* Notifications and updates

### Nurse Features

* Nurse registration and profile management
* Document submission and verification
* Service management
* Availability scheduling
* Appointment management
* Accept or reject service requests
* Track earnings and completed appointments

### Admin Features

* Admin dashboard
* Nurse verification and approval
* User management
* Service monitoring
* Complaint and report management
* Platform analytics and oversight

---

## System Architecture

The system consists of three main components:

### Mobile Application

* Flutter
* Dart

### Backend API

* ASP.NET Core Web API

### Admin Dashboard

* Web-based administrative panel

### Database

* SQL Server

---

## Technologies Used

### Frontend

* Flutter
* Dart

### Backend

* ASP.NET Core
* Entity Framework Core

### Database

* Microsoft SQL Server

### Tools

* Git
* GitHub
* Figma
* Postman

---

## User Roles

### Patient

Patients can search for nurses, book appointments, manage payments, and track healthcare services.

### Nurse

Nurses can manage their profiles, services, availability, and incoming requests.

### Administrator

Administrators verify nurses, manage users, and maintain platform quality and security.

---

## Project Structure

```text
HomeNurse/
│
├── Mobile App (Flutter)
├── Backend API (ASP.NET Core)
├── Admin Dashboard
├── Database Scripts
├── Documentation
└── Assets
```

## Installation

### Clone Repository

```bash
git clone https://github.com/your-organization/HomeNurse.git
```

### Flutter Application

```bash
flutter pub get
flutter run
```

### Backend API

```bash
dotnet restore
dotnet run
```

### Database

1. Create SQL Server database.
2. Update connection string.
3. Run migrations.

```bash
dotnet ef database update
```

---

## Main Workflow

1. Nurse registers an account.
2. Admin reviews submitted credentials.
3. Nurse is approved.
4. Nurse adds services and availability.
5. Patient searches for a nurse.
6. Patient books a service.
7. Nurse accepts the request.
8. Service is delivered.
9. Patient submits rating and feedback.

---


## Future Improvements

* Real-time chat
* Video consultation support
* Advanced analytics
* Multi-language support
* AI-powered nurse recommendations

---

