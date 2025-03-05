import 'package:blackbook/core/common/widgets/svg_icon.dart';
import 'package:blackbook/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function()? onSubmit;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  const PasswordField({
    super.key,
    this.onSubmit,
    this.validator,
    this.controller,
    this.labelText,
    this.hintText,
    this.textInputAction,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordHide = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: passwordHide,
      onEditingComplete: widget.onSubmit,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      textInputAction: widget.textInputAction,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        errorMaxLines: 10,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SvgIcon(AppIcons.lock, size: 20),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            onPressed: () => setState(() => passwordHide = !passwordHide),
            icon: SvgIcon(
              passwordHide ? AppIcons.eyeClose : AppIcons.eyeEmpty,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
