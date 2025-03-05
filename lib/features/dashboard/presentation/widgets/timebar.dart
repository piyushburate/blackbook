import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Timebar extends StatefulWidget {
  final int? maxTime;
  // final int currentTime;
  final StopWatchTimer timer;
  const Timebar(
      {super.key,
      this.maxTime,
      // this.currentTime = 0,
      required this.timer});

  @override
  State<Timebar> createState() => _TimebarState();
}

class _TimebarState extends State<Timebar> {
  int get currentTime => widget.timer.secondTime.value;

  @override
  void initState() {
    super.initState();
    widget.timer.secondTime.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 28,
      animation: true,
      percent: getCurrentPercent(),
      animateFromLastPercent: true,
      backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(30),
      progressColor: Theme.of(context).colorScheme.primary,
      barRadius: const Radius.circular(15),
      padding: EdgeInsets.zero,
      center: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(getTimeText(),
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const Icon(Icons.timer_outlined, size: 20),
          ],
        ),
      ),
    );
  }

  String getTimeText() {
    String timeUnit = "seconds";
    int time = (widget.maxTime ?? 0) - currentTime;
    if (time >= 60) {
      timeUnit = 'minutes';
      time = (time / 60).ceil();
    }
    if (time.isNegative) {
      time *= -1;
    }
    return "$time $timeUnit ${(widget.maxTime == null) ? '' : 'left'}";
  }

  double getCurrentPercent() {
    double percent =
        (widget.maxTime == null) ? 0 : (currentTime / widget.maxTime!);
    if (percent < 0) {
      percent = 0;
    }
    if (percent > 1) {
      percent = 1;
    }
    return percent;
  }
}
