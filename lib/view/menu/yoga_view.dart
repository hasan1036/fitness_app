import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:workoutfitnesstool/common_widget/round_button.dart';

import '../../common/color_extention.dart';
import '../../common_widget/response_row.dart';

class YogaView extends StatefulWidget {
  const YogaView({super.key});

  @override
  State<YogaView> createState() => _YogaView();
}

class _YogaView extends State<YogaView> {

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
        title: Text("Yoga",
          style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),



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
              child: Text("Tips",
                style: TextStyle(
                    color: TColor.sceondarText,
                    fontSize: 18,

                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.\n Lorem Ipsum has been the industry's standard dummy text ever since 1966,\n when designers at Letraset and James Mosley,\n the librarian at St Bride Printing Library in London,\n took a 1914 Cicero translation and scrambled it to make dummy text for Letraset's Body Type sheets.\n It has survived not only many decades,\n but also the leap into electronic typesetting,\n remaining essentially unchanged.\n It was popularised thanks to these sheets and more recently with desktop publishing software like Aldus PageMaker and \nMicrosoft Word including versions of Lorem Ipsum.",
                         style: TextStyle(
               color: TColor.sceondarText,
               fontSize: 16,
               fontWeight: FontWeight.w700

                         ),
                         ),
            )

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
