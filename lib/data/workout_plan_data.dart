final List<Map<String, dynamic>> workoutPlanData =
List.generate(30, (index) {

  final int day = index + 1;

  /// 3 ধরনের exercise set
  final List<List<Map<String, dynamic>>> exerciseSets = [

    /// SET 1
    [
      {
        "name": "MOUNTAIN CLIMBER",
        "value": "00:30",
        "gif": "assets/gif/mountain_climber.gif",
      },
      {
        "name": "SQUATS",
        "value": "x16",
        "gif": "assets/gif/squats.gif",
      },
      {
        "name": "HIGH STEPPING",
        "value": "00:30",
        "gif": "assets/gif/high_stepping.gif",
      },
      {
        "name": "PUSH-UPS",
        "value": "x10",
        "gif": "assets/gif/push_up.gif",
      },
      {
        "name": "REVERSE CRUNCHES",
        "value": "x16",
        "gif": "assets/gif/reverse_crunch.gif",
      },
      {
        "name": "PLANK",
        "value": "00:30",
        "gif": "assets/gif/plank.gif",
      },
      {
        "name": "LUNGES",
        "value": "x16",
        "gif": "assets/gif/lunges.gif",
      },
      {
        "name": "HIGH KNEES",
        "value": "00:30",
        "gif": "assets/gif/high_knees.gif",
      },
      {
        "name": "LEG RAISES",
        "value": "x14",
        "gif": "assets/gif/leg_raises.gif",
      },
      {
        "name": "JUMPING JACKS",
        "value": "00:30",
        "gif": "assets/gif/jumping_jacks.gif",
      },
    ],

    /// SET 2
    [
      {
        "name": "JUMPING JACKS",
        "value": "00:30",
        "gif": "assets/gif/jumping_jacks.gif",
      },
      {
        "name": "LUNGES",
        "value": "x18",
        "gif": "assets/gif/lunges.gif",
      },
      {
        "name": "HIGH KNEES",
        "value": "00:35",
        "gif": "assets/gif/high_knees.gif",
      },
      {
        "name": "SQUATS",
        "value": "x18",
        "gif": "assets/gif/squats.gif",
      },
      {
        "name": "PUSH-UPS",
        "value": "x12",
        "gif": "assets/gif/push_up.gif",
      },
      {
        "name": "PLANK",
        "value": "00:35",
        "gif": "assets/gif/plank.gif",
      },
      {
        "name": "LEG RAISES",
        "value": "x16",
        "gif": "assets/gif/leg_raises.gif",
      },
      {
        "name": "MOUNTAIN CLIMBER",
        "value": "00:35",
        "gif": "assets/gif/mountain_climber.gif",
      },
      {
        "name": "REVERSE CRUNCHES",
        "value": "x18",
        "gif": "assets/gif/reverse_crunch.gif",
      },
      {
        "name": "HIGH STEPPING",
        "value": "00:35",
        "gif": "assets/gif/high_stepping.gif",
      },
    ],

    /// SET 3
    [
      {
        "name": "HIGH STEPPING",
        "value": "00:40",
        "gif": "assets/gif/high_stepping.gif",
      },
      {
        "name": "SQUATS",
        "value": "x20",
        "gif": "assets/gif/squats.gif",
      },
      {
        "name": "MOUNTAIN CLIMBER",
        "value": "00:40",
        "gif": "assets/gif/mountain_climber.gif",
      },
      {
        "name": "LUNGES",
        "value": "x20",
        "gif": "assets/gif/lunges.gif",
      },
      {
        "name": "PUSH-UPS",
        "value": "x14",
        "gif": "assets/gif/push_up.gif",
      },
      {
        "name": "REVERSE CRUNCHES",
        "value": "x20",
        "gif": "assets/gif/reverse_crunch.gif",
      },
      {
        "name": "HIGH KNEES",
        "value": "00:40",
        "gif": "assets/gif/high_knees.gif",
      },
      {
        "name": "LEG RAISES",
        "value": "x18",
        "gif": "assets/gif/leg_raises.gif",
      },
      {
        "name": "JUMPING JACKS",
        "value": "00:40",
        "gif": "assets/gif/jumping_jacks.gif",
      },
      {
        "name": "PLANK",
        "value": "00:40",
        "gif": "assets/gif/plank.gif",
      },
    ],
  ];

  return {
    "day": day,

    "calorie":
    "${(68.1 + (index * 1.5)).toStringAsFixed(1)} kcal",

    "time":
    "${5 + (index ~/ 5)} min",

    "level": day <= 10
        ? "Beginner"
        : day <= 20
        ? "Intermediate"
        : "Advanced",

    /// Day অনুযায়ী exercise set ঘুরে ঘুরে আসবে
    "exercises":
    exerciseSets[index % exerciseSets.length],
  };
});