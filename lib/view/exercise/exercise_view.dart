import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workoutfitnesstool/common_widget/round_button.dart';
import 'package:workoutfitnesstool/view/workout/workout_detail_view.dart';

import '../../common/color_extention.dart';
import '../../common_widget/tap_button.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseView();
}

class _ExerciseView extends State<ExerciseView> {

  int isActiveTab = 0;

  List workArr= [{
    "name":"Climber",
    "image":"assets/img/11.png",
    "title":"Workout",
    "subtitle":"Personalized workouts will help\n you fain strength"
  },
    {
      "name":"Climber",
      "image":"assets/img/2.png",
      "title":"Workout",
      "subtitle":"Personalized workouts will help\n you fain strength"
    },

    {
      "name":"Climber",
      "image":"assets/img/3.png",
      "title":"Workout",
      "subtitle":"Personalized workouts will help\n you fain strength"
    },
    {
      "name":"Climber",
      "image":"assets/img/1.png",
      "title":"Workout",
      "subtitle":"Personalized workouts will help\n you fain strength"
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
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon: Image.asset("assets/img/leftarrow.png",
              width: 125,
              height: 125,
              color: Colors.black,
            )),
        title: Text("Exercise",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),),

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: TColor.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2)
                )
              ]
            ),

            child: Row(
              children: [
                Expanded(
                    child: TapButton(
                        title: "Full Body",
                        isActive: isActiveTab == 0,
                        onPressed: (){
                          setState(() {
                            isActiveTab =0;
                          });
                        })
                ),
                Expanded(
                    child: TapButton(
                        title: "Foot",
                        isActive: isActiveTab == 1,
                        onPressed: (){
                          setState(() {
                            isActiveTab =1;
                          });
                        })
                ),
                Expanded(
                    child: TapButton(
                        title: "Arm",
                        isActive: isActiveTab == 2,
                        onPressed: (){
                          setState(() {
                            isActiveTab =2;
                          });
                        })
                ),
                Expanded(
                    child: TapButton(
                        title: "Body",
                        isActive: isActiveTab == 3,
                        onPressed: (){
                          setState(() {
                            isActiveTab =3;
                          });
                        })
                ),




              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                itemCount: workArr.length,
                itemBuilder: (context, index){
                  var wObj = workArr[index] as Map ?? {};
                  return Container(
                    margin:  const EdgeInsets.symmetric(vertical: 10),
                    height: media.width * 0.5,
                    decoration: BoxDecoration(
                      color: TColor.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
            
                    clipBehavior: Clip.antiAlias,
            
                    child: Stack(
                      children: [
                        Image.asset(wObj["image"].toString(),
                            height: media.width * 0.5,
                            width: media.width,
                            fit: BoxFit.cover),
            
                        Container(
                          width: media.width,
                          height: media.width * 0.5,
                          decoration:  BoxDecoration(
                              color: index % 2 ==0 ? Colors.grey.withOpacity(0.7): TColor.grey.withOpacity(0.25)
            
                          ),
                        ),
            
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
            
                              Text(wObj["title"],
                                style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
            
                                ),
                              ),
            
                              Text(wObj["name"],
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
            
                                ),
                              ),
                              Text(wObj["subtitle"],
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
            
                                ),
                              ),
            
                              const Spacer(),
            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 25,
                                    child: RoundButton(title: "see more",
                                        fontSize: 14,
                                        fontweight: FontWeight.w500,
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder:
            
                                              (context) => const WorkoutDetailView()));
            
                                        }),
                                  ),
                                ],
                              )
            
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),

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
