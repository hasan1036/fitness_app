import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/workout_plan_data.dart';

class WorkoutDayView extends StatefulWidget {
  final int dayNumber;

  const WorkoutDayView({
    super.key,
    required this.dayNumber,
  });

  @override
  State<WorkoutDayView> createState() => _WorkoutDayViewState();
}

class _WorkoutDayViewState extends State<WorkoutDayView> {
  bool warmUp = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
    workoutPlanData[widget.dayNumber - 1];

    final List exercises = data["exercises"];

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// ===============================
            /// SCROLLABLE BODY
            /// ===============================

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ===============================
                    /// TOP HEADER
                    /// ===============================

                    Container(
                      height: 330,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            TColor.purpleSoft,
                            const Color(0xffF7F1FF),
                            Colors.white,
                          ],
                        ),
                      ),

                      child: Stack(
                        children: [

                          /// BACK BUTTON

                          Positioned(
                            left: 15,
                            top: 15,

                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              icon: const Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          /// HEADER IMAGE

                          Positioned(
                            right: 0,
                            bottom: 0,

                            child: Image.asset(
                              "assets/img/2.png",
                              width: 190,
                              height: 260,
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// TEXT

                          Positioned(
                            left: 25,
                            top: 95,

                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  "DAY ${data["day"]}",

                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                const Text(
                                  "LOSE WEIGHT IN 30 DAYS",

                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),

                                  decoration: BoxDecoration(
                                    color: TColor.primaryLight,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),

                                  child: Row(
                                    children: [

                                      Icon(
                                        Icons.lightbulb_outline,
                                        size: 18,
                                        color: TColor.primary,
                                      ),

                                      const SizedBox(width: 6),

                                      Text(
                                        "FAQ",
                                        style: TextStyle(
                                          color: TColor.primary,
                                          fontWeight:
                                          FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ===============================
                    /// BASIC + FOCUS AREA CARD
                    /// ===============================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Container(
                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: const Color(0xffF8F5FC),

                          borderRadius:
                          BorderRadius.circular(24),
                        ),

                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            /// BASIC

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    "Basic",
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  _buildInfoRow(
                                    icon:
                                    Icons.local_fire_department,
                                    text: data["calorie"],
                                  ),

                                  const SizedBox(height: 20),

                                  _buildInfoRow(
                                    icon:
                                    Icons.access_time_filled,
                                    text: data["time"],
                                  ),

                                  const SizedBox(height: 20),

                                  _buildInfoRow(
                                    icon:
                                    Icons.layers_rounded,
                                    text: data["level"],
                                  ),

                                  const SizedBox(height: 25),

                                  InkWell(
                                    onTap: () {},

                                    child: Row(
                                      children: [

                                        Text(
                                          "Workout settings",
                                          style: TextStyle(
                                            color: TColor.primary,
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),

                                        const Spacer(),

                                        const Icon(
                                          Icons
                                              .arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 15),

                            /// FOCUS AREA

                            Expanded(
                              child: Column(
                                children: [

                                  Text(
                                    "Focus Areas",
                                    style: TextStyle(
                                      color: TColor.primary,
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/img/me1.png",
                                      width: 110,
                                      height: 170,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// ===============================
                    /// WARM UP
                    /// ===============================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Row(
                        children: [

                          const Text(
                            "Warm-up",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const Spacer(),

                          Switch(
                            value: warmUp,

                            activeColor: TColor.primary,

                            onChanged: (value) {
                              setState(() {
                                warmUp = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ===============================
                    /// EXERCISES TITLE
                    /// ===============================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Row(
                        children: [

                          Text(
                            "${exercises.length}",

                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () {},

                            child: Text(
                              "Edit >",
                              style: TextStyle(
                                color: TColor.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ===============================
                    /// EXERCISE LIST
                    /// ===============================

                    ListView.builder(
                      shrinkWrap: true,

                      physics:
                      const NeverScrollableScrollPhysics(),

                      itemCount: exercises.length,

                      itemBuilder: (context, index) {

                        final exercise =
                        exercises[index];

                        return _buildExerciseItem(
                          exercise,
                        );
                      },
                    ),

                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),

            /// ===============================
            /// BOTTOM START BUTTON
            /// ===============================

            Container(
              color: Colors.white,

              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                18,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: () {

                    /// Next step:
                    /// Exercise Player page open হবে
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(22),
                    ),
                  ),

                  child: const Text(
                    "START",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// BASIC INFO ROW
  /// ===============================

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {

    return Row(
      children: [

        Icon(
          icon,
          color: Colors.grey,
          size: 25,
        ),

        const SizedBox(width: 12),

        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// ===============================
  /// EXERCISE ITEM
  /// ===============================

  Widget _buildExerciseItem(
      Map<String, dynamic> exercise,
      ) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      child: Row(
        children: [

          /// GIF

          Container(
            width: 120,
            height: 100,

            decoration: BoxDecoration(
              color: const Color(0xffFAF8FD),

              borderRadius:
              BorderRadius.circular(15),
            ),

            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(15),

              child: Image.asset(
                exercise["gif"],
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 20),

          /// NAME + VALUE

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  exercise["name"],

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  exercise["value"],

                  style: TextStyle(
                    fontSize: 17,
                    color: TColor.sceondarText,
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