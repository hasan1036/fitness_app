import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:workoutfitnesstool/common_widget/border_button.dart';

import '../../common/color_extention.dart';

class ScheduleView extends StatefulWidget {

  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleView();
}

class _ScheduleView extends State<ScheduleView> {

  DateTime nowTime = DateTime.now();
  DateTime targetDate = DateTime.now();
  List dataArr = [
    DateTime(2023,7,2),
    DateTime(2026,7,14)

  ];

  List notArr = [
    {"day": "2", "detail": "You exercise 48 minutes a day and five days a week at a certain time, you practice on a regular schedule. Changing the schedule will result is diminished results, resulting in fatique"},
    {"day":"14", "detail": "Tips for weight loss work towards functional exercises, proven strength and balance, and reduced risk of injury when muscle groups are active at the same time"}

  ];


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
        title: Text("Schedule",
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
            Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            child: Row(
              children: [
                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.MMM().format(targetDate).toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.sceondarText,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      DateFormat.y().format(targetDate),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.sceondarText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),

                ),


                IconButton(onPressed: (){
                  setState(() {
                    targetDate = DateTime(targetDate.year, targetDate.month - 1);
                  });
                },
                    icon: Image.asset("assets/img/back1.png",
                    width: 18,
                      height: 18,
                      color: TColor.sceondarText,
                    ),
                ),

                IconButton(onPressed: (){
                  targetDate = DateTime(targetDate.year, targetDate.month + 1);

                },
                    icon: Image.asset("assets/img/122.png",
                    width: 60,
                        height: 60,
                    ))
              ],
            ),

            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Stack(
                children: [
                  CalendarCarousel(
                   // todayButtonColor: TColor.primary,
                 //   todayBorderColor: TColor.primary,
                   // selectedDayButtonColor: TColor.primary,
                    // selectedDayBorderColor: TColor.primary,
                    onDayPressed: (DateTime date, List events) {
                      this.setState(() => nowTime = date);
                    },

                    onCalendarChanged: (date){
                      setState(() {

                        targetDate =date;

                      });
                    },
                    selectedDayTextStyle: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                    daysTextStyle: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                    weekDayFormat: WeekdayFormat.narrow,

                    weekdayTextStyle: TextStyle(
                      color: TColor.grey,
                      fontSize: 20
                    ),

                    weekendTextStyle:  TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                    thisMonthDayBorderColor: Colors.transparent,
                    showHeader: false,

                  //      ),
                    customDayBuilder: (   /// you can provide your own build function to make custom day containers
                        bool isSelectable,
                        int index,
                        bool isSelectedDay,
                        bool isToday,
                        bool isPrevMonthDay,
                        TextStyle textStyle,
                        bool isNextMonthDay,
                        bool isThisMonthDay,
                        DateTime day,
                        ) {

                      var selectObj = dataArr.firstWhere(
                              (eDate) =>
                              day.day == eDate.day &&
                           day.month == eDate.month &&
                                  day.year == eDate.year,
                          orElse:()=> null );

                      if(selectObj != null){
                        return Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)
                          ),

                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                            ),

                          ),
                        );

                      }

                      // if (day.day == 15) {
                      //   return Center(
                      //     child: Icon(Icons.local_airport),
                      //   );
                      // } else {
                      //   return null;
                      // }
                    },
                    weekFormat: false,

                    height: 340.0,
                    selectedDateTime: nowTime,
                    targetDateTime: targetDate,
                    daysHaveCircularBorder: true, /// null for not rendering any border, true for circular border, false for rectangular border
                  ),

                  //padding:  EdgeInsets.only(40),
                   const Divider(color: Colors.black26,height: 1,),



                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text("Note",
                textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                    ),
                    ),
            ),

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: notArr.length,
                itemBuilder: (context,index){
                  var iObj = notArr[index] as Map ?? {};
              return Container(
                padding: const EdgeInsets.only(
                    bottom: 15, left: 8),
                child: Row(
                   children: [


                     Container(
                       width: 35,
                       height: 35,
                       decoration: BoxDecoration(
                         color: Colors.blue,
                         borderRadius: BorderRadius.circular(20)
                       ),

                       alignment: Alignment.center,
                       child: Text(
                         iObj["day"],
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           color: TColor.white,
                           fontSize: 18,
                           fontWeight: FontWeight.w700
                         ),

                       ),
                     ),
                     SizedBox(
                       width: 15,
                     ),

                     Expanded(child: Text(
                       iObj["detail"],
                       style:TextStyle(
                         color: TColor.sceondarText,
                         fontSize: 16
                       ),
                     ))

                   ],
                ),

              );

            })


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
