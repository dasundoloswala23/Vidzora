import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

/// A rounded text field with a link icon and a paste-from-clipboard action.
class UrlInputField extends StatelessWidget {
  const UrlInputField({super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text != null && text.isNotEmpty) {
      controller.text = text;
      onChanged(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Paste video URL',
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        prefixIcon: const Icon(Icons.link_rounded, color: AppColors.textSecondary),
        suffixIcon: IconButton(
          icon: const Icon(Icons.content_paste_rounded, color: AppColors.primaryPurple),
          onPressed: _pasteFromClipboard,
        ),
      ),
    );
  }
}
