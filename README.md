<div align="center">

<!-- Badges at Top -->
<p>
  <a href="https://github.com/Korya0/car_register/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/Korya0/car_register" alt="contributors" />
  </a>
  <a href="https://github.com/Korya0/car_register/commits/main">
    <img src="https://img.shields.io/github/last-commit/Korya0/car_register" alt="last update" />
  </a>
  <a href="https://github.com/Korya0/car_register/stargazers">
    <img src="https://img.shields.io/github/stars/Korya0/car_register" alt="stars" />
  </a>
  <a href="https://github.com/Korya0/car_register/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/Korya0/car_register" alt="license" />
  </a>
</p>

<!-- Typing Logo -->
<img src="https://readme-typing-svg.herokuapp.com/?font=Inter&weight=800&size=50&center=true&vCenter=true&width=600&height=100&duration=4000&color=D91B21&lines=Car+Register+App"/>

<!-- Links Section -->
<p>
  <a href="https://mostaql.com/u/Korya/reviews/9091624">
    <img src="https://img.shields.io/badge/⭐_Client_Review-D91B21?style=for-the-badge" alt="Client Review"/>
  </a>
  <a href="https://www.linkedin.com/in/mahmoudk25/">
    <img src="https://img.shields.io/badge/💬_LinkedIn-091E30?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
</p>

</div>

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
  <img src="https://img.shields.io/badge/%F0%9F%93%B8_App_Preview-091E30?style=for-the-badge" alt="App Preview" />
</div>

<!-- TODO: replace the placeholder icon below with readme_assets/all_views.jpg when available. -->
<!-- TODO: replace the table placeholders with readme_assets/car_plate_gif.gif and readme_assets/all_views.jpg when available. -->

<div align="center">

<img src="assets/native/app_icon.png" width="220" alt="App Screens" />

<br/>
<br/>

| Access Control | Home | Search | Delete |
|:---:|:---:|:---:|:---:|
| <img src="screenshots/access_control.jpeg" width="180"/> | <img src="screenshots/home.jpeg" width="180"/> | <img src="screenshots/search.jpeg" width="180"/> | <img src="screenshots/delete.jpeg" width="180"/> |

</div>

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
  <img src="https://img.shields.io/badge/%F0%9F%9A%80_Key_Features-091E30?style=for-the-badge" alt="Key Features" />
</div>

<details>
<summary><b>📋 Brochure Numbers</b></summary>
<br>

- **Add &amp; Save**: Record car brochure numbers from 1 to 4 digits.
- **Leading Zeros**: Numbers are stored as `String`, so `007` stays `007`.
- **Search &amp; Count**: Search any number and see the total registered count.
- **Delete**: Delete a single number after a confirmation dialog.

</details>

<details>
<summary><b>☁️ Cloud Data</b></summary>
<br>

- **Firestore Only**: All data lives in `Cloud Firestore` under `access_codes/{code}/plates`; every read and write needs a connection.
- **Access Code Check**: The shared access code is validated by reading its `access_codes/{code}` document and its active flag.
- **Session Cache Only**: Brochures are cached in memory per session — there is no local database or offline sync yet.
- **Secure Code Storage**: `flutter_secure_storage` keeps the access code on the device; nothing else is stored locally.

</details>

<details>
<summary><b>🔒 App Lock</b></summary>
<br>

- **Built on `local_auth`**: The app delegates authentication to the package — it does not implement its own PIN or biometric system.
- **Device Credentials**: Authentication requests use the device's existing screen lock (PIN/pattern) and fingerprint when enrolled, on the device's side.
- **Auth Guard Wrapper**: An opt-in `runWithLocalAuth` context guard prompts authentication before delete actions only.
- **Result Mapping**: The package's exception codes are mapped into a `LocalAuthResult` enum (success, cancelled, unavailable, not enrolled, locked out, busy, error).
- **Availability Check**: `isDeviceSupported()` is verified before prompting.

</details>

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
  <img src="https://img.shields.io/badge/%F0%9F%9B%A0%EF%B8%8F_Tech_Stack-091E30?style=for-the-badge" alt="Tech Stack" />
</div>

- **Framework**: `Flutter`
- **Language**: `Dart`
- **State Management**: `Riverpod`
- **Cloud Database**: `Cloud Firestore`
- **Local Storage**: `flutter_secure_storage` (access code only)
- **Device Auth**: `local_auth` (delegates to the device's screen lock and biometrics)
- **Architecture**: `Feature-First Clean Architecture`
- **Testing**: `Unit & Widget Tests`

<img src="https://img.shields.io/badge/-%20-C8CBCD?style=flat-square" width="100%" height="2" alt="" />

<div align="center">
Made with ❤️ by Korya
<br/>
<b>© 2026 Car Register App</b>
</div>