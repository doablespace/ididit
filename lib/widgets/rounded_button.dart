import 'package:flutter/material.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.buttonHeight = 36,
    this.buttonWidth = 100,
    this.onPressed,
    this.label,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final double buttonHeight;
  final double buttonWidth;
  final void Function() onPressed;
  final String label;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: new BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2.0),
        borderRadius: new BorderRadius.all(Radius.circular(100)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(label.toUpperCase(), style: CustomTextStyle(textColor)),
      ),
    );
  }
}