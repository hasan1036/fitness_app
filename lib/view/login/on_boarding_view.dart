import 'package:flutter/material.dart';
import 'package:workoutfitnesstool/common/color_extention.dart';

import '../../common_widget/round_button.dart';
import '../menu/menu_view.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() =>
      _OnBoardingViewState();
}

class _OnBoardingViewState
    extends State<OnBoardingView> {
  final PageController controller = PageController();

  int selectPage = 0;

  final List<Map<String, String>> pageArr = const [
    {
      "title": "Have a good health",
      "subtitle":
      "Being healthy is everything. Without good health, nothing feels complete.",
      "image": "assets/img/on_board_1.png",
    },
    {
      "title": "Be stronger",
      "subtitle":
      "Take 30 minutes for exercise every day to stay physically fit and healthy.",
      "image": "assets/img/on_board_2.png",
    },
    {
      "title": "Have a nice body",
      "subtitle":
      "Build strength, improve sleep, support healthy weight and feel more confident every day.",
      "image": "assets/img/on_board_3.png",
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!mounted) return;

    setState(() {
      selectPage = index;
    });
  }

  void _openHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MenuView(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: TColor.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/img/on_board_bg.png",
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: pageArr.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      final Map<String, String> page =
                      pageArr[index];

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final double imageSize =
                          (constraints.maxHeight * 0.52)
                              .clamp(
                            210.0,
                            media.width * 0.78,
                          );

                          return SingleChildScrollView(
                            padding:
                            const EdgeInsets.fromLTRB(
                              24,
                              18,
                              24,
                              16,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight:
                                constraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    page["title"] ?? "",
                                    textAlign:
                                    TextAlign.center,
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 24,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Image.asset(
                                    page["image"] ?? "",
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    page["subtitle"] ?? "",
                                    textAlign:
                                    TextAlign.center,
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 6,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: List.generate(
                      pageArr.length,
                          (index) {
                        final bool selected =
                            selectPage == index;

                        return AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 220,
                          ),
                          margin:
                          const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          width: selected ? 24 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: selected
                                ? TColor.white
                                : TColor.white
                                .withOpacity(0.45),
                            borderRadius:
                            BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    25,
                    12,
                    25,
                    18,
                  ),
                  child: RoundButton(
                    title: 'Start',
                    type:
                    RoundButtonType.primaryText,
                    onPressed: _openHome,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
