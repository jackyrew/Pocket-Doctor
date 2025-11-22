# PocketDoctor – CSCI 4311 Group Project

## 1. Project Information

### 1.1 Group Name
Group Name: United 

### 1.2 Group Members

| No. | Name                     | Matric No.  | Role in Project                      |
|-----|--------------------------|-------------|--------------------------------------|
| 1   | MUHAMMAD AFIQ HAMIZAN BIN HAMDAN | 2218411 | Group Leader, Backend Integration, UI/UX |
| 2   | MUHAMMAD IMRAN BIN MUHAMMAD ALI | 2214599 | UI/UX & Frontend Development, Backend Integration |         |
| 3   | _[Member 3 Name]_        | _[xxxxxxx]_ | Authentication & Storage Integration |
| 4   | _[Member 4 Name]_        | _[xxxxxxx]_ | Testing, Documentation & Deployment  |

## 2. Project Initiation & Ideation

### 2.1 Title

**Project Title:** PocketDoctor – AI-Assisted Symptom Checker & Health Companion

### 2.2 Background of the Problem

Many people search for health information online when they feel unwell, but the information is often confusing, unreliable, and may cause unnecessary panic. Clinics are also commonly overloaded with patients who are unsure whether their symptoms are serious or not. There is a need for a simple mobile application that can help users:

- Understand their symptoms in a structured way  
- Decide whether they should seek medical attention  
- Keep basic records of symptoms and health-related notes  

Mobile phones are almost always with the user, making them suitable platforms for a quick and guided symptom check, reminders, and basic health tracking.

### 2.3 Purpose / Objectives

The main objectives of **PocketDoctor** are:

1. Help users describe and understand their symptoms in a structured manner using a guided questionnaire and chatbot-style interface.  
2. Provide preliminary AI-assisted health information while reminding users that this is **not a replacement** for real doctors.  
3. Store basic symptom history, notes, and recommendations using secure cloud storage so users can show them to healthcare professionals.  
4. Offer login and authentication for personalized usage and secure access to health records.  
5. Provide an intuitive, user-friendly Flutter app that works smoothly on common Android smartphones.

### 2.4 Target Users

- **Primary Users:** General public (teenagers to adults) who want quick, trustworthy symptom guidance.  
- **Secondary Users:**  
  - Patients preparing for clinic visits

### 2.5 Preferred Platform

- **Mobile Platform:** Android & iOS(Flutter)  
- **Framework:** Flutter (Dart)  
- **Back End as a Service (BaaS):** Firebase(for authentication & storage)

### 2.6 Key Features & Functionalities

Planned core features:

1. **User Authentication**
   - Email & password registration and login
   - Secure session handling and logout
   - Password reset (if supported by chosen BaaS)

2. **Symptom Checker / Chatbot**
   - Chat-style interface to ask about symptoms (e.g. location, duration, severity)
   - Calls to a health/symptom API or custom logic to generate preliminary suggestions
   - Clear disclaimer that results are not a diagnosis

3. **Medicine / Reminder Module**
   - Users can set reminders for medication or follow-up
   - Local notifications from the device

4. **Profile Screen**
   - View basic profile details
   - Manage personal settings and preferences

5. **General App Features**
   - Responsive layout for common phone sizes
   - Dark/light mode support (optional)
   - Error handling and input validation on forms

---

## 3. Technologies & Architecture

### 3.1 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend / BaaS:** Firebase
  - Authentication
  - Cloud database for CRUD (symptom history, user settings, etc.)
- **Packages / Plugins (Examples)**
  - `firebase_auth` client
  - `cloud_firestore` / database plugin
  - `http` for API calls (e.g. symptom/health APIs)
  - `provider`, `riverpod`, or `bloc` for state management
  - `flutter_local_notifications` (for reminders, if used)

### 3.2 High-Level Architecture

- **Presentation Layer:** Flutter screens and widgets (Home, Login, Signup, Symptom Checker, History, Profile)  
- **Logic Layer:**  
  - State management for user session and symptom flows  
  - Controllers/services for API calls and CRUD operations  
- **Data Layer:**  
  - BaaS Authentication (Firebase/Auth)  
  - Cloud database collections for users & symptom sessions  

---

## 4. Requirement Analysis & Planning

### 4.1 Technical Feasibility & Back-End Assessment

- App will run on **Android & iOS smartphones** using Flutter’s rendering engine.
- BaaS (Firebase) supports:
  - Authentication: email/password
  - Real-time or document-based storage (symptom history, user records)
- CRUD Operations:
  - **Create**: Store new symptom session records  
  - **Read**: Retrieve past sessions and user profile  
  - **Update**: Edit user profile, update session notes  
  - **Delete**: Delete a session record  

Compatibility considerations:

- Designed for current Android & iOS versions used by students (e.g. Android 10+).  
- Network access required for authentication & API calls.  
- Some limited offline functionality can be considered (e.g. local cache of last results).

### 4.2 Logical Design – Screen Navigation Flow

Below is a simplified screen navigation flow:

```text
Splash Screen
      |
      v
  Login Screen <----> Signup Screen
      |
      v
   Home Screen
     |     \
     |      \
Symptom Checker    Profile Screen
       |
       v
  Result / Summary Screen
