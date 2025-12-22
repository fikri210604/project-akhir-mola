import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpFields extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final double boxSize;
  final double spacing;
  final Color? borderColor;
  final Color? focusColor;

  const OtpFields({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.boxSize = 48,
    this.spacing = 10,
    this.borderColor,
    this.focusColor,
  });

  @override
  State<OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _notify() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      widget.onCompleted?.call(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.borderColor ?? Colors.grey.shade400;
    final focus = widget.focusColor ?? Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: widget.boxSize,
          height: widget.boxSize,
          margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            maxLength: 1,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: color)),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: focus, width: 1.5)),
            ),
            onChanged: (val) {
              if (val.isNotEmpty) {
                // Move to next
                if (index + 1 < widget.length) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else {
                // Back to previous
                if (index - 1 >= 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              }
              _notify();
            },
            onSubmitted: (_) => _notify(),
          ),
        );
      }),
    );
  }
}

