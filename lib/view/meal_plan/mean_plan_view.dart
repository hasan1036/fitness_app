import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workoutfitnesstool/common_widget/round_button.dart';
import 'package:workoutfitnesstool/view/workout/workout_detail_view.dart';

import '../../common/color_extention.dart';
import '../../common_widget/tap_button.dart';

class MealPlanView extends StatefulWidget {
  const MealPlanView({super.key});

  @override
  State<MealPlanView> createState() => _MealPlanView();
}

class _MealPlanView extends State<MealPlanView> {

  int isActiveTab = 0;

  List planArr= [
    {
    "name":"Breakfast",
    "image":"assets/img/breakfast1.png",
    "title":"Meal Plan",
    "subtitle":"Personalized workouts will help\n you fain strength"
  },
    {
      "name":"Snack",
      "image":"assets/img/breakfast2.png",
      "title":"Workout",
      "subtitle":"Personalized workouts will help\n you fain strength"
    },

    {
      "name":"Climber",
      "image":"assets/img/breakfast1.png",
      "title":"Workout",
      "subtitle":"Personalized workouts will help\n you fain strength"
    },
    {
      "name":"Climber",
      "image":"assets/img/breakfast2.png",
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
        title: Text("Meal Plan",
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
                        title: "Water",
                        isActive: isActiveTab == 0,
                        onPressed: (){
                          setState(() {
                            isActiveTab =0;
                          });
                        })
                ),
                Expanded(
                    child: TapButton(
                        title: "Food",
                        isActive: isActiveTab == 1,
                        onPressed: (){
                          setState(() {
                            isActiveTab =1;
                          });
                        })
                ),





              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [

                IconButton(onPressed: (){},
                    icon: Image.asset("assets/img/back1.png",
                      width: 20,
                      height: 20,
                    )),

                Expanded(child: Text("Sunday, Oct 05",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                  ),
                )
                ),

                IconButton(
                  onPressed: (){},
                  icon: Image.asset(
                    "assets/img/rightbutton.png",
                    width: 30,
                    height: 30,
                  ),
                )




                // Left IconButton-এর সমান জায়গা
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric( horizontal: 20),
                itemCount: planArr.length,
                itemBuilder: (context, index){
                  var wObj = planArr[index] as Map ?? {};
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
