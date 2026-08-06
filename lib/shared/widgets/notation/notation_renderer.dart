import 'package:flutter/material.dart';

import 'staff_layout.dart';

abstract interface class NotationRenderer {
  Widget build({
    required BuildContext context,
    required StaffLayoutData layout,
    required bool showActiveHighlights,
  });
}
