import 'package:flutter/material.dart';

class ActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          if (index == 0) return ActivityButton(icon: Icon(Icons.add_rounded));

          return ActivityButton(icon: Icon(Icons.accessibility_new_rounded));
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class ActivityButton extends StatelessWidget {
  final Widget icon;

  const ActivityButton({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: icon,
      label: Text('Test'),
      onPressed: () {},
    );
  }
}
