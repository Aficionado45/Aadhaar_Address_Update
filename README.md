# UIDAI Hackathon 2021 Submission
---

![Aadhaar Logo](https://upload.wikimedia.org/wikipedia/en/thumb/c/cf/Aadhaar_Logo.svg/1200px-Aadhaar_Logo.svg.png)

This is the Github repository submission of our team for the UIDAI Hackathon 2021.

---
### Necessary Links 🔗

1. [Presentation/Demonstration](https://drive.google.com/drive/folders/11KKc_MD2qGqXQAVogeriECCYd9IuDfBd?usp=sharing)
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
### App Workflow / Architecure
![Untitled Workspace](https://user-images.githubusercontent.com/61295782/190618318-97495dea-caae-4fcd-a2fc-081950c819d7.png)

---

### Screens Screenshots  📸
| Welcome Screen | Resident Login | OTP Authentication | Scan Documents |
|:--------------:|:-------:|:-------:|:-------:|
|![WhatsApp Image 2021-10-31 at 7 14 30 PM (1)](https://user-images.githubusercontent.com/61295782/190618891-2cee1e45-821d-4fe1-95ed-a61e68c042b4.jpeg)|![Resident Login Screenshot](https://i.ibb.co/GFHRCZ5/Screenshot-20211031-184201.jpg)|![WhatsApp Image 2021-10-31 at 7 14 31 PM](https://user-images.githubusercontent.com/61295782/190618962-72286da0-f66f-4f17-9e42-968667168530.jpeg)|![Scan Documents Screenshot](https://i.ibb.co/zhLxdnW/Screenshot-20211031-184449-01-01.jpg)|

| Confirm Address and Verify GPS | Edit Address Form | Face Capture | Recipt Generation|
|:--------------:|:-------:|:-------:|:-------:|
|![Confirm Address and Verify GPS Screenshot](https://i.ibb.co/9mDPtFr/Screenshot-20211031-184604-01-01.jpg)|![Edit Address Form Screenshot](https://i.ibb.co/WvfN1sv/Screenshot-20211031-184618-01.jpg)|![WhatsApp Image 2021-11-13 at 4 16 35 PM](https://user-images.githubusercontent.com/61295782/190619175-c4480dce-43d8-4106-8ef0-9b37700dfb20.jpeg)|![WhatsApp Image 2021-11-28 at 10 54 09 PM](https://user-images.githubusercontent.com/61295782/190619195-ce6aec71-4207-4f39-b97f-1ce4db70d208.jpeg)|
---
