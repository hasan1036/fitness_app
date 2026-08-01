import 'package:flutter/material.dart';
import 'package:workoutfitnesstool/view/login/step2_view.dart';

import '../../common/color_extention.dart';
import '../../common_widget/round_button.dart';


class Step1View extends StatefulWidget {
  const Step1View({super.key});

  @override
  State<Step1View> createState() => _Step1ViewState();
}

class _Step1ViewState extends State<Step1View> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true, title:       Text("Step 1 of 3",
        style: TextStyle(
            color: TColor.primary,
            fontSize: 20,
            fontWeight: FontWeight.w700),
      ),),

      body:
          SafeArea(
            child: Column(

              children: [



                const Spacer(),
              Image.asset("assets/img/on_board_3.png",
                width: media.width * 0.6,
                height: media.width * 0.6,
                fit: BoxFit.contain,
              ),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text("Welcome to\nCapi Fitness Application",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.sceondarText,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Text("Personalized workouts will help you\ngain strength, get in better shape and\nembrace a healthy lifestyle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),

              const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: RoundButton(
                    title: 'Get Started', onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Step2View()));

                  },),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1,2,3].map((pObj){
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: 1 == pObj ?
                          TColor.primary : TColor.grey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6)
                      ),

                    );
                  }).toList(),
                ),

               const SizedBox(height: 15),
                //  )
              ],),
          )


    );
  }
}
