import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/common/entities/test_result.dart';
import 'package:blackbook/core/utils/numeric_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class TestAttemptsDialog extends StatefulWidget {
  final List<TestAttempt> attempts;
  const TestAttemptsDialog(this.attempts, {super.key});

  @override
  State<TestAttemptsDialog> createState() => _TestAttemptsDialogState();
}

class _TestAttemptsDialogState extends State<TestAttemptsDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            toolbarHeight: 70,
            titleSpacing: 25,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            shape: Border(),
            title: Text(
              'Test Attempts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).extension<AppColors>()?.darkTextColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.close),
              ),
              Gap(20),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: widget.attempts.length,
              separatorBuilder: (context, index) => Gap(10),
              itemBuilder: (context, index) {
                final itemIndex = widget.attempts.length - index - 1;
                final attempt = widget.attempts[itemIndex];
                final result = TestResult(attempt);
                return Card(
                  child: ListTile(
                    onTap: () => context.push('/test/result/${attempt.id}'),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                    ),
                    title: Text(
                      'Attempt ${itemIndex + 1}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${result.percentage.toPointerAsFixed(2)} %',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(120),
                                  ),
                        ),
                        Text(
                          result.timeTaken,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(120),
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SliverGap(20),
        ],
      ),
    );
  }
}
