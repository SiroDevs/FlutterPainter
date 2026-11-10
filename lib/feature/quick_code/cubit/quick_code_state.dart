part of 'quick_code_cubit.dart';

enum QuickCodeStatus { empty, invalid, tooFew, ready }

class QuickCodeState extends Equatable {
  const QuickCodeState({
    required this.content,
    required this.request,
    required this.status,
    this.shapeKind,
  });

  final String content;
  final QuickCodeRequest request;
  final QuickCodeStatus status;
  final ShapeKind? shapeKind;

  bool get isPolygon => request.isPolygon;

  QuickCodeState copyWith({
    String? content,
    QuickCodeRequest? request,
    QuickCodeStatus? status,
    Object? shapeKind = unset,
  }) => QuickCodeState(
    content: content ?? this.content,
    request: request ?? this.request,
    status: status ?? this.status,
    shapeKind: keep<ShapeKind>(shapeKind, this.shapeKind),
  );

  @override
  List<Object?> get props => [content, request, status, shapeKind];
}
