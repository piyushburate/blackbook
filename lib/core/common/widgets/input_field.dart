import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function()? onSubmit;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  const InputField({
    super.key,
    this.onSubmit,
    this.validator,
    this.controller,
    this.keyboardType,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.autofillHints,
    this.textInputAction,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onEditingComplete: onSubmit,
      validator: validator,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(22),
        hintText: hintText,
        labelText: labelText,
        errorMaxLines: 10,
        prefixIcon: (prefixIcon == null)
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: prefixIcon,
              ),
      ),
    );
  }
}
