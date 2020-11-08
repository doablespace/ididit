import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/day_progress.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
        return LinearPercentIndicator(
          percent:
              value == 0 ? double.minPositive : value.toDouble() / maxProgress,
          animation: true,
          lineHeight: 10,
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: state.color,
          backgroundColor: Colors.transparent,
          leading: SizedBox(
            width: 20,
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
