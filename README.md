 # COP (Constable On Patrol) iOS Application

## Overview

The **COP** iOS application is designed for the Delhi Police to facilitate crime monitoring and reporting. It allows users to sign up, log in, and verify their identity. The app features a tab bar navigation system, each tab corresponding to different functionalities for crime tracking in map based on place,datea and crime type ,Live tracking of junior police officers location,time and other stuff by Admins, user profile, and more.

### Features

- **SignIn & SignUp Flow**: Allows users to log in or create an account using their phone number.
- **OTP Verification**: Users receive an OTP to verify their phone number and complete registration or sign-in.
- **Tab Bar Navigation**: After successful OTP verification, users are taken to a screen with four main tabs for different functionalities:
  - **Home (Tab 1)**: Displays a map with crime data and filtering options.
  - **Admin (Tab 2)**: Track live location, time and other details of Juniors.
  - **Profile (Tab 4)**: Manage user details like name, phone number, date of birth, and address.
  - **Settings (Tab 3)**: To Log out or checking details.


### Technology Stack

- **Swift**: Frontend built using UIKit.
- **Node.js**: By team members, Backend for handling user authentication and data storage.
- **Alamofire**: Networking library for API calls.
- **CoreLocation**: For current Location of user.
- **MapKit**: Used for displaying crime data on a map with filtering options.
- **JSON**: Handling data exchange between frontend and backend.

## COP App Screenshots

| **Screen**            | **Description**                       |
|-----------------------|---------------------------------------|
| <img src="https://github.com/user-attachments/assets/bdfe98d0-983e-4f5a-ae9c-3f5bf7fcb5fd" width="400"/> | **Sign In**: Enter phone number and request OTP.<br> - **Feature**: Secure OTP-based login system integrated with backend. |
| <img src="https://github.com/user-attachments/assets/4092e692-a0d4-4a7f-8afc-b660b8f4e2db" width="400"/> | **Sign Up**: Create a new account using a phone number.<br> - **Feature**: User-friendly sign-up interface with real-time validation. |
| <img src="https://github.com/user-attachments/assets/59b5a75e-0e92-4224-bef8-08295522d73a" width="400"/> | **Enter Details For SignUp**: Provide user details to sign up.<br> - **Feature**: validation with secure data submission. |
| <img src="https://github.com/user-attachments/assets/2a4693a2-a757-4253-a71d-544e74dc856b" width="400"/> | **OTP Verification**: Verify phone number with OTP.<br> - **Feature**: Backend-integrated OTP verification. |
| <img src= "https://github.com/user-attachments/assets/2651f38c-ea5f-4cda-8fe5-2750305d45b8" width="400"/> | **Home Tab**: View crime data on a map.<br> - **Feature**: Interactive map with crime filters using MapKit. |
| <img src="https://github.com/user-attachments/assets/ab1449fe-c341-4c7d-95f0-0f2292f80d9b" width="400"/> | **Admin Tab**: Track constables in real-time.<br> - **Feature**: Live constable tracking with CoreLocation. |
| <img src="https://github.com/user-attachments/assets/6d2f43ac-db4c-4de1-99d1-b173b793cc73" width="400"/> | **Profile Tab**: Edit and view personal details.<br> - **Feature**: Editable profile fields synced with backend. |
| <img src="https://github.com/user-attachments/assets/4906294d-db61-484b-b51c-933bf4a45d9e" width="400"/> | **Settings Tab**: Manage app settings and log out.<br> - **Feature**: Secure logout functionality. |


