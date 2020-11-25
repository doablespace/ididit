import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/screens/images_screen.dart';
import 'package:ididit/ui/activity_icons.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_icon.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

import '../activity_box.dart';

class ActivityImage extends StatefulWidget {
  final Activity activity;
  ActivityImage(this.activity);
  @override
  _ActivityImageState createState() => _ActivityImageState();
}

class _ActivityImageState extends State<ActivityImage> {
  Future<int> _selectImage(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagesScreen(
          initialQuery: widget.activity.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _imageSize = 250;
    return TextButton(
      onPressed: () async {
        int imageId = await _selectImage(context);
        // Update the referenced activity.
        widget.activity.icon = imageId;
        // Redraw the picture.
        setState(() {});
      },
      child: ActivityBox(
        color: widget.activity.ink,
        child: widget.activity.icon == null
            ? selectIllustrationPrompt(widget.activity, _imageSize)
            : Center(
                child: ActivityIcon(
                  widget.activity.iconAsset,
                  color: ThemeColors.inkColor,
                  size: _imageSize,
                ),
              ),
      ),
    );
  }
}

Stack selectIllustrationPrompt(Activity activity, double imageSize) {
  activity.icon = Random().nextInt(ActivityIcons.values.length);
  return Stack(children: [
    Align(
      alignment: Alignment(0, 0.4),
      child: ActivityIcon(
        // Select prompt illustration by random.
        activity.iconAsset,
        color: ThemeColors.inkColor,
        size: imageSize,
      ),
    ),
    Align(
      alignment: Alignment(0, -0.8),
      child: Text(
        'Tap to select illustration',
        style: CustomTextStyle(ThemeColors.inkColor, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    ),
  ]);
}
