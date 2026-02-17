import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constants.dart';

/// A styled text field with consistent theming for the Anandham platform.
///
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hint: 'you@example.com',
///   prefixIcon: Icons.email_outlined,
///   validator: Validators.email,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffix,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: ColorConstants.divider),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: ColorConstants.primary, width: 1.5),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: ColorConstants.error, width: 1.5),
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      style: const TextStyle(fontSize: 15, color: ColorConstants.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        hintStyle: const TextStyle(color: ColorConstants.textHint),
        labelStyle: const TextStyle(color: ColorConstants.textSecondary),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: ColorConstants.textSecondary, size: 20)
            : null,
        suffixIcon: suffix != null
            ? Padding(padding: const EdgeInsets.only(right: 4), child: suffix)
            : null,
        filled: true,
        fillColor: enabled ? ColorConstants.surface : ColorConstants.background,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: border,
      ),
    );
  }
}
