# Changelog v1.0.3

## [1.0.3] - 2025-01-31

### ✨ Added
- **Daily Mutabaah Reminder System**
  - Automatic daily notifications at 7:30 PM (19:30 WIB)
  - Notification service with timezone support (Asia/Jakarta)
  - Navigation to Yaumiyah page when notification is tapped
  - Default enabled notification setting for new users

- **Notification Settings in Profile**
  - Toggle switch to enable/disable daily reminders
  - Test notification button for immediate testing
  - Visual feedback with snackbar messages
  - Persistent settings storage using GetStorage

- **Permission Management**
  - Automatic notification permission request
  - Exact alarm permission handling for Android 12+
  - Fallback mechanism for permission-restricted devices
  - User-friendly error messages for permission issues

### 🔧 Fixed
- **Event Controller Error Handling**
  - Replaced ScaffoldMessenger with Get.snackbar to prevent context errors
  - Improved error handling in fetchEvents() and fetchActiveEvent()
  - Better user feedback for API failures

- **Notification Service Stability**
  - Fixed method compatibility issues with flutter_local_notifications
  - Implemented robust fallback system for scheduling failures
  - Added proper error logging and debugging support

### 🚀 Improved
- **Application Performance**
  - Removed unused Firebase dependencies (firebase_core, firebase_messaging)
  - Cleaned up build configuration and reduced APK size
  - Optimized dependency management
  - Faster app startup and reduced memory usage

- **Code Quality**
  - Better error handling throughout the application
  - Improved logging system for debugging
  - Consistent use of GetX architecture patterns
  - Enhanced code documentation

### 🗑️ Removed
- **Firebase Integration**
  - Removed firebase_core and firebase_messaging dependencies
  - Deleted google-services.json configuration file
  - Cleaned up Firebase-related build configurations
  - Removed unused Firebase initialization code (kept commented for future use)

### 📱 Technical Details
- **Dependencies Updated:**
  - Added: `timezone: ^0.10.1`
  - Removed: `firebase_core: ^4.0.0`, `firebase_messaging: ^16.0.0`

- **Android Permissions Added:**
  - `android.permission.USE_EXACT_ALARM`
  - `android.permission.POST_NOTIFICATIONS`
  - Enhanced `android.permission.SCHEDULE_EXACT_ALARM` handling

- **New Files:**
  - `lib/services/notification_service.dart` - Core notification management
  - `lib/controllers/mutabaah_controller.dart` - Notification settings controller
  - `lib/widgets/mutabaah_notification_setting.dart` - Settings UI component

### 🔄 Migration Notes
- Users upgrading from previous versions will have notifications enabled by default
- No data migration required - all existing user data remains intact
- Settings are automatically initialized on first app launch

### 🐛 Known Issues
- None reported in this version

### 📊 Build Information
- **APK Size:** ~81 MB
- **Build Time:** ~60 seconds
- **Target SDK:** Android 34 (Android 14)
- **Minimum SDK:** Android 23 (Android 6.0)

### 🧪 Testing
- ✅ Notification scheduling and delivery
- ✅ Permission handling on various Android versions
- ✅ Settings persistence and UI functionality
- ✅ Navigation from notification to Yaumiyah page
- ✅ Fallback mechanisms for restricted permissions
- ✅ APK build and installation process