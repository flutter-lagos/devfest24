import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../themes/text_field_theme.dart';
import '../themes/themes.dart';

class DevfestTextFormField extends StatelessWidget {
  const DevfestTextFormField({
    super.key,
    this.title,
    this.controller,
    this.hint,
    this.info,
    TextInputType? keyboardType,
    Color? iconColor,
    bool? readOnly,
    IconData? prefixIconData,
    IconData? suffixIconData,
    this.inputFormatters,
    this.enabled,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.autovalidateMode,
    this.prefixIcon,
    this.onTap,
    this.prefixIconColor,
    this.suffixIconColor,
    this.suffixIcon,
    this.contentPadding,
    this.hintStyle,
    this.errorStyle,
    this.onEditingComplete,
  })  : keyboardType = keyboardType ?? TextInputType.text,
        readOnly = readOnly ?? false,
        iconColor = iconColor ?? DevfestColors.grey10;
  final String? title;
  final String? info;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool? enabled;
  final Color iconColor;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefixIcon;
  final GestureTapCallback? onTap;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    Widget? prefixIcon;
    Widget? suffixIcon;
    final textFieldTheme = DevfestTheme.of(context).textFieldTheme ??
        DevfestTextFieldTheme.light();

    switch (this.prefixIcon) {
      case _?:
        switch (this.prefixIcon) {
          case Icon():
            prefixIcon = Icon(
              (this.prefixIcon! as Icon).icon,
              color: prefixIconColor ?? textFieldTheme.prefixColor,
            );
          default:
            prefixIcon = this.prefixIcon;
        }
    }

    switch (this.suffixIcon) {
      case _?:
        switch (this.suffixIcon) {
          case Icon():
            suffixIcon = Icon(
              (this.suffixIcon! as Icon).icon,
              color: suffixIconColor ?? textFieldTheme.suffixColor,
            );
          default:
            suffixIcon = this.suffixIcon;
        }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: DevfestTheme.of(context).textTheme?.bodyBody3Medium,
          ),
          Constants.smallVerticalGutter.verticalSpace,
        ],
        Semantics(
          label: hint,
          child: ExcludeSemantics(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              onTap: onTap,
              readOnly: readOnly,
              enabled: enabled,
              onChanged: onChanged,
              validator: validator,
              textInputAction: textInputAction,
              autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
              keyboardAppearance: Brightness.dark,
              style: textFieldTheme.style,
              onEditingComplete: onEditingComplete,
              inputFormatters: inputFormatters ?? [],
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                hintText: hint,
                hintStyle: hintStyle ?? textFieldTheme.hintStyle,
                errorStyle: errorStyle ?? textFieldTheme.errorStyle,
                errorMaxLines: 2,
                contentPadding: contentPadding ?? const EdgeInsets.all(16),
                border: textFieldTheme.border,
                enabledBorder: textFieldTheme.enabledBorder,
                focusedBorder: textFieldTheme.focusedBorder,
                errorBorder: textFieldTheme.errorBorder,
                focusedErrorBorder: textFieldTheme.errorBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
