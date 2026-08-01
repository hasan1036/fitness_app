import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:workoutfitnesstool/common/color_extention.dart';

import '../../common_widget/running_top_button.dart';


class RunningView extends StatefulWidget {
  const RunningView({super.key});

  @override
  State<RunningView> createState() => _RunningViewState();
}

class _RunningViewState extends State<RunningView> {

  int selectTab = 0;

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
        }, icon: Image.asset("assets/img/back1.png",
         color: Colors.white,
          width: 125,
          height: 125,
        )),
        title: Text("Running",
        style: TextStyle(
          color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700
        ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            color: TColor.primary,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: media.width * 0.9,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xffFBF6F9),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))
                
              ),
              child: Row(
                children: [
                  Container( width: 1, height: 40, color: TColor.grey,),
                  RunningTopButton(
                    icon: "assets/img/location.png",
                    isActive: selectTab == 0,
                    onPressed: (){
                      setState(() {
                        selectTab == 0;
                      });
                    },
                  ),
                  Container( width: 1, height: 40, color: TColor.grey,),
                  RunningTopButton(
                    icon: "assets/img/speedometer.png",
                    isActive: selectTab ==1,
                    onPressed: (){
                      setState(() {
                        selectTab == 1;
                      });
                    },
                  ),
                  Container( width: 1, height: 40, color: TColor.grey,),
                  RunningTopButton(
                    icon: "assets/img/timeclock.png",
                    isActive: selectTab == 2,
                    onPressed: (){
                      setState(() {
                        selectTab == 2;
                      });
                    },
                  ),
                  Container( width: 1, height: 40, color: TColor.grey,),
                  RunningTopButton(
                    icon: "assets/img/heartbeat.png",
                    isActive: selectTab == 3,
                    onPressed: (){
                      setState(() {
                        selectTab == 3;
                      });
                    },
                  ),
                  Container( width: 1, height: 40, color: TColor.grey,),
                  RunningTopButton(
                    icon: "assets/img/report.png",
                    isActive: selectTab ==4,
                    onPressed: (){
                      setState(() {
                        selectTab == 4;
                      });
                    },
                  ),

                  Container(
                    width: 1,
                    height: 40,
                    color: TColor.grey,

                  )

                ],
              ),

            ),
          ),

          Container(
             width: media.width * 0.9,
            height: media.height * 0.65,
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              boxShadow: const[

                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0,1)
                )

              ]
            ),


            child: Stack(
            alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                      child: Text("Time",
                      style: TextStyle(
                        color: TColor.sceondarText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                      ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text("15:10",style:
                            TextStyle(
                              color: TColor.sceondarText,
                              fontSize: 65,
                              fontWeight: FontWeight.w700
                            )
                            ,),
                          SimpleCircularProgressBar(
                            size: media.width * 0.65,
                            animationDuration: 1,
                            mergeMode: true,
                            backColor: Color(0xffE6E6E6),
                            progressColors: [TColor.primary],
                            progressStrokeWidth: 12,
                            backStrokeWidth: 12,
                            startAngle: 45,
                          ),
                        ],

                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Min 50",
                              style: TextStyle(
                                  color:TColor.sceondarText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Text("Min 50",
                              style: TextStyle(
                                  color:TColor.sceondarText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                      ),

                        ],
                      ),
                ),

                Container(
                  height: 60,
                  child: Slider(
                    activeColor: TColor.primary,
                    inactiveColor: TColor.sceondarText,
                    value: 0.5, onChanged: (newVal){
                    setState(() {

                    });

                  },),
                )


                  ],


            ),
          ),





          
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){},
                  child: Column(
                      children: [
                        Image.asset("assets/img/settings.png",
                          width: 25,
                          height: 25,),
                       const Text("Setting")
                      ],
                    )),

                InkWell(
                  onTap: (){},
                    child: Container(
                      width: media.width * 0.5,
                      height: 40,
                      alignment: Alignment.center,
                      decoration:  BoxDecoration(
                        color: TColor.primary,
                        borderRadius: BorderRadius.circular(20)),
                      child: Image.asset("assets/img/pause.png",
                        width: 20, height: 20,
                        color: Colors.white,
                        ),
                    ),
                ),

                InkWell(
                    onTap: (){},
                    child: Column(
                      children: [
                        Image.asset("assets/img/unlock.png",
                          width: 20,
                          height: 20,),
                        const Text("Unlock",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700

                        ),

                        )
                      ],
                    ))
              ],
            ),
          )






        ],
      ),
    );
  }
}
