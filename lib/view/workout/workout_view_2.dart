import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workoutfitnesstool/common_widget/round_button.dart';
import 'package:workoutfitnesstool/view/workout/workout_detail_view.dart';

import '../../common/color_extention.dart';

class WorkoutView2 extends StatefulWidget {
  const WorkoutView2({super.key});

  @override
  State<WorkoutView2> createState() => _WorkoutView2State();
}

class _WorkoutView2State extends State<WorkoutView2> {

  List workArr= [{
    "name":"Push-Up",
    "image":"assets/img/11.png",
  },

    {
      "name":"Leg extensiom",
      "image":"assets/img/2.png",

    },

    {
      "name":"Push-Up",
      "image":"assets/img/3.png",

    },
    {
      "name":"Climber",
      "image":"assets/img/1.png",
    }

  ];
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon: Image.asset("assets/img/leftarrow.png",
              width: 125,
              height: 125,
              color: Colors.white,
            )),
        title: Text("Workout",
          style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),),

      body: ListView.builder(
          padding:  EdgeInsets.zero,
          itemCount: workArr.length,
          itemBuilder: (context, index){
            var wObj = workArr[index] as Map ?? {};
            return Container(
              decoration: BoxDecoration(
                color: TColor.white,),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(wObj["image"].toString(),
                          height: media.width * 0.55,
                          width: media.width,
                          fit: BoxFit.cover),

                      Container(
                        width: media.width,
                        height: media.width * 0.55,
                        decoration:  BoxDecoration(
                            color: Colors.grey.withOpacity(0.7)
                        ),
                      ),

                      Image.asset("assets/img/play.png",
                          color: TColor.white,
                          height: 60,
                          width: 60,
                         ),


                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(wObj["name"],
                          style: TextStyle(
                              color: TColor.sceondarText,
                              fontSize: 20,
                              fontWeight: FontWeight.w700

                          ),
                        ),

                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder:

                          (context) => const WorkoutDetailView()));

                        },
                            icon: Image.asset("assets/img/more.png",
                              width: 25,
                              height: 25,
                            ))



                      ],
                    ),
                  ),


                ],
              ),
            );
          }),

      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: (){},
                child: Image.asset("assets/img/power.png", width: 25, height: 25,),

              ),
              InkWell(
                onTap: (){},
                child: Image.asset("assets/img/spoon.png", width: 25, height: 25,),

              ),
              InkWell(
                onTap: (){},
                child: Image.asset("assets/img/home.png", width: 25, height: 25,),

              ),
              InkWell(
                onTap: (){},
                child: Image.asset("assets/img/scale.png", width: 25, height: 25,),

              ),

              InkWell(
                onTap: (){},
                child: Image.asset("assets/img/more.png", width: 25, height: 25,),

              ),
            ],
          ),
        ),
      ),

    );
  }
}
