import 'package:flutter/material.dart';
import 'package:workoutfitnesstool/common_widget/fitness_level_selector.dart';
import 'package:workoutfitnesstool/view/login/step3_view.dart';

import '../../common/color_extention.dart';
import '../../common_widget/round_button.dart';


class Step2View extends StatefulWidget {
  const Step2View({super.key});

  @override
  State<Step2View> createState() => _Step1ViewState();
}

class _Step1ViewState extends State<Step2View> {

  var selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(

        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },
              icon: Image.asset("assets/img/back.png",
                width: 125,
                height: 125,
                color: Colors.black,
              )),
          title: Text("Step 2 of 3",
            style: TextStyle(
                color: TColor.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),),
        body:


        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text("Select your fitness level",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TColor.sceondarText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),

              FitnessLevelSelector(isSelect:  selectIndex == 0,
                  title:"Beginer" ,
                  subtitle:"You are new to fitness training" ,
                  onPressed: (){
                    setState(() {
                      selectIndex = 0;
                    });
                  }),
              FitnessLevelSelector(isSelect:  selectIndex == 1,
                  title:"Intermediate" ,
                  subtitle:"You have been training regularly" ,
                  onPressed: (){
                    setState(() {
                      selectIndex = 1;
                    });
                  }),
              FitnessLevelSelector(isSelect:  selectIndex == 2,
                  title:"Advanced" ,
                  subtitle:"You're fit and ready for an intensive workout plan" ,
                  onPressed: (){
                    setState(() {
                      selectIndex = 2;
                    });
                  }),




              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: RoundButton(
                  title: 'Next', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  const Step3View()
                  ));
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
                        color: 2 == pObj ?
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
