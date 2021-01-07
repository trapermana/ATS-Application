import 'package:flutter/material.dart';

class CostumText extends StatelessWidget {

  final String textFill;
  final double ftSize;
  final double bpad;

  CostumText(this.textFill, this.ftSize, this.bpad);

  @override
  Widget build(BuildContext context) {
    return Container(
                     padding: EdgeInsets.only(bottom: bpad),
                     child: Text(
                      textFill,
                      style: TextStyle(
                        fontSize: ftSize,
                        fontFamily: 'Asap', 
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(212, 168, 11, 1),
                        )
                       )
    );
  }
}