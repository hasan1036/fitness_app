import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../l10n/app_localizations.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  // TODO: Play Store publish করার আগে এগুলো পরিবর্তন করবে।
  static const String appName = 'Fitness Workout';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Md Hasan Ali';
  static const String supportEmail = 'bdhasan009@gmail.com';

  static const String lastUpdated = '6 August 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          context.tr('about'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          16,
          20,
          30,
        ),
        children: [
          _buildAppHeader(),

          const SizedBox(height: 20),

          _infoCard(
            icon: Icons.info_outline_rounded,
            title: 'About This App',
            text:
            '$appName provides structured home workout plans, '
                'exercise instructions, workout progress tracking, '
                'weight tracking, water tracking, meal planning and '
                'workout, water, meal and sleep reminders.',
          ),

          _infoCard(
            icon: Icons.favorite_rounded,
            title: 'Our Mission',
            text:
            'Our mission is to make healthy habits simple, accessible '
                'and easy to maintain through clear exercise guidance and '
                'useful daily fitness tools.',
          ),

          _actionCard(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle:
            'Learn how your information is accessed, stored and protected.',
            onTap: () {
              _showPolicySheet(
                context: context,
                title: 'Privacy Policy',
                icon: Icons.privacy_tip_outlined,
                content: _privacyPolicy,
              );
            },
          ),

          _actionCard(
            icon: Icons.admin_panel_settings_outlined,
            title: 'App Permissions',
            subtitle:
            'Learn why notifications, alarms, photos and other features are used.',
            onTap: () {
              _showPolicySheet(
                context: context,
                title: 'App Permissions',
                icon: Icons.admin_panel_settings_outlined,
                content: _permissionsPolicy,
              );
            },
          ),

          _actionCard(
            icon: Icons.storage_rounded,
            title: 'Local Data Storage',
            subtitle:
            'Learn what fitness information is stored on your device.',
            onTap: () {
              _showPolicySheet(
                context: context,
                title: 'Local Data Storage',
                icon: Icons.storage_rounded,
                content: _localDataPolicy,
              );
            },
          ),

          _actionCard(
            icon: Icons.share_outlined,
            title: 'Third-Party Services',
            subtitle:
            'Information about YouTube and device text-to-speech services.',
            onTap: () {
              _showPolicySheet(
                context: context,
                title: 'Third-Party Services',
                icon: Icons.share_outlined,
                content: _thirdPartyServices,
              );
            },
          ),

          _actionCard(
            icon: Icons.health_and_safety_outlined,
            title: 'Medical Disclaimer',
            subtitle:
            'Important health and exercise safety information.',
            onTap: () {
              _showPolicySheet(
                context: context,
                title: 'Medical Disclaimer',
                icon: Icons.health_and_safety_outlined,
                content: _medicalDisclaimer,
              );
            },
          ),

          _actionCard(
            icon: Icons.description_outlined,
            title: 'Terms of Use',
            subtitle:
            'Read the terms that apply when using this app.',
            onTap: () {
              _showPolicySheet(
                context: context,
                title: 'Terms of Use',
                icon: Icons.description_outlined,
                content: _termsOfUse,
              );
            },
          ),

          _actionCard(
            icon: Icons.delete_outline_rounded,
            title: 'Delete Local Data',
            subtitle:
            'Learn how to remove locally stored app information.',
            onTap: () {
              _showPolicySheet(
                context: context,
                title: 'Delete Local Data',
                icon: Icons.delete_outline_rounded,
                content: _dataDeletionPolicy,
              );
            },
          ),

          _infoCard(
            icon: Icons.email_outlined,
            title: 'Contact Us',
            text:
            'For privacy questions, feedback or support, contact us at:\n\n'
                '$supportEmail',
          ),

          _infoCard(
            icon: Icons.developer_mode_rounded,
            title: 'Developer Information',
            text:
            'Developer: $developerName\n'
                'Application: $appName\n'
                'Version: $appVersion',
          ),

          const SizedBox(height: 10),

          Text(
            'Last updated: $lastUpdated',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '© 2026 $developerName. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Made with dedication for a healthier life.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primary,
            const Color(0xff8748E8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: TColor.primary.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: TColor.primary,
              size: 42,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            appName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Version $appVersion',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconBox(icon),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  text,
                  style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                _iconBox(icon),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: TextStyle(
                          color: TColor.sceondarText,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: TColor.primary,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: TColor.primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: TColor.primary,
      ),
    );
  }

  void _showPolicySheet({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String content,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xffF7F3FD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      16,
                      10,
                      12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: TColor.primaryLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            icon,
                            color: TColor.primary,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        35,
                      ),
                      child: Text(
                        content,
                        style: const TextStyle(
                          color: Color(0xff2D2933),
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static const String _privacyPolicy = '''
PRIVACY POLICY

Effective date: $lastUpdated

$appName respects your privacy. This Privacy Policy explains what information the app accesses, how information is used and how information is stored.

1. INFORMATION PROVIDED BY THE USER

The app may process information voluntarily entered or selected by the user, including:

• Profile name
• Profile picture
• Age
• Gender
• Height
• Current weight
• Target weight
• Fitness goal
• Weight history
• Workout progress
• Completed exercises
• Workout duration and repetition settings
• Water tracking records
• Meal planning and completion records
• Workout, water, meal and sleep reminder settings

This information is used to provide the app's fitness, progress and reminder features.

2. LOCAL STORAGE

The current version stores primary fitness information locally on the user's device.

The app currently does not create an online user account and does not use a developer-owned cloud database for workout records.

Locally stored information is not intentionally uploaded to a developer-owned server.

3. PROFILE PHOTO

Users may voluntarily choose a profile picture from their device.

The selected picture is used as the in-app profile image. In the current version, the developer does not intentionally upload the selected picture to a developer-owned server.

4. NOTIFICATIONS AND REMINDERS

The app may request notification permission to provide workout, water, meal and sleep reminders configured by the user.

Notifications are not used for unrelated advertising messages.

5. EXACT ALARMS

On supported Android devices, the app may use exact alarm access so reminders can appear near the time chosen by the user.

If this access is disabled, reminder timing may be less accurate or some reminders may not work.

6. DEVICE RESTART

The app may receive a device restart event to restore previously configured reminders after the device is restarted.

This feature is not used to read personal files or monitor unrelated device activity.

7. VIBRATION

The app may use vibration when a reminder notification is delivered.

8. DEVICE TIME ZONE

The app uses the device's time zone information to schedule reminders at the correct local time.

The current version does not request GPS location permission for this purpose.

9. TEXT-TO-SPEECH

The app uses a text-to-speech service available on the user's device to read exercise names, instructions and workout guidance aloud.

Text-to-speech processing and available languages may depend on the speech engine installed on the device.

10. YOUTUBE CONTENT

The app may display exercise videos using YouTube.

When YouTube content is loaded or played, Google or YouTube may process technical, usage, cookie, device or network information according to their own terms and privacy policies.

11. DATA SHARING

The developer does not sell users' personal information.

The current version does not intentionally share locally stored workout progress, profile information, reminder settings, weight records or fitness preferences with advertising companies or data brokers.

Third-party services may process information according to their own privacy policies when users interact with those services.

12. ADVERTISING AND ANALYTICS

The current version does not intentionally integrate:

• Google AdMob
• Advertising SDKs
• Firebase Analytics
• Firebase Crashlytics
• Developer-owned user tracking systems

This section will be updated if these services are introduced in a future version.

13. DATA SECURITY

Reasonable measures are used to protect information handled by the app.

Most fitness data is stored locally on the user's device. Users are responsible for protecting access to their device.

No electronic storage or transmission method can be guaranteed to be completely secure.

14. DATA RETENTION

Locally stored information remains on the device until the user:

• Deletes or resets information inside the app, where available
• Clears the app's storage
• Uninstalls the app

Device backup settings may affect whether some application data is restored.

15. CHILDREN'S PRIVACY

The app is a general fitness application and is not specifically designed for children under 13.

Children should use the app only with the permission and supervision of a parent or legal guardian.

16. HEALTH INFORMATION

Fitness, weight and workout information provided by the app is intended for general educational and fitness purposes.

The app does not provide medical diagnosis, treatment or professional medical advice.

17. FUTURE FEATURES

If the app later introduces online accounts, cloud backup, advertising, analytics, subscriptions or other data-processing features, this Privacy Policy and the applicable store disclosures will be updated.

18. CHANGES TO THIS POLICY

This Privacy Policy may be updated when app functionality, third-party services or legal requirements change.

The latest version will show a revised effective date.

19. CONTACT

For questions about this Privacy Policy or the app, contact:

Email: $supportEmail
Developer: $developerName
Application: $appName
''';

  static const String _permissionsPolicy = '''
APP PERMISSIONS

$appName requests permissions only when they are required to provide an app feature.

1. NOTIFICATIONS

Purpose:
To deliver workout, water, meal and sleep reminders configured by the user.

The app does not use notification permission to send unrelated advertising messages.

2. EXACT ALARM ACCESS

Purpose:
To schedule reminders near the exact time selected by the user.

This access may be optional on supported Android devices. If exact alarm access is denied, reminder timing may be less precise.

3. DEVICE RESTART ACCESS

Purpose:
To restore scheduled reminders after the phone is restarted or the application is updated.

This does not provide access to personal files, messages, contacts or calls.

4. VIBRATION

Purpose:
To vibrate the device when a scheduled reminder notification is delivered.

5. PHOTOS OR MEDIA

Purpose:
To allow the user to voluntarily select a profile picture.

The selected picture is used inside the app. The current version does not intentionally upload it to a developer-owned server.

6. INTERNET

Purpose:
To load YouTube exercise videos and other online content provided through third-party services.

7. TEXT-TO-SPEECH

Purpose:
To read exercise instructions and workout guidance aloud using the text-to-speech service installed on the device.

8. DEVICE TIME ZONE

Purpose:
To schedule reminders according to the user's current local time zone.

The app does not require GPS location permission to determine the time zone.

9. LOCAL STORAGE

Purpose:
To save workout progress, profile information, weight data, reminder settings, meal records, water records and other fitness preferences on the device.

Users may deny optional permissions. The related feature may not work without the permission it requires.
''';

  static const String _localDataPolicy = '''
LOCAL DATA STORAGE

The current version primarily stores app information locally on your device.

Information stored locally may include:

• Profile name
• Selected profile picture path
• Age, gender and fitness goal
• Height and weight information
• Target weight and weight history
• Workout progress
• Completed workout days
• Current exercise progress
• Calories and workout statistics
• Water tracking records
• Meal completion records
• Workout reminder settings
• Water reminder settings
• Meal reminder settings
• Sleep reminder settings
• Language and application preferences

PURPOSE OF LOCAL STORAGE

Local storage is used to:

• Restore workout progress
• Continue an unfinished workout
• Display progress and achievements
• Save fitness preferences
• Schedule reminders
• Personalize the app experience

NO ONLINE ACCOUNT

The current version does not require an online user account.

The developer does not currently operate a cloud database for this locally stored fitness information.

SECURITY

Local data security depends partly on the security of the user's device.

Users should use a screen lock and avoid giving unauthorized people access to their device.
''';

  static const String _thirdPartyServices = '''
THIRD-PARTY SERVICES

$appName may use device services and third-party components to provide certain features.

1. YOUTUBE

The app may embed or display exercise videos through YouTube.

When YouTube content is loaded or played, Google or YouTube may process information according to their own privacy policies and terms.

This may include technical, device, usage, network or cookie-related information.

2. DEVICE TEXT-TO-SPEECH

The app uses the text-to-speech engine installed on the user's device to read exercise guidance aloud.

Text-to-speech processing may be provided by Google, Apple, the device manufacturer or another speech engine provider.

3. OPERATING SYSTEM PHOTO PICKER

The app uses the operating system's photo or media picker when the user chooses a profile picture.

4. LOCAL NOTIFICATION SYSTEM

The app uses Android and iOS notification systems to display reminders requested by the user.

5. DEVICE TIME ZONE SERVICE

The app reads the device time zone to schedule reminders at the correct local time.

The developer is not responsible for the privacy practices of independent third-party service providers.
''';

  static const String _medicalDisclaimer = '''
MEDICAL DISCLAIMER

$appName provides general exercise, workout, fitness, meal, hydration and lifestyle information for educational purposes only.

The app does not provide:

• Medical advice
• Medical diagnosis
• Medical treatment
• Emergency medical assistance
• Professional nutritional treatment
• Physiotherapy services

CONSULT A PROFESSIONAL

Before beginning an exercise program, consult a doctor or qualified healthcare professional, especially if you:

• Have an existing medical condition
• Have an injury or chronic pain
• Are pregnant
• Recently had surgery
• Have heart or breathing problems
• Have been advised to limit physical activity
• Are unsure whether an exercise is safe for you

STOP EXERCISING

Stop exercising immediately and seek medical help if you experience:

• Chest pain
• Severe shortness of breath
• Dizziness or fainting
• Sudden weakness
• Severe or unusual pain
• Loss of balance
• Any worrying physical symptom

USER RESPONSIBILITY

Exercise involves inherent risks.

You are responsible for:

• Choosing exercises appropriate for your ability
• Maintaining correct form
• Using a safe exercise area
• Following professional medical advice
• Stopping when an exercise causes pain or unusual discomfort

The developer is not responsible for injury or loss caused by improper exercise, unsafe surroundings, ignoring medical advice or using the app beyond the user's physical ability.
''';

  static const String _termsOfUse = '''
TERMS OF USE

By downloading or using $appName, you agree to these Terms of Use.

1. PERSONAL USE

The app is provided for personal fitness and educational use.

You may not copy, resell, reproduce, distribute or commercially exploit the app without permission.

2. USER RESPONSIBILITY

You are responsible for:

• Selecting suitable exercises
• Using proper exercise form
• Exercising in a safe environment
• Consulting a medical professional when necessary
• Stopping exercise if you experience pain or discomfort
• Protecting your device and locally stored information

3. NO MEDICAL SERVICE

The app is not a medical service and does not replace a doctor, physiotherapist, dietitian or other qualified healthcare professional.

4. APP AVAILABILITY

Features may be changed, updated, removed or temporarily unavailable.

The developer does not guarantee uninterrupted or error-free operation on every device.

5. THIRD-PARTY CONTENT

The app may display third-party content, including YouTube videos.

Third-party content is governed by the provider's own terms and policies.

6. INTELLECTUAL PROPERTY

The app interface, branding, original text, code and original visual assets are protected by applicable intellectual property laws.

7. LIMITATION OF LIABILITY

To the maximum extent allowed by applicable law, the developer is not responsible for injury, loss or damage caused by:

• Improper exercise
• Misuse of the app
• Ignoring health warnings
• Incorrect information entered by the user
• Third-party content or service interruption
• Device failure or loss of locally stored information

8. CHANGES TO THESE TERMS

These Terms may be updated when app functionality or legal requirements change.

9. CONTACT

Email: $supportEmail
''';

  static const String _dataDeletionPolicy = '''
DELETE LOCAL DATA

The current version does not create a remote online account with the developer.

Most app data is stored locally on your device.

You can remove locally stored information using one or more of the following methods:

1. IN-APP OPTIONS

Use any available reset, clear or delete option inside the app.

2. CLEAR APP STORAGE

Android:

• Open device Settings
• Open Apps
• Select $appName
• Open Storage
• Select Clear Data or Clear Storage

The exact steps may vary by device.

3. UNINSTALL THE APP

Uninstalling the app normally removes its locally stored information.

Some information may be restored if operating-system backup is enabled.

IMPORTANT

Clearing app storage or uninstalling the app may permanently remove:

• Workout progress
• Weight records
• Reminder settings
• Profile information
• Meal records
• Water records
• App preferences

Because the current version does not create a developer-owned online account, there is currently no remote account record to request for deletion.

If online accounts or cloud backup are added in a future version, account and remote data-deletion instructions will be added to the app and Privacy Policy.
''';
}