import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
      
    }

    _timer = Timer(Duration(milliseconds: 800), action);
  }
}
