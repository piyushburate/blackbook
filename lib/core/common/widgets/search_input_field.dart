import 'package:blackbook/core/common/widgets/svg_icon.dart';
import 'package:blackbook/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

class SearchInputField extends StatefulWidget {
  final TextEditingController controller;
  final void Function()? onSubmit;
  final void Function(String? value)? onChanged;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  const SearchInputField({
    super.key,
    this.onSubmit,
    this.onChanged,
    required this.controller,
    this.labelText,
    this.hintText,
    this.textInputAction,
  });

  @override
  State<SearchInputField> createState() => SearchInputFieldState();
}

class SearchInputFieldState extends State<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextField(
        controller: widget.controller,
        onEditingComplete: widget.onSubmit,
        keyboardType: TextInputType.text,
        textInputAction: widget.textInputAction,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        onChanged: (value) {
          setState(() {});
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintText: widget.hintText,
          label: (widget.labelText != null) ? Text(widget.labelText!) : null,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgIcon(AppIcons.search),
          ),
          suffixIcon: Visibility(
            visible: widget.controller.text != '',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: IconButton(
                onPressed: () => setState(() {
                  widget.controller.clear();
                  if (widget.onChanged != null) {
                    widget.onChanged!(widget.controller.text);
                  }
                }),
                icon: const Icon(
                  Icons.clear_rounded,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
