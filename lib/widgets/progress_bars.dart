import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/day_progress.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:provider/provider.dart';

class ProgressBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return Column(
      children: [
        for (final state in ActivityState.values)
          _progressBar(activitiesBloc.progress, state),
      ],
    );
  }

  Widget _progressBar(DayProgress progress, ActivityState state) {
    return ModelProvider(
      value: progress,
      builder: (context, _, child) {
        final maxProgress = progress.values.reduce(max);
        final value = progress.getProgress(state);
        return Row(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: LinearProgressIndicator(
                  value: maxProgress == 0 ? 0 : value / maxProgress,
                  valueColor: AlwaysStoppedAnimation(state.color),
                  backgroundColor: Colors.transparent,
                  minHeight: 10,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
