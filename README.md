<h1 align="center">
    <img src="https://readme-typing-svg.herokuapp.com/?font=Righteous&size=35&center=true&vCenter=true&width=500&height=70&duration=4000&lines=Hi+There!+👋;+I'm+Mohit+Bajpai!;" />
</h1>

<h3 align="center">A passionate iOS App developer from India</h3>

<br/>

<div align="center">

 </div>
 
<div align="center"> 
  <a href="www.linkedin.com/in/mohit-bajpai-a65b7b256" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" target="_blank" />
  </a>
</div>

 <hr/>

 # COP (Crime Observation and Prevention) iOS Application

## Overview

The **COP** iOS application is designed for the Delhi Police to facilitate crime monitoring and reporting. It allows users to sign up, log in, and verify their identity. The app features a tab bar navigation system, each tab corresponding to different functionalities for crime tracking in map based on place,datea and crime type ,Live tracking of junior police officers location,time and other stull by Admins, user profile, and more.

### Features

- **SignIn & SignUp Flow**: Allows users to log in or create an account using their phone number.
- **OTP Verification**: Users receive an OTP to verify their phone number and complete registration or sign-in.
- **Tab Bar Navigation**: After successful OTP verification, users are taken to a screen with four main tabs for different functionalities:
  - **Home (Tab 1)**: Displays a map with crime data and filtering options.
  - **Reports (Tab 2)**: View reports and insights into crime data.
  - **Notifications (Tab 3)**: Notifications regarding recent activities or updates.
  - **Profile (Tab 4)**: Manage user details like name, phone number, date of birth, and address.

### View Controllers

- **SignInViewController**: Handles user login with a phone number input and a button to generate OTP.
- **SignUpViewController**: Facilitates user registration with a phone number input and a button to generate OTP.
- **OTPViewController**: Manages OTP verification, sending, and verifying the OTP for both SignIn and SignUp flows.
- **Tab Bar Controller**: Once logged in, users can access different functionalities via four tabs:
  1. **Home**
  2. **Reports**
  3. **Notifications**
  4. **Profile**

### Technology Stack

- **Swift**: Frontend built using UIKit.
- **Node.js**: By team members, Backend for handling user authentication and data storage.
- **Alamofire**: Networking library for API calls.
- **MapKit**: Used for displaying crime data on a map with filtering options.
- **JSON**: Handling data exchange between frontend and backend.

## Screenshots

Below are some screenshots of the COP app showing various screens:

| Screen            | Description                       |
|-------------------|-----------------------------------|
| <img src="https://github.com/user-attachments/assets/6141293f-5053-4067-b866-522d96de1cf1" width="200"/> | **Sign In**: Enter phone number and request OTP. |
| <img src="./screenshots/signup.png" width="200"/> | **Sign Up**: Enter phone number to create a new account. |
| <img src="./screenshots/notifications_tab.png" width="200"/> | **Notifications Tab**: Notifications about activities and updates. |
| <img src="./screenshots/otp_verification.png" width="200"/> | **OTP Verification**: Enter the OTP received to verify the phone number. |
| <img src="https://github.com/user-attachments/assets/b8439a3c-389d-4fef-af3d-ab2f0acf4572" width="200"/> <img src="https://github.com/user-attachments/assets/3edb2245-9043-4e51-b823-6e305905212a" width="200"/> | **Home Tab**: Map displaying crime data and filter options. |
| <img src="./screenshots/reports_tab.png" width="200"/> | **Admin Tab**: Live tracking of constables by Admins. |
| <img src="https://github.com/user-attachments/assets/ff03185a-16a7-43ba-9f74-813a627153fb" width="200"/> | **Profile Tab**: View and edit personal details such as name, phone number, and address. |
