// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductDetailState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Product product) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Product product)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Product product)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProductDetailInitial value) initial,
    required TResult Function(_ProductDetailLoading value) loading,
    required TResult Function(_ProductDetailLoaded value) loaded,
    required TResult Function(_ProductDetailError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductDetailInitial value)? initial,
    TResult? Function(_ProductDetailLoading value)? loading,
    TResult? Function(_ProductDetailLoaded value)? loaded,
    TResult? Function(_ProductDetailError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductDetailInitial value)? initial,
    TResult Function(_ProductDetailLoading value)? loading,
    TResult Function(_ProductDetailLoaded value)? loaded,
    TResult Function(_ProductDetailError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDetailStateCopyWith<$Res> {
  factory $ProductDetailStateCopyWith(
    ProductDetailState value,
    $Res Function(ProductDetailState) then,
  ) = _$ProductDetailStateCopyWithImpl<$Res, ProductDetailState>;
}

/// @nodoc
class _$ProductDetailStateCopyWithImpl<$Res, $Val extends ProductDetailState>
    implements $ProductDetailStateCopyWith<$Res> {
  _$ProductDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ProductDetailInitialImplCopyWith<$Res> {
  factory _$$ProductDetailInitialImplCopyWith(
    _$ProductDetailInitialImpl value,
    $Res Function(_$ProductDetailInitialImpl) then,
  ) = __$$ProductDetailInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductDetailInitialImplCopyWithImpl<$Res>
    extends _$ProductDetailStateCopyWithImpl<$Res, _$ProductDetailInitialImpl>
    implements _$$ProductDetailInitialImplCopyWith<$Res> {
  __$$ProductDetailInitialImplCopyWithImpl(
    _$ProductDetailInitialImpl _value,
    $Res Function(_$ProductDetailInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductDetailInitialImpl implements _ProductDetailInitial {
  const _$ProductDetailInitialImpl();

  @override
  String toString() {
    return 'ProductDetailState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Product product) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Product product)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Product product)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProductDetailInitial value) initial,
    required TResult Function(_ProductDetailLoading value) loading,
    required TResult Function(_ProductDetailLoaded value) loaded,
    required TResult Function(_ProductDetailError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductDetailInitial value)? initial,
    TResult? Function(_ProductDetailLoading value)? loading,
    TResult? Function(_ProductDetailLoaded value)? loaded,
    TResult? Function(_ProductDetailError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductDetailInitial value)? initial,
    TResult Function(_ProductDetailLoading value)? loading,
    TResult Function(_ProductDetailLoaded value)? loaded,
    TResult Function(_ProductDetailError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _ProductDetailInitial implements ProductDetailState {
  const factory _ProductDetailInitial() = _$ProductDetailInitialImpl;
}

/// @nodoc
abstract class _$$ProductDetailLoadingImplCopyWith<$Res> {
  factory _$$ProductDetailLoadingImplCopyWith(
    _$ProductDetailLoadingImpl value,
    $Res Function(_$ProductDetailLoadingImpl) then,
  ) = __$$ProductDetailLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductDetailLoadingImplCopyWithImpl<$Res>
    extends _$ProductDetailStateCopyWithImpl<$Res, _$ProductDetailLoadingImpl>
    implements _$$ProductDetailLoadingImplCopyWith<$Res> {
  __$$ProductDetailLoadingImplCopyWithImpl(
    _$ProductDetailLoadingImpl _value,
    $Res Function(_$ProductDetailLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductDetailLoadingImpl implements _ProductDetailLoading {
  const _$ProductDetailLoadingImpl();

  @override
  String toString() {
    return 'ProductDetailState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Product product) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Product product)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Product product)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProductDetailInitial value) initial,
    required TResult Function(_ProductDetailLoading value) loading,
    required TResult Function(_ProductDetailLoaded value) loaded,
    required TResult Function(_ProductDetailError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductDetailInitial value)? initial,
    TResult? Function(_ProductDetailLoading value)? loading,
    TResult? Function(_ProductDetailLoaded value)? loaded,
    TResult? Function(_ProductDetailError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductDetailInitial value)? initial,
    TResult Function(_ProductDetailLoading value)? loading,
    TResult Function(_ProductDetailLoaded value)? loaded,
    TResult Function(_ProductDetailError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _ProductDetailLoading implements ProductDetailState {
  const factory _ProductDetailLoading() = _$ProductDetailLoadingImpl;
}

/// @nodoc
abstract class _$$ProductDetailLoadedImplCopyWith<$Res> {
  factory _$$ProductDetailLoadedImplCopyWith(
    _$ProductDetailLoadedImpl value,
    $Res Function(_$ProductDetailLoadedImpl) then,
  ) = __$$ProductDetailLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Product product});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$ProductDetailLoadedImplCopyWithImpl<$Res>
    extends _$ProductDetailStateCopyWithImpl<$Res, _$ProductDetailLoadedImpl>
    implements _$$ProductDetailLoadedImplCopyWith<$Res> {
  __$$ProductDetailLoadedImplCopyWithImpl(
    _$ProductDetailLoadedImpl _value,
    $Res Function(_$ProductDetailLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? product = null}) {
    return _then(
      _$ProductDetailLoadedImpl(
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as Product,
      ),
    );
  }

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value));
    });
  }
}

/// @nodoc

class _$ProductDetailLoadedImpl implements _ProductDetailLoaded {
  const _$ProductDetailLoadedImpl({required this.product});

  @override
  final Product product;

  @override
  String toString() {
    return 'ProductDetailState.loaded(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailLoadedImpl &&
            (identical(other.product, product) || other.product == product));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailLoadedImplCopyWith<_$ProductDetailLoadedImpl> get copyWith =>
      __$$ProductDetailLoadedImplCopyWithImpl<_$ProductDetailLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Product product) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Product product)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Product product)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProductDetailInitial value) initial,
    required TResult Function(_ProductDetailLoading value) loading,
    required TResult Function(_ProductDetailLoaded value) loaded,
    required TResult Function(_ProductDetailError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductDetailInitial value)? initial,
    TResult? Function(_ProductDetailLoading value)? loading,
    TResult? Function(_ProductDetailLoaded value)? loaded,
    TResult? Function(_ProductDetailError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductDetailInitial value)? initial,
    TResult Function(_ProductDetailLoading value)? loading,
    TResult Function(_ProductDetailLoaded value)? loaded,
    TResult Function(_ProductDetailError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _ProductDetailLoaded implements ProductDetailState {
  const factory _ProductDetailLoaded({required final Product product}) =
      _$ProductDetailLoadedImpl;

  Product get product;

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailLoadedImplCopyWith<_$ProductDetailLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductDetailErrorImplCopyWith<$Res> {
  factory _$$ProductDetailErrorImplCopyWith(
    _$ProductDetailErrorImpl value,
    $Res Function(_$ProductDetailErrorImpl) then,
  ) = __$$ProductDetailErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ProductDetailErrorImplCopyWithImpl<$Res>
    extends _$ProductDetailStateCopyWithImpl<$Res, _$ProductDetailErrorImpl>
    implements _$$ProductDetailErrorImplCopyWith<$Res> {
  __$$ProductDetailErrorImplCopyWithImpl(
    _$ProductDetailErrorImpl _value,
    $Res Function(_$ProductDetailErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ProductDetailErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ProductDetailErrorImpl implements _ProductDetailError {
  const _$ProductDetailErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ProductDetailState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailErrorImplCopyWith<_$ProductDetailErrorImpl> get copyWith =>
      __$$ProductDetailErrorImplCopyWithImpl<_$ProductDetailErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Product product) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Product product)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Product product)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProductDetailInitial value) initial,
    required TResult Function(_ProductDetailLoading value) loading,
    required TResult Function(_ProductDetailLoaded value) loaded,
    required TResult Function(_ProductDetailError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductDetailInitial value)? initial,
    TResult? Function(_ProductDetailLoading value)? loading,
    TResult? Function(_ProductDetailLoaded value)? loaded,
    TResult? Function(_ProductDetailError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductDetailInitial value)? initial,
    TResult Function(_ProductDetailLoading value)? loading,
    TResult Function(_ProductDetailLoaded value)? loaded,
    TResult Function(_ProductDetailError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ProductDetailError implements ProductDetailState {
  const factory _ProductDetailError({required final String message}) =
      _$ProductDetailErrorImpl;

  String get message;

  /// Create a copy of ProductDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailErrorImplCopyWith<_$ProductDetailErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
