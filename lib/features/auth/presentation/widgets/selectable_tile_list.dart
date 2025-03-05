import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SelectableTileList extends StatefulWidget {
  final List<String> items;
  final int? initiallySelected;
  final void Function(int? value) onChanged;
  const SelectableTileList({
    super.key,
    required this.items,
    required this.initiallySelected,
    required this.onChanged,
  });

  @override
  State<SelectableTileList> createState() => _SelectableTileListState();
}

class _SelectableTileListState extends State<SelectableTileList> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: List.generate(
        widget.items.length,
        (index) {
          final selected = index == selectedIndex;
          void onSelected() {
            selectedIndex = index;
            setState(() {});
            widget.onChanged(selectedIndex);
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
            trailing: selected ? Icon(Icons.check) : null,
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
