import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../common/smooth_page_route.dart';
import '../../common_widget/round_button.dart';
import '../../service/user_profile_service.dart';
import '../menu/menu_view.dart';

class AboutYouView extends StatefulWidget {
  const AboutYouView({super.key});

  @override
  State<AboutYouView> createState() => _AboutYouViewState();
}

class _AboutYouViewState extends State<AboutYouView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  String _gender = 'male';
  String _goal = 'lose_weight';
  int _heightFeet = 5;
  int _heightInch = 6;
  bool _isSaving = false;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  String? _validateNumber(
    String? value, {
    required String label,
    required double min,
    required double max,
  }) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return '$label is required';

    final double? number = double.tryParse(text);
    if (number == null) return 'Enter a valid $label';
    if (number < min || number > max) {
      return '$label must be between ${min.toStringAsFixed(0)} and ${max.toStringAsFixed(0)}';
    }
    return null;
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final int age = int.parse(_ageController.text.trim());
    final double height = ((_heightFeet * 12) + _heightInch) * 2.54;
    final double weight = double.parse(_weightController.text.trim());
    final double targetWeight = double.parse(_targetWeightController.text.trim());

    if (_goal == 'lose_weight' && targetWeight >= weight) {
      _showMessage('Target weight must be lower than current weight.');
      return;
    }

    if (_goal == 'gain_weight' && targetWeight <= weight) {
      _showMessage('Target weight must be higher than current weight.');
      return;
    }

    setState(() => _isSaving = true);

    await UserProfileService.saveProfile(
      startWeight: weight,
      currentWeight: weight,
      targetWeight: targetWeight,
      heightCm: height,
      age: age,
      gender: _gender,
      goalType: _goal,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    final String fitnessLevel = await UserProfileService.getFitnessLevel();
    await UserProfileService.completeInitialSetup(fitnessLevel);
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      smoothPageRoute(const MenuView()),
      (route) => false,
    );
  }

  Future<void> _selectLevel(String level) async {
    await UserProfileService.completeInitialSetup(level);
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      smoothPageRoute(const MenuView()),
      (route) => false,
    );
  }

  Future<void> _showFitnessLevelDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final Size screenSize = MediaQuery.sizeOf(dialogContext);
        final bool compact = screenSize.width < 360 || screenSize.height < 650;
        final double dialogInset = screenSize.width < 360 ? 12 : 20;

        return PopScope(
          canPop: false,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: dialogInset,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(compact ? 20 : 26),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 460,
                maxHeight: screenSize.height * 0.88,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  compact ? 14 : 20,
                  compact ? 18 : 24,
                  compact ? 14 : 20,
                  compact ? 14 : 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: compact ? 48 : 58,
                      height: compact ? 48 : 58,
                      decoration: BoxDecoration(
                        color: TColor.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.fitness_center_rounded,
                        color: TColor.primary,
                        size: compact ? 25 : 30,
                      ),
                    ),
                    SizedBox(height: compact ? 10 : 14),
                    Text(
                      'Choose your fitness level',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: compact ? 18 : 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'We will use this level to personalize your workout plan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.sceondarText,
                        fontSize: compact ? 12 : 13,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: compact ? 14 : 20),
                    _levelButton(
                      title: 'Beginner',
                      subtitle: 'I am new to fitness training',
                      icon: Icons.directions_walk_rounded,
                      compact: compact,
                      onTap: () => _selectLevel('beginner'),
                    ),
                    SizedBox(height: compact ? 8 : 12),
                    _levelButton(
                      title: 'Intermediate',
                      subtitle: 'I exercise regularly',
                      icon: Icons.directions_run_rounded,
                      compact: compact,
                      onTap: () => _selectLevel('intermediate'),
                    ),
                    SizedBox(height: compact ? 8 : 12),
                    _levelButton(
                      title: 'Advanced',
                      subtitle: 'I am ready for intense workouts',
                      icon: Icons.local_fire_department_rounded,
                      compact: compact,
                      onTap: () => _selectLevel('advanced'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _levelButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool compact = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 13 : 16),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: TColor.purpleSoft,
            borderRadius: BorderRadius.circular(compact ? 13 : 16),
            border: Border.all(color: TColor.primary.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: compact ? 38 : 44,
                height: compact ? 38 : 44,
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(compact ? 10 : 13),
                ),
                child: Icon(
                  icon,
                  color: TColor.primary,
                  size: compact ? 20 : 24,
                ),
              ),
              SizedBox(width: compact ? 9 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 14 : 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: TColor.sceondarText,
                        fontSize: compact ? 11 : 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: compact ? 4 : 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: TColor.primary,
                size: compact ? 14 : 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: TColor.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        ),
        title: Text(
          'About You',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool compact = constraints.maxWidth < 360;
            final double horizontalPadding = compact ? 14 : 20;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      10,
                      horizontalPadding,
                      28,
                    ),
                    children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TColor.primary, TColor.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your details help us create a more suitable workout experience.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('Your goal'),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, goalConstraints) {
                  final bool stackGoals = goalConstraints.maxWidth < 390;
                  if (stackGoals) {
                    return Column(
                      children: [
                        _choiceChip('Lose weight', 'lose_weight'),
                        const SizedBox(height: 10),
                        _choiceChip('Keep fit', 'keep_fit'),
                        const SizedBox(height: 10),
                        _choiceChip('Gain weight', 'gain_weight'),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: _choiceChip('Lose weight', 'lose_weight')),
                      const SizedBox(width: 10),
                      Expanded(child: _choiceChip('Keep fit', 'keep_fit')),
                      const SizedBox(width: 10),
                      Expanded(child: _choiceChip('Gain weight', 'gain_weight')),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              _sectionTitle('Gender'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _genderButton('Male', 'male', Icons.male_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _genderButton('Female', 'female', Icons.female_rounded)),
                ],
              ),
              const SizedBox(height: 24),
              _sectionTitle('Body information'),
              const SizedBox(height: 12),
              _input(
                controller: _ageController,
                label: 'Age',
                suffix: 'years',
                icon: Icons.cake_rounded,
                validator: (value) => _validateNumber(value, label: 'Age', min: 12, max: 100),
              ),
              const SizedBox(height: 13),
              _heightPicker(),
              const SizedBox(height: 13),
              _input(
                controller: _weightController,
                label: 'Current weight',
                suffix: 'kg',
                icon: Icons.monitor_weight_outlined,
                validator: (value) => _validateNumber(value, label: 'Weight', min: 30, max: 300),
              ),
              const SizedBox(height: 13),
              _input(
                controller: _targetWeightController,
                label: 'Target weight',
                suffix: 'kg',
                icon: Icons.flag_rounded,
                validator: (value) => _validateNumber(value, label: 'Target weight', min: 30, max: 300),
              ),
              const SizedBox(height: 28),
              RoundButton(
                title: _isSaving ? 'Saving...' : 'Continue',
                onPressed: _isSaving ? () {} : _continue,
              ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: TColor.primaryText,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _choiceChip(String title, String value) {
    final bool selected = _goal == value;
    return InkWell(
      onTap: () => setState(() => _goal = value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? TColor.primary : TColor.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? TColor.primary : TColor.divider),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : TColor.primaryText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _genderButton(String title, String value, IconData icon) {
    final bool selected = _gender == value;
    return InkWell(
      onTap: () => setState(() => _gender = value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: selected ? TColor.primaryLight : TColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? TColor.primary : TColor.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: TColor.primary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _heightPicker() {
    return InkWell(
      onTap: _showHeightPicker,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TColor.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.height_rounded, color: TColor.primary),
            const SizedBox(width: 10),
            Text(
              'Height',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '$_heightFeet ft $_heightInch in',
              style: TextStyle(
                color: TColor.primary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: TColor.sceondarText,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHeightPicker() async {
    int tempFeet = _heightFeet;
    int tempInch = _heightInch;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: TColor.divider,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Select Height',
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$tempFeet ft $tempInch in',
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _heightWheel(
                            itemCount: 5,
                            initialItem: tempFeet - 4,
                            labelBuilder: (index) => '${index + 4} ft',
                            onChanged: (index) {
                              setSheetState(() => tempFeet = index + 4);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _heightWheel(
                            itemCount: 12,
                            initialItem: tempInch,
                            labelBuilder: (index) => '$index in',
                            onChanged: (index) {
                              setSheetState(() => tempInch = index);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _heightFeet = tempFeet;
                            _heightInch = tempInch;
                          });
                          Navigator.pop(sheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _heightWheel({
    required int itemCount,
    required int initialItem,
    required String Function(int index) labelBuilder,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: TColor.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: TColor.primaryLight,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: TColor.primary.withOpacity(0.22)),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: initialItem),
            itemExtent: 44,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.002,
            diameterRatio: 1.5,
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                return Center(
                  child: Text(
                    labelBuilder(index),
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon, color: TColor.primary),
        filled: true,
        fillColor: TColor.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: TColor.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: TColor.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: TColor.primary, width: 1.5),
        ),
      ),
    );
  }
}
