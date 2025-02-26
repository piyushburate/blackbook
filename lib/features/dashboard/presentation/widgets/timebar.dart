import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TimerBar extends StatelessWidget {
  final int? maxTime;
  final int currentTime;
  const TimerBar({
    super.key,
    this.maxTime,
    this.currentTime = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 28,
      animation: true,
      // percent: (maxTime == null) ? 0 : (currentTime / maxTime!),
      percent: getCurrentPercent(),
      animateFromLastPercent: true,
      backgroundColor: Colors.grey.shade300,
      progressColor: AppPallete.primaryColor,
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
    int time = (maxTime ?? 0) - currentTime;
    if (time >= 60) {
      timeUnit = 'minutes';
      time = (time / 60).ceil();
    }
    if (time.isNegative) {
      time *= -1;
    }
    return "$time $timeUnit ${(maxTime == null) ? '' : 'left'}";
  }

  double getCurrentPercent() {
    double percent = (maxTime == null) ? 0 : (currentTime / maxTime!);
    if (percent < 0) {
      percent = 0;
    }
    if (percent > 1) {
      percent = 1;
    }
    return percent;
  }
}
