import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NgrokImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;

  const NgrokImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
    this.loadingBuilder,
  });

  @override
  State<NgrokImage> createState() => _NgrokImageState();
}

class _NgrokImageState extends State<NgrokImage> {
  Uint8List? _imageBytes;
  bool _hasError = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  @override
  void didUpdateWidget(covariant NgrokImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _fetchImage();
    }
  }

  Future<void> _fetchImage() async {
    if (widget.imageUrl.isEmpty) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    try {
      final uri = Uri.parse(widget.imageUrl);
      final response = await http.get(uri, headers: {
        'ngrok-skip-browser-warning': 'true',
        'User-Agent': 'PostmanRuntime/7.32.3', 
      });

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _imageBytes = response.bodyBytes;
            _loading = false;
            _hasError = false;
          });
        }
      } else {
        if (mounted) setState(() => _hasError = true);
      }
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorBuilder?.call(context, 'Error', null) ?? 
             Container(
               width: widget.width,
               height: widget.height,
               color: Colors.grey[200],
               child: const Icon(Icons.broken_image, color: Colors.grey),
             );
    }

    if (_loading || _imageBytes == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: widget.loadingBuilder != null 
              ? widget.loadingBuilder!(context, Container(), null)
              : const CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}