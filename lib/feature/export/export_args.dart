// Project imports:
import '../../domain/models/drawing.dart';

/// What the code editor route needs: the drawing to generate code from. It is
/// passed as the route's `extra`.
class ExportArgs {
  const ExportArgs(this.drawing);

  final Drawing drawing;
}
