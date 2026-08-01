import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workoutfitnesstool/common_widget/border_button.dart';

import '../../common/color_extention.dart';

class WeightView extends StatefulWidget {
  const WeightView({super.key});

  @override
  State<WeightView> createState() => _WeightView();
}

class _WeightView extends State<WeightView> {

  List myWeightArr= [{
    "name":"Sunday, OCT 05",
    "image":"assets/img/11.png",
  },

    {
      "name":"Sunday, OCT 05",
      "image":"assets/img/2.png",

    },

    {
      "name":"Running",
      "image":"assets/img/3.png",

    },

  ];



//


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
            onPressed: (){
          Navigator.pop(context);
        },
            icon: Image.asset("assets/img/leftarrow.png",
              width: 125,
              height: 125,
              color: Colors.white,
            )),
        title: Text("Check your process",
          style: TextStyle(
              color: TColor.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),



      ),

      body: SingleChildScrollView(
        child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child:BorderButton(
                        title: "Check Process",
                        onPressed: (){},
                    type: BorderButtonType.inactive,
                  ) ),
                  const SizedBox(width: 15),
                  Expanded(child: BorderButton(
                    title: "My Weight",

                    onPressed: (){},
                    type: BorderButtonType.inactive,
                  ) ),

                  
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Text(
              "Add more photo to control your process",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.sceondarText,
                fontSize: 14
              ),
            ),

            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
                 width: media.width,
              height: media.width *0.6,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 0.5,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.65,
                  enlargeFactor: 0.4,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom
                ),
                itemCount: myWeightArr.length,
                itemBuilder:(BuildContext context, int itemIndex, int index){
                  var dObj = myWeightArr[index] as Map ?? {};
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10
                    ),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2)
                        )
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(dObj["image"].toString(),
                        width: double.maxFinite,
                        height: double.maxFinite,
                        fit: BoxFit.cover,

                    ),
                    )
                  );
                },

              )
            ),

            ),




            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                children: [

                  IconButton(onPressed: (){},
                      icon: Image.asset("",
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
                     "assets/img/",
                     width: 20,
                     height: 20,
                   ),
                 )




                 // Left IconButton-এর সমান জায়গা
                ],
              ),
            ),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: TColor.grey.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "74 Kg",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
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
