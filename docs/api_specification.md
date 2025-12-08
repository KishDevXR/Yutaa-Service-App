# Customer App - API Specification

## Overview
This document defines all API endpoints required for the Customer App backend.

---

## Base URL
```
https://api.yutaa.com/v1
```

---

## 1. Authentication APIs (Firebase Integrated)

### POST `/auth/login`
Exchange Firebase ID Token for App Session Token.

**Request:**
```json
{
  "firebaseToken": "eyJhbGciOiJSUzI1..." // ID Token from Client SDK
}
```

**Response:**
```json
{
  "success": true,
  "token": "jwt_session_token",
  "user": {
    "id": "user_123",
    "phone": "+919876543210",
    "name": "Rahul Kumar",
    "email": "rahul@email.com",
    "profileComplete": true
  },
  "isNewUser": false
}
```

> **Note:** OTP generation and verification handled entirely by Firebase Client SDK.

## 2. User Profile APIs

### GET `/users/me`
Get current user profile.

### PUT `/users/me`
Update user profile.

**Request:**
```json
{
  "name": "Rahul Kumar",
  "email": "rahul@email.com",
  "profileImage": "base64_or_url"
}
```

---

### GET `/users/me/addresses`
Get user's saved addresses.

### POST `/users/me/addresses`
Add new address.

**Request:**
```json
{
  "label": "Home",
  "fullAddress": "123 Main Street, Koramangala",
  "city": "Bangalore",
  "pincode": "560034",
  "lat": 12.9352,
  "lng": 77.6245,
  "isDefault": true
}
```

### DELETE `/users/me/addresses/:addressId`
Delete an address.

---

## 3. Service Catalog APIs

### GET `/categories`
Get all service categories.

**Response:**
```json
{
  "categories": [
    {"id": "cat_1", "name": "Electrician", "icon": "⚡", "image": "url"},
    {"id": "cat_2", "name": "Plumber", "icon": "🔧", "image": "url"},
    {"id": "cat_3", "name": "Carpenter", "icon": "🪚", "image": "url"}
  ]
}
```

---

### GET `/categories/:categoryId/services`
Get services for a category.

**Response:**
```json
{
  "services": [
    {
      "id": "svc_1",
      "title": "Switch/Socket Installation",
      "description": "Installation of switches and sockets",
      "rating": 4.6,
      "reviewCount": 654,
      "duration": "30 min",
      "priceRange": "₹179 - ₹229",
      "categoryId": "cat_1"
    }
  ]
}
```

---

## 4. Partner APIs

### GET `/services/:serviceId/partners`
Get available partners for a service.

**Query Params:** `lat`, `lng`, `radius` (optional)

**Response:**
```json
{
  "partners": [
    {
      "id": "partner_1",
      "name": "Rajesh Kumar",
      "profileImage": "url",
      "rating": 4.8,
      "reviewCount": 248,
      "jobCount": 342,
      "distance": 2.5,
      "estimatedTime": "15-20 min",
      "price": "₹199",
      "isTopPro": true,
      "isPremium": false
    }
  ]
}
```

---

## 5. Booking APIs

### POST `/bookings`
Create a new booking (enquiry to multiple partners).

**Request:**
```json
{
  "serviceId": "svc_1",
  "partnerIds": ["partner_1", "partner_2", "partner_3"],
  "date": "2025-12-10",
  "timeSlot": "2:00 PM - 3:00 PM",
  "addressId": "addr_1",
  "notes": "Please bring extra tools"
}
```

**Response:**
```json
{
  "bookingId": "booking_123",
  "status": "waiting",
  "partnerStatuses": [
    {"partnerId": "partner_1", "status": "pending"},
    {"partnerId": "partner_2", "status": "pending"},
    {"partnerId": "partner_3", "status": "pending"}
  ]
}
```

---

### GET `/bookings`
Get all bookings for user.

**Query Params:** `status` (optional: waiting, approved, in_progress, completed)

---

### GET `/bookings/:bookingId`
Get booking details.

---

### POST `/bookings/:bookingId/confirm`
User confirms a partner (after partner approves).

**Request:**
```json
{
  "partnerId": "partner_1"
}
```

---

### POST `/bookings/:bookingId/decline`
User declines a partner's approval.

**Request:**
```json
{
  "partnerId": "partner_1"
}
```

---

### POST `/bookings/:bookingId/cancel`
Cancel entire booking.

---

## 6. Admin APIs (for Dashboard)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/admin/users` | GET | List all users |
| `/admin/partners` | GET/POST | Partners CRUD |
| `/admin/services` | GET/POST/PUT/DELETE | Services CRUD |
| `/admin/categories` | GET/POST/PUT/DELETE | Categories CRUD |
| `/admin/bookings` | GET | All bookings |
| `/admin/analytics` | GET | Dashboard stats |

---

## API Summary Table

| Module | Endpoint | Method | Description |
|--------|----------|--------|-------------|
| Auth | `/auth/send-otp` | POST | Send OTP |
| Auth | `/auth/verify-otp` | POST | Verify & login |
| Profile | `/users/me` | GET/PUT | User profile |
| Addresses | `/users/me/addresses` | GET/POST/DELETE | Addresses |
| Categories | `/categories` | GET | All categories |
| Services | `/categories/:id/services` | GET | Services list |
| Partners | `/services/:id/partners` | GET | Available partners |
| Bookings | `/bookings` | GET/POST | Bookings CRUD |
| Bookings | `/bookings/:id/confirm` | POST | Confirm partner |
| Bookings | `/bookings/:id/decline` | POST | Decline partner |
| Bookings | `/bookings/:id/cancel` | POST | Cancel booking |

---

## Technology Recommendations

| Component | Technology | Reason |
|-----------|------------|--------|
| **Backend** | Node.js + Express | Quick development, JS ecosystem |
| **Database** | MongoDB | Flexible schema for bookings |
| **Auth** | Firebase Auth | OTP handling built-in |
| **Hosting** | Vercel / Railway | Easy deployment |

---

## 7. Firebase Auth Implementation Logic

### Client-Side (Flutter)
1. **Initialize Firebase**: Add `firebase_core` and `firebase_auth`.
2. **Phone Auth**:
   - Call `FirebaseAuth.verifyPhoneNumber`.
   - On `codeSent`: Navigate to OTP Screen.
   - On `verificationCompleted`: Auto-sign-in (rare for SMS).
   - On `codeAutoRetrievalTimeout`: Handle timeout.
3. **Verify OTP**:
   - User enters OTP.
   - Create credential: `PhoneAuthProvider.credential(verificationId, smsCode)`.
   - Sign in: `FirebaseAuth.signInWithCredential(credential)`.
4. **Get ID Token**:
   - User is signed in. Get token: `user.getIdToken()`.
5. **Backend Login**:
   - Call `POST /auth/login` with `firebaseToken`.
   - Store generic session token/user data from response.

### Server-Side (Node.js)
1. **Setup**: Initialize `firebase-admin` SDK with service account.
2. **Verify Endpoint (`/auth/login`)**:
   - Receive `firebaseToken`.
   - Verify: `await admin.auth().verifyIdToken(firebaseToken)`.
   - Extract `uid` and `phone_number`.
3. **User Logic**:
   - Find user in MongoDB by `phone`.
   - If not found, create new user.
   - Generate app-specific JWT (Session Token).
   - Return Token + User Profile.
