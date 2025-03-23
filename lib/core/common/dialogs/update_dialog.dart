import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      alignment: Alignment.center,
      child: Container(
        // margin: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage(AppImages.waves),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: -30,
                    child: Image.asset(
                      AppImages.rocket,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ABOUT UPDATE",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        "v2.3.6",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(),
                          )
                          .shimmer(color: Colors.white, delay: 3000.ms),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "1. Fix some terrible bugs\n"
                    "2. New navigation interaction\n"
                    "3. Improve loading experience\n"
                    "4. Voice-integrated search in the app",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .extension<AppColors>()
                              ?.normalTextColor
                              .withAlpha(180),
                        ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        isDense: true,
                        text: 'Later',
                        backgroundColor: Colors.transparent,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: AppButton(
                          isDense: true,
                          text: 'Update',
                          trailing: Icon(Icons.arrow_upward)
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .moveY(
                                begin: 0,
                                end: -10,
                                duration: 500.ms,
                                delay: 750.ms,
                                curve: Curves.easeInOut,
                              )
                              .scaleY(
                                begin: 1.0,
                                end: 0.9,
                                duration: 500.ms,
                                curve: Curves.easeInOut,
                                delay: 500.ms,
                              ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          onPressed: () {
                            //
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
