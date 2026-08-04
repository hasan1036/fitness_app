import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../service/user_profile_service.dart';
import '../../service/weight_unit_service.dart';
import 'me_view.dart';

import '../../l10n/app_localizations.dart';
class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() =>
      _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _ageController =
  TextEditingController();

  final TextEditingController _heightController =
  TextEditingController();

  final TextEditingController _currentWeightController =
  TextEditingController();

  final TextEditingController _targetWeightController =
  TextEditingController();

  String selectedGoal = "lose_weight";
  String selectedGender = "male";

  bool isSaving = false;
  String weightUnit = WeightUnitService.kilograms;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final String unit = await WeightUnitService.getUnit();
    final UserProfileData data = await UserProfileService.getProfile();
    if (!mounted) return;
    setState(() {
      weightUnit = unit;
      if (data.age > 0) _ageController.text = data.age.toString();
      if (data.heightCm > 0) _heightController.text = data.heightCm.toStringAsFixed(0);
      if (data.currentWeight > 0) _currentWeightController.text = WeightUnitService.fromKg(data.currentWeight, unit).toStringAsFixed(1);
      if (data.targetWeight > 0) _targetWeightController.text = WeightUnitService.fromKg(data.targetWeight, unit).toStringAsFixed(1);
      if (data.gender.isNotEmpty) selectedGender = data.gender;
      if (data.goalType.isNotEmpty) selectedGoal = data.goalType;
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int age =
    int.parse(_ageController.text.trim());

    final double height =
    double.parse(_heightController.text.trim());

    final double currentWeightInput =
    double.parse(_currentWeightController.text.trim());

    final double currentWeight =
    WeightUnitService.toKg(currentWeightInput, weightUnit);

    final double targetWeightInput =
    double.parse(_targetWeightController.text.trim());

    final double targetWeight =
    WeightUnitService.toKg(targetWeightInput, weightUnit);

    if (selectedGoal == "lose_weight" &&
        targetWeight >= currentWeight) {
      _showMessage(
        context.tr('targetWeightLowerThanCurrent'),
      );
      return;
    }

    if (selectedGoal == "gain_weight" &&
        targetWeight <= currentWeight) {
      _showMessage(
        context.tr('targetWeightHigherThanCurrent'),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    await UserProfileService.saveProfile(
      startWeight: currentWeight,
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      heightCm: height,
      age: age,
      gender: selectedGender,
      goalType: selectedGoal,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MeView(),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String? _validateNumber(
      String? value, {
        required String fieldLabel,
        required double min,
        required double max,
      }) {
    final String text = value?.trim() ?? "";

    if (text.isEmpty) {
      return "${fieldLabel} ${context.tr('isRequired')}";
    }

    final double? number = double.tryParse(text);

    if (number == null) {
      return "${context.tr('enterValid')} ${fieldLabel.toLowerCase()}";
    }

    if (number < min || number > max) {
      return "${fieldLabel} ${context.tr('mustBeBetween')} "
          "${min.toStringAsFixed(0)} ${context.tr('and')} "
          "${max.toStringAsFixed(0)}";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffF7F3FD),

      appBar: AppBar(
        backgroundColor:
        const Color(0xffF7F3FD),
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
          context.tr('yourProfile'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Form(
          key: _formKey,

          child: ListView(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              30,
            ),

            children: [
              _buildHeader(),

              const SizedBox(height: 28),

              _sectionTitle(context.tr('whatIsYourGoal')),

              const SizedBox(height: 14),

              _buildGoalSelector(),

              const SizedBox(height: 28),

              _sectionTitle(context.tr('gender')),

              const SizedBox(height: 14),

              _buildGenderSelector(),

              const SizedBox(height: 28),

              _sectionTitle(context.tr('bodyInformation')),

              const SizedBox(height: 14),

              _inputField(
                controller: _ageController,
                label: context.tr('age'),
                hint: context.tr('enterYourAge'),
                suffix: context.tr('years'),
                icon: Icons.cake_rounded,
                keyboardType:
                TextInputType.number,
                validator: (value) {
                  return _validateNumber(
                    value,
                    fieldLabel: context.tr('age'),
                    min: 12,
                    max: 100,
                  );
                },
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: _heightController,
                label: context.tr('height'),
                hint: context.tr('enterYourHeight'),
                suffix: "cm",
                icon: Icons.height_rounded,
                keyboardType:
                const TextInputType
                    .numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  return _validateNumber(
                    value,
                    fieldLabel: context.tr('height'),
                    min: 100,
                    max: 250,
                  );
                },
              ),

              const SizedBox(height: 14),

              _inputField(
                controller:
                _currentWeightController,
                label: context.tr('currentWeight'),
                hint: context.tr('enterCurrentWeight'),
                suffix: WeightUnitService.label(weightUnit),
                icon:
                Icons.monitor_weight_rounded,
                keyboardType:
                const TextInputType
                    .numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  return _validateNumber(
                    value,
                    fieldLabel: context.tr('currentWeight'),
                    min: weightUnit == WeightUnitService.pounds ? 55 : 25,
                    max: weightUnit == WeightUnitService.pounds ? 1100 : 500,
                  );
                },
              ),

              const SizedBox(height: 14),

              _inputField(
                controller:
                _targetWeightController,
                label: context.tr('targetWeight'),
                hint: context.tr('enterTargetWeight'),
                suffix: WeightUnitService.label(weightUnit),
                icon: Icons.flag_rounded,
                keyboardType:
                const TextInputType
                    .numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  return _validateNumber(
                    value,
                    fieldLabel: context.tr('targetWeight'),
                    min: weightUnit == WeightUnitService.pounds ? 55 : 25,
                    max: weightUnit == WeightUnitService.pounds ? 1100 : 500,
                  );
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 58,

                child: ElevatedButton(
                  onPressed:
                  isSaving
                      ? null
                      : _saveProfile,

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    TColor.primary,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),

                  child: isSaving
                      ? const SizedBox(
                    width: 24,
                    height: 24,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    context.tr('continue'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primary,
            const Color(0xff8748E8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
        BorderRadius.circular(24),
      ),

      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,

            decoration: BoxDecoration(
              color:
              Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            context.tr('tellUsAboutYourself'),
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            context.tr('profileInfoUsage'),
            textAlign: TextAlign.center,

            style: TextStyle(
              color:
              Colors.white.withOpacity(0.86),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: TColor.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildGoalSelector() {
    return Column(
      children: [
        _selectionTile(
          title: context.tr('loseWeightTitle'),
          subtitle:
          context.tr('reduceBodyWeightFat'),
          icon:
          Icons.trending_down_rounded,
          selected:
          selectedGoal ==
              "lose_weight",
          onTap: () {
            setState(() {
              selectedGoal =
              "lose_weight";
            });
          },
        ),

        const SizedBox(height: 12),

        _selectionTile(
          title: context.tr('gainWeightTitle'),
          subtitle:
          context.tr('increaseHealthyBodyWeight'),
          icon:
          Icons.trending_up_rounded,
          selected:
          selectedGoal ==
              "gain_weight",
          onTap: () {
            setState(() {
              selectedGoal =
              "gain_weight";
            });
          },
        ),

        const SizedBox(height: 12),

        _selectionTile(
          title: context.tr('maintainWeightTitle'),
          subtitle:
          context.tr('keepWeightStable'),
          icon:
          Icons.balance_rounded,
          selected:
          selectedGoal ==
              "maintain_weight",
          onTap: () {
            setState(() {
              selectedGoal =
              "maintain_weight";
            });
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _genderTile(
            title: context.tr('male'),
            icon: Icons.male_rounded,
            selected:
            selectedGender == "male",
            onTap: () {
              setState(() {
                selectedGender = "male";
              });
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _genderTile(
            title: context.tr('female'),
            icon: Icons.female_rounded,
            selected:
            selectedGender == "female",
            onTap: () {
              setState(() {
                selectedGender = "female";
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _selectionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
      BorderRadius.circular(20),

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 220),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: selected
              ? TColor.primaryLight
              : Colors.white,

          borderRadius:
          BorderRadius.circular(20),

          border: Border.all(
            color: selected
                ? TColor.primary
                : const Color(0xffE8E2EF),
            width: selected ? 2 : 1,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,

              decoration: BoxDecoration(
                color: selected
                    ? TColor.primary
                    : TColor.primaryLight,

                borderRadius:
                BorderRadius.circular(15),
              ),

              child: Icon(
                icon,
                color: selected
                    ? Colors.white
                    : TColor.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                      TColor.sceondarText,
                      fontSize: 12,
                    ),
                  ),
                ],
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
    );
  }

  Widget _genderTile({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
      BorderRadius.circular(20),

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 220),

        padding:
        const EdgeInsets.symmetric(
          vertical: 20,
        ),

        decoration: BoxDecoration(
          color: selected
              ? TColor.primary
              : Colors.white,

          borderRadius:
          BorderRadius.circular(20),

          border: Border.all(
            color: selected
                ? TColor.primary
                : const Color(0xffE8E2EF),
          ),
        ),

        child: Column(
          children: [
            Icon(
              icon,
              color: selected
                  ? Colors.white
                  : TColor.primary,
              size: 34,
            ),

            const SizedBox(height: 9),

            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : TColor.primaryText,
                fontSize: 15,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController
    controller,
    required String label,
    required String hint,
    required String suffix,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?)
    validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,

      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,

        prefixIcon: Icon(
          icon,
          color: TColor.primary,
        ),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: const BorderSide(
            color: Color(0xffE8E2EF),
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide(
            color: TColor.primary,
            width: 2,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}
