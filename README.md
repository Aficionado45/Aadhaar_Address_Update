# UIDAI Hackathon 2021 Submission
---

![Aadhaar Logo](https://upload.wikimedia.org/wikipedia/en/thumb/c/cf/Aadhaar_Logo.svg/1200px-Aadhaar_Logo.svg.png)

This is the Github repository submission of our team for the UIDAI Hackathon 2021.

---
### Necessary Links 🔗

1. [Presentation/Demonstration](https://drive.google.com/drive/folders/1_tZZ7tbVm0qgQgyItn1vBBni0Lyu6U-H?usp=sharing)
---

### Team Name: cbxkznoia96
### Team Referral ID: Edyxy75KKi
### Theme: Address Update
### Problem Statement: Address Update using Supporting Document

###### Brief Overview of Problem Statement:
An Aadhaar Address App for mobile operators who move door-to-door to assist residents in updating the address on their Aadhar Card with the help of supporting documents.

###### Brief Overview of Solution 👨‍💻 :
1. Database registered mobile operators login to the app with UIDAI OTP authentication to their staging UID.
2. A new session for address update of resident is initiated using staging UID of resident along with UIDAI OTP authentication.
3. Supporting proof documents are scanned in the app and address is extracted from it using OCR technology
> The scanned document can be cropped multiple times to extract just the right fields without loss of image quality.
>

4. The extracted address is pinned on a GPS map and is verified to be within a tolerable range of distance with the live location of the device.
5. An editable form is provided to the user to make minor changes to the approved extracted address. The modified address is again verified to be within a tolerable range with both the live location of the device as well as the document extracted address to prevent any fradulent activity.
6. A face authentication of both the resident and operator is done to ensure no misuse of OTP verification is done, as well as an added layer of security.
7. A confirmation is prompted. On approval address is updated and receipt is generated.

> In case the mobile or app crashes in between the process, address updation resumes from where it was left off when the resident is logged in again.

---
### Technologies Used 📱

| Android Studio | Flutter | Firebase |
|:--------------:|:-------:|:--------:|
|![Android Studio Logo](https://techcrunch.com/wp-content/uploads/2017/02/android-studio-logo.png?w=730&crop=1)|![Flutter Logo](https://repository-images.githubusercontent.com/31792824/fb7e5700-6ccc-11e9-83fe-f602e1e1a9f1)|![Firebase Logo](https://www.technisys.com/wp-content/uploads/2021/06/firebase_logo-1.png)|

---

### Installation and Setup Guidelines to Run the App on Debug Mode 📥

> The given guidelines is for Windows Operating System

> If you wish to run the app normally, download APK of the app from the links given above, and run on an Android device.

1. Download the Flutter SDK (and other prerequisites):
   [Get Started - Flutter](https://flutter.dev/docs/get-started/install/windows)

2. Add path for Flutter in environment paths.

3. Check dependencies and resolve them by running the following code in Command Prompt:
```
flutter doctor
```

4. Install Android Studio: [Installation - Android Studio](https://developer.android.com/studio)

5. OR Alternatively Install Visual Studio Code: [Installation - Visual Studio Code](https://code.visualstudio.com/Download)

6. Install Flutter and Dart Plugin in your code editor.

7. Clone this repository using the following command:
```
git clone https://github.com/Aficionado45/Aadhaar_Address_Update.git
```

8. Run the app.
---

### Screenshots of Important Screens 📸

| Resident Login | Scan Documents | Edit Address Form | Confirm Address and Verify GPS |
|:--------------:|:-------:|:-------:|:-------:|
|![Resident Login Screenshot](https://i.ibb.co/GFHRCZ5/Screenshot-20211031-184201.jpg)|![Scan Documents Screenshot](https://i.ibb.co/zhLxdnW/Screenshot-20211031-184449-01-01.jpg)|![Edit Address Form Screenshot](https://i.ibb.co/WvfN1sv/Screenshot-20211031-184618-01.jpg)|![Confirm Address and Verify GPS Screenshot](https://i.ibb.co/9mDPtFr/Screenshot-20211031-184604-01-01.jpg)|
---
