// Project imports:
import '../../../../../domain/models/model3d/part_pose.dart';
import '../../../../../domain/models/model3d/section_profile.dart';
import '../../../bloc/controller/editor_bloc.dart';
import '../shared/editor_ops.dart';

/// The cross-section and tilt of the selected shapes of a 3D layer.
abstract class Shape3dLogic {
  Shape3dLogic._();

  // Changes each selected shape's cross-section (no history entry).
  static EditorState setSection(
    EditorState s,
    SectionProfile Function(SectionProfile section) change,
  ) => s.withShapeChanges({
    for (final index in s.validSelectedIndices)
      index: s.layer.shapes[index].copyWith(
        section: change(s.layer.shapes[index].section),
      ),
  });

  // Changes each selected shape's tilt (no history entry).
  static EditorState setTilt(
    EditorState s,
    PartPose Function(PartPose tilt) change,
  ) => s.withShapeChanges({
    for (final index in s.validSelectedIndices)
      index: s.layer.shapes[index].copyWith(
        tilt: change(s.layer.shapes[index].tilt),
      ),
  });
}
