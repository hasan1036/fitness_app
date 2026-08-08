import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../service/user_profile_service.dart';
import '../menu/menu_view.dart';
import 'on_boarding_view.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();
    _openCorrectScreen();
  }

  Future<void> _openCorrectScreen() async {
    final bool completed = await UserProfileService.isInitialSetupCompleted();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => completed ? const MenuView() : const OnBoardingView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.primary,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
