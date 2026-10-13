/// Marks a `copyWith` argument as "not passed", so that passing `null` can
/// mean "clear this field" (a plain `value ?? this.value` cannot tell the two
/// apart).
///
/// ```dart
/// Foo copyWith({Object? note = unset}) =>
///     Foo(note: keep<String>(note, this.note));
/// ```
const Object unset = Object();

/// Returns [current] if [value] was left as [unset], otherwise [value].
T? keep<T>(Object? value, T? current) =>
    identical(value, unset) ? current : value as T?;
