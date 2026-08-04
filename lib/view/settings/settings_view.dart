import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../l10n/app_localizations.dart';
import '../../service/language_service.dart';
import '../../service/weight_unit_service.dart';
import '../profile/profile_setup_view.dart';
import '../schedule/schedule_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;

  String weightUnit = WeightUnitService.kilograms;

  @override
  void initState() {
    super.initState();
    _loadWeightUnit();
  }

  Future<void> _loadWeightUnit() async {
    final String unit = await WeightUnitService.getUnit();

    if (!mounted) return;

    setState(() {
      weightUnit = unit;
    });
  }

  String _languageName(String code) {
    switch (code) {
      case 'bn':
        return context.tr('bangla');
      case 'hi':
        return context.tr('hindi');
      case 'ar':
        return context.tr('arabic');
      case 'ja':
        return context.tr('japanese');
      case 'es':
        return context.tr('spanish');
      default:
        return context.tr('english');
    }
  }

  Future<void> _showLanguagePicker() async {
    final String current = LanguageService.currentCode;

    final String? result =
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        const List<(String, String, String)> languages = [
          ('en', 'English', '🇺🇸'),
          ('bn', 'বাংলা', '🇧🇩'),
          ('hi', 'हिन्दी', '🇮🇳'),
          ('ar', 'العربية', '🇸🇦'),
          ('ja', '日本語', '🇯🇵'),
          ('es', 'Español', '🇪🇸'),
        ];

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xffF7F3FD),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                top: false,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    14,
                    20,
                    28,
                  ),
                  children: [
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      sheetContext.tr('chooseLanguage'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...languages.map((item) {
                      final bool selected =
                          current == item.$1;

                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 9),
                        child: InkWell(
                          borderRadius:
                          BorderRadius.circular(17),
                          onTap: () {
                            Navigator.pop(
                              sheetContext,
                              item.$1,
                            );
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? TColor.primaryLight
                                  : Colors.white,
                              borderRadius:
                              BorderRadius.circular(17),
                              border: Border.all(
                                color: selected
                                    ? TColor.primary
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  item.$3,
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Text(
                                    item.$2,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Icon(
                                  selected
                                      ? Icons
                                      .check_circle_rounded
                                      : Icons
                                      .radio_button_unchecked_rounded,
                                  color: selected
                                      ? TColor.primary
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null || !mounted) return;

    await LanguageService.setLanguage(result);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _showWeightUnitPicker() async {
    final String? result =
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                28,
              ),
              decoration: const BoxDecoration(
                color: Color(0xffF7F3FD),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('weightUnit'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr('chooseWeightUnit'),
                    style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _unitOption(
                    sheetContext,
                    WeightUnitService.kilograms,
                    context.tr('kilograms'),
                    'kg',
                  ),
                  const SizedBox(height: 10),
                  _unitOption(
                    sheetContext,
                    WeightUnitService.pounds,
                    context.tr('pounds'),
                    'lb',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result == null || !mounted) return;

    await WeightUnitService.setUnit(result);

    if (!mounted) return;

    setState(() {
      weightUnit = result;
    });
  }

  Widget _unitOption(
      BuildContext sheetContext,
      String value,
      String title,
      String symbol,
      ) {
    final bool selected = weightUnit == value;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.pop(sheetContext, value);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? TColor.primaryLight
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? TColor.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? TColor.primary
                    : TColor.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                symbol,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : TColor.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                '$title ($symbol)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected
                  ? TColor.primary
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          context.tr('settings'),
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
          10,
          20,
          30,
        ),
        children: [
          _sectionTitle(
            context.tr('general'),
          ),
          _tile(
            icon: Icons.person_outline_rounded,
            title: context.tr('personalInformation'),
            subtitle: context.tr('personalInfoSubtitle'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ProfileSetupView(),
                ),
              );
            },
          ),
          _tile(
            icon:
            Icons.notifications_active_outlined,
            title: context.tr('scheduleReminders'),
            subtitle: context.tr('scheduleSubtitle'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ScheduleView(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _sectionTitle(
            context.tr('notifications'),
          ),
          _switchTile(
            icon: Icons.notifications_rounded,
            title: context.tr('notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          _switchTile(
            icon: Icons.volume_up_rounded,
            title: context.tr('notificationSound'),
            value: soundEnabled,
            onChanged: notificationsEnabled
                ? (value) {
              setState(() {
                soundEnabled = value;
              });
            }
                : null,
          ),
          _switchTile(
            icon: Icons.vibration_rounded,
            title: context.tr('vibration'),
            value: vibrationEnabled,
            onChanged: notificationsEnabled
                ? (value) {
              setState(() {
                vibrationEnabled = value;
              });
            }
                : null,
          ),
          const SizedBox(height: 20),
          _sectionTitle(
            context.tr('app'),
          ),
          _tile(
            icon: Icons.language_rounded,
            title: context.tr('language'),
            subtitle: _languageName(
              LanguageService.currentCode,
            ),
            onTap: _showLanguagePicker,
          ),
          _tile(
            icon: Icons.straighten_rounded,
            title: context.tr('weightUnit'),
            subtitle:
            weightUnit == WeightUnitService.pounds
                ? '${context.tr('pounds')} (lb)'
                : '${context.tr('kilograms')} (kg)',
            onTap: _showWeightUnitPicker,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: TColor.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        leading: _iconBox(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: TColor.sceondarText,
            fontSize: 11,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: TColor.primary,
          size: 16,
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: TColor.primary,
        secondary: _iconBox(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: TColor.primaryLight,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: TColor.primary,
      ),
    );
  }
}
