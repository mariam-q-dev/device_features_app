Flutter Device Features App 
📱A comprehensive Flutter application demonstrating native hardware and device integration including Device Information, Image Picker, Google Maps, Biometric Authentication, and Audio Recording & Playback.🚀 Features📱 Device Information (device_info_plus):Fetches detailed system and hardware specifications of the device.📸 Image Picker (image_picker):Pick images directly from the Device Camera or Gallery with runtime permission handling.🗺️ Google Maps Integration (google_maps_flutter):Interactive map integration with custom markers and camera controls.🔒 Biometrics Authentication (local_auth):Secure identity verification using Fingerprint / Biometric authentication.🎙️ Audio Recorder & Player (record & audioplayers):Record voice notes locally using system microphone permissions and play recorded files back seamlessly.📸 App ScreenshotsDevice InfoImage PickerGoogle MapsBiometrics & Audio🛠️ Getting StartedPrerequisitesFlutter SDK (>=3.0.0)Android Studio / VS CodeAndroid Device running API Level 21 or higherInstallationClone the repository:git clone https://github.com/mariam-q-dev/device_features_app.git
Install dependencies:flutter pub get
Configure Google Maps API Key:
Add your Google Maps API Key in android/app/src/main/AndroidManifest.xml:<meta-data 
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
Run the App:flutter run
📦 Main Dependenciesdevice_info_plusimage_pickergoogle_maps_flutterlocal_authrecordaudioplayerspath_provider📄 LicenseThis project is open-source and available under the MIT License.