import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../data/exercise_details_data.dart';

class EditPlanView extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;

  const EditPlanView({
    super.key,
    required this.exercises,
  });

  @override
  State<EditPlanView> createState() => _EditPlanViewState();
}

class _EditPlanViewState extends State<EditPlanView> {
  late List<Map<String, dynamic>> exercises;
  late List<Map<String, dynamic>> defaultExercises;

  @override
  void initState() {
    super.initState();

    exercises = widget.exercises
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    defaultExercises = widget.exercises
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  bool _isRepsExercise(String value) {
    return value.toLowerCase().startsWith('x');
  }

  int _getReps(String value) {
    return int.tryParse(
      value.toLowerCase().replaceAll('x', '').trim(),
    ) ??
        1;
  }

  int _getSeconds(String value) {
    final List<String> parts = value.split(':');

    if (parts.length != 2) {
      return 30;
    }

    final int minutes = int.tryParse(parts[0]) ?? 0;
    final int seconds = int.tryParse(parts[1]) ?? 0;

    return (minutes * 60) + seconds;
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _increaseValue(int index) {
    final String value = exercises[index]['value'].toString();

    setState(() {
      if (_isRepsExercise(value)) {
        final int reps = _getReps(value);
        exercises[index]['value'] = 'x${reps + 1}';
      } else {
        final int seconds = _getSeconds(value);
        exercises[index]['value'] = _formatTime(seconds + 5);
      }
    });
  }

  void _decreaseValue(int index) {
    final String value = exercises[index]['value'].toString();

    setState(() {
      if (_isRepsExercise(value)) {
        final int reps = _getReps(value);

        if (reps > 1) {
          exercises[index]['value'] = 'x${reps - 1}';
        }
      } else {
        final int seconds = _getSeconds(value);

        if (seconds > 5) {
          exercises[index]['value'] = _formatTime(seconds - 5);
        }
      }
    });
  }

  void _replaceExercise(int index) {
    final List<Map<String, dynamic>> availableExercises =
    exerciseDetailsData.values
        .map(
          (item) => Map<String, dynamic>.from(item),
    )
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.72,
            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Replace Exercise',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: availableExercises.length,
                    separatorBuilder: (_, __) {
                      return const Divider(height: 1);
                    },
                    itemBuilder: (context, replaceIndex) {
                      final Map<String, dynamic> newExercise =
                      availableExercises[replaceIndex];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F5FC),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              newExercise['gif'].toString(),
                              fit: BoxFit.contain,
                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Icon(
                                  Icons.fitness_center,
                                  color: TColor.primary,
                                );
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          newExercise['name'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          newExercise['value'].toString(),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                          color: TColor.primary,
                        ),
                        onTap: () {
                          final String oldValue =
                          exercises[index]['value'].toString();

                          setState(() {
                            exercises[index] = {
                              'name': newExercise['name'],
                              'gif': newExercise['gif'],

                              // পুরনো exercise time/reps একই ধরনের হলে
                              // সেটি রাখা হবে।
                              'value': _isRepsExercise(oldValue) ==
                                  _isRepsExercise(
                                    newExercise['value'].toString(),
                                  )
                                  ? oldValue
                                  : newExercise['value'],
                            };
                          });

                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetPlan() {
    setState(() {
      exercises = defaultExercises
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    });
  }

  void _savePlan() {
    final List<Map<String, dynamic>> result = exercises
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    Navigator.pop(context, result);
  }

  Future<bool> _onWillPop() async {
    final bool? leave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text(
            'If you do not save, your changes wont be kept.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              final bool canLeave = await _onWillPop();

              if (canLeave && context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'Edit Plan',
            style: TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _resetPlan,
              child: Text(
                'Reset',
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xffFFF3D9),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xffE49B16),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Change the order of the exercises by dragging.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  14,
                  14,
                  100,
                ),
                itemCount: exercises.length,
                buildDefaultDragHandles: false,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }

                    final Map<String, dynamic> movedExercise =
                    exercises.removeAt(oldIndex);

                    exercises.insert(
                      newIndex,
                      movedExercise,
                    );
                  });
                },
                itemBuilder: (context, index) {
                  final Map<String, dynamic> exercise =
                  exercises[index];

                  return Container(
                    key: ValueKey(
                      '${exercise['name']}_$index',
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.04,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Icon(
                              Icons.drag_indicator_rounded,
                              color: Colors.grey,
                              size: 28,
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F5FC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              exercise['gif'].toString(),
                              fit: BoxFit.contain,
                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Icon(
                                  Icons.fitness_center,
                                  color: TColor.primary,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise['name'].toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  _ValueButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      _decreaseValue(index);
                                    },
                                  ),

                                  Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 62,
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      exercise['value'].toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),

                                  _ValueButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      _increaseValue(index);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        IconButton(
                          tooltip: 'Replace exercise',
                          onPressed: () {
                            _replaceExercise(index);
                          },
                          icon: Icon(
                            Icons.sync_rounded,
                            color: TColor.primary,
                            size: 27,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              16,
            ),
            child: SizedBox(
              height: 58,
              child: ElevatedButton(
                onPressed: _savePlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ValueButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ValueButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xffF0E7FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: TColor.primary,
        ),
      ),
    );
  }
}