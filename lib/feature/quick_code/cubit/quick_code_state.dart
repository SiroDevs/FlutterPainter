part of 'quick_code_cubit.dart';

enum QuickCodeStatus { empty, invalid, tooFew, ready }

class QuickCodeState extends Equatable {
  const QuickCodeState({
    required this.content,
    required this.request,
    required this.status,
    this.shapeKind,
    this.format = QuickCodeFormat.dartOffsets,
  });

  final String content;
  final QuickCodeRequest request;
  final QuickCodeStatus status;
  final ShapeKind? shapeKind;
  final QuickCodeFormat format;

  bool get isPolygon => request.isPolygon;

  QuickCodeState copyWith({
    String? content,
    QuickCodeRequest? request,
    QuickCodeStatus? status,
    QuickCodeFormat? format,
    Object? shapeKind = unset,
  }) => QuickCodeState(
    content: content ?? this.content,
    request: request ?? this.request,
    status: status ?? this.status,
    format: format ?? this.format,
    shapeKind: keep<ShapeKind>(shapeKind, this.shapeKind),
  );

  @override
  List<Object?> get props => [content, request, status, shapeKind, format];
}
