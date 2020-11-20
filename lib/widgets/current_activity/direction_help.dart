import 'package:flutter/material.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

class DirectionHelp extends StatelessWidget {
  final Color _color;
  final String _text;
  final IconData _iconData;
  final MainAxisAlignment _colAlign;
  final CrossAxisAlignment _rowAlign;
  final Axis _axis;

  const DirectionHelp(this._color, this._text, this._iconData, this._colAlign,
      this._rowAlign, this._axis,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: _axis == Axis.vertical ? 32 : 16, horizontal: 16),
      child: Flex(
        direction: _axis,
        mainAxisAlignment: _colAlign,
        crossAxisAlignment: _rowAlign,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              _text,
              style: CustomTextStyle(
                _color,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          Icon(
            _iconData,
            size: 40,
            color: _color,
          )
        ],
      ),
    );
  }
}
