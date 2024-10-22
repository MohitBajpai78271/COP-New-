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
| <img src="https://github.com/user-attachments/assets/6141293f-5053-4067-b866-522d96de1cf1" width="200"/> | **Sign In**: Enter phone number and request OTP. <br> - **Feature**: Secure OTP login system, ensuring user authentication with backend integration. |
| <img src="https://github.com/user-attachments/assets/5c1ca78f-38e3-4012-8c84-dc4722e107f7" width="200"/> | **Sign Up**: Enter phone number to create a new account. <br> - **Feature**: Optimized new user creation with real-time phone number validation. |
| <img src="https://github.com/user-attachments/assets/2771e4f5-8468-4f94-a579-54a0f6820fce" width="200"/> | **Enter Details for SignUp**: Input details like name and address. <br> - **Feature**: Real-time form validation with secure input handling. |
| <img src="https://github.com/user-attachments/assets/2771e4f5-8468-4f94-a579-54a0f6820fce" width="200"/> | **OTP Verification**: Verify phone number via OTP. <br> - **Feature**: Two-factor authentication with backend integration. |
| <img src="https://github.com/user-attachments/assets/b8439a3c-389d-4fef-af3d-ab2f0acf4572" width="200"/> | **Home Tab**: Map showing real-time crime data. <br> - **Feature**: Integrated MapKit for real-time data visualization with advanced filters. |
| <img src="https://github.com/user-attachments/assets/66e15e4a-7354-4509-9102-9f4d533cc807" width="200"/> | **Admin Tab**: Live tracking of constables for admins. <br> - **Feature**: Real-time constable location tracking using MapKit and CoreLocation. |
| <img src="https://github.com/user-attachments/assets/ff03185a-16a7-43ba-9f74-813a627153fb" width="200"/> | **Profile Tab**: Manage personal details. <br> - **Feature**: Editable profile fields with real-time updates. |
| <img src="https://github.com/user-attachments/assets/8c4d8e15-ce95-413c-a8d4-c35635579aef" width="200"/> | **Settings Tab**: Check app details, log out securely. <br> - **Feature**: Logout with backend confirmation. |

