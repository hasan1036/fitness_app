import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workoutfitnesstool/view/workout/workout_detail_view.dart';
import '../../common/color_extention.dart';
import '../../common_widget/tap_button.dart';


class MealPlanView2 extends StatefulWidget {
  const MealPlanView2({super.key});

  @override
  State<MealPlanView2> createState() => _MealPlanView2();
}

class _MealPlanView2 extends State<MealPlanView2> {
  int isActiveTab = 0;
  List workArr= [{
    "name":"Breakfast",
    "title":"vegetable, sandwich",
    "image":"assets/img/breakfast1.png",
  },

    {
      "name":"Snack",
      "title":"Boat, nut, butter",
      "image":"assets/img/breakfast2.png",

    },
    {
      "name":"Breakfast",
      "title":"vegetable, sandwich",
      "image":"assets/img/breakfast1.png",
    },

    {
      "name":"Snack",
      "title":"Boat, nut, butter",
      "image":"assets/img/breakfast2.png",

    },



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
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon: Image.asset("assets/img/leftarrow.png",
              width: 125,
              height: 125,
              color: Colors.white,
            )),
        title: Text("Meal Plan",
          style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),),

      body:Column(
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
                      flex:3,
                      child: TapButton2(
                          title: "water",
                          isActive: isActiveTab == 0,
                          onPressed: (){
                            setState(() {
                              isActiveTab =0;
                            });
                          })
                  ),
                  Expanded(
                      flex: 2,
                      child: TapButton2(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  itemCount: workArr.length,
                  itemBuilder: (context, index){
                    var wObj = workArr[index] as Map ?? {};
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: TColor.white,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start ,
                        children: [

                              ClipRRect(
                                borderRadius:BorderRadius.circular(10),
                                child: Image.asset(wObj["image"].toString(),
                                    height: media.width * 0.55,
                                    width: media.width,
                                    fit: BoxFit.cover),
                              ),



                          Text(wObj["name"],
                            style: TextStyle(
                                color: TColor.sceondarText,
                                fontSize: 20,
                                fontWeight: FontWeight.w700

                            ),
                          ),

                          Text(wObj["title"],
                            style: TextStyle(
                                color: TColor.sceondarText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700

                            ),
                          ),

                        ],

                      ),
                    );
                  }),),]),

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
