class ExtraExerciseItem {
  final String name;
  final String asset;
  final String duration;
  final String instruction;
  final String benefit;
  final List<String> focusAreas;

  const ExtraExerciseItem({
    required this.name,
    required this.asset,
    required this.duration,
    required this.instruction,
    required this.benefit,
    required this.focusAreas,
  });
}

class ExtraWorkoutItem {
  final String name;
  final String coverImage;
  final int minutes;
  final double kcal;
  final String level;
  final String instruction;
  final List<String> focusAreas;
  final List<ExtraExerciseItem> exercises;

  const ExtraWorkoutItem({
    required this.name,
    required this.coverImage,
    required this.minutes,
    required this.kcal,
    required this.level,
    required this.instruction,
    required this.focusAreas,
    required this.exercises,
  });
}

const _genericInstruction =
    'Move with control, keep your breathing steady, and stay inside a comfortable range of motion.';

ExtraExerciseItem _ex(
  String name,
  String duration, {
  String asset = 'assets/img/pic1.png',
  List<String> focus = const ['Full Body'],
  String benefit = 'Improves mobility, control, strength and overall fitness.',
}) {
  return ExtraExerciseItem(
    name: name,
    asset: asset,
    duration: duration,
    instruction: _genericInstruction,
    benefit: benefit,
    focusAreas: focus,
  );
}

List<ExtraExerciseItem> _beforeWarmup() => [
  _ex('ARM SWINGS WITH LATERAL STEPS', '00:30', asset: 'assets/img/pic1.png', focus: ['Shoulders', 'Legs']),
  _ex('SKIPPING WITHOUT ROPE', '00:30', asset: 'assets/img/pic2.png', focus: ['Cardio', 'Legs']),
  _ex('CROSS TOUCH AND REACH', '00:30', asset: 'assets/img/pic3.png', focus: ['Back', 'Hamstrings']),
  _ex('HIGH STEPPING', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Cardio']),
  _ex('ADDUCTOR STRETCH IN STANDING', '00:30', asset: 'assets/img/pic2.png', focus: ['Inner Thigh', 'Hips']),
];

List<ExtraExerciseItem> _sleepyStretch() => [
  _ex('LEFT QUAD STRETCH WITH WALL', '00:20', asset: 'assets/img/pic1.png', focus: ['Quadriceps']),
  _ex('RIGHT QUAD STRETCH WITH WALL', '00:20', asset: 'assets/img/pic1.png', focus: ['Quadriceps']),
  _ex('CALF STRETCH LEFT', '00:20', asset: 'assets/img/pic2.png', focus: ['Calves']),
  _ex('CALF STRETCH RIGHT', '00:20', asset: 'assets/img/pic2.png', focus: ['Calves']),
  _ex('TRICEPS STRETCH LEFT', '00:30', asset: 'assets/img/pic3.png', focus: ['Triceps', 'Shoulders']),
  _ex('TRICEPS STRETCH RIGHT', '00:30', asset: 'assets/img/pic3.png', focus: ['Triceps', 'Shoulders']),
  _ex('CHILD POSE', '00:30', asset: 'assets/img/pic1.png', focus: ['Back', 'Hips']),
  _ex('KNEE TO CHEST LEFT', '00:20', asset: 'assets/img/pic2.png', focus: ['Hips', 'Lower Back']),
  _ex('KNEE TO CHEST RIGHT', '00:20', asset: 'assets/img/pic2.png', focus: ['Hips', 'Lower Back']),
  _ex('SEATED FORWARD FOLD', '00:30', asset: 'assets/img/pic3.png', focus: ['Hamstrings']),
  _ex('SHOULDER ROLLS', '00:30', asset: 'assets/img/pic1.png', focus: ['Shoulders']),
  _ex('NECK SIDE STRETCH', '00:20', asset: 'assets/img/pic2.png', focus: ['Neck', 'Shoulders']),
  _ex('DEEP BREATH RELAX', '00:40', asset: 'assets/img/pic3.png', focus: ['Full Body']),
];

List<ExtraExerciseItem> _freshStartWarmup() => [
  _ex('CAT COW POSE', '00:40', asset: 'assets/img/pic1.png', focus: ['Back', 'Core']),
  _ex('BIRD DOG', '00:40', asset: 'assets/img/pic2.png', focus: ['Core', 'Back']),
  _ex('COBRAS', '00:40', asset: 'assets/img/pic3.png', focus: ['Back', 'Chest']),
  _ex('STRAIGHT ARM PLANK TO PIKE', '00:40', asset: 'assets/img/pic1.png', focus: ['Core', 'Shoulders']),
  _ex('WALK THE DOG', '00:40', asset: 'assets/img/pic2.png', focus: ['Hamstrings', 'Calves']),
  _ex('BUTT BRIDGE', '00:40', asset: 'assets/img/pic3.png', focus: ['Glutes', 'Core']),
  _ex('BENT LEG TWIST', '00:40', asset: 'assets/img/pic1.png', focus: ['Core', 'Lower Back']),
  _ex('LYING KNEE HUG', '00:40', asset: 'assets/img/pic2.png', focus: ['Hips', 'Lower Back']),
];

List<ExtraExerciseItem> _lazyMorningStretch() => [
  _ex('LYING KNEE HUG', '00:40', asset: 'assets/img/pic1.png', focus: ['Hips', 'Lower Back']),
  _ex('SPINE LUMBAR TWIST STRETCH RIGHT', '00:30', asset: 'assets/img/pic2.png', focus: ['Lower Back', 'Core']),
  _ex('SPINE LUMBAR TWIST STRETCH LEFT', '00:30', asset: 'assets/img/pic2.png', focus: ['Lower Back', 'Core']),
  _ex('SUPINE HAMSTRING STRETCH LEFT', '00:30', asset: 'assets/img/pic3.png', focus: ['Hamstrings']),
  _ex('SUPINE HAMSTRING STRETCH RIGHT', '00:30', asset: 'assets/img/pic3.png', focus: ['Hamstrings']),
  _ex('LYING BUTTERFLY STRETCH', '00:40', asset: 'assets/img/pic1.png', focus: ['Hips', 'Inner Thigh']),
  _ex('DOUBLE KNEES TO CHEST', '00:40', asset: 'assets/img/pic2.png', focus: ['Lower Back', 'Hips']),
  _ex('COBRA STRETCH', '00:30', asset: 'assets/img/pic3.png', focus: ['Back', 'Abs']),
  _ex('CAT COW POSE', '00:40', asset: 'assets/img/pic1.png', focus: ['Back', 'Core']),
  _ex('SEATED SIDE BEND LEFT', '00:30', asset: 'assets/img/pic2.png', focus: ['Side Body', 'Back']),
  _ex('SEATED SIDE BEND RIGHT', '00:30', asset: 'assets/img/pic2.png', focus: ['Side Body', 'Back']),
];

List<ExtraExerciseItem> _fatBurningHiit() => [
  _ex('SINGLE LEG HIP ROTATION', '00:30', asset: 'assets/img/pic1.png', focus: ['Hips', 'Core']),
  _ex('SQUAT REACH UPS', '00:30', asset: 'assets/img/pic2.png', focus: ['Legs', 'Shoulders']),
  _ex('SKATER JUMP', '00:30', asset: 'assets/img/pic3.png', focus: ['Legs', 'Cardio']),
  _ex('SIDE HOP', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Cardio']),
  _ex('ALTERNATING HOOKS', '00:30', asset: 'assets/img/pic2.png', focus: ['Arms', 'Core']),
  _ex('BUTT KICKS', '00:30', asset: 'assets/img/pic3.png', focus: ['Legs', 'Cardio']),
  _ex('JUMPING JACKS', '00:30', asset: 'assets/img/pic1.png', focus: ['Full Body', 'Cardio']),
  _ex('HIGH KNEES', '00:30', asset: 'assets/img/pic2.png', focus: ['Legs', 'Cardio']),
  _ex('MOUNTAIN CLIMBER', '00:30', asset: 'assets/img/pic3.png', focus: ['Core', 'Shoulders']),
  _ex('SQUATS', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Glutes']),
  _ex('LUNGES', '00:30', asset: 'assets/img/pic2.png', focus: ['Legs', 'Glutes']),
  _ex('PLANK', '00:30', asset: 'assets/img/pic3.png', focus: ['Core']),
  _ex('SIDE HOP', '00:10', asset: 'assets/img/pic1.png', focus: ['Legs', 'Cardio']),
  _ex('ALTERNATING HOOKS', '00:10', asset: 'assets/img/pic2.png', focus: ['Arms', 'Core']),
  _ex('BUTT KICKS', '00:10', asset: 'assets/img/pic3.png', focus: ['Legs', 'Cardio']),
  _ex('RIGHT QUAD STRETCH WITH WALL', '00:30', asset: 'assets/img/pic1.png', focus: ['Quadriceps']),
  _ex('LEFT QUAD STRETCH WITH WALL', '00:30', asset: 'assets/img/pic1.png', focus: ['Quadriceps']),
];

List<ExtraExerciseItem> _loseFatNoJumping() => [
  _ex('TOY SOLDIERS', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Core']),
  _ex('ALTERNATING HOOKS', '00:30', asset: 'assets/img/pic2.png', focus: ['Arms', 'Core']),
  _ex('UP AND DOWN PLANK', '00:30', asset: 'assets/img/pic3.png', focus: ['Core', 'Shoulders']),
  _ex('BICYCLE CRUNCHES', '00:30', asset: 'assets/img/pic1.png', focus: ['Abs', 'Core']),
  _ex('BUTT BRIDGE', '00:30', asset: 'assets/img/pic2.png', focus: ['Glutes', 'Core']),
  _ex('HEEL TOUCH', '00:30', asset: 'assets/img/pic3.png', focus: ['Abs']),
  _ex('SPIDERMAN PLANK', '00:30', asset: 'assets/img/pic1.png', focus: ['Core', 'Shoulders']),
  _ex('FROG PRESS', '00:30', asset: 'assets/img/pic2.png', focus: ['Abs', 'Hips']),
  _ex('BACKWARD LUNGE', '00:30', asset: 'assets/img/pic3.png', focus: ['Legs', 'Glutes']),
  _ex('FROGGY GLUTE LIFTS', '00:30', asset: 'assets/img/pic1.png', focus: ['Glutes']),
  _ex('MOUNTAIN CLIMBER', '00:30', asset: 'assets/img/pic2.png', focus: ['Core', 'Shoulders']),
  _ex('SQUAT TO REACH', '00:30', asset: 'assets/img/pic3.png', focus: ['Legs', 'Full Body']),
  _ex('REVERSE CRUNCHES', '00:30', asset: 'assets/img/pic1.png', focus: ['Abs']),
  _ex('DEAD BUG', '00:30', asset: 'assets/img/pic2.png', focus: ['Core']),
  _ex('BENT LEG TWIST', '00:30', asset: 'assets/img/pic3.png', focus: ['Core', 'Lower Back']),
  _ex('KNEE DRIVE', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Core']),
  _ex('STANDING SIDE CRUNCH', '00:30', asset: 'assets/img/pic2.png', focus: ['Obliques']),
  _ex('DONKEY KICKS LEFT', '00:20', asset: 'assets/img/pic3.png', focus: ['Glutes']),
  _ex('DONKEY KICKS RIGHT', '00:20', asset: 'assets/img/pic3.png', focus: ['Glutes']),
  _ex('IN & OUTS', '00:30', asset: 'assets/img/pic1.png', focus: ['Core', 'Shoulders']),
  _ex('PLANK', '00:30', asset: 'assets/img/pic2.png', focus: ['Core']),
  _ex('CHILD POSE', '00:30', asset: 'assets/img/pic3.png', focus: ['Back', 'Hips']),
];

List<ExtraExerciseItem> _calorieBurner30() => [
  _ex('SQUAT REACH UPS', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Shoulders']),
  _ex('TRICEPS KICKBACKS', 'x10', asset: 'assets/img/pic2.png', focus: ['Triceps']),
  _ex('DIAGONAL PLANK', '00:30', asset: 'assets/img/pic3.png', focus: ['Core', 'Shoulders']),
  _ex('INCHWORMS', '00:30', asset: 'assets/img/pic1.png', focus: ['Full Body', 'Hamstrings']),
  _ex('LONG ARM CRUNCHES', '00:30', asset: 'assets/img/pic2.png', focus: ['Abs']),
  _ex('REVERSE CRUNCHES', '00:30', asset: 'assets/img/pic3.png', focus: ['Abs']),
  _ex('BENT LEG TWIST', '00:30', asset: 'assets/img/pic1.png', focus: ['Core', 'Lower Back']),
  _ex('BICYCLE CRUNCHES', '00:30', asset: 'assets/img/pic2.png', focus: ['Abs', 'Core']),
  _ex('DEAD BUG', '00:30', asset: 'assets/img/pic3.png', focus: ['Core']),
  _ex('CROSS KNEE PLANK', '00:30', asset: 'assets/img/pic1.png', focus: ['Core', 'Shoulders']),
  _ex('FROGGY GLUTE LIFTS', '00:30', asset: 'assets/img/pic2.png', focus: ['Glutes']),
  _ex('FROG PRESS', '00:30', asset: 'assets/img/pic3.png', focus: ['Abs', 'Hips']),
  _ex('DONKEY KICKS LEFT', '00:20', asset: 'assets/img/pic1.png', focus: ['Glutes']),
  _ex('DONKEY KICKS RIGHT', '00:20', asset: 'assets/img/pic1.png', focus: ['Glutes']),
  _ex('IN & OUTS', '00:30', asset: 'assets/img/pic2.png', focus: ['Core', 'Shoulders']),
  _ex('MOUNTAIN CLIMBER', '00:30', asset: 'assets/img/pic3.png', focus: ['Core', 'Cardio']),
  _ex('JUMPING JACKS', '00:30', asset: 'assets/img/pic1.png', focus: ['Full Body', 'Cardio']),
  _ex('HIGH KNEES', '00:30', asset: 'assets/img/pic2.png', focus: ['Legs', 'Cardio']),
  _ex('LUNGES', '00:30', asset: 'assets/img/pic3.png', focus: ['Legs', 'Glutes']),
  _ex('SQUATS', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Glutes']),
  _ex('PUSH UPS', 'x10', asset: 'assets/img/pic2.png', focus: ['Chest', 'Triceps']),
  _ex('PLANK', '00:30', asset: 'assets/img/pic3.png', focus: ['Core']),
  _ex('LEG RAISES', '00:30', asset: 'assets/img/pic1.png', focus: ['Lower Abs']),
  _ex('SKATER JUMP', '00:30', asset: 'assets/img/pic2.png', focus: ['Legs', 'Cardio']),
  _ex('SIDE HOP', '00:30', asset: 'assets/img/pic3.png', focus: ['Legs', 'Cardio']),
  _ex('BUTT KICKS', '00:30', asset: 'assets/img/pic1.png', focus: ['Legs', 'Cardio']),
  _ex('ALTERNATING HOOKS', '00:30', asset: 'assets/img/pic2.png', focus: ['Arms', 'Core']),
  _ex('TOY SOLDIERS', '00:30', asset: 'assets/img/pic3.png', focus: ['Legs', 'Core']),
  _ex('UP AND DOWN PLANK', '00:30', asset: 'assets/img/pic1.png', focus: ['Core', 'Shoulders']),
  _ex('COBRA STRETCH', '00:30', asset: 'assets/img/pic2.png', focus: ['Back', 'Abs']),
];

List<ExtraExerciseItem> _strengthSet() => [
  _ex('PUSH UPS', '00:30', asset: 'assets/img/pic1.png', focus: ['Chest', 'Triceps']),
  _ex('SQUATS', '00:30', asset: 'assets/img/pic2.png', focus: ['Legs', 'Glutes']),
  _ex('REVERSE CRUNCHES', '00:30', asset: 'assets/img/pic3.png', focus: ['Abs']),
  _ex('PLANK', '00:30', asset: 'assets/img/pic1.png', focus: ['Core']),
  _ex('LUNGES', '00:30', asset: 'assets/img/pic2.png', focus: ['Legs']),
  _ex('LEG RAISES', '00:30', asset: 'assets/img/pic3.png', focus: ['Lower Abs']),
];

class ExtraWorkoutCatalog {
  static ExtraWorkoutItem fromCategoryItem({
    required String name,
    required String coverImage,
    required int minutes,
    required double kcal,
    required String level,
  }) {
    late final List<ExtraExerciseItem> exercises;
    late final String instruction;
    late final List<String> focus;

    if (name == 'Before Workout Warmup') {
      exercises = _beforeWarmup();
      instruction =
          "It's essential to warm up BEFORE workout. Only 5 simple movements in a few minutes will prepare your body for exercise.";
      focus = ['Full Body', 'Shoulders', 'Legs'];
    } else if (name == 'Sleepy Time Stretching') {
      exercises = _sleepyStretch();
      instruction =
          'Relax yourself and get ready for high-quality sleep with gentle full-body stretches.';
      focus = ['Full Body', 'Legs', 'Back'];
    } else if (name == 'Fresh Start Warm Up') {
      exercises = _freshStartWarmup();
      instruction =
          "Wake up your body before working out with an easy mobility-based warm-up routine.";
      focus = ['Core', 'Back', 'Shoulders'];
    } else if (name == 'Lazy Morning Stretching') {
      exercises = _lazyMorningStretch();
      instruction =
          'A gentle morning routine with slow stretches to reduce stiffness and help your body start moving.';
      focus = ['Core', 'Back', 'Hips'];
    } else if (name == 'Fat Burning HIIT') {
      exercises = _fatBurningHiit();
      instruction =
          'A super effective intense workout for calorie burn and full-body conditioning.';
      focus = ['Full Body', 'Core', 'Legs'];
    } else if (name == 'Lose Fat (NO JUMPING!)') {
      exercises = _loseFatNoJumping();
      instruction =
          'No jumping. A low-impact aerobic and strength routine that works the whole body and supports fat-burning progress.';
      focus = ['Full Body', 'Core', 'Legs'];
    } else if (name == '20 Min Body Calorie Burner') {
      exercises = _calorieBurner30();
      instruction =
          'A high-intensity full-body workout combining aerobic and bodyweight exercises for total-body conditioning.';
      focus = ['Full Body', 'Core', 'Legs'];
    } else if (name.contains('Stretch') || name.contains('Warm Up')) {
      exercises = _sleepyStretch().take(8).toList();
      instruction =
          'A gentle mobility routine to loosen the body and improve flexibility.';
      focus = ['Full Body', 'Mobility'];
    } else {
      exercises = _strengthSet();
      instruction =
          'A focused workout designed to improve strength, fitness and body control.';
      focus = ['Full Body', 'Core'];
    }

    return ExtraWorkoutItem(
      name: name,
      coverImage: coverImage,
      minutes: minutes,
      kcal: kcal,
      level: level,
      instruction: instruction,
      focusAreas: focus,
      exercises: exercises,
    );
  }
}
