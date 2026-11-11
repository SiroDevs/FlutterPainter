part of 'quick_code_cubit.dart';

class QuickCodeState extends Equatable {
  const QuickCodeState({
    required this.content,
    required this.request,
    required this.status,
    this.shapeKind,
    this.format = QuickCodeFormat.dartOffsets,
    this.shapeCount = 0,
  });

  final String content;
  final QuickCodeRequest request;
  final QuickCodeStatus status;
  final ShapeKind? shapeKind;
  final QuickCodeFormat format;
  final int shapeCount;

  bool get isPolygon => request.isPolygon;
  bool get canToggleFormat => status != QuickCodeStatus.invalid;

  QuickCodeState copyWith({
    String? content,
    QuickCodeRequest? request,
    QuickCodeStatus? status,
    QuickCodeFormat? format,
    int? shapeCount,
    Object? shapeKind = unset,
  }) => QuickCodeState(
    content: content ?? this.content,
    request: request ?? this.request,
    status: status ?? this.status,
    format: format ?? this.format,
    shapeCount: shapeCount ?? this.shapeCount,
    shapeKind: keep<ShapeKind>(shapeKind, this.shapeKind),
  );

  @override
  List<Object?> get props => [
    content,
    request,
    status,
    shapeKind,
    format,
    shapeCount,
  ];
}
