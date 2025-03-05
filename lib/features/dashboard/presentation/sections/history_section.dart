import 'package:blackbook/core/common/widgets/search_input_field.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HistorySection extends StatefulWidget {
  const HistorySection({super.key});

  @override
  State<HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  int currListIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitlebar(),
            buildSelectionSection(),
            buildSetlist(),
          ],
        ),
      ),
    );
  }

  Widget buildSetlist() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(15, (index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'SSC CGI 2022 - Previous Year Paper (05 Dec, 2022)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .extension<AppColors>()!
                                .darkTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share_outlined,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  const IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Time Taken',
                              style: TextStyle(fontSize: 10),
                            ),
                            Row(
                              children: [
                                Icon(Icons.timer_outlined, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  '14 Min',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        VerticalDivider(),
                        Column(
                          children: [
                            Text(
                              'Ques. Solved',
                              style: TextStyle(fontSize: 10),
                            ),
                            Row(
                              children: [
                                Icon(Icons.question_mark_rounded, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  '18',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        VerticalDivider(),
                        Column(
                          children: [
                            Text(
                              'Marks Obtained',
                              style: TextStyle(fontSize: 10),
                            ),
                            Row(
                              children: [
                                Icon(Icons.checklist_rounded, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  '245',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
        }),
      ),
    );
  }

  Widget buildSelectionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: SearchInputField(
                  controller: TextEditingController(),
                  hintText: "Search topic...",
                ),
              ),
              const SizedBox(width: 12),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Theme.of(context)
                              .extension<AppColors>()!
                              .darkTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.sort, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTitlebar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'View all your played history here',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
