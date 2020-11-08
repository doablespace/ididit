import 'package:flutter/material.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.buttonHeight = 36,
    this.buttonWidth = 100,
    this.onPressed,
    this.label = '',
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.iconLabel,
  }) : super(key: key);

  final double buttonHeight;
  final double buttonWidth;
  final void Function() onPressed;
  final String label;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final Widget icon;
  final IconData iconLabel;

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
      child: icon != null
          ? TextButton(
              onPressed: onPressed,
              child: icon,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            )
          : iconLabel != null
              ? TextButton.icon(
                  onPressed: onPressed,
                  icon: Transform(
                    child: Icon(iconLabel, color: textColor),
                    // Icons are larger than text, so have to start earlier.
                    transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                  ),
                  label: Text(
                    label.toUpperCase(),
                    style: CustomTextStyle(textColor),
                  ),
                )
              : TextButton(
                  onPressed: onPressed,
                  child: Text(
                    label.toUpperCase(),
                    style: CustomTextStyle(textColor),
                  ),
                ),
    );
  }
}
