import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../service/user_profile_service.dart';

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

    final double currentWeight =
    double.parse(
      _currentWeightController.text.trim(),
    );

    final double targetWeight =
    double.parse(
      _targetWeightController.text.trim(),
    );

    if (selectedGoal == "lose_weight" &&
        targetWeight >= currentWeight) {
      _showMessage(
        "Target weight must be lower than current weight.",
      );
      return;
    }

    if (selectedGoal == "gain_weight" &&
        targetWeight <= currentWeight) {
      _showMessage(
        "Target weight must be higher than current weight.",
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

    Navigator.pop(context, true);
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
        required String fieldName,
        required double min,
        required double max,
      }) {
    final String text = value?.trim() ?? "";

    if (text.isEmpty) {
      return "$fieldName is required";
    }

    final double? number =
    double.tryParse(text);

    if (number == null) {
      return "Enter a valid $fieldName";
    }

    if (number < min || number > max) {
      return "$fieldName must be between "
          "${min.toStringAsFixed(0)} and "
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

        title: const Text(
          "Your Profile",
          style: TextStyle(
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

              _sectionTitle(
                "What is your goal?",
              ),

              const SizedBox(height: 14),

              _buildGoalSelector(),

              const SizedBox(height: 28),

              _sectionTitle(
                "Gender",
              ),

              const SizedBox(height: 14),

              _buildGenderSelector(),

              const SizedBox(height: 28),

              _sectionTitle(
                "Body Information",
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: _ageController,
                label: "Age",
                hint: "Enter your age",
                suffix: "years",
                icon: Icons.cake_rounded,
                keyboardType:
                TextInputType.number,
                validator: (value) {
                  return _validateNumber(
                    value,
                    fieldName: "Age",
                    min: 12,
                    max: 100,
                  );
                },
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: _heightController,
                label: "Height",
                hint: "Enter your height",
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
                    fieldName: "Height",
                    min: 100,
                    max: 250,
                  );
                },
              ),

              const SizedBox(height: 14),

              _inputField(
                controller:
                _currentWeightController,
                label: "Current Weight",
                hint: "Enter current weight",
                suffix: "kg",
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
                    fieldName: "Current weight",
                    min: 25,
                    max: 500,
                  );
                },
              ),

              const SizedBox(height: 14),

              _inputField(
                controller:
                _targetWeightController,
                label: "Target Weight",
                hint: "Enter target weight",
                suffix: "kg",
                icon: Icons.flag_rounded,
                keyboardType:
                const TextInputType
                    .numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  return _validateNumber(
                    value,
                    fieldName: "Target weight",
                    min: 25,
                    max: 500,
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
                      : const Text(
                    "CONTINUE",
                    style: TextStyle(
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

          const Text(
            "Tell us about yourself",
            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "We will use this information "
                "to calculate BMI and weight progress.",
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
          title: "Lose Weight",
          subtitle:
          "Reduce body weight and fat",
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
          title: "Gain Weight",
          subtitle:
          "Increase healthy body weight",
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
          title: "Maintain Weight",
          subtitle:
          "Keep your weight stable",
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
            title: "Male",
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
            title: "Female",
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
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