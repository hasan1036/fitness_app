import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/color_extention.dart';

class SelectPicker extends StatelessWidget {

  final String? selectVal;
  final String title;
  final List allVal;
  final Function(String) didChange;
  const SelectPicker({
    super.key, required this.allVal,
    required this.selectVal,
     required this.title,
    required this.didChange});

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.sizeOf(context);

    return  InkWell(
      onTap: (){
        showCupertinoModalPopup(
            context: context,
            builder: (context){
              return Container(
                height: 250,
                color: TColor.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child:  Text("Done",
                          style: TextStyle(
                              color: TColor.sceondarText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          ),

                        ))
                      ],
                    ),
                    SizedBox(
                      height: 200,
                    child: CupertinoPicker(
                      onSelectedItemChanged: (index){
                        didChange(allVal[index]);
                      },
                      itemExtent: 40,
                        magnification: 1.2,
                          children: allVal.map((itemOb){
                            return Text(
                              itemOb.toString(),
                              style: TextStyle(
                                color: TColor.sceondarText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                            );
                          }).toList()),
                    )

                  ],
                ),
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: media.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(title,
              style: TextStyle(
                  color: TColor.sceondarText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              selectVal ?? "Select",
              style: TextStyle(
                  color: TColor.primary,fontSize: 18
              ),)

          ],
        ),
      ),
    );
  }
}
