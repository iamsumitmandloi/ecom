// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProductsInitial value) initial,
    required TResult Function(_ProductsLoading value) loading,
    required TResult Function(_ProductsLoaded value) loaded,
    required TResult Function(_ProductsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductsInitial value)? initial,
    TResult? Function(_ProductsLoading value)? loading,
    TResult? Function(_ProductsLoaded value)? loaded,
    TResult? Function(_ProductsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductsInitial value)? initial,
    TResult Function(_ProductsLoading value)? loading,
    TResult Function(_ProductsLoaded value)? loaded,
    TResult Function(_ProductsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsStateCopyWith<$Res> {
  factory $ProductsStateCopyWith(
    ProductsState value,
    $Res Function(ProductsState) then,
  ) = _$ProductsStateCopyWithImpl<$Res, ProductsState>;
}

/// @nodoc
class _$ProductsStateCopyWithImpl<$Res, $Val extends ProductsState>
    implements $ProductsStateCopyWith<$Res> {
  _$ProductsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ProductsInitialImplCopyWith<$Res> {
  factory _$$ProductsInitialImplCopyWith(
    _$ProductsInitialImpl value,
    $Res Function(_$ProductsInitialImpl) then,
  ) = __$$ProductsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductsInitialImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsInitialImpl>
    implements _$$ProductsInitialImplCopyWith<$Res> {
  __$$ProductsInitialImplCopyWithImpl(
    _$ProductsInitialImpl _value,
    $Res Function(_$ProductsInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductsInitialImpl implements _ProductsInitial {
  const _$ProductsInitialImpl();

  @override
  String toString() {
    return 'ProductsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
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
    required TResult Function(_ProductsInitial value) initial,
    required TResult Function(_ProductsLoading value) loading,
    required TResult Function(_ProductsLoaded value) loaded,
    required TResult Function(_ProductsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductsInitial value)? initial,
    TResult? Function(_ProductsLoading value)? loading,
    TResult? Function(_ProductsLoaded value)? loaded,
    TResult? Function(_ProductsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductsInitial value)? initial,
    TResult Function(_ProductsLoading value)? loading,
    TResult Function(_ProductsLoaded value)? loaded,
    TResult Function(_ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _ProductsInitial implements ProductsState {
  const factory _ProductsInitial() = _$ProductsInitialImpl;
}

/// @nodoc
abstract class _$$ProductsLoadingImplCopyWith<$Res> {
  factory _$$ProductsLoadingImplCopyWith(
    _$ProductsLoadingImpl value,
    $Res Function(_$ProductsLoadingImpl) then,
  ) = __$$ProductsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductsLoadingImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsLoadingImpl>
    implements _$$ProductsLoadingImplCopyWith<$Res> {
  __$$ProductsLoadingImplCopyWithImpl(
    _$ProductsLoadingImpl _value,
    $Res Function(_$ProductsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductsLoadingImpl implements _ProductsLoading {
  const _$ProductsLoadingImpl();

  @override
  String toString() {
    return 'ProductsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
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
    required TResult Function(_ProductsInitial value) initial,
    required TResult Function(_ProductsLoading value) loading,
    required TResult Function(_ProductsLoaded value) loaded,
    required TResult Function(_ProductsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductsInitial value)? initial,
    TResult? Function(_ProductsLoading value)? loading,
    TResult? Function(_ProductsLoaded value)? loaded,
    TResult? Function(_ProductsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductsInitial value)? initial,
    TResult Function(_ProductsLoading value)? loading,
    TResult Function(_ProductsLoaded value)? loaded,
    TResult Function(_ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _ProductsLoading implements ProductsState {
  const factory _ProductsLoading() = _$ProductsLoadingImpl;
}

/// @nodoc
abstract class _$$ProductsLoadedImplCopyWith<$Res> {
  factory _$$ProductsLoadedImplCopyWith(
    _$ProductsLoadedImpl value,
    $Res Function(_$ProductsLoadedImpl) then,
  ) = __$$ProductsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Product> products, List<Category> categories, bool hasMore});
}

/// @nodoc
class __$$ProductsLoadedImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsLoadedImpl>
    implements _$$ProductsLoadedImplCopyWith<$Res> {
  __$$ProductsLoadedImplCopyWithImpl(
    _$ProductsLoadedImpl _value,
    $Res Function(_$ProductsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? categories = null,
    Object? hasMore = null,
  }) {
    return _then(
      _$ProductsLoadedImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<Product>,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<Category>,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ProductsLoadedImpl implements _ProductsLoaded {
  const _$ProductsLoadedImpl({
    required final List<Product> products,
    required final List<Category> categories,
    this.hasMore = false,
  }) : _products = products,
       _categories = categories;

  final List<Product> _products;
  @override
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<Category> _categories;
  @override
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'ProductsState.loaded(products: $products, categories: $categories, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsLoadedImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    const DeepCollectionEquality().hash(_categories),
    hasMore,
  );

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsLoadedImplCopyWith<_$ProductsLoadedImpl> get copyWith =>
      __$$ProductsLoadedImplCopyWithImpl<_$ProductsLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(products, categories, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(products, categories, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(products, categories, hasMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProductsInitial value) initial,
    required TResult Function(_ProductsLoading value) loading,
    required TResult Function(_ProductsLoaded value) loaded,
    required TResult Function(_ProductsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductsInitial value)? initial,
    TResult? Function(_ProductsLoading value)? loading,
    TResult? Function(_ProductsLoaded value)? loaded,
    TResult? Function(_ProductsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductsInitial value)? initial,
    TResult Function(_ProductsLoading value)? loading,
    TResult Function(_ProductsLoaded value)? loaded,
    TResult Function(_ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _ProductsLoaded implements ProductsState {
  const factory _ProductsLoaded({
    required final List<Product> products,
    required final List<Category> categories,
    final bool hasMore,
  }) = _$ProductsLoadedImpl;

  List<Product> get products;
  List<Category> get categories;
  bool get hasMore;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductsLoadedImplCopyWith<_$ProductsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductsErrorImplCopyWith<$Res> {
  factory _$$ProductsErrorImplCopyWith(
    _$ProductsErrorImpl value,
    $Res Function(_$ProductsErrorImpl) then,
  ) = __$$ProductsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ProductsErrorImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsErrorImpl>
    implements _$$ProductsErrorImplCopyWith<$Res> {
  __$$ProductsErrorImplCopyWithImpl(
    _$ProductsErrorImpl _value,
    $Res Function(_$ProductsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ProductsErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ProductsErrorImpl implements _ProductsError {
  const _$ProductsErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ProductsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsErrorImplCopyWith<_$ProductsErrorImpl> get copyWith =>
      __$$ProductsErrorImplCopyWithImpl<_$ProductsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<Product> products,
      List<Category> categories,
      bool hasMore,
    )?
    loaded,
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
    required TResult Function(_ProductsInitial value) initial,
    required TResult Function(_ProductsLoading value) loading,
    required TResult Function(_ProductsLoaded value) loaded,
    required TResult Function(_ProductsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProductsInitial value)? initial,
    TResult? Function(_ProductsLoading value)? loading,
    TResult? Function(_ProductsLoaded value)? loaded,
    TResult? Function(_ProductsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProductsInitial value)? initial,
    TResult Function(_ProductsLoading value)? loading,
    TResult Function(_ProductsLoaded value)? loaded,
    TResult Function(_ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ProductsError implements ProductsState {
  const factory _ProductsError({required final String message}) =
      _$ProductsErrorImpl;

  String get message;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductsErrorImplCopyWith<_$ProductsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
