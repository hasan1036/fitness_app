import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:workoutfitnesstool/common_widget/round_button.dart';

import '../../common/color_extention.dart';
import '../../common_widget/response_row.dart';

class WorkoutDetailView extends StatefulWidget {
  const WorkoutDetailView({super.key});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailView();
}

class _WorkoutDetailView extends State<WorkoutDetailView> {

  List workArr= [{
    "name":"Running",
    "image":"assets/img/11.png",
  },

    {
      "name":"Jumping",
      "image":"assets/img/2.png",

    },

    {
      "name":"Running",
      "image":"assets/img/3.png",

    },
    {
      "name":"Jumping",
      "image":"assets/img/1.png",
    }

  ];

  List responseArr = [{
    "name":"Mikhail Eduardovich",
    "time":"89 days ago",
    "image":"assets/img/u1.png",
    "message":"Lorem ipsum dolar sit amet, conse ctetur adipiscing elit"
  },
    {
      "name":"Mikhail Eduardovich",
      "time":"11 days ago",
      "image":"assets/img/u2.png",
      "message":"Lorem ipsum dolar sit amet, conse ctetur adipiscing elit"
    },
    {
      "name":"Mikhail Eduardovich",
      "time":"12 days ago",
      "image":"assets/img/u1.png",
      "message":"Lorem ipsum dolar sit amet, conse ctetur adipiscing elit"
    },

    {
      "name":"Mikhail Eduardovich",
      "time":"13 days ago",
      "image":"assets/img/u2.png",
      "message":"Lorem ipsum dolar sit amet, conse ctetur adipiscing elit"
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
        title: Text("Climbers",
          style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),

        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          },
              icon: Image.asset("assets/img/music.png",
                width: 125,
                height: 125,
                color: Colors.white,
              )),

        ],

      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/img/11.png",
                 width: media.width,
              height: media.width * 0.55,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: RatingBar.builder(
                      initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 25,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: TColor.primary,
                        ),
                        onRatingUpdate: (rating){
                        print(rating);
                        }),
                  ),


                  const Spacer(),

                  IconButton(onPressed: (){

                  },
                      icon: Image.asset("assets/img/like.png",
                        width: 125,
                        height: 125,
                        color: Colors.black,
                      )),

                  IconButton(onPressed: (){

                  },
                      icon: Image.asset("assets/img/share.png",
                        width: 125,
                        height: 125,
                        color: Colors.black,
                      )),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 20),
              child: Text("Recommended",
                style: TextStyle(
                  color: TColor.sceondarText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
                ),

              ),
            ),

            SizedBox(
              height: media.width * 0.26,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric( horizontal: 15),
                  itemCount: workArr.length,
                  itemBuilder: (context, index){
                    var wObj = workArr[index] as Map ?? {};
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      width: media.width * 0.28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(wObj["image"].toString(),
                                  height: media.width * 0.15,
                                  width: media.width,
                                  fit: BoxFit.cover),

                              Container(
                                width: media.width,
                                height: media.width * 0.15,
                                decoration:  BoxDecoration(
                                    color: Colors.white.withOpacity(0.7)
                                ),
                              ),




                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: Text(wObj["name"],
                              style: TextStyle(
                                  color: TColor.sceondarText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700

                              ),
                            ),

                          ),


                        ],
                      ),
                    );
                  }),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                 horizontal: 18),
              child: Text("17 Responses",
                style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                ),

              ),
            ),

            ListView.builder(
               physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical:20, horizontal: 20),
                shrinkWrap: true,
                itemCount: responseArr.length,
                itemBuilder: (context, index){
                 var rObj = responseArr[index] as Map ?? {};
             return ResponseRow(rObj: rObj,);
            }),

          ],
        ),
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
