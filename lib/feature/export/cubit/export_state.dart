part of 'export_cubit.dart';

class ExportState extends Equatable {
  const ExportState({
    this.code = '',
    this.perLayer = true,
    this.status = '',
  });

  /// The generated Dart source for the current options.
  final String code;

  /// One class per layer (true) or a single class with a method per layer.
  final bool perLayer;

  /// Feedback line: copied, saved to a path, or an error.
  final String status;

  ExportState copyWith({String? code, bool? perLayer, String? status}) =>
      ExportState(
        code: code ?? this.code,
        perLayer: perLayer ?? this.perLayer,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [code, perLayer, status];
}
