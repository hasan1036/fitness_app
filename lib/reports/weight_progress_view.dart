import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/color_extention.dart';
import '../service/weight_unit_service.dart';
import '../l10n/app_localizations.dart';

class WeightProgressView extends StatefulWidget {
  const WeightProgressView({super.key});

  @override
  State<WeightProgressView> createState() => _WeightProgressViewState();
}

class _WeightProgressViewState extends State<WeightProgressView> {
  static const String _currentWeightKey = 'current_weight';
  static const String _startWeightKey = 'start_weight';
  static const String _goalWeightKey = 'goal_weight';
  static const String _weightHistoryKey = 'weight_history';

  double? startWeight;
  double? currentWeight;
  double? goalWeight;
  bool isLoading = true;
  String weightUnit = WeightUnitService.kilograms;

  List<Map<String, dynamic>> weightHistory = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _loadWeightData();
  }

  Future<void> _loadWeightData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedUnit = await WeightUnitService.getUnit();

    final double? savedCurrentWeight = prefs.getDouble(_currentWeightKey);
    double? savedStartWeight = prefs.getDouble(_startWeightKey);
    final double? savedGoalWeight = prefs.getDouble(_goalWeightKey);
    final List<String> savedHistory =
        prefs.getStringList(_weightHistoryKey) ?? <String>[];

    final List<Map<String, dynamic>> parsedHistory = <Map<String, dynamic>>[];

    for (final String item in savedHistory) {
      final List<String> parts = item.split('|');
      if (parts.length < 2) continue;

      final double? weight = double.tryParse(parts[0]);
      final DateTime? date = DateTime.tryParse(parts[1]);

      if (weight == null || date == null) continue;

      parsedHistory.add(<String, dynamic>{
        'weight': weight,
        'date': parts[1],
      });
    }

    parsedHistory.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      return b['date'].toString().compareTo(a['date'].toString());
    });

    // পুরোনো user-এর start weight save না থাকলে oldest history/current weight ব্যবহার করবে।
    if (savedStartWeight == null) {
      if (parsedHistory.isNotEmpty) {
        savedStartWeight =
            (parsedHistory.last['weight'] as num).toDouble();
      } else {
        savedStartWeight = savedCurrentWeight;
      }

      if (savedStartWeight != null) {
        await prefs.setDouble(_startWeightKey, savedStartWeight);
      }
    }

    if (!mounted) return;

    setState(() {
      startWeight = savedStartWeight;
      currentWeight = savedCurrentWeight;
      goalWeight = savedGoalWeight;
      weightHistory = parsedHistory;
      weightUnit = savedUnit;
      isLoading = false;
    });
  }

  Future<void> _saveWeightData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (startWeight == null) {
      await prefs.remove(_startWeightKey);
    } else {
      await prefs.setDouble(_startWeightKey, startWeight!);
    }

    if (currentWeight == null) {
      await prefs.remove(_currentWeightKey);
    } else {
      await prefs.setDouble(_currentWeightKey, currentWeight!);
    }

    if (goalWeight == null) {
      await prefs.remove(_goalWeightKey);
    } else {
      await prefs.setDouble(_goalWeightKey, goalWeight!);
    }

    final List<String> history = weightHistory.map((item) {
      return '${item['weight']}|${item['date']}';
    }).toList();

    await prefs.setStringList(_weightHistoryKey, history);
  }

  String _todayDate() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _formatDate(String savedDate) {
    final DateTime? date = DateTime.tryParse(savedDate);
    if (date == null) return savedDate;

    const List<String> monthKeys = <String>[
      'januaryShort',
      'februaryShort',
      'marchShort',
      'aprilShort',
      'mayShort',
      'juneShort',
      'julyShort',
      'augustShort',
      'septemberShort',
      'octoberShort',
      'novemberShort',
      'decemberShort',
    ];

    return '${date.day} ${context.tr(monthKeys[date.month - 1])} ${date.year}';
  }

  double get totalLost {
    if (startWeight == null || currentWeight == null) return 0;

    final double lost = startWeight! - currentWeight!;
    return lost > 0 ? lost : 0;
  }

  double? get remainingWeight {
    if (currentWeight == null || goalWeight == null) return null;
    final double remaining = currentWeight! - goalWeight!;
    return remaining > 0 ? remaining : 0;
  }

  String _weightText(double? value) {
    return value == null
        ? '--'
        : WeightUnitService.fromKg(value, weightUnit).toStringAsFixed(1);
  }

  String get _unitLabel => WeightUnitService.label(weightUnit);

  Future<double?> _openWeightInput({
    required String title,
    required String hint,
    double? initialValue,
  }) async {
    String inputValue = '';
    String? errorText;

    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        autofocus: true,
                        initialValue: initialValue == null
                            ? null
                            : WeightUnitService.fromKg(initialValue, weightUnit).toStringAsFixed(1),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (String value) {
                          inputValue = value.trim();
                          if (errorText != null) {
                            setSheetState(() {
                              errorText = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: context.tr('weight'),
                          hintText: hint,
                          suffixText: _unitLabel,
                          errorText: errorText,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(sheetContext);
                              },
                              child: Text(context.tr('cancel')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final String raw = inputValue.isEmpty &&
                                    initialValue != null
                                    ? initialValue.toString()
                                    : inputValue;
                                final double? value = double.tryParse(raw);

                                final double minValue = weightUnit == WeightUnitService.pounds ? 44 : 20;
                                final double maxValue = weightUnit == WeightUnitService.pounds ? 1100 : 500;
                                if (value == null || value < minValue || value > maxValue) {
                                  setSheetState(() {
                                    errorText =
                                    '${context.tr('enterValidWeightIn')} $_unitLabel';
                                  });
                                  return;
                                }

                                Navigator.pop(
                                  sheetContext,
                                  WeightUnitService.toKg(value, weightUnit),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColor.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(context.tr('save')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAddWeightDialog() async {
    final double? result = await _openWeightInput(
      title: currentWeight == null ? context.tr('addCurrentWeight') : context.tr('updateWeight'),
      hint: context.tr('enterCurrentWeight'),
      initialValue: currentWeight,
    );

    if (result == null || !mounted) return;

    final String today = _todayDate();
    final int existingIndex = weightHistory.indexWhere(
          (Map<String, dynamic> item) => item['date'] == today,
    );

    setState(() {
      // Option A: প্রথম add করা weight-ই start weight হবে।
      startWeight ??= result;
      currentWeight = result;

      if (existingIndex >= 0) {
        weightHistory[existingIndex] = <String, dynamic>{
          'weight': result,
          'date': today,
        };
      } else {
        weightHistory.insert(0, <String, dynamic>{
          'weight': result,
          'date': today,
        });
      }
    });

    await _saveWeightData();
  }

  Future<void> _showGoalWeightDialog() async {
    final double? result = await _openWeightInput(
      title: goalWeight == null ? context.tr('setTargetWeight') : context.tr('updateTargetWeight'),
      hint: context.tr('enterTargetWeight'),
      initialValue: goalWeight,
    );

    if (result == null || !mounted) return;

    setState(() {
      goalWeight = result;
    });

    await _saveWeightData();
  }


  void _syncWeightsFromHistory() {
    weightHistory.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      return b['date'].toString().compareTo(a['date'].toString());
    });

    if (weightHistory.isEmpty) {
      startWeight = null;
      currentWeight = null;
      return;
    }

    currentWeight =
        (weightHistory.first['weight'] as num).toDouble();
    startWeight =
        (weightHistory.last['weight'] as num).toDouble();
  }

  Future<void> _showHistoryActions({
    required double weight,
    required String date,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${WeightUnitService.fromKg(weight, weightUnit).toStringAsFixed(1)} $_unitLabel',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.edit_rounded, color: TColor.primary),
                  title: Text(
                    context.tr('editWeight'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _editHistoryEntry(
                      oldWeight: weight,
                      date: date,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  title: Text(
                    context.tr('deleteEntry'),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmDeleteHistoryEntry(date);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _editHistoryEntry({
    required double oldWeight,
    required String date,
  }) async {
    final double? result = await _openWeightInput(
      title: context.tr('editWeight'),
      hint: context.tr('enterCorrectedWeight'),
      initialValue: oldWeight,
    );

    if (result == null || !mounted) return;

    final int index = weightHistory.indexWhere(
          (Map<String, dynamic> item) => item['date'] == date,
    );

    if (index < 0) return;

    setState(() {
      weightHistory[index] = <String, dynamic>{
        'weight': result,
        'date': date,
      };
      _syncWeightsFromHistory();
    });

    await _saveWeightData();
  }

  Future<void> _confirmDeleteHistoryEntry(String date) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.tr('deleteWeightEntryTitle')),
          content: Text(
            context.tr('deleteWeightEntryMessage'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.tr('cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(context.tr('delete')),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    setState(() {
      weightHistory.removeWhere(
            (Map<String, dynamic> item) => item['date'] == date,
      );
      _syncWeightsFromHistory();
    });

    await _saveWeightData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        ),
        title: Text(
          context.tr('weightProgress'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWeightDialog,
        backgroundColor: TColor.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          currentWeight == null
              ? context.tr('addWeight')
              : context.tr('updateWeight'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: TColor.primary))
          : RefreshIndicator(
        color: TColor.primary,
        onRefresh: _loadWeightData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
          children: <Widget>[
            _buildTopCard(),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: _summaryCard(
                    icon: Icons.monitor_weight_rounded,
                    title: context.tr('current'),
                    value: '${_weightText(currentWeight)} $_unitLabel',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    icon: Icons.local_fire_department_rounded,
                    title: context.tr('totalLost'),
                    value: '${WeightUnitService.fromKg(totalLost, weightUnit).toStringAsFixed(1)} $_unitLabel',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              context.tr('weightTrend'),
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            _buildWeightTrendCard(),
            const SizedBox(height: 28),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    context.tr('weightHistory'),
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _showAddWeightDialog,
                  child: Text(
                    currentWeight == null ? context.tr('addNew') : context.tr('updateToday'),
                    style: TextStyle(
                      color: TColor.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (weightHistory.isEmpty)
              _buildEmptyHistory()
            else
              ...weightHistory.map(
                    (Map<String, dynamic> item) => _buildHistoryCard(
                  weight: (item['weight'] as num).toDouble(),
                  date: item['date'].toString(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    final String remainingText = remainingWeight == null
        ? '-- $_unitLabel'
        : '${WeightUnitService.fromKg(remainingWeight!, weightUnit).toStringAsFixed(1)} $_unitLabel';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[TColor.primary, const Color(0xff8748E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr('currentWeight'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                _weightText(currentWeight),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 43,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  bottom: 7,
                ),
                child: Text(
                  _unitLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: context.tr('updateWeight'),
                onPressed: _showAddWeightDialog,
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _topSmallStat(
                  title: context.tr('targetWeight'),
                  value: '${_weightText(goalWeight)} $_unitLabel',
                  icon: Icons.flag_rounded,
                  buttonText: goalWeight == null ? context.tr('setTarget') : context.tr('edit'),
                  onTap: _showGoalWeightDialog,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _topSmallStat(
                  title: context.tr('remaining'),
                  value: remainingText,
                  icon: Icons.trending_down_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topSmallStat({
    required String title,
    required String value,
    required IconData icon,
    String? buttonText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Colors.white, size: 22),
                if (buttonText != null) ...<Widget>[
                  const Spacer(),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: TColor.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: TColor.primary),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTrendCard() {
    final List<Map<String, dynamic>> displayData =
    weightHistory.take(7).toList().reversed.toList();

    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: displayData.isEmpty
          ? Center(
        child: Text(
          context.tr('addWeightEntriesTrend'),
          textAlign: TextAlign.center,
          style: TextStyle(color: TColor.sceondarText, fontSize: 13),
        ),
      )
          : CustomPaint(
        painter: _WeightChartPainter(
          data: displayData,
          primaryColor: TColor.primary,
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required double weight,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () {
          _showHistoryActions(
            weight: weight,
            date: date,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TColor.primaryLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.monitor_weight_rounded,
                  color: TColor.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${WeightUnitService.fromKg(weight, weightUnit).toStringAsFixed(1)} $_unitLabel',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(date),
                      style: TextStyle(
                        color: TColor.sceondarText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (date == _todayDate()) ...<Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    context.tr('today'),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.more_vert_rounded,
                color: TColor.sceondarText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: TColor.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.monitor_weight_outlined,
              color: TColor.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('noWeightHistory'),
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          Text(
            context.tr('tapAddWeightFirstEntry'),
            textAlign: TextAlign.center,
            style: TextStyle(color: TColor.sceondarText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color primaryColor;

  _WeightChartPainter({
    required this.data,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final double y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final List<double> weights = data.map((Map<String, dynamic> item) {
      return (item['weight'] as num).toDouble();
    }).toList();

    double minWeight = weights.reduce((double a, double b) => a < b ? a : b);
    double maxWeight = weights.reduce((double a, double b) => a > b ? a : b);

    if (minWeight == maxWeight) {
      minWeight -= 1;
      maxWeight += 1;
    }

    final Path path = Path();
    final List<Offset> points = <Offset>[];

    for (int i = 0; i < weights.length; i++) {
      final double x = weights.length == 1
          ? size.width / 2
          : size.width * i / (weights.length - 1);

      final double normalized =
          (weights[i] - minWeight) / (maxWeight - minWeight);
      final double y =
          size.height - (normalized * (size.height - 24)) - 12;
      final Offset point = Offset(x, y);
      points.add(point);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final Paint linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    final Paint pointPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    final Paint pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final Offset point in points) {
      canvas.drawCircle(point, 6, pointBorderPaint);
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.primaryColor != primaryColor;
  }
}
