import 'package:flutter/material.dart';
import '../../common/color_extention.dart';
import '../reminder/workout_reminder_view.dart';
import '../reminder/water_reminder_view.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3FD),

      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3FD),
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
          "Schedule & Reminders",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        children: [
          _buildHeader(),

          const SizedBox(height: 26),

          Text(
            "Your Reminders",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          _reminderCard(
            context: context,
            icon: Icons.fitness_center_rounded,
            title: "Workout Reminder",
            subtitle: "Set your daily workout time",
            enabled: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const WorkoutReminderView(),
                ),
              );
            },
          ),

          _reminderCard(
            context: context,
            icon: Icons.water_drop_rounded,
            title: "Water Reminder",
            subtitle: "Remember to drink enough water",
            enabled: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WaterReminderView(),
                ),
              );
            },
          ),

          _reminderCard(
            context: context,
            icon: Icons.restaurant_rounded,
            title: "Meal Reminder",
            subtitle: "Schedule breakfast, lunch and dinner",
            enabled: false,
          ),

          _reminderCard(
            context: context,
            icon: Icons.bedtime_rounded,
            title: "Sleep Reminder",
            subtitle: "Maintain a healthy sleeping routine",
            enabled: false,
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: TColor.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: TColor.primary,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    "Reminders help you stay consistent with your fitness routine.",
                    style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Stay on Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  "Create reminders and never miss your healthy routine.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reminderCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: enabled ? onTap : null,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),

        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: enabled
                ? TColor.primaryLight
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: enabled
                ? TColor.primary
                : Colors.grey,
          ),
        ),

        title: Text(
          title,
          style: TextStyle(
            color: enabled
                ? TColor.primaryText
                : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: TColor.sceondarText,
              fontSize: 12,
            ),
          ),
        ),

        trailing: enabled
            ? Icon(
          Icons.arrow_forward_ios_rounded,
          color: TColor.primary,
          size: 17,
        )
            : Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Soon",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}