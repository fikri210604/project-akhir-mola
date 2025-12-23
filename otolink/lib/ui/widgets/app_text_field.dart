import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final bool obscure;
  final bool enableToggleObscure;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final Color? labelColor;
  final Color? primaryColor;
  final String? Function(String?)? validator;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.enableToggleObscure = false,
    this.errorText,
    this.onChanged,
    this.labelColor,
    this.primaryColor,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: widget.labelColor,
            )),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscure,
          onChanged: widget.onChanged,
          validator: widget.validator,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.primaryColor ?? theme.colorScheme.primary, width: 1.5),
            ),
            suffixIcon: widget.enableToggleObscure
                ? IconButton(
                    tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}