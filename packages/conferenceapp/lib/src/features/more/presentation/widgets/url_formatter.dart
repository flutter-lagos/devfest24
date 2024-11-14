import 'package:flutter/services.dart';

class UrlInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new text is a valid URL using tryParse
    String text = newValue.text;

    // Add "https://" if the URL does not start with "http" or "https"
    if (!text.startsWith('http://') && !text.startsWith('https://')) {
      text = 'https://$text';
    }

    // Validate the updated text using Uri.tryParse
    final uri = Uri.tryParse(text);

    // Define a regex pattern for basic URL validation
    final urlPattern = RegExp(
      r"^(https?:\/\/)?([\w\-]+\.)+[\w\-]{2,}([\/\w\-._~:/?#[\]@!$&\'()*+,;=%]*)?$",
    );

    // Allow the update only if the URL has a valid host
    if (uri != null && uri.host.isNotEmpty && urlPattern.hasMatch(text)) {
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    // Reject the update if the input is not a valid URL
    return oldValue;
  }
}
