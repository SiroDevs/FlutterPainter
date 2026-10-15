// Flutter imports:
import 'package:flutter/painting.dart';

// Project imports:
import '../../domain/models/app_settings.dart';

/// The filter that makes the canvas look like [preview], or null for true
/// colours. The colour-blindness matrices are the widely used approximations;
/// they are for judging a design, not a medical simulation.
ColorFilter? colorFilterFor(ColorPreview preview) => switch (preview) {
      ColorPreview.none => null,
      ColorPreview.grayscale => const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0, 0, 0, 1, 0,
        ]),
      ColorPreview.protanopia => const ColorFilter.matrix(<double>[
          0.567, 0.433, 0, 0, 0, //
          0.558, 0.442, 0, 0, 0, //
          0, 0.242, 0.758, 0, 0, //
          0, 0, 0, 1, 0,
        ]),
      ColorPreview.deuteranopia => const ColorFilter.matrix(<double>[
          0.625, 0.375, 0, 0, 0, //
          0.7, 0.3, 0, 0, 0, //
          0, 0.3, 0.7, 0, 0, //
          0, 0, 0, 1, 0,
        ]),
      ColorPreview.tritanopia => const ColorFilter.matrix(<double>[
          0.95, 0.05, 0, 0, 0, //
          0, 0.433, 0.567, 0, 0, //
          0, 0.475, 0.525, 0, 0, //
          0, 0, 0, 1, 0,
        ]),
    };
