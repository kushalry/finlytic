// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionEntity {
  /// Null for not-yet-persisted transactions.
  int? get id => throw _privateConstructorUsedError;
  int get accountId => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  TransactionKind get kind => throw _privateConstructorUsedError;
  Money get amount => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get occurredAt => throw _privateConstructorUsedError;

  /// Shared UUID linking the two rows of a transfer (out + in).
  String? get transferGroupId => throw _privateConstructorUsedError;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionEntityCopyWith<TransactionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEntityCopyWith<$Res> {
  factory $TransactionEntityCopyWith(
          TransactionEntity value, $Res Function(TransactionEntity) then) =
      _$TransactionEntityCopyWithImpl<$Res, TransactionEntity>;
  @useResult
  $Res call(
      {int? id,
      int accountId,
      int? categoryId,
      TransactionKind kind,
      Money amount,
      String? note,
      DateTime occurredAt,
      String? transferGroupId});

  $MoneyCopyWith<$Res> get amount;
}

/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res, $Val extends TransactionEntity>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? accountId = null,
    Object? categoryId = freezed,
    Object? kind = null,
    Object? amount = null,
    Object? note = freezed,
    Object? occurredAt = null,
    Object? transferGroupId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as TransactionKind,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      transferGroupId: freezed == transferGroupId
          ? _value.transferGroupId
          : transferGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyCopyWith<$Res> get amount {
    return $MoneyCopyWith<$Res>(_value.amount, (value) {
      return _then(_value.copyWith(amount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionEntityImplCopyWith<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  factory _$$TransactionEntityImplCopyWith(_$TransactionEntityImpl value,
          $Res Function(_$TransactionEntityImpl) then) =
      __$$TransactionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int accountId,
      int? categoryId,
      TransactionKind kind,
      Money amount,
      String? note,
      DateTime occurredAt,
      String? transferGroupId});

  @override
  $MoneyCopyWith<$Res> get amount;
}

/// @nodoc
class __$$TransactionEntityImplCopyWithImpl<$Res>
    extends _$TransactionEntityCopyWithImpl<$Res, _$TransactionEntityImpl>
    implements _$$TransactionEntityImplCopyWith<$Res> {
  __$$TransactionEntityImplCopyWithImpl(_$TransactionEntityImpl _value,
      $Res Function(_$TransactionEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? accountId = null,
    Object? categoryId = freezed,
    Object? kind = null,
    Object? amount = null,
    Object? note = freezed,
    Object? occurredAt = null,
    Object? transferGroupId = freezed,
  }) {
    return _then(_$TransactionEntityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as TransactionKind,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      transferGroupId: freezed == transferGroupId
          ? _value.transferGroupId
          : transferGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TransactionEntityImpl extends _TransactionEntity {
  const _$TransactionEntityImpl(
      {this.id,
      required this.accountId,
      this.categoryId,
      required this.kind,
      required this.amount,
      this.note,
      required this.occurredAt,
      this.transferGroupId})
      : super._();

  /// Null for not-yet-persisted transactions.
  @override
  final int? id;
  @override
  final int accountId;
  @override
  final int? categoryId;
  @override
  final TransactionKind kind;
  @override
  final Money amount;
  @override
  final String? note;
  @override
  final DateTime occurredAt;

  /// Shared UUID linking the two rows of a transfer (out + in).
  @override
  final String? transferGroupId;

  @override
  String toString() {
    return 'TransactionEntity(id: $id, accountId: $accountId, categoryId: $categoryId, kind: $kind, amount: $amount, note: $note, occurredAt: $occurredAt, transferGroupId: $transferGroupId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.transferGroupId, transferGroupId) ||
                other.transferGroupId == transferGroupId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, categoryId, kind,
      amount, note, occurredAt, transferGroupId);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      __$$TransactionEntityImplCopyWithImpl<_$TransactionEntityImpl>(
          this, _$identity);
}

abstract class _TransactionEntity extends TransactionEntity {
  const factory _TransactionEntity(
      {final int? id,
      required final int accountId,
      final int? categoryId,
      required final TransactionKind kind,
      required final Money amount,
      final String? note,
      required final DateTime occurredAt,
      final String? transferGroupId}) = _$TransactionEntityImpl;
  const _TransactionEntity._() : super._();

  /// Null for not-yet-persisted transactions.
  @override
  int? get id;
  @override
  int get accountId;
  @override
  int? get categoryId;
  @override
  TransactionKind get kind;
  @override
  Money get amount;
  @override
  String? get note;
  @override
  DateTime get occurredAt;

  /// Shared UUID linking the two rows of a transfer (out + in).
  @override
  String? get transferGroupId;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
