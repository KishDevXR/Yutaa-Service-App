# Yutaa Service App - AI Handoff Document

This document provides context for AI assistants to understand the current state of the project, architecture, and implemented features. **Read this first when resuming work.**

## Project Structure
The repository contains a Flutter workspace with:
- `customer_app/`: The main application for customers to book services.
- `shared/`: A local package for shared UI components and logic (currently minimal usage).

## Implemented Features (Customer App)

### 1. Authentication
- **Login Screen:** Phone number input.
- **OTP Verification:** 6-digit OTP input with simple verification logic.
- **Profile Setup:** Name and Email input.

### 2. Home & Discovery
- **Home Screen:** Displays Service Categories.
- **Category Screen:** Lists services within a category. Supports "Add to Cart" (simulated).

### 3. Booking Flow
- **Partner List Screen:** 
    - Accessed after selecting a service.
    - Displays mock partners/providers.
    - **Multi-Selection:** Users can select up to 3 partners.
    - **Dynamic Pricing:** Shows price ranges.
- **Booking Details Screen:**
    - Date & Time Picker.
    - Address Input.
    - **"Book Now" Action:** Creates a booking request in the mock repository.

### 4. Booking Request Management
- **Bookings Tab:** Added to the main Bottom Navigation Bar (`MainWrapper`).
- **Bookings Screen:** Lists active and past bookings.
- **Booking Status Screen:**
    - Detaled view of a booking.
    - Shows the list of requested partners and their status (`Waiting`, `Approved`, `Cancelled`).
    - **Simulation:** Includes "DEBUG" buttons to simulate a partner accepting the request.
    - **User Confirmation:** User can "Confirm & Pay" after a partner accepts.

## Tech Stack & Architecture
- **Framework:** Flutter.
- **Routing:** `go_router` (Defined in `lib/router/app_router.dart`).
- **State Management:** Currently using simple `SetState` + Singleton/Static mock repositories (`BookingsRepository` in `bookings_data.dart`) for rapid prototyping. `flutter_riverpod` is installed but not heavily used yet.
- **Theme:** centralized in `AppTheme`.

## Critical Files
- `lib/router/app_router.dart`: All routes defined here.
- `lib/features/booking/data/partners_data.dart`: Mock data for partners.
- `lib/features/bookings/data/bookings_data.dart`: Mock repository handling booking logic and simulation.
- `lib/features/bookings/screens/booking_status_screen.dart`: Core logic for managing multi-partner requests.

## Setup Instructions
1.  **Flutter:** Ensure Flutter SDK is installed.
2.  **Dependencies:** Run `flutter pub get` in `customer_app`.
3.  **Run:** `flutter run -d [device_id]`.
    - **Note:** Windows build might be flaky (`FileStream` error). Use Android Emulator.

## Next Steps
- **Backend Integration:** Replace mock repositories (`bookings_data.dart`, `partners_data.dart`) with real API calls.
- **Service Provider App:** Implement the other side of the marketplace.
- **Notifications:** Real-time updates for booking status.
- **Payment Gateway:** Real payment integration.

**Date:** December 5, 2025
