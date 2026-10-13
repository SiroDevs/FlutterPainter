part of 'export_cubit.dart';

@freezed
abstract class ExportState with _$ExportState {
  const factory ExportState({
    /// The generated Dart source for the current options.
    @Default('') String code,

    /// One class per layer (true) or a single class with a method per layer.
    @Default(true) bool perLayer,

    /// Feedback line: copied, saved to a path, or an error.
    @Default('') String status,
  }) = _ExportState;
}
