import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TestPageTimerCubit extends Cubit<int> {
  late final StopWatchTimer timer;
  final int maxTime;
  final VoidCallback onTimeUp;
  int get time => timer.secondTime.value;

  TestPageTimerCubit({
    required this.maxTime,
    required this.onTimeUp,
  }) : super(0) {
    timer = StopWatchTimer(
      refreshTime: 1000,
      mode: StopWatchMode.countUp,
      onChangeRawMinute: (time) {
        if (time >= maxTime) {
          onTimeUp();
        }
      },
    );
    timer.onStartTimer();
  }

  @override
  Future<void> close() {
    timer.dispose();
    return super.close();
  }

  void stopTimer() {
    timer.onStopTimer();
  }
}
