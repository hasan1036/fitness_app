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
        "gif": "assets/webp/mountainclimber.webp",
      },
      {
        "name": "SQUATS",
        "value": "x16",
        "gif": "assets/webp/squats.webp",
      },
      {
        "name": "HIGH STEPPING",
        "value": "00:30",
        "gif": "assets/webp/legstepping.webp",
      },
      {
        "name": "PUSH-UPS",
        "value": "x10",
        "gif": "assets/webp/pushups.webp",
      },
      {
        "name": "REVERSE CRUNCHES",
        "value": "x16",
        "gif": "assets/webp/reversecruches.webp",
      },
      {
        "name": "PLANK",
        "value": "00:30",
        "gif": "assets/webp/plank.webp",
      },
      {
        "name": "LUNGES",
        "value": "x16",
        "gif": "assets/webp/lunges.webp",
      },
      {
        "name": "HIGH KNEES",
        "value": "00:30",
        "gif": "assets/webp/highknees.webp",
      },
      {
        "name": "LEG RAISES",
        "value": "x14",
        "gif": "assets/webp/legraises.webp",
      },
      {
        "name": "JUMPING JACKS",
        "value": "00:30",
        "gif": "assets/webp/jumping.webp",
      },
    ],

    /// SET 2
    [
      {
        "name": "JUMPING JACKS",
        "value": "00:30",
        "gif":"assets/webp/jumping.webp",
      },
      {
        "name": "LUNGES",
        "value": "x18",
        "gif": "assets/webp/lunges.webp",
      },
      {
        "name": "HIGH KNEES",
        "value": "00:35",
        "gif": "assets/webp/highknees.webp",
      },
      {
        "name": "SQUATS",
        "value": "x18",
        "gif": "assets/webp/squats.webp",
      },
      {
        "name": "PUSH-UPS",
        "value": "x12",
        "gif": "assets/webp/pushups.webp",
      },
      {
        "name": "PLANK",
        "value": "00:35",
        "gif": "assets/webp/plank.webp",
      },
      {
        "name": "LEG RAISES",
        "value": "x16",
        "gif": "assets/webp/legraises.webp",
      },
      {
        "name": "MOUNTAIN CLIMBER",
        "value": "00:35",
        "gif": "assets/webp/mountainclimber.webp",
      },
      {
        "name": "REVERSE CRUNCHES",
        "value": "x18",
        "gif": "assets/webp/reversecruches.webp",
      },
      {
        "name": "HIGH STEPPING",
        "value": "00:35",
        "gif": "assets/webp/legstepping.webp",
      },
    ],

    /// SET 3
    [
      {
        "name": "HIGH STEPPING",
        "value": "00:40",
        "gif": "assets/webp/legstepping.webp",
      },
      {
        "name": "SQUATS",
        "value": "x20",
        "gif": "assets/webp/squats.webp",
      },
      {
        "name": "MOUNTAIN CLIMBER",
        "value": "00:40",
        "gif": "assets/webp/mountainclimber.webp",
      },
      {
        "name": "LUNGES",
        "value": "x20",
        "gif": "assets/webp/lunges.webp",
      },
      {
        "name": "PUSH-UPS",
        "value": "x14",
        "gif": "assets/webp/pushups.webp",
      },
      {
        "name": "REVERSE CRUNCHES",
        "value": "x20",
        "gif": "assets/webp/reversecruches.webp",
      },
      {
        "name": "HIGH KNEES",
        "value": "00:40",
        "gif": "assets/webp/highknees.webp",
      },
      {
        "name": "LEG RAISES",
        "value": "x18",
        "gif": "assets/webp/legraises.webp",
      },
      {
        "name": "JUMPING JACKS",
        "value": "00:40",
        "gif": "assets/webp/jumping.webp",
      },
      {
        "name": "PLANK",
        "value": "00:40",
        "gif": "assets/webp/plank.webp",
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