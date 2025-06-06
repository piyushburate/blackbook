import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MultiSelectableTileList extends StatefulWidget {
  final List<String> items;
  final Set<int> selectedIndexes;
  final void Function(Set<int> value) onChanged;
  const MultiSelectableTileList({
    super.key,
    required this.items,
    required this.selectedIndexes,
    required this.onChanged,
  });

  @override
  State<MultiSelectableTileList> createState() =>
      _MultiSelectableTileListState();
}

class _MultiSelectableTileListState extends State<MultiSelectableTileList> {
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    selectedIndexes = widget.selectedIndexes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: List.generate(
        widget.items.length,
        (index) {
          final selected = selectedIndexes.contains(index);
          void onSelected() {
            if (!selected) {
              selectedIndexes.add(index);
            } else {
              selectedIndexes.remove(index);
            }
            setState(() {});
            widget.onChanged(selectedIndexes);
          }

          return ListTile(
            selected: selected,
            selectedColor: Theme.of(context).colorScheme.primary,
            selectedTileColor:
                Theme.of(context).colorScheme.primary.withAlpha(8),
            title: Text(
              widget.items[index],
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color:
                      selected ? Theme.of(context).colorScheme.primary : null),
            ),
            trailing: Checkbox(
              value: selected,
              onChanged: (value) => onSelected(),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                width: 1.5,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .extension<AppColors>()!
                        .borderLightColor,
              ),
            ),
            onTap: onSelected,
          );
        },
      ),
    );
  }
}
