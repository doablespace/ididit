import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/screens/images_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

import '../activity_box.dart';

class ActivityImage extends StatefulWidget {
  final Activity activity;
  ActivityImage(this.activity);
  @override
  _ActivityImageState createState() => _ActivityImageState();
}

class _ActivityImageState extends State<ActivityImage> {
  // Dummy icon id just for rerendering it after selection.
  int _imageId;

  Future<int> _selectImage(BuildContext context) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImagesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        int imageId = await _selectImage(context);
        // Update the referenced activity.
        widget.activity.icon = imageId;
        // Redraw the picture.
        setState(() {
          _imageId = imageId;
        });
      },
      child: ActivityBox(
        color: widget.activity.ink,
        child: Stack(children: [
          Align(
            alignment: Alignment(0, 0.4),
            child: SvgPicture.asset(
              widget.activity.icon == null
                  ? Activity.selectIcon
                  : widget.activity.iconAsset,
              color: ThemeColors.darkBlue,
              width: 180,
              height: 180,
            ),
          ),
          Align(
            alignment: Alignment(0, -0.8),
            child: Text(
              'Select illustration',
              style: CustomTextStyle(ThemeColors.darkBlue, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),
    );
  }
}
