import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PracticePageTimerCubit extends Cubit<int> {
  final StopWatchTimer timer = StopWatchTimer(
    refreshTime: 1000,
    mode: StopWatchMode.countUp,
  );
  late List<int?> timers;

  PracticePageTimerCubit({
    required int length,
  }) : super(0) {
    timer.onStartTimer();
    timers = List.generate(length, (index) => null);
  }

  @override
  Future<void> close() {
    timer.dispose();
    return super.close();
  }

  void changeIndex(int index, bool startTimer) async {
    if (index != state) {
      saveTimer();
      timer.onResetTimer();
      emit(index);
      timer.setPresetSecondTime(
        timers[state] ?? 0,
        add: false,
      );
      if (startTimer) {
        timer.onStartTimer();
      }
    }
  }

  void saveTimer() {
    timers[state] = timer.secondTime.value;
    timer.onStopTimer();
  }
}
