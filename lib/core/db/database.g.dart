// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whyMeta = const VerificationMeta('why');
  @override
  late final GeneratedColumn<String> why = GeneratedColumn<String>(
    'why',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _targetPaiseMeta = const VerificationMeta(
    'targetPaise',
  );
  @override
  late final GeneratedColumn<int> targetPaise = GeneratedColumn<int>(
    'target_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<int> startAt = GeneratedColumn<int>(
    'start_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineAtMeta = const VerificationMeta(
    'deadlineAt',
  );
  @override
  late final GeneratedColumn<int> deadlineAt = GeneratedColumn<int>(
    'deadline_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _digestMeta = const VerificationMeta('digest');
  @override
  late final GeneratedColumn<String> digest = GeneratedColumn<String>(
    'digest',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _digestStaleMeta = const VerificationMeta(
    'digestStale',
  );
  @override
  late final GeneratedColumn<bool> digestStale = GeneratedColumn<bool>(
    'digest_stale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("digest_stale" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _digestAtMeta = const VerificationMeta(
    'digestAt',
  );
  @override
  late final GeneratedColumn<int> digestAt = GeneratedColumn<int>(
    'digest_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    why,
    type,
    targetPaise,
    startAt,
    deadlineAt,
    priority,
    color,
    status,
    digest,
    digestStale,
    digestAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('why')) {
      context.handle(
        _whyMeta,
        why.isAcceptableOrUnknown(data['why']!, _whyMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('target_paise')) {
      context.handle(
        _targetPaiseMeta,
        targetPaise.isAcceptableOrUnknown(
          data['target_paise']!,
          _targetPaiseMeta,
        ),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('deadline_at')) {
      context.handle(
        _deadlineAtMeta,
        deadlineAt.isAcceptableOrUnknown(data['deadline_at']!, _deadlineAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deadlineAtMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('digest')) {
      context.handle(
        _digestMeta,
        digest.isAcceptableOrUnknown(data['digest']!, _digestMeta),
      );
    }
    if (data.containsKey('digest_stale')) {
      context.handle(
        _digestStaleMeta,
        digestStale.isAcceptableOrUnknown(
          data['digest_stale']!,
          _digestStaleMeta,
        ),
      );
    }
    if (data.containsKey('digest_at')) {
      context.handle(
        _digestAtMeta,
        digestAt.isAcceptableOrUnknown(data['digest_at']!, _digestAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      why: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}why'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      targetPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_paise'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_at'],
      )!,
      deadlineAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deadline_at'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      digest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}digest'],
      ),
      digestStale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}digest_stale'],
      )!,
      digestAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}digest_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String title;
  final String why;
  final String type;
  final int? targetPaise;
  final int startAt;
  final int deadlineAt;
  final int priority;
  final int color;
  final String status;
  final String? digest;
  final bool digestStale;
  final int? digestAt;
  final int createdAt;
  final int updatedAt;
  const Goal({
    required this.id,
    required this.title,
    required this.why,
    required this.type,
    this.targetPaise,
    required this.startAt,
    required this.deadlineAt,
    required this.priority,
    required this.color,
    required this.status,
    this.digest,
    required this.digestStale,
    this.digestAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['why'] = Variable<String>(why);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || targetPaise != null) {
      map['target_paise'] = Variable<int>(targetPaise);
    }
    map['start_at'] = Variable<int>(startAt);
    map['deadline_at'] = Variable<int>(deadlineAt);
    map['priority'] = Variable<int>(priority);
    map['color'] = Variable<int>(color);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || digest != null) {
      map['digest'] = Variable<String>(digest);
    }
    map['digest_stale'] = Variable<bool>(digestStale);
    if (!nullToAbsent || digestAt != null) {
      map['digest_at'] = Variable<int>(digestAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      title: Value(title),
      why: Value(why),
      type: Value(type),
      targetPaise: targetPaise == null && nullToAbsent
          ? const Value.absent()
          : Value(targetPaise),
      startAt: Value(startAt),
      deadlineAt: Value(deadlineAt),
      priority: Value(priority),
      color: Value(color),
      status: Value(status),
      digest: digest == null && nullToAbsent
          ? const Value.absent()
          : Value(digest),
      digestStale: Value(digestStale),
      digestAt: digestAt == null && nullToAbsent
          ? const Value.absent()
          : Value(digestAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      why: serializer.fromJson<String>(json['why']),
      type: serializer.fromJson<String>(json['type']),
      targetPaise: serializer.fromJson<int?>(json['targetPaise']),
      startAt: serializer.fromJson<int>(json['startAt']),
      deadlineAt: serializer.fromJson<int>(json['deadlineAt']),
      priority: serializer.fromJson<int>(json['priority']),
      color: serializer.fromJson<int>(json['color']),
      status: serializer.fromJson<String>(json['status']),
      digest: serializer.fromJson<String?>(json['digest']),
      digestStale: serializer.fromJson<bool>(json['digestStale']),
      digestAt: serializer.fromJson<int?>(json['digestAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'why': serializer.toJson<String>(why),
      'type': serializer.toJson<String>(type),
      'targetPaise': serializer.toJson<int?>(targetPaise),
      'startAt': serializer.toJson<int>(startAt),
      'deadlineAt': serializer.toJson<int>(deadlineAt),
      'priority': serializer.toJson<int>(priority),
      'color': serializer.toJson<int>(color),
      'status': serializer.toJson<String>(status),
      'digest': serializer.toJson<String?>(digest),
      'digestStale': serializer.toJson<bool>(digestStale),
      'digestAt': serializer.toJson<int?>(digestAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Goal copyWith({
    String? id,
    String? title,
    String? why,
    String? type,
    Value<int?> targetPaise = const Value.absent(),
    int? startAt,
    int? deadlineAt,
    int? priority,
    int? color,
    String? status,
    Value<String?> digest = const Value.absent(),
    bool? digestStale,
    Value<int?> digestAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Goal(
    id: id ?? this.id,
    title: title ?? this.title,
    why: why ?? this.why,
    type: type ?? this.type,
    targetPaise: targetPaise.present ? targetPaise.value : this.targetPaise,
    startAt: startAt ?? this.startAt,
    deadlineAt: deadlineAt ?? this.deadlineAt,
    priority: priority ?? this.priority,
    color: color ?? this.color,
    status: status ?? this.status,
    digest: digest.present ? digest.value : this.digest,
    digestStale: digestStale ?? this.digestStale,
    digestAt: digestAt.present ? digestAt.value : this.digestAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      why: data.why.present ? data.why.value : this.why,
      type: data.type.present ? data.type.value : this.type,
      targetPaise: data.targetPaise.present
          ? data.targetPaise.value
          : this.targetPaise,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      deadlineAt: data.deadlineAt.present
          ? data.deadlineAt.value
          : this.deadlineAt,
      priority: data.priority.present ? data.priority.value : this.priority,
      color: data.color.present ? data.color.value : this.color,
      status: data.status.present ? data.status.value : this.status,
      digest: data.digest.present ? data.digest.value : this.digest,
      digestStale: data.digestStale.present
          ? data.digestStale.value
          : this.digestStale,
      digestAt: data.digestAt.present ? data.digestAt.value : this.digestAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('why: $why, ')
          ..write('type: $type, ')
          ..write('targetPaise: $targetPaise, ')
          ..write('startAt: $startAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('digest: $digest, ')
          ..write('digestStale: $digestStale, ')
          ..write('digestAt: $digestAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    why,
    type,
    targetPaise,
    startAt,
    deadlineAt,
    priority,
    color,
    status,
    digest,
    digestStale,
    digestAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.title == this.title &&
          other.why == this.why &&
          other.type == this.type &&
          other.targetPaise == this.targetPaise &&
          other.startAt == this.startAt &&
          other.deadlineAt == this.deadlineAt &&
          other.priority == this.priority &&
          other.color == this.color &&
          other.status == this.status &&
          other.digest == this.digest &&
          other.digestStale == this.digestStale &&
          other.digestAt == this.digestAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> why;
  final Value<String> type;
  final Value<int?> targetPaise;
  final Value<int> startAt;
  final Value<int> deadlineAt;
  final Value<int> priority;
  final Value<int> color;
  final Value<String> status;
  final Value<String?> digest;
  final Value<bool> digestStale;
  final Value<int?> digestAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.why = const Value.absent(),
    this.type = const Value.absent(),
    this.targetPaise = const Value.absent(),
    this.startAt = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.color = const Value.absent(),
    this.status = const Value.absent(),
    this.digest = const Value.absent(),
    this.digestStale = const Value.absent(),
    this.digestAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String title,
    this.why = const Value.absent(),
    this.type = const Value.absent(),
    this.targetPaise = const Value.absent(),
    required int startAt,
    required int deadlineAt,
    this.priority = const Value.absent(),
    required int color,
    this.status = const Value.absent(),
    this.digest = const Value.absent(),
    this.digestStale = const Value.absent(),
    this.digestAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       startAt = Value(startAt),
       deadlineAt = Value(deadlineAt),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? why,
    Expression<String>? type,
    Expression<int>? targetPaise,
    Expression<int>? startAt,
    Expression<int>? deadlineAt,
    Expression<int>? priority,
    Expression<int>? color,
    Expression<String>? status,
    Expression<String>? digest,
    Expression<bool>? digestStale,
    Expression<int>? digestAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (why != null) 'why': why,
      if (type != null) 'type': type,
      if (targetPaise != null) 'target_paise': targetPaise,
      if (startAt != null) 'start_at': startAt,
      if (deadlineAt != null) 'deadline_at': deadlineAt,
      if (priority != null) 'priority': priority,
      if (color != null) 'color': color,
      if (status != null) 'status': status,
      if (digest != null) 'digest': digest,
      if (digestStale != null) 'digest_stale': digestStale,
      if (digestAt != null) 'digest_at': digestAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? why,
    Value<String>? type,
    Value<int?>? targetPaise,
    Value<int>? startAt,
    Value<int>? deadlineAt,
    Value<int>? priority,
    Value<int>? color,
    Value<String>? status,
    Value<String?>? digest,
    Value<bool>? digestStale,
    Value<int?>? digestAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      why: why ?? this.why,
      type: type ?? this.type,
      targetPaise: targetPaise ?? this.targetPaise,
      startAt: startAt ?? this.startAt,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      status: status ?? this.status,
      digest: digest ?? this.digest,
      digestStale: digestStale ?? this.digestStale,
      digestAt: digestAt ?? this.digestAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (why.present) {
      map['why'] = Variable<String>(why.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetPaise.present) {
      map['target_paise'] = Variable<int>(targetPaise.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<int>(startAt.value);
    }
    if (deadlineAt.present) {
      map['deadline_at'] = Variable<int>(deadlineAt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (digest.present) {
      map['digest'] = Variable<String>(digest.value);
    }
    if (digestStale.present) {
      map['digest_stale'] = Variable<bool>(digestStale.value);
    }
    if (digestAt.present) {
      map['digest_at'] = Variable<int>(digestAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('why: $why, ')
          ..write('type: $type, ')
          ..write('targetPaise: $targetPaise, ')
          ..write('startAt: $startAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('digest: $digest, ')
          ..write('digestStale: $digestStale, ')
          ..write('digestAt: $digestAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StagesTable extends Stages with TableInfo<$StagesTable, Stage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneWhenMeta = const VerificationMeta(
    'doneWhen',
  );
  @override
  late final GeneratedColumn<String> doneWhen = GeneratedColumn<String>(
    'done_when',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<int> dueAt = GeneratedColumn<int>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _alignScoreMeta = const VerificationMeta(
    'alignScore',
  );
  @override
  late final GeneratedColumn<int> alignScore = GeneratedColumn<int>(
    'align_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<int> doneAt = GeneratedColumn<int>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    title,
    doneWhen,
    dueAt,
    weight,
    orderIndex,
    status,
    source,
    alignScore,
    createdAt,
    doneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('done_when')) {
      context.handle(
        _doneWhenMeta,
        doneWhen.isAcceptableOrUnknown(data['done_when']!, _doneWhenMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('align_score')) {
      context.handle(
        _alignScoreMeta,
        alignScore.isAcceptableOrUnknown(data['align_score']!, _alignScoreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      doneWhen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}done_when'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_at'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      alignScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}align_score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_at'],
      ),
    );
  }

  @override
  $StagesTable createAlias(String alias) {
    return $StagesTable(attachedDatabase, alias);
  }
}

class Stage extends DataClass implements Insertable<Stage> {
  final String id;
  final String goalId;
  final String title;
  final String doneWhen;
  final int dueAt;
  final int weight;
  final int orderIndex;
  final String status;
  final String source;
  final int? alignScore;
  final int createdAt;
  final int? doneAt;
  const Stage({
    required this.id,
    required this.goalId,
    required this.title,
    required this.doneWhen,
    required this.dueAt,
    required this.weight,
    required this.orderIndex,
    required this.status,
    required this.source,
    this.alignScore,
    required this.createdAt,
    this.doneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['title'] = Variable<String>(title);
    map['done_when'] = Variable<String>(doneWhen);
    map['due_at'] = Variable<int>(dueAt);
    map['weight'] = Variable<int>(weight);
    map['order_index'] = Variable<int>(orderIndex);
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || alignScore != null) {
      map['align_score'] = Variable<int>(alignScore);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<int>(doneAt);
    }
    return map;
  }

  StagesCompanion toCompanion(bool nullToAbsent) {
    return StagesCompanion(
      id: Value(id),
      goalId: Value(goalId),
      title: Value(title),
      doneWhen: Value(doneWhen),
      dueAt: Value(dueAt),
      weight: Value(weight),
      orderIndex: Value(orderIndex),
      status: Value(status),
      source: Value(source),
      alignScore: alignScore == null && nullToAbsent
          ? const Value.absent()
          : Value(alignScore),
      createdAt: Value(createdAt),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
    );
  }

  factory Stage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stage(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      title: serializer.fromJson<String>(json['title']),
      doneWhen: serializer.fromJson<String>(json['doneWhen']),
      dueAt: serializer.fromJson<int>(json['dueAt']),
      weight: serializer.fromJson<int>(json['weight']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      alignScore: serializer.fromJson<int?>(json['alignScore']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      doneAt: serializer.fromJson<int?>(json['doneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'title': serializer.toJson<String>(title),
      'doneWhen': serializer.toJson<String>(doneWhen),
      'dueAt': serializer.toJson<int>(dueAt),
      'weight': serializer.toJson<int>(weight),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'alignScore': serializer.toJson<int?>(alignScore),
      'createdAt': serializer.toJson<int>(createdAt),
      'doneAt': serializer.toJson<int?>(doneAt),
    };
  }

  Stage copyWith({
    String? id,
    String? goalId,
    String? title,
    String? doneWhen,
    int? dueAt,
    int? weight,
    int? orderIndex,
    String? status,
    String? source,
    Value<int?> alignScore = const Value.absent(),
    int? createdAt,
    Value<int?> doneAt = const Value.absent(),
  }) => Stage(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    title: title ?? this.title,
    doneWhen: doneWhen ?? this.doneWhen,
    dueAt: dueAt ?? this.dueAt,
    weight: weight ?? this.weight,
    orderIndex: orderIndex ?? this.orderIndex,
    status: status ?? this.status,
    source: source ?? this.source,
    alignScore: alignScore.present ? alignScore.value : this.alignScore,
    createdAt: createdAt ?? this.createdAt,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
  );
  Stage copyWithCompanion(StagesCompanion data) {
    return Stage(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      title: data.title.present ? data.title.value : this.title,
      doneWhen: data.doneWhen.present ? data.doneWhen.value : this.doneWhen,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      weight: data.weight.present ? data.weight.value : this.weight,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      alignScore: data.alignScore.present
          ? data.alignScore.value
          : this.alignScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stage(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('doneWhen: $doneWhen, ')
          ..write('dueAt: $dueAt, ')
          ..write('weight: $weight, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('alignScore: $alignScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalId,
    title,
    doneWhen,
    dueAt,
    weight,
    orderIndex,
    status,
    source,
    alignScore,
    createdAt,
    doneAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stage &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.title == this.title &&
          other.doneWhen == this.doneWhen &&
          other.dueAt == this.dueAt &&
          other.weight == this.weight &&
          other.orderIndex == this.orderIndex &&
          other.status == this.status &&
          other.source == this.source &&
          other.alignScore == this.alignScore &&
          other.createdAt == this.createdAt &&
          other.doneAt == this.doneAt);
}

class StagesCompanion extends UpdateCompanion<Stage> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> title;
  final Value<String> doneWhen;
  final Value<int> dueAt;
  final Value<int> weight;
  final Value<int> orderIndex;
  final Value<String> status;
  final Value<String> source;
  final Value<int?> alignScore;
  final Value<int> createdAt;
  final Value<int?> doneAt;
  final Value<int> rowid;
  const StagesCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.title = const Value.absent(),
    this.doneWhen = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.weight = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.alignScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StagesCompanion.insert({
    required String id,
    required String goalId,
    required String title,
    this.doneWhen = const Value.absent(),
    required int dueAt,
    this.weight = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.alignScore = const Value.absent(),
    required int createdAt,
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       title = Value(title),
       dueAt = Value(dueAt),
       createdAt = Value(createdAt);
  static Insertable<Stage> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? title,
    Expression<String>? doneWhen,
    Expression<int>? dueAt,
    Expression<int>? weight,
    Expression<int>? orderIndex,
    Expression<String>? status,
    Expression<String>? source,
    Expression<int>? alignScore,
    Expression<int>? createdAt,
    Expression<int>? doneAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (title != null) 'title': title,
      if (doneWhen != null) 'done_when': doneWhen,
      if (dueAt != null) 'due_at': dueAt,
      if (weight != null) 'weight': weight,
      if (orderIndex != null) 'order_index': orderIndex,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (alignScore != null) 'align_score': alignScore,
      if (createdAt != null) 'created_at': createdAt,
      if (doneAt != null) 'done_at': doneAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StagesCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<String>? title,
    Value<String>? doneWhen,
    Value<int>? dueAt,
    Value<int>? weight,
    Value<int>? orderIndex,
    Value<String>? status,
    Value<String>? source,
    Value<int?>? alignScore,
    Value<int>? createdAt,
    Value<int?>? doneAt,
    Value<int>? rowid,
  }) {
    return StagesCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      doneWhen: doneWhen ?? this.doneWhen,
      dueAt: dueAt ?? this.dueAt,
      weight: weight ?? this.weight,
      orderIndex: orderIndex ?? this.orderIndex,
      status: status ?? this.status,
      source: source ?? this.source,
      alignScore: alignScore ?? this.alignScore,
      createdAt: createdAt ?? this.createdAt,
      doneAt: doneAt ?? this.doneAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (doneWhen.present) {
      map['done_when'] = Variable<String>(doneWhen.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<int>(dueAt.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (alignScore.present) {
      map['align_score'] = Variable<int>(alignScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<int>(doneAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StagesCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('doneWhen: $doneWhen, ')
          ..write('dueAt: $dueAt, ')
          ..write('weight: $weight, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('alignScore: $alignScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stageIdMeta = const VerificationMeta(
    'stageId',
  );
  @override
  late final GeneratedColumn<String> stageId = GeneratedColumn<String>(
    'stage_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normHashMeta = const VerificationMeta(
    'normHash',
  );
  @override
  late final GeneratedColumn<String> normHash = GeneratedColumn<String>(
    'norm_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimateMinMeta = const VerificationMeta(
    'estimateMin',
  );
  @override
  late final GeneratedColumn<int> estimateMin = GeneratedColumn<int>(
    'estimate_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<int> dueAt = GeneratedColumn<int>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindAtMeta = const VerificationMeta(
    'remindAt',
  );
  @override
  late final GeneratedColumn<int> remindAt = GeneratedColumn<int>(
    'remind_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta(
    'recurrence',
  );
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreSourceMeta = const VerificationMeta(
    'scoreSource',
  );
  @override
  late final GeneratedColumn<String> scoreSource = GeneratedColumn<String>(
    'score_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('rule'),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<int> doneAt = GeneratedColumn<int>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    stageId,
    title,
    normHash,
    estimateMin,
    dueAt,
    remindAt,
    recurrence,
    score,
    scoreSource,
    reason,
    status,
    createdAt,
    doneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('stage_id')) {
      context.handle(
        _stageIdMeta,
        stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('norm_hash')) {
      context.handle(
        _normHashMeta,
        normHash.isAcceptableOrUnknown(data['norm_hash']!, _normHashMeta),
      );
    } else if (isInserting) {
      context.missing(_normHashMeta);
    }
    if (data.containsKey('estimate_min')) {
      context.handle(
        _estimateMinMeta,
        estimateMin.isAcceptableOrUnknown(
          data['estimate_min']!,
          _estimateMinMeta,
        ),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('remind_at')) {
      context.handle(
        _remindAtMeta,
        remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta),
      );
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('score_source')) {
      context.handle(
        _scoreSourceMeta,
        scoreSource.isAcceptableOrUnknown(
          data['score_source']!,
          _scoreSourceMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      stageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      normHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}norm_hash'],
      )!,
      estimateMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimate_min'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_at'],
      ),
      remindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_at'],
      ),
      recurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      scoreSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}score_source'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_at'],
      ),
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final String id;
  final String? goalId;
  final String? stageId;
  final String title;
  final String normHash;
  final int estimateMin;
  final int? dueAt;
  final int? remindAt;
  final String recurrence;
  final int? score;
  final String scoreSource;
  final String? reason;
  final String status;
  final int createdAt;
  final int? doneAt;
  const Todo({
    required this.id,
    this.goalId,
    this.stageId,
    required this.title,
    required this.normHash,
    required this.estimateMin,
    this.dueAt,
    this.remindAt,
    required this.recurrence,
    this.score,
    required this.scoreSource,
    this.reason,
    required this.status,
    required this.createdAt,
    this.doneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    if (!nullToAbsent || stageId != null) {
      map['stage_id'] = Variable<String>(stageId);
    }
    map['title'] = Variable<String>(title);
    map['norm_hash'] = Variable<String>(normHash);
    map['estimate_min'] = Variable<int>(estimateMin);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<int>(dueAt);
    }
    if (!nullToAbsent || remindAt != null) {
      map['remind_at'] = Variable<int>(remindAt);
    }
    map['recurrence'] = Variable<String>(recurrence);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['score_source'] = Variable<String>(scoreSource);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<int>(doneAt);
    }
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      stageId: stageId == null && nullToAbsent
          ? const Value.absent()
          : Value(stageId),
      title: Value(title),
      normHash: Value(normHash),
      estimateMin: Value(estimateMin),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      remindAt: remindAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remindAt),
      recurrence: Value(recurrence),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      scoreSource: Value(scoreSource),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      status: Value(status),
      createdAt: Value(createdAt),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      stageId: serializer.fromJson<String?>(json['stageId']),
      title: serializer.fromJson<String>(json['title']),
      normHash: serializer.fromJson<String>(json['normHash']),
      estimateMin: serializer.fromJson<int>(json['estimateMin']),
      dueAt: serializer.fromJson<int?>(json['dueAt']),
      remindAt: serializer.fromJson<int?>(json['remindAt']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      score: serializer.fromJson<int?>(json['score']),
      scoreSource: serializer.fromJson<String>(json['scoreSource']),
      reason: serializer.fromJson<String?>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      doneAt: serializer.fromJson<int?>(json['doneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String?>(goalId),
      'stageId': serializer.toJson<String?>(stageId),
      'title': serializer.toJson<String>(title),
      'normHash': serializer.toJson<String>(normHash),
      'estimateMin': serializer.toJson<int>(estimateMin),
      'dueAt': serializer.toJson<int?>(dueAt),
      'remindAt': serializer.toJson<int?>(remindAt),
      'recurrence': serializer.toJson<String>(recurrence),
      'score': serializer.toJson<int?>(score),
      'scoreSource': serializer.toJson<String>(scoreSource),
      'reason': serializer.toJson<String?>(reason),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'doneAt': serializer.toJson<int?>(doneAt),
    };
  }

  Todo copyWith({
    String? id,
    Value<String?> goalId = const Value.absent(),
    Value<String?> stageId = const Value.absent(),
    String? title,
    String? normHash,
    int? estimateMin,
    Value<int?> dueAt = const Value.absent(),
    Value<int?> remindAt = const Value.absent(),
    String? recurrence,
    Value<int?> score = const Value.absent(),
    String? scoreSource,
    Value<String?> reason = const Value.absent(),
    String? status,
    int? createdAt,
    Value<int?> doneAt = const Value.absent(),
  }) => Todo(
    id: id ?? this.id,
    goalId: goalId.present ? goalId.value : this.goalId,
    stageId: stageId.present ? stageId.value : this.stageId,
    title: title ?? this.title,
    normHash: normHash ?? this.normHash,
    estimateMin: estimateMin ?? this.estimateMin,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    remindAt: remindAt.present ? remindAt.value : this.remindAt,
    recurrence: recurrence ?? this.recurrence,
    score: score.present ? score.value : this.score,
    scoreSource: scoreSource ?? this.scoreSource,
    reason: reason.present ? reason.value : this.reason,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      title: data.title.present ? data.title.value : this.title,
      normHash: data.normHash.present ? data.normHash.value : this.normHash,
      estimateMin: data.estimateMin.present
          ? data.estimateMin.value
          : this.estimateMin,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      score: data.score.present ? data.score.value : this.score,
      scoreSource: data.scoreSource.present
          ? data.scoreSource.value
          : this.scoreSource,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('stageId: $stageId, ')
          ..write('title: $title, ')
          ..write('normHash: $normHash, ')
          ..write('estimateMin: $estimateMin, ')
          ..write('dueAt: $dueAt, ')
          ..write('remindAt: $remindAt, ')
          ..write('recurrence: $recurrence, ')
          ..write('score: $score, ')
          ..write('scoreSource: $scoreSource, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalId,
    stageId,
    title,
    normHash,
    estimateMin,
    dueAt,
    remindAt,
    recurrence,
    score,
    scoreSource,
    reason,
    status,
    createdAt,
    doneAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.stageId == this.stageId &&
          other.title == this.title &&
          other.normHash == this.normHash &&
          other.estimateMin == this.estimateMin &&
          other.dueAt == this.dueAt &&
          other.remindAt == this.remindAt &&
          other.recurrence == this.recurrence &&
          other.score == this.score &&
          other.scoreSource == this.scoreSource &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.doneAt == this.doneAt);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<String> id;
  final Value<String?> goalId;
  final Value<String?> stageId;
  final Value<String> title;
  final Value<String> normHash;
  final Value<int> estimateMin;
  final Value<int?> dueAt;
  final Value<int?> remindAt;
  final Value<String> recurrence;
  final Value<int?> score;
  final Value<String> scoreSource;
  final Value<String?> reason;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int?> doneAt;
  final Value<int> rowid;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.stageId = const Value.absent(),
    this.title = const Value.absent(),
    this.normHash = const Value.absent(),
    this.estimateMin = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.score = const Value.absent(),
    this.scoreSource = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosCompanion.insert({
    required String id,
    this.goalId = const Value.absent(),
    this.stageId = const Value.absent(),
    required String title,
    required String normHash,
    this.estimateMin = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.score = const Value.absent(),
    this.scoreSource = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    required int createdAt,
    this.doneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       normHash = Value(normHash),
       createdAt = Value(createdAt);
  static Insertable<Todo> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? stageId,
    Expression<String>? title,
    Expression<String>? normHash,
    Expression<int>? estimateMin,
    Expression<int>? dueAt,
    Expression<int>? remindAt,
    Expression<String>? recurrence,
    Expression<int>? score,
    Expression<String>? scoreSource,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? doneAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (stageId != null) 'stage_id': stageId,
      if (title != null) 'title': title,
      if (normHash != null) 'norm_hash': normHash,
      if (estimateMin != null) 'estimate_min': estimateMin,
      if (dueAt != null) 'due_at': dueAt,
      if (remindAt != null) 'remind_at': remindAt,
      if (recurrence != null) 'recurrence': recurrence,
      if (score != null) 'score': score,
      if (scoreSource != null) 'score_source': scoreSource,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (doneAt != null) 'done_at': doneAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosCompanion copyWith({
    Value<String>? id,
    Value<String?>? goalId,
    Value<String?>? stageId,
    Value<String>? title,
    Value<String>? normHash,
    Value<int>? estimateMin,
    Value<int?>? dueAt,
    Value<int?>? remindAt,
    Value<String>? recurrence,
    Value<int?>? score,
    Value<String>? scoreSource,
    Value<String?>? reason,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int?>? doneAt,
    Value<int>? rowid,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      stageId: stageId ?? this.stageId,
      title: title ?? this.title,
      normHash: normHash ?? this.normHash,
      estimateMin: estimateMin ?? this.estimateMin,
      dueAt: dueAt ?? this.dueAt,
      remindAt: remindAt ?? this.remindAt,
      recurrence: recurrence ?? this.recurrence,
      score: score ?? this.score,
      scoreSource: scoreSource ?? this.scoreSource,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      doneAt: doneAt ?? this.doneAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (stageId.present) {
      map['stage_id'] = Variable<String>(stageId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (normHash.present) {
      map['norm_hash'] = Variable<String>(normHash.value);
    }
    if (estimateMin.present) {
      map['estimate_min'] = Variable<int>(estimateMin.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<int>(dueAt.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<int>(remindAt.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (scoreSource.present) {
      map['score_source'] = Variable<String>(scoreSource.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<int>(doneAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('stageId: $stageId, ')
          ..write('title: $title, ')
          ..write('normHash: $normHash, ')
          ..write('estimateMin: $estimateMin, ')
          ..write('dueAt: $dueAt, ')
          ..write('remindAt: $remindAt, ')
          ..write('recurrence: $recurrence, ')
          ..write('score: $score, ')
          ..write('scoreSource: $scoreSource, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<String> todoId = GeneratedColumn<String>(
    'todo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('work'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    todoId,
    category,
    startedAt,
    endedAt,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('todo_id')) {
      context.handle(
        _todoIdMeta,
        todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      todoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}todo_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final String id;
  final String? todoId;
  final String category;
  final int startedAt;
  final int? endedAt;
  final String source;
  const FocusSession({
    required this.id,
    this.todoId,
    required this.category,
    required this.startedAt,
    this.endedAt,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || todoId != null) {
      map['todo_id'] = Variable<String>(todoId);
    }
    map['category'] = Variable<String>(category);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      todoId: todoId == null && nullToAbsent
          ? const Value.absent()
          : Value(todoId),
      category: Value(category),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      source: Value(source),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<String>(json['id']),
      todoId: serializer.fromJson<String?>(json['todoId']),
      category: serializer.fromJson<String>(json['category']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'todoId': serializer.toJson<String?>(todoId),
      'category': serializer.toJson<String>(category),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'source': serializer.toJson<String>(source),
    };
  }

  FocusSession copyWith({
    String? id,
    Value<String?> todoId = const Value.absent(),
    String? category,
    int? startedAt,
    Value<int?> endedAt = const Value.absent(),
    String? source,
  }) => FocusSession(
    id: id ?? this.id,
    todoId: todoId.present ? todoId.value : this.todoId,
    category: category ?? this.category,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    source: source ?? this.source,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      category: data.category.present ? data.category.value : this.category,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('category: $category, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, todoId, category, startedAt, endedAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.category == this.category &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.source == this.source);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<String> id;
  final Value<String?> todoId;
  final Value<String> category;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<String> source;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.category = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.todoId = const Value.absent(),
    this.category = const Value.absent(),
    required int startedAt,
    this.endedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt);
  static Insertable<FocusSession> custom({
    Expression<String>? id,
    Expression<String>? todoId,
    Expression<String>? category,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (category != null) 'category': category,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? todoId,
    Value<String>? category,
    Value<int>? startedAt,
    Value<int?>? endedAt,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      category: category ?? this.category,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<String>(todoId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('category: $category, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeHhmmMeta = const VerificationMeta(
    'timeHhmm',
  );
  @override
  late final GeneratedColumn<String> timeHhmm = GeneratedColumn<String>(
    'time_hhmm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('06:30'),
  );
  static const VerificationMeta _daysMaskMeta = const VerificationMeta(
    'daysMask',
  );
  @override
  late final GeneratedColumn<int> daysMask = GeneratedColumn<int>(
    'days_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    title,
    timeHhmm,
    daysMask,
    enabled,
    configJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('time_hhmm')) {
      context.handle(
        _timeHhmmMeta,
        timeHhmm.isAcceptableOrUnknown(data['time_hhmm']!, _timeHhmmMeta),
      );
    }
    if (data.containsKey('days_mask')) {
      context.handle(
        _daysMaskMeta,
        daysMask.isAcceptableOrUnknown(data['days_mask']!, _daysMaskMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      timeHhmm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_hhmm'],
      )!,
      daysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_mask'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final String id;
  final String kind;
  final String title;
  final String timeHhmm;
  final int daysMask;
  final bool enabled;
  final String configJson;
  const Routine({
    required this.id,
    required this.kind,
    required this.title,
    required this.timeHhmm,
    required this.daysMask,
    required this.enabled,
    required this.configJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['time_hhmm'] = Variable<String>(timeHhmm);
    map['days_mask'] = Variable<int>(daysMask);
    map['enabled'] = Variable<bool>(enabled);
    map['config_json'] = Variable<String>(configJson);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      timeHhmm: Value(timeHhmm),
      daysMask: Value(daysMask),
      enabled: Value(enabled),
      configJson: Value(configJson),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      timeHhmm: serializer.fromJson<String>(json['timeHhmm']),
      daysMask: serializer.fromJson<int>(json['daysMask']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      configJson: serializer.fromJson<String>(json['configJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'timeHhmm': serializer.toJson<String>(timeHhmm),
      'daysMask': serializer.toJson<int>(daysMask),
      'enabled': serializer.toJson<bool>(enabled),
      'configJson': serializer.toJson<String>(configJson),
    };
  }

  Routine copyWith({
    String? id,
    String? kind,
    String? title,
    String? timeHhmm,
    int? daysMask,
    bool? enabled,
    String? configJson,
  }) => Routine(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    timeHhmm: timeHhmm ?? this.timeHhmm,
    daysMask: daysMask ?? this.daysMask,
    enabled: enabled ?? this.enabled,
    configJson: configJson ?? this.configJson,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      timeHhmm: data.timeHhmm.present ? data.timeHhmm.value : this.timeHhmm,
      daysMask: data.daysMask.present ? data.daysMask.value : this.daysMask,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('timeHhmm: $timeHhmm, ')
          ..write('daysMask: $daysMask, ')
          ..write('enabled: $enabled, ')
          ..write('configJson: $configJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, title, timeHhmm, daysMask, enabled, configJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.timeHhmm == this.timeHhmm &&
          other.daysMask == this.daysMask &&
          other.enabled == this.enabled &&
          other.configJson == this.configJson);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> title;
  final Value<String> timeHhmm;
  final Value<int> daysMask;
  final Value<bool> enabled;
  final Value<String> configJson;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.timeHhmm = const Value.absent(),
    this.daysMask = const Value.absent(),
    this.enabled = const Value.absent(),
    this.configJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String kind,
    required String title,
    this.timeHhmm = const Value.absent(),
    this.daysMask = const Value.absent(),
    this.enabled = const Value.absent(),
    this.configJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       title = Value(title);
  static Insertable<Routine> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? timeHhmm,
    Expression<int>? daysMask,
    Expression<bool>? enabled,
    Expression<String>? configJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (timeHhmm != null) 'time_hhmm': timeHhmm,
      if (daysMask != null) 'days_mask': daysMask,
      if (enabled != null) 'enabled': enabled,
      if (configJson != null) 'config_json': configJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? title,
    Value<String>? timeHhmm,
    Value<int>? daysMask,
    Value<bool>? enabled,
    Value<String>? configJson,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      timeHhmm: timeHhmm ?? this.timeHhmm,
      daysMask: daysMask ?? this.daysMask,
      enabled: enabled ?? this.enabled,
      configJson: configJson ?? this.configJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (timeHhmm.present) {
      map['time_hhmm'] = Variable<String>(timeHhmm.value);
    }
    if (daysMask.present) {
      map['days_mask'] = Variable<int>(daysMask.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('timeHhmm: $timeHhmm, ')
          ..write('daysMask: $daysMask, ')
          ..write('enabled: $enabled, ')
          ..write('configJson: $configJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneE164Meta = const VerificationMeta(
    'phoneE164',
  );
  @override
  late final GeneratedColumn<String> phoneE164 = GeneratedColumn<String>(
    'phone_e164',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelMeta = const VerificationMeta(
    'channel',
  );
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
    'channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('both'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phoneE164, channel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_e164')) {
      context.handle(
        _phoneE164Meta,
        phoneE164.isAcceptableOrUnknown(data['phone_e164']!, _phoneE164Meta),
      );
    } else if (isInserting) {
      context.missing(_phoneE164Meta);
    }
    if (data.containsKey('channel')) {
      context.handle(
        _channelMeta,
        channel.isAcceptableOrUnknown(data['channel']!, _channelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneE164: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_e164'],
      )!,
      channel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel'],
      )!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final String id;
  final String name;
  final String phoneE164;
  final String channel;
  const Contact({
    required this.id,
    required this.name,
    required this.phoneE164,
    required this.channel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone_e164'] = Variable<String>(phoneE164);
    map['channel'] = Variable<String>(channel);
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      name: Value(name),
      phoneE164: Value(phoneE164),
      channel: Value(channel),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneE164: serializer.fromJson<String>(json['phoneE164']),
      channel: serializer.fromJson<String>(json['channel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phoneE164': serializer.toJson<String>(phoneE164),
      'channel': serializer.toJson<String>(channel),
    };
  }

  Contact copyWith({
    String? id,
    String? name,
    String? phoneE164,
    String? channel,
  }) => Contact(
    id: id ?? this.id,
    name: name ?? this.name,
    phoneE164: phoneE164 ?? this.phoneE164,
    channel: channel ?? this.channel,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneE164: data.phoneE164.present ? data.phoneE164.value : this.phoneE164,
      channel: data.channel.present ? data.channel.value : this.channel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneE164: $phoneE164, ')
          ..write('channel: $channel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phoneE164, channel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneE164 == this.phoneE164 &&
          other.channel == this.channel);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phoneE164;
  final Value<String> channel;
  final Value<int> rowid;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneE164 = const Value.absent(),
    this.channel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    required String id,
    required String name,
    required String phoneE164,
    this.channel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       phoneE164 = Value(phoneE164);
  static Insertable<Contact> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phoneE164,
    Expression<String>? channel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneE164 != null) 'phone_e164': phoneE164,
      if (channel != null) 'channel': channel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phoneE164,
    Value<String>? channel,
    Value<int>? rowid,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneE164: phoneE164 ?? this.phoneE164,
      channel: channel ?? this.channel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneE164.present) {
      map['phone_e164'] = Variable<String>(phoneE164.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneE164: $phoneE164, ')
          ..write('channel: $channel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppCategoriesTable extends AppCategories
    with TableInfo<$AppCategoriesTable, AppCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageMeta = const VerificationMeta(
    'package',
  );
  @override
  late final GeneratedColumn<String> package = GeneratedColumn<String>(
    'package',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userSetMeta = const VerificationMeta(
    'userSet',
  );
  @override
  late final GeneratedColumn<bool> userSet = GeneratedColumn<bool>(
    'user_set',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_set" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [package, label, category, userSet];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package')) {
      context.handle(
        _packageMeta,
        package.isAcceptableOrUnknown(data['package']!, _packageMeta),
      );
    } else if (isInserting) {
      context.missing(_packageMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('user_set')) {
      context.handle(
        _userSetMeta,
        userSet.isAcceptableOrUnknown(data['user_set']!, _userSetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {package};
  @override
  AppCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppCategory(
      package: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      userSet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_set'],
      )!,
    );
  }

  @override
  $AppCategoriesTable createAlias(String alias) {
    return $AppCategoriesTable(attachedDatabase, alias);
  }
}

class AppCategory extends DataClass implements Insertable<AppCategory> {
  final String package;
  final String label;
  final String category;
  final bool userSet;
  const AppCategory({
    required this.package,
    required this.label,
    required this.category,
    required this.userSet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package'] = Variable<String>(package);
    map['label'] = Variable<String>(label);
    map['category'] = Variable<String>(category);
    map['user_set'] = Variable<bool>(userSet);
    return map;
  }

  AppCategoriesCompanion toCompanion(bool nullToAbsent) {
    return AppCategoriesCompanion(
      package: Value(package),
      label: Value(label),
      category: Value(category),
      userSet: Value(userSet),
    );
  }

  factory AppCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppCategory(
      package: serializer.fromJson<String>(json['package']),
      label: serializer.fromJson<String>(json['label']),
      category: serializer.fromJson<String>(json['category']),
      userSet: serializer.fromJson<bool>(json['userSet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'package': serializer.toJson<String>(package),
      'label': serializer.toJson<String>(label),
      'category': serializer.toJson<String>(category),
      'userSet': serializer.toJson<bool>(userSet),
    };
  }

  AppCategory copyWith({
    String? package,
    String? label,
    String? category,
    bool? userSet,
  }) => AppCategory(
    package: package ?? this.package,
    label: label ?? this.label,
    category: category ?? this.category,
    userSet: userSet ?? this.userSet,
  );
  AppCategory copyWithCompanion(AppCategoriesCompanion data) {
    return AppCategory(
      package: data.package.present ? data.package.value : this.package,
      label: data.label.present ? data.label.value : this.label,
      category: data.category.present ? data.category.value : this.category,
      userSet: data.userSet.present ? data.userSet.value : this.userSet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppCategory(')
          ..write('package: $package, ')
          ..write('label: $label, ')
          ..write('category: $category, ')
          ..write('userSet: $userSet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(package, label, category, userSet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppCategory &&
          other.package == this.package &&
          other.label == this.label &&
          other.category == this.category &&
          other.userSet == this.userSet);
}

class AppCategoriesCompanion extends UpdateCompanion<AppCategory> {
  final Value<String> package;
  final Value<String> label;
  final Value<String> category;
  final Value<bool> userSet;
  final Value<int> rowid;
  const AppCategoriesCompanion({
    this.package = const Value.absent(),
    this.label = const Value.absent(),
    this.category = const Value.absent(),
    this.userSet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppCategoriesCompanion.insert({
    required String package,
    required String label,
    required String category,
    this.userSet = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : package = Value(package),
       label = Value(label),
       category = Value(category);
  static Insertable<AppCategory> custom({
    Expression<String>? package,
    Expression<String>? label,
    Expression<String>? category,
    Expression<bool>? userSet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (package != null) 'package': package,
      if (label != null) 'label': label,
      if (category != null) 'category': category,
      if (userSet != null) 'user_set': userSet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppCategoriesCompanion copyWith({
    Value<String>? package,
    Value<String>? label,
    Value<String>? category,
    Value<bool>? userSet,
    Value<int>? rowid,
  }) {
    return AppCategoriesCompanion(
      package: package ?? this.package,
      label: label ?? this.label,
      category: category ?? this.category,
      userSet: userSet ?? this.userSet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (package.present) {
      map['package'] = Variable<String>(package.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (userSet.present) {
      map['user_set'] = Variable<bool>(userSet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppCategoriesCompanion(')
          ..write('package: $package, ')
          ..write('label: $label, ')
          ..write('category: $category, ')
          ..write('userSet: $userSet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageSessionsTable extends UsageSessions
    with TableInfo<$UsageSessionsTable, UsageSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageMeta = const VerificationMeta(
    'package',
  );
  @override
  late final GeneratedColumn<String> package = GeneratedColumn<String>(
    'package',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    package,
    startedAt,
    endedAt,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package')) {
      context.handle(
        _packageMeta,
        package.isAcceptableOrUnknown(data['package']!, _packageMeta),
      );
    } else if (isInserting) {
      context.missing(_packageMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      package: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $UsageSessionsTable createAlias(String alias) {
    return $UsageSessionsTable(attachedDatabase, alias);
  }
}

class UsageSession extends DataClass implements Insertable<UsageSession> {
  final int id;
  final String package;
  final int startedAt;
  final int endedAt;
  final String category;
  const UsageSession({
    required this.id,
    required this.package,
    required this.startedAt,
    required this.endedAt,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package'] = Variable<String>(package);
    map['started_at'] = Variable<int>(startedAt);
    map['ended_at'] = Variable<int>(endedAt);
    map['category'] = Variable<String>(category);
    return map;
  }

  UsageSessionsCompanion toCompanion(bool nullToAbsent) {
    return UsageSessionsCompanion(
      id: Value(id),
      package: Value(package),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      category: Value(category),
    );
  }

  factory UsageSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageSession(
      id: serializer.fromJson<int>(json['id']),
      package: serializer.fromJson<String>(json['package']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int>(json['endedAt']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'package': serializer.toJson<String>(package),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int>(endedAt),
      'category': serializer.toJson<String>(category),
    };
  }

  UsageSession copyWith({
    int? id,
    String? package,
    int? startedAt,
    int? endedAt,
    String? category,
  }) => UsageSession(
    id: id ?? this.id,
    package: package ?? this.package,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    category: category ?? this.category,
  );
  UsageSession copyWithCompanion(UsageSessionsCompanion data) {
    return UsageSession(
      id: data.id.present ? data.id.value : this.id,
      package: data.package.present ? data.package.value : this.package,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageSession(')
          ..write('id: $id, ')
          ..write('package: $package, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, package, startedAt, endedAt, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageSession &&
          other.id == this.id &&
          other.package == this.package &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.category == this.category);
}

class UsageSessionsCompanion extends UpdateCompanion<UsageSession> {
  final Value<int> id;
  final Value<String> package;
  final Value<int> startedAt;
  final Value<int> endedAt;
  final Value<String> category;
  const UsageSessionsCompanion({
    this.id = const Value.absent(),
    this.package = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.category = const Value.absent(),
  });
  UsageSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String package,
    required int startedAt,
    required int endedAt,
    required String category,
  }) : package = Value(package),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       category = Value(category);
  static Insertable<UsageSession> custom({
    Expression<int>? id,
    Expression<String>? package,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (package != null) 'package': package,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (category != null) 'category': category,
    });
  }

  UsageSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? package,
    Value<int>? startedAt,
    Value<int>? endedAt,
    Value<String>? category,
  }) {
    return UsageSessionsCompanion(
      id: id ?? this.id,
      package: package ?? this.package,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (package.present) {
      map['package'] = Variable<String>(package.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageSessionsCompanion(')
          ..write('id: $id, ')
          ..write('package: $package, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $ContentItemsTable extends ContentItems
    with TableInfo<$ContentItemsTable, ContentItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageMeta = const VerificationMeta(
    'package',
  );
  @override
  late final GeneratedColumn<String> package = GeneratedColumn<String>(
    'package',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelOrDomainMeta = const VerificationMeta(
    'channelOrDomain',
  );
  @override
  late final GeneratedColumn<String> channelOrDomain = GeneratedColumn<String>(
    'channel_or_domain',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('page'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classifiedByMeta = const VerificationMeta(
    'classifiedBy',
  );
  @override
  late final GeneratedColumn<String> classifiedBy = GeneratedColumn<String>(
    'classified_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _titleHashMeta = const VerificationMeta(
    'titleHash',
  );
  @override
  late final GeneratedColumn<String> titleHash = GeneratedColumn<String>(
    'title_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    package,
    title,
    channelOrDomain,
    kind,
    startedAt,
    endedAt,
    category,
    classifiedBy,
    titleHash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package')) {
      context.handle(
        _packageMeta,
        package.isAcceptableOrUnknown(data['package']!, _packageMeta),
      );
    } else if (isInserting) {
      context.missing(_packageMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('channel_or_domain')) {
      context.handle(
        _channelOrDomainMeta,
        channelOrDomain.isAcceptableOrUnknown(
          data['channel_or_domain']!,
          _channelOrDomainMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('classified_by')) {
      context.handle(
        _classifiedByMeta,
        classifiedBy.isAcceptableOrUnknown(
          data['classified_by']!,
          _classifiedByMeta,
        ),
      );
    }
    if (data.containsKey('title_hash')) {
      context.handle(
        _titleHashMeta,
        titleHash.isAcceptableOrUnknown(data['title_hash']!, _titleHashMeta),
      );
    } else if (isInserting) {
      context.missing(_titleHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      package: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      channelOrDomain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_or_domain'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      classifiedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classified_by'],
      )!,
      titleHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_hash'],
      )!,
    );
  }

  @override
  $ContentItemsTable createAlias(String alias) {
    return $ContentItemsTable(attachedDatabase, alias);
  }
}

class ContentItem extends DataClass implements Insertable<ContentItem> {
  final int id;
  final String package;
  final String title;
  final String? channelOrDomain;
  final String kind;
  final int startedAt;
  final int? endedAt;
  final String? category;
  final String classifiedBy;
  final String titleHash;
  const ContentItem({
    required this.id,
    required this.package,
    required this.title,
    this.channelOrDomain,
    required this.kind,
    required this.startedAt,
    this.endedAt,
    this.category,
    required this.classifiedBy,
    required this.titleHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package'] = Variable<String>(package);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || channelOrDomain != null) {
      map['channel_or_domain'] = Variable<String>(channelOrDomain);
    }
    map['kind'] = Variable<String>(kind);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['classified_by'] = Variable<String>(classifiedBy);
    map['title_hash'] = Variable<String>(titleHash);
    return map;
  }

  ContentItemsCompanion toCompanion(bool nullToAbsent) {
    return ContentItemsCompanion(
      id: Value(id),
      package: Value(package),
      title: Value(title),
      channelOrDomain: channelOrDomain == null && nullToAbsent
          ? const Value.absent()
          : Value(channelOrDomain),
      kind: Value(kind),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      classifiedBy: Value(classifiedBy),
      titleHash: Value(titleHash),
    );
  }

  factory ContentItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentItem(
      id: serializer.fromJson<int>(json['id']),
      package: serializer.fromJson<String>(json['package']),
      title: serializer.fromJson<String>(json['title']),
      channelOrDomain: serializer.fromJson<String?>(json['channelOrDomain']),
      kind: serializer.fromJson<String>(json['kind']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      category: serializer.fromJson<String?>(json['category']),
      classifiedBy: serializer.fromJson<String>(json['classifiedBy']),
      titleHash: serializer.fromJson<String>(json['titleHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'package': serializer.toJson<String>(package),
      'title': serializer.toJson<String>(title),
      'channelOrDomain': serializer.toJson<String?>(channelOrDomain),
      'kind': serializer.toJson<String>(kind),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'category': serializer.toJson<String?>(category),
      'classifiedBy': serializer.toJson<String>(classifiedBy),
      'titleHash': serializer.toJson<String>(titleHash),
    };
  }

  ContentItem copyWith({
    int? id,
    String? package,
    String? title,
    Value<String?> channelOrDomain = const Value.absent(),
    String? kind,
    int? startedAt,
    Value<int?> endedAt = const Value.absent(),
    Value<String?> category = const Value.absent(),
    String? classifiedBy,
    String? titleHash,
  }) => ContentItem(
    id: id ?? this.id,
    package: package ?? this.package,
    title: title ?? this.title,
    channelOrDomain: channelOrDomain.present
        ? channelOrDomain.value
        : this.channelOrDomain,
    kind: kind ?? this.kind,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    category: category.present ? category.value : this.category,
    classifiedBy: classifiedBy ?? this.classifiedBy,
    titleHash: titleHash ?? this.titleHash,
  );
  ContentItem copyWithCompanion(ContentItemsCompanion data) {
    return ContentItem(
      id: data.id.present ? data.id.value : this.id,
      package: data.package.present ? data.package.value : this.package,
      title: data.title.present ? data.title.value : this.title,
      channelOrDomain: data.channelOrDomain.present
          ? data.channelOrDomain.value
          : this.channelOrDomain,
      kind: data.kind.present ? data.kind.value : this.kind,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      category: data.category.present ? data.category.value : this.category,
      classifiedBy: data.classifiedBy.present
          ? data.classifiedBy.value
          : this.classifiedBy,
      titleHash: data.titleHash.present ? data.titleHash.value : this.titleHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentItem(')
          ..write('id: $id, ')
          ..write('package: $package, ')
          ..write('title: $title, ')
          ..write('channelOrDomain: $channelOrDomain, ')
          ..write('kind: $kind, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('category: $category, ')
          ..write('classifiedBy: $classifiedBy, ')
          ..write('titleHash: $titleHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    package,
    title,
    channelOrDomain,
    kind,
    startedAt,
    endedAt,
    category,
    classifiedBy,
    titleHash,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentItem &&
          other.id == this.id &&
          other.package == this.package &&
          other.title == this.title &&
          other.channelOrDomain == this.channelOrDomain &&
          other.kind == this.kind &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.category == this.category &&
          other.classifiedBy == this.classifiedBy &&
          other.titleHash == this.titleHash);
}

class ContentItemsCompanion extends UpdateCompanion<ContentItem> {
  final Value<int> id;
  final Value<String> package;
  final Value<String> title;
  final Value<String?> channelOrDomain;
  final Value<String> kind;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<String?> category;
  final Value<String> classifiedBy;
  final Value<String> titleHash;
  const ContentItemsCompanion({
    this.id = const Value.absent(),
    this.package = const Value.absent(),
    this.title = const Value.absent(),
    this.channelOrDomain = const Value.absent(),
    this.kind = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.classifiedBy = const Value.absent(),
    this.titleHash = const Value.absent(),
  });
  ContentItemsCompanion.insert({
    this.id = const Value.absent(),
    required String package,
    required String title,
    this.channelOrDomain = const Value.absent(),
    this.kind = const Value.absent(),
    required int startedAt,
    this.endedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.classifiedBy = const Value.absent(),
    required String titleHash,
  }) : package = Value(package),
       title = Value(title),
       startedAt = Value(startedAt),
       titleHash = Value(titleHash);
  static Insertable<ContentItem> custom({
    Expression<int>? id,
    Expression<String>? package,
    Expression<String>? title,
    Expression<String>? channelOrDomain,
    Expression<String>? kind,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<String>? category,
    Expression<String>? classifiedBy,
    Expression<String>? titleHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (package != null) 'package': package,
      if (title != null) 'title': title,
      if (channelOrDomain != null) 'channel_or_domain': channelOrDomain,
      if (kind != null) 'kind': kind,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (category != null) 'category': category,
      if (classifiedBy != null) 'classified_by': classifiedBy,
      if (titleHash != null) 'title_hash': titleHash,
    });
  }

  ContentItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? package,
    Value<String>? title,
    Value<String?>? channelOrDomain,
    Value<String>? kind,
    Value<int>? startedAt,
    Value<int?>? endedAt,
    Value<String?>? category,
    Value<String>? classifiedBy,
    Value<String>? titleHash,
  }) {
    return ContentItemsCompanion(
      id: id ?? this.id,
      package: package ?? this.package,
      title: title ?? this.title,
      channelOrDomain: channelOrDomain ?? this.channelOrDomain,
      kind: kind ?? this.kind,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      category: category ?? this.category,
      classifiedBy: classifiedBy ?? this.classifiedBy,
      titleHash: titleHash ?? this.titleHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (package.present) {
      map['package'] = Variable<String>(package.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (channelOrDomain.present) {
      map['channel_or_domain'] = Variable<String>(channelOrDomain.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (classifiedBy.present) {
      map['classified_by'] = Variable<String>(classifiedBy.value);
    }
    if (titleHash.present) {
      map['title_hash'] = Variable<String>(titleHash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentItemsCompanion(')
          ..write('id: $id, ')
          ..write('package: $package, ')
          ..write('title: $title, ')
          ..write('channelOrDomain: $channelOrDomain, ')
          ..write('kind: $kind, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('category: $category, ')
          ..write('classifiedBy: $classifiedBy, ')
          ..write('titleHash: $titleHash')
          ..write(')'))
        .toString();
  }
}

class $ContentRulesTable extends ContentRules
    with TableInfo<$ContentRulesTable, ContentRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _matchTypeMeta = const VerificationMeta(
    'matchType',
  );
  @override
  late final GeneratedColumn<String> matchType = GeneratedColumn<String>(
    'match_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, matchType, value, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('match_type')) {
      context.handle(
        _matchTypeMeta,
        matchType.isAcceptableOrUnknown(data['match_type']!, _matchTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_matchTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      matchType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $ContentRulesTable createAlias(String alias) {
    return $ContentRulesTable(attachedDatabase, alias);
  }
}

class ContentRule extends DataClass implements Insertable<ContentRule> {
  final int id;
  final String matchType;
  final String value;
  final String category;
  const ContentRule({
    required this.id,
    required this.matchType,
    required this.value,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['match_type'] = Variable<String>(matchType);
    map['value'] = Variable<String>(value);
    map['category'] = Variable<String>(category);
    return map;
  }

  ContentRulesCompanion toCompanion(bool nullToAbsent) {
    return ContentRulesCompanion(
      id: Value(id),
      matchType: Value(matchType),
      value: Value(value),
      category: Value(category),
    );
  }

  factory ContentRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentRule(
      id: serializer.fromJson<int>(json['id']),
      matchType: serializer.fromJson<String>(json['matchType']),
      value: serializer.fromJson<String>(json['value']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'matchType': serializer.toJson<String>(matchType),
      'value': serializer.toJson<String>(value),
      'category': serializer.toJson<String>(category),
    };
  }

  ContentRule copyWith({
    int? id,
    String? matchType,
    String? value,
    String? category,
  }) => ContentRule(
    id: id ?? this.id,
    matchType: matchType ?? this.matchType,
    value: value ?? this.value,
    category: category ?? this.category,
  );
  ContentRule copyWithCompanion(ContentRulesCompanion data) {
    return ContentRule(
      id: data.id.present ? data.id.value : this.id,
      matchType: data.matchType.present ? data.matchType.value : this.matchType,
      value: data.value.present ? data.value.value : this.value,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentRule(')
          ..write('id: $id, ')
          ..write('matchType: $matchType, ')
          ..write('value: $value, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, matchType, value, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentRule &&
          other.id == this.id &&
          other.matchType == this.matchType &&
          other.value == this.value &&
          other.category == this.category);
}

class ContentRulesCompanion extends UpdateCompanion<ContentRule> {
  final Value<int> id;
  final Value<String> matchType;
  final Value<String> value;
  final Value<String> category;
  const ContentRulesCompanion({
    this.id = const Value.absent(),
    this.matchType = const Value.absent(),
    this.value = const Value.absent(),
    this.category = const Value.absent(),
  });
  ContentRulesCompanion.insert({
    this.id = const Value.absent(),
    required String matchType,
    required String value,
    required String category,
  }) : matchType = Value(matchType),
       value = Value(value),
       category = Value(category);
  static Insertable<ContentRule> custom({
    Expression<int>? id,
    Expression<String>? matchType,
    Expression<String>? value,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (matchType != null) 'match_type': matchType,
      if (value != null) 'value': value,
      if (category != null) 'category': category,
    });
  }

  ContentRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? matchType,
    Value<String>? value,
    Value<String>? category,
  }) {
    return ContentRulesCompanion(
      id: id ?? this.id,
      matchType: matchType ?? this.matchType,
      value: value ?? this.value,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (matchType.present) {
      map['match_type'] = Variable<String>(matchType.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentRulesCompanion(')
          ..write('id: $id, ')
          ..write('matchType: $matchType, ')
          ..write('value: $value, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $ActivityDailyTable extends ActivityDaily
    with TableInfo<$ActivityDailyTable, ActivityDailyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityDailyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
    'distance_m',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activeMinMeta = const VerificationMeta(
    'activeMin',
  );
  @override
  late final GeneratedColumn<int> activeMin = GeneratedColumn<int>(
    'active_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exerciseMinMeta = const VerificationMeta(
    'exerciseMin',
  );
  @override
  late final GeneratedColumn<int> exerciseMin = GeneratedColumn<int>(
    'exercise_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    steps,
    distanceM,
    activeMin,
    exerciseMin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_daily';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityDailyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    }
    if (data.containsKey('active_min')) {
      context.handle(
        _activeMinMeta,
        activeMin.isAcceptableOrUnknown(data['active_min']!, _activeMinMeta),
      );
    }
    if (data.containsKey('exercise_min')) {
      context.handle(
        _exerciseMinMeta,
        exerciseMin.isAcceptableOrUnknown(
          data['exercise_min']!,
          _exerciseMinMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  ActivityDailyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityDailyData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distance_m'],
      )!,
      activeMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_min'],
      )!,
      exerciseMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_min'],
      )!,
    );
  }

  @override
  $ActivityDailyTable createAlias(String alias) {
    return $ActivityDailyTable(attachedDatabase, alias);
  }
}

class ActivityDailyData extends DataClass
    implements Insertable<ActivityDailyData> {
  final String date;
  final int steps;
  final int distanceM;
  final int activeMin;
  final int exerciseMin;
  const ActivityDailyData({
    required this.date,
    required this.steps,
    required this.distanceM,
    required this.activeMin,
    required this.exerciseMin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['steps'] = Variable<int>(steps);
    map['distance_m'] = Variable<int>(distanceM);
    map['active_min'] = Variable<int>(activeMin);
    map['exercise_min'] = Variable<int>(exerciseMin);
    return map;
  }

  ActivityDailyCompanion toCompanion(bool nullToAbsent) {
    return ActivityDailyCompanion(
      date: Value(date),
      steps: Value(steps),
      distanceM: Value(distanceM),
      activeMin: Value(activeMin),
      exerciseMin: Value(exerciseMin),
    );
  }

  factory ActivityDailyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityDailyData(
      date: serializer.fromJson<String>(json['date']),
      steps: serializer.fromJson<int>(json['steps']),
      distanceM: serializer.fromJson<int>(json['distanceM']),
      activeMin: serializer.fromJson<int>(json['activeMin']),
      exerciseMin: serializer.fromJson<int>(json['exerciseMin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'steps': serializer.toJson<int>(steps),
      'distanceM': serializer.toJson<int>(distanceM),
      'activeMin': serializer.toJson<int>(activeMin),
      'exerciseMin': serializer.toJson<int>(exerciseMin),
    };
  }

  ActivityDailyData copyWith({
    String? date,
    int? steps,
    int? distanceM,
    int? activeMin,
    int? exerciseMin,
  }) => ActivityDailyData(
    date: date ?? this.date,
    steps: steps ?? this.steps,
    distanceM: distanceM ?? this.distanceM,
    activeMin: activeMin ?? this.activeMin,
    exerciseMin: exerciseMin ?? this.exerciseMin,
  );
  ActivityDailyData copyWithCompanion(ActivityDailyCompanion data) {
    return ActivityDailyData(
      date: data.date.present ? data.date.value : this.date,
      steps: data.steps.present ? data.steps.value : this.steps,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      activeMin: data.activeMin.present ? data.activeMin.value : this.activeMin,
      exerciseMin: data.exerciseMin.present
          ? data.exerciseMin.value
          : this.exerciseMin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityDailyData(')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('distanceM: $distanceM, ')
          ..write('activeMin: $activeMin, ')
          ..write('exerciseMin: $exerciseMin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, steps, distanceM, activeMin, exerciseMin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityDailyData &&
          other.date == this.date &&
          other.steps == this.steps &&
          other.distanceM == this.distanceM &&
          other.activeMin == this.activeMin &&
          other.exerciseMin == this.exerciseMin);
}

class ActivityDailyCompanion extends UpdateCompanion<ActivityDailyData> {
  final Value<String> date;
  final Value<int> steps;
  final Value<int> distanceM;
  final Value<int> activeMin;
  final Value<int> exerciseMin;
  final Value<int> rowid;
  const ActivityDailyCompanion({
    this.date = const Value.absent(),
    this.steps = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.activeMin = const Value.absent(),
    this.exerciseMin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityDailyCompanion.insert({
    required String date,
    this.steps = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.activeMin = const Value.absent(),
    this.exerciseMin = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<ActivityDailyData> custom({
    Expression<String>? date,
    Expression<int>? steps,
    Expression<int>? distanceM,
    Expression<int>? activeMin,
    Expression<int>? exerciseMin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (steps != null) 'steps': steps,
      if (distanceM != null) 'distance_m': distanceM,
      if (activeMin != null) 'active_min': activeMin,
      if (exerciseMin != null) 'exercise_min': exerciseMin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityDailyCompanion copyWith({
    Value<String>? date,
    Value<int>? steps,
    Value<int>? distanceM,
    Value<int>? activeMin,
    Value<int>? exerciseMin,
    Value<int>? rowid,
  }) {
    return ActivityDailyCompanion(
      date: date ?? this.date,
      steps: steps ?? this.steps,
      distanceM: distanceM ?? this.distanceM,
      activeMin: activeMin ?? this.activeMin,
      exerciseMin: exerciseMin ?? this.exerciseMin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    if (activeMin.present) {
      map['active_min'] = Variable<int>(activeMin.value);
    }
    if (exerciseMin.present) {
      map['exercise_min'] = Variable<int>(exerciseMin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityDailyCompanion(')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('distanceM: $distanceM, ')
          ..write('activeMin: $activeMin, ')
          ..write('exerciseMin: $exerciseMin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoneyEntriesTable extends MoneyEntries
    with TableInfo<$MoneyEntriesTable, MoneyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoneyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringIdMeta = const VerificationMeta(
    'recurringId',
  );
  @override
  late final GeneratedColumn<String> recurringId = GeneratedColumn<String>(
    'recurring_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    date,
    amountPaise,
    kind,
    category,
    note,
    recurringId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'money_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoneyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('recurring_id')) {
      context.handle(
        _recurringIdMeta,
        recurringId.isAcceptableOrUnknown(
          data['recurring_id']!,
          _recurringIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoneyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoneyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      recurringId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_id'],
      ),
    );
  }

  @override
  $MoneyEntriesTable createAlias(String alias) {
    return $MoneyEntriesTable(attachedDatabase, alias);
  }
}

class MoneyEntry extends DataClass implements Insertable<MoneyEntry> {
  final String id;
  final String? goalId;
  final int date;
  final int amountPaise;
  final String kind;
  final String category;
  final String? note;
  final String? recurringId;
  const MoneyEntry({
    required this.id,
    this.goalId,
    required this.date,
    required this.amountPaise,
    required this.kind,
    required this.category,
    this.note,
    this.recurringId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    map['date'] = Variable<int>(date);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['kind'] = Variable<String>(kind);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || recurringId != null) {
      map['recurring_id'] = Variable<String>(recurringId);
    }
    return map;
  }

  MoneyEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoneyEntriesCompanion(
      id: Value(id),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      date: Value(date),
      amountPaise: Value(amountPaise),
      kind: Value(kind),
      category: Value(category),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      recurringId: recurringId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringId),
    );
  }

  factory MoneyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoneyEntry(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      date: serializer.fromJson<int>(json['date']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      kind: serializer.fromJson<String>(json['kind']),
      category: serializer.fromJson<String>(json['category']),
      note: serializer.fromJson<String?>(json['note']),
      recurringId: serializer.fromJson<String?>(json['recurringId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String?>(goalId),
      'date': serializer.toJson<int>(date),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'kind': serializer.toJson<String>(kind),
      'category': serializer.toJson<String>(category),
      'note': serializer.toJson<String?>(note),
      'recurringId': serializer.toJson<String?>(recurringId),
    };
  }

  MoneyEntry copyWith({
    String? id,
    Value<String?> goalId = const Value.absent(),
    int? date,
    int? amountPaise,
    String? kind,
    String? category,
    Value<String?> note = const Value.absent(),
    Value<String?> recurringId = const Value.absent(),
  }) => MoneyEntry(
    id: id ?? this.id,
    goalId: goalId.present ? goalId.value : this.goalId,
    date: date ?? this.date,
    amountPaise: amountPaise ?? this.amountPaise,
    kind: kind ?? this.kind,
    category: category ?? this.category,
    note: note.present ? note.value : this.note,
    recurringId: recurringId.present ? recurringId.value : this.recurringId,
  );
  MoneyEntry copyWithCompanion(MoneyEntriesCompanion data) {
    return MoneyEntry(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      date: data.date.present ? data.date.value : this.date,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      kind: data.kind.present ? data.kind.value : this.kind,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      recurringId: data.recurringId.present
          ? data.recurringId.value
          : this.recurringId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoneyEntry(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('date: $date, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('recurringId: $recurringId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalId,
    date,
    amountPaise,
    kind,
    category,
    note,
    recurringId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoneyEntry &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.date == this.date &&
          other.amountPaise == this.amountPaise &&
          other.kind == this.kind &&
          other.category == this.category &&
          other.note == this.note &&
          other.recurringId == this.recurringId);
}

class MoneyEntriesCompanion extends UpdateCompanion<MoneyEntry> {
  final Value<String> id;
  final Value<String?> goalId;
  final Value<int> date;
  final Value<int> amountPaise;
  final Value<String> kind;
  final Value<String> category;
  final Value<String?> note;
  final Value<String?> recurringId;
  final Value<int> rowid;
  const MoneyEntriesCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.date = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.kind = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoneyEntriesCompanion.insert({
    required String id,
    this.goalId = const Value.absent(),
    required int date,
    required int amountPaise,
    required String kind,
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       amountPaise = Value(amountPaise),
       kind = Value(kind);
  static Insertable<MoneyEntry> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<int>? date,
    Expression<int>? amountPaise,
    Expression<String>? kind,
    Expression<String>? category,
    Expression<String>? note,
    Expression<String>? recurringId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (date != null) 'date': date,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (kind != null) 'kind': kind,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (recurringId != null) 'recurring_id': recurringId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoneyEntriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? goalId,
    Value<int>? date,
    Value<int>? amountPaise,
    Value<String>? kind,
    Value<String>? category,
    Value<String?>? note,
    Value<String?>? recurringId,
    Value<int>? rowid,
  }) {
    return MoneyEntriesCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      date: date ?? this.date,
      amountPaise: amountPaise ?? this.amountPaise,
      kind: kind ?? this.kind,
      category: category ?? this.category,
      note: note ?? this.note,
      recurringId: recurringId ?? this.recurringId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (recurringId.present) {
      map['recurring_id'] = Variable<String>(recurringId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoneyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('date: $date, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('recurringId: $recurringId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoneyRecurringTable extends MoneyRecurring
    with TableInfo<$MoneyRecurringTable, MoneyRecurringData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoneyRecurringTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amountPaise,
    kind,
    category,
    dayOfMonth,
    goalId,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'money_recurring';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoneyRecurringData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoneyRecurringData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoneyRecurringData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $MoneyRecurringTable createAlias(String alias) {
    return $MoneyRecurringTable(attachedDatabase, alias);
  }
}

class MoneyRecurringData extends DataClass
    implements Insertable<MoneyRecurringData> {
  final String id;
  final String title;
  final int amountPaise;
  final String kind;
  final String category;
  final int dayOfMonth;
  final String? goalId;
  final bool enabled;
  const MoneyRecurringData({
    required this.id,
    required this.title,
    required this.amountPaise,
    required this.kind,
    required this.category,
    required this.dayOfMonth,
    this.goalId,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['kind'] = Variable<String>(kind);
    map['category'] = Variable<String>(category);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  MoneyRecurringCompanion toCompanion(bool nullToAbsent) {
    return MoneyRecurringCompanion(
      id: Value(id),
      title: Value(title),
      amountPaise: Value(amountPaise),
      kind: Value(kind),
      category: Value(category),
      dayOfMonth: Value(dayOfMonth),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      enabled: Value(enabled),
    );
  }

  factory MoneyRecurringData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoneyRecurringData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      kind: serializer.fromJson<String>(json['kind']),
      category: serializer.fromJson<String>(json['category']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'kind': serializer.toJson<String>(kind),
      'category': serializer.toJson<String>(category),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'goalId': serializer.toJson<String?>(goalId),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  MoneyRecurringData copyWith({
    String? id,
    String? title,
    int? amountPaise,
    String? kind,
    String? category,
    int? dayOfMonth,
    Value<String?> goalId = const Value.absent(),
    bool? enabled,
  }) => MoneyRecurringData(
    id: id ?? this.id,
    title: title ?? this.title,
    amountPaise: amountPaise ?? this.amountPaise,
    kind: kind ?? this.kind,
    category: category ?? this.category,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    goalId: goalId.present ? goalId.value : this.goalId,
    enabled: enabled ?? this.enabled,
  );
  MoneyRecurringData copyWithCompanion(MoneyRecurringCompanion data) {
    return MoneyRecurringData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      kind: data.kind.present ? data.kind.value : this.kind,
      category: data.category.present ? data.category.value : this.category,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoneyRecurringData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('goalId: $goalId, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amountPaise,
    kind,
    category,
    dayOfMonth,
    goalId,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoneyRecurringData &&
          other.id == this.id &&
          other.title == this.title &&
          other.amountPaise == this.amountPaise &&
          other.kind == this.kind &&
          other.category == this.category &&
          other.dayOfMonth == this.dayOfMonth &&
          other.goalId == this.goalId &&
          other.enabled == this.enabled);
}

class MoneyRecurringCompanion extends UpdateCompanion<MoneyRecurringData> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> amountPaise;
  final Value<String> kind;
  final Value<String> category;
  final Value<int> dayOfMonth;
  final Value<String?> goalId;
  final Value<bool> enabled;
  final Value<int> rowid;
  const MoneyRecurringCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.kind = const Value.absent(),
    this.category = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.goalId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoneyRecurringCompanion.insert({
    required String id,
    required String title,
    required int amountPaise,
    required String kind,
    this.category = const Value.absent(),
    required int dayOfMonth,
    this.goalId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       amountPaise = Value(amountPaise),
       kind = Value(kind),
       dayOfMonth = Value(dayOfMonth);
  static Insertable<MoneyRecurringData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? amountPaise,
    Expression<String>? kind,
    Expression<String>? category,
    Expression<int>? dayOfMonth,
    Expression<String>? goalId,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (kind != null) 'kind': kind,
      if (category != null) 'category': category,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (goalId != null) 'goal_id': goalId,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoneyRecurringCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? amountPaise,
    Value<String>? kind,
    Value<String>? category,
    Value<int>? dayOfMonth,
    Value<String?>? goalId,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return MoneyRecurringCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amountPaise: amountPaise ?? this.amountPaise,
      kind: kind ?? this.kind,
      category: category ?? this.category,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      goalId: goalId ?? this.goalId,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoneyRecurringCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('goalId: $goalId, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NudgeLogTable extends NudgeLog
    with TableInfo<$NudgeLogTable, NudgeLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NudgeLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<int> at = GeneratedColumn<int>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageMeta = const VerificationMeta(
    'package',
  );
  @override
  late final GeneratedColumn<String> package = GeneratedColumn<String>(
    'package',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<String> todoId = GeneratedColumn<String>(
    'todo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _text_Meta = const VerificationMeta('text_');
  @override
  late final GeneratedColumn<String> text_ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    type,
    package,
    todoId,
    text_,
    action,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nudge_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<NudgeLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('package')) {
      context.handle(
        _packageMeta,
        package.isAcceptableOrUnknown(data['package']!, _packageMeta),
      );
    }
    if (data.containsKey('todo_id')) {
      context.handle(
        _todoIdMeta,
        todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta),
      );
    }
    if (data.containsKey('text')) {
      context.handle(
        _text_Meta,
        text_.isAcceptableOrUnknown(data['text']!, _text_Meta),
      );
    } else if (isInserting) {
      context.missing(_text_Meta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NudgeLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NudgeLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      package: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package'],
      ),
      todoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}todo_id'],
      ),
      text_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
    );
  }

  @override
  $NudgeLogTable createAlias(String alias) {
    return $NudgeLogTable(attachedDatabase, alias);
  }
}

class NudgeLogData extends DataClass implements Insertable<NudgeLogData> {
  final int id;
  final int at;
  final String type;
  final String? package;
  final String? todoId;
  final String text_;
  final String action;
  const NudgeLogData({
    required this.id,
    required this.at,
    required this.type,
    this.package,
    this.todoId,
    required this.text_,
    required this.action,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<int>(at);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || package != null) {
      map['package'] = Variable<String>(package);
    }
    if (!nullToAbsent || todoId != null) {
      map['todo_id'] = Variable<String>(todoId);
    }
    map['text'] = Variable<String>(text_);
    map['action'] = Variable<String>(action);
    return map;
  }

  NudgeLogCompanion toCompanion(bool nullToAbsent) {
    return NudgeLogCompanion(
      id: Value(id),
      at: Value(at),
      type: Value(type),
      package: package == null && nullToAbsent
          ? const Value.absent()
          : Value(package),
      todoId: todoId == null && nullToAbsent
          ? const Value.absent()
          : Value(todoId),
      text_: Value(text_),
      action: Value(action),
    );
  }

  factory NudgeLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NudgeLogData(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<int>(json['at']),
      type: serializer.fromJson<String>(json['type']),
      package: serializer.fromJson<String?>(json['package']),
      todoId: serializer.fromJson<String?>(json['todoId']),
      text_: serializer.fromJson<String>(json['text_']),
      action: serializer.fromJson<String>(json['action']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<int>(at),
      'type': serializer.toJson<String>(type),
      'package': serializer.toJson<String?>(package),
      'todoId': serializer.toJson<String?>(todoId),
      'text_': serializer.toJson<String>(text_),
      'action': serializer.toJson<String>(action),
    };
  }

  NudgeLogData copyWith({
    int? id,
    int? at,
    String? type,
    Value<String?> package = const Value.absent(),
    Value<String?> todoId = const Value.absent(),
    String? text_,
    String? action,
  }) => NudgeLogData(
    id: id ?? this.id,
    at: at ?? this.at,
    type: type ?? this.type,
    package: package.present ? package.value : this.package,
    todoId: todoId.present ? todoId.value : this.todoId,
    text_: text_ ?? this.text_,
    action: action ?? this.action,
  );
  NudgeLogData copyWithCompanion(NudgeLogCompanion data) {
    return NudgeLogData(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      type: data.type.present ? data.type.value : this.type,
      package: data.package.present ? data.package.value : this.package,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      text_: data.text_.present ? data.text_.value : this.text_,
      action: data.action.present ? data.action.value : this.action,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NudgeLogData(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('type: $type, ')
          ..write('package: $package, ')
          ..write('todoId: $todoId, ')
          ..write('text_: $text_, ')
          ..write('action: $action')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, type, package, todoId, text_, action);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NudgeLogData &&
          other.id == this.id &&
          other.at == this.at &&
          other.type == this.type &&
          other.package == this.package &&
          other.todoId == this.todoId &&
          other.text_ == this.text_ &&
          other.action == this.action);
}

class NudgeLogCompanion extends UpdateCompanion<NudgeLogData> {
  final Value<int> id;
  final Value<int> at;
  final Value<String> type;
  final Value<String?> package;
  final Value<String?> todoId;
  final Value<String> text_;
  final Value<String> action;
  const NudgeLogCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.type = const Value.absent(),
    this.package = const Value.absent(),
    this.todoId = const Value.absent(),
    this.text_ = const Value.absent(),
    this.action = const Value.absent(),
  });
  NudgeLogCompanion.insert({
    this.id = const Value.absent(),
    required int at,
    required String type,
    this.package = const Value.absent(),
    this.todoId = const Value.absent(),
    required String text_,
    required String action,
  }) : at = Value(at),
       type = Value(type),
       text_ = Value(text_),
       action = Value(action);
  static Insertable<NudgeLogData> custom({
    Expression<int>? id,
    Expression<int>? at,
    Expression<String>? type,
    Expression<String>? package,
    Expression<String>? todoId,
    Expression<String>? text_,
    Expression<String>? action,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (type != null) 'type': type,
      if (package != null) 'package': package,
      if (todoId != null) 'todo_id': todoId,
      if (text_ != null) 'text': text_,
      if (action != null) 'action': action,
    });
  }

  NudgeLogCompanion copyWith({
    Value<int>? id,
    Value<int>? at,
    Value<String>? type,
    Value<String?>? package,
    Value<String?>? todoId,
    Value<String>? text_,
    Value<String>? action,
  }) {
    return NudgeLogCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      type: type ?? this.type,
      package: package ?? this.package,
      todoId: todoId ?? this.todoId,
      text_: text_ ?? this.text_,
      action: action ?? this.action,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<int>(at.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (package.present) {
      map['package'] = Variable<String>(package.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<String>(todoId.value);
    }
    if (text_.present) {
      map['text'] = Variable<String>(text_.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NudgeLogCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('type: $type, ')
          ..write('package: $package, ')
          ..write('todoId: $todoId, ')
          ..write('text_: $text_, ')
          ..write('action: $action')
          ..write(')'))
        .toString();
  }
}

class $EventLogTable extends EventLog
    with TableInfo<$EventLogTable, EventLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<int> at = GeneratedColumn<int>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('info'),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    source,
    level,
    message,
    dataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      ),
    );
  }

  @override
  $EventLogTable createAlias(String alias) {
    return $EventLogTable(attachedDatabase, alias);
  }
}

class EventLogData extends DataClass implements Insertable<EventLogData> {
  final int id;
  final int at;
  final String source;
  final String level;
  final String message;
  final String? dataJson;
  const EventLogData({
    required this.id,
    required this.at,
    required this.source,
    required this.level,
    required this.message,
    this.dataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<int>(at);
    map['source'] = Variable<String>(source);
    map['level'] = Variable<String>(level);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || dataJson != null) {
      map['data_json'] = Variable<String>(dataJson);
    }
    return map;
  }

  EventLogCompanion toCompanion(bool nullToAbsent) {
    return EventLogCompanion(
      id: Value(id),
      at: Value(at),
      source: Value(source),
      level: Value(level),
      message: Value(message),
      dataJson: dataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dataJson),
    );
  }

  factory EventLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventLogData(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<int>(json['at']),
      source: serializer.fromJson<String>(json['source']),
      level: serializer.fromJson<String>(json['level']),
      message: serializer.fromJson<String>(json['message']),
      dataJson: serializer.fromJson<String?>(json['dataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<int>(at),
      'source': serializer.toJson<String>(source),
      'level': serializer.toJson<String>(level),
      'message': serializer.toJson<String>(message),
      'dataJson': serializer.toJson<String?>(dataJson),
    };
  }

  EventLogData copyWith({
    int? id,
    int? at,
    String? source,
    String? level,
    String? message,
    Value<String?> dataJson = const Value.absent(),
  }) => EventLogData(
    id: id ?? this.id,
    at: at ?? this.at,
    source: source ?? this.source,
    level: level ?? this.level,
    message: message ?? this.message,
    dataJson: dataJson.present ? dataJson.value : this.dataJson,
  );
  EventLogData copyWithCompanion(EventLogCompanion data) {
    return EventLogData(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      source: data.source.present ? data.source.value : this.source,
      level: data.level.present ? data.level.value : this.level,
      message: data.message.present ? data.message.value : this.message,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventLogData(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('source: $source, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('dataJson: $dataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, source, level, message, dataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventLogData &&
          other.id == this.id &&
          other.at == this.at &&
          other.source == this.source &&
          other.level == this.level &&
          other.message == this.message &&
          other.dataJson == this.dataJson);
}

class EventLogCompanion extends UpdateCompanion<EventLogData> {
  final Value<int> id;
  final Value<int> at;
  final Value<String> source;
  final Value<String> level;
  final Value<String> message;
  final Value<String?> dataJson;
  const EventLogCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.source = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.dataJson = const Value.absent(),
  });
  EventLogCompanion.insert({
    this.id = const Value.absent(),
    required int at,
    required String source,
    this.level = const Value.absent(),
    required String message,
    this.dataJson = const Value.absent(),
  }) : at = Value(at),
       source = Value(source),
       message = Value(message);
  static Insertable<EventLogData> custom({
    Expression<int>? id,
    Expression<int>? at,
    Expression<String>? source,
    Expression<String>? level,
    Expression<String>? message,
    Expression<String>? dataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (source != null) 'source': source,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (dataJson != null) 'data_json': dataJson,
    });
  }

  EventLogCompanion copyWith({
    Value<int>? id,
    Value<int>? at,
    Value<String>? source,
    Value<String>? level,
    Value<String>? message,
    Value<String?>? dataJson,
  }) {
    return EventLogCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      source: source ?? this.source,
      level: level ?? this.level,
      message: message ?? this.message,
      dataJson: dataJson ?? this.dataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<int>(at.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventLogCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('source: $source, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('dataJson: $dataJson')
          ..write(')'))
        .toString();
  }
}

class $AiCacheTable extends AiCache with TableInfo<$AiCacheTable, AiCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseJsonMeta = const VerificationMeta(
    'responseJson',
  );
  @override
  late final GeneratedColumn<String> responseJson = GeneratedColumn<String>(
    'response_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    kind,
    responseJson,
    createdAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('response_json')) {
      context.handle(
        _responseJsonMeta,
        responseJson.isAcceptableOrUnknown(
          data['response_json']!,
          _responseJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responseJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AiCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiCacheData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      responseJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $AiCacheTable createAlias(String alias) {
    return $AiCacheTable(attachedDatabase, alias);
  }
}

class AiCacheData extends DataClass implements Insertable<AiCacheData> {
  final String key;
  final String kind;
  final String responseJson;
  final int createdAt;
  final int? expiresAt;
  const AiCacheData({
    required this.key,
    required this.kind,
    required this.responseJson,
    required this.createdAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['kind'] = Variable<String>(kind);
    map['response_json'] = Variable<String>(responseJson);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<int>(expiresAt);
    }
    return map;
  }

  AiCacheCompanion toCompanion(bool nullToAbsent) {
    return AiCacheCompanion(
      key: Value(key),
      kind: Value(kind),
      responseJson: Value(responseJson),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory AiCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiCacheData(
      key: serializer.fromJson<String>(json['key']),
      kind: serializer.fromJson<String>(json['kind']),
      responseJson: serializer.fromJson<String>(json['responseJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      expiresAt: serializer.fromJson<int?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'kind': serializer.toJson<String>(kind),
      'responseJson': serializer.toJson<String>(responseJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'expiresAt': serializer.toJson<int?>(expiresAt),
    };
  }

  AiCacheData copyWith({
    String? key,
    String? kind,
    String? responseJson,
    int? createdAt,
    Value<int?> expiresAt = const Value.absent(),
  }) => AiCacheData(
    key: key ?? this.key,
    kind: kind ?? this.kind,
    responseJson: responseJson ?? this.responseJson,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  AiCacheData copyWithCompanion(AiCacheCompanion data) {
    return AiCacheData(
      key: data.key.present ? data.key.value : this.key,
      kind: data.kind.present ? data.kind.value : this.kind,
      responseJson: data.responseJson.present
          ? data.responseJson.value
          : this.responseJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiCacheData(')
          ..write('key: $key, ')
          ..write('kind: $kind, ')
          ..write('responseJson: $responseJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key, kind, responseJson, createdAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiCacheData &&
          other.key == this.key &&
          other.kind == this.kind &&
          other.responseJson == this.responseJson &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class AiCacheCompanion extends UpdateCompanion<AiCacheData> {
  final Value<String> key;
  final Value<String> kind;
  final Value<String> responseJson;
  final Value<int> createdAt;
  final Value<int?> expiresAt;
  final Value<int> rowid;
  const AiCacheCompanion({
    this.key = const Value.absent(),
    this.kind = const Value.absent(),
    this.responseJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiCacheCompanion.insert({
    required String key,
    required String kind,
    required String responseJson,
    required int createdAt,
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       kind = Value(kind),
       responseJson = Value(responseJson),
       createdAt = Value(createdAt);
  static Insertable<AiCacheData> custom({
    Expression<String>? key,
    Expression<String>? kind,
    Expression<String>? responseJson,
    Expression<int>? createdAt,
    Expression<int>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (kind != null) 'kind': kind,
      if (responseJson != null) 'response_json': responseJson,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiCacheCompanion copyWith({
    Value<String>? key,
    Value<String>? kind,
    Value<String>? responseJson,
    Value<int>? createdAt,
    Value<int?>? expiresAt,
    Value<int>? rowid,
  }) {
    return AiCacheCompanion(
      key: key ?? this.key,
      kind: kind ?? this.kind,
      responseJson: responseJson ?? this.responseJson,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (responseJson.present) {
      map['response_json'] = Variable<String>(responseJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiCacheCompanion(')
          ..write('key: $key, ')
          ..write('kind: $kind, ')
          ..write('responseJson: $responseJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiUsageTable extends AiUsage with TableInfo<$AiUsageTable, AiUsageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiUsageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<int> at = GeneratedColumn<int>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureMeta = const VerificationMeta(
    'feature',
  );
  @override
  late final GeneratedColumn<String> feature = GeneratedColumn<String>(
    'feature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputTokensMeta = const VerificationMeta(
    'inputTokens',
  );
  @override
  late final GeneratedColumn<int> inputTokens = GeneratedColumn<int>(
    'input_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _outputTokensMeta = const VerificationMeta(
    'outputTokens',
  );
  @override
  late final GeneratedColumn<int> outputTokens = GeneratedColumn<int>(
    'output_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cacheReadTokensMeta = const VerificationMeta(
    'cacheReadTokens',
  );
  @override
  late final GeneratedColumn<int> cacheReadTokens = GeneratedColumn<int>(
    'cache_read_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cacheWriteTokensMeta = const VerificationMeta(
    'cacheWriteTokens',
  );
  @override
  late final GeneratedColumn<int> cacheWriteTokens = GeneratedColumn<int>(
    'cache_write_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    feature,
    model,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    cacheWriteTokens,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_usage';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiUsageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('feature')) {
      context.handle(
        _featureMeta,
        feature.isAcceptableOrUnknown(data['feature']!, _featureMeta),
      );
    } else if (isInserting) {
      context.missing(_featureMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('input_tokens')) {
      context.handle(
        _inputTokensMeta,
        inputTokens.isAcceptableOrUnknown(
          data['input_tokens']!,
          _inputTokensMeta,
        ),
      );
    }
    if (data.containsKey('output_tokens')) {
      context.handle(
        _outputTokensMeta,
        outputTokens.isAcceptableOrUnknown(
          data['output_tokens']!,
          _outputTokensMeta,
        ),
      );
    }
    if (data.containsKey('cache_read_tokens')) {
      context.handle(
        _cacheReadTokensMeta,
        cacheReadTokens.isAcceptableOrUnknown(
          data['cache_read_tokens']!,
          _cacheReadTokensMeta,
        ),
      );
    }
    if (data.containsKey('cache_write_tokens')) {
      context.handle(
        _cacheWriteTokensMeta,
        cacheWriteTokens.isAcceptableOrUnknown(
          data['cache_write_tokens']!,
          _cacheWriteTokensMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiUsageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiUsageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at'],
      )!,
      feature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      inputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}input_tokens'],
      )!,
      outputTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}output_tokens'],
      )!,
      cacheReadTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cache_read_tokens'],
      )!,
      cacheWriteTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cache_write_tokens'],
      )!,
    );
  }

  @override
  $AiUsageTable createAlias(String alias) {
    return $AiUsageTable(attachedDatabase, alias);
  }
}

class AiUsageData extends DataClass implements Insertable<AiUsageData> {
  final int id;
  final int at;
  final String feature;
  final String model;
  final int inputTokens;
  final int outputTokens;
  final int cacheReadTokens;
  final int cacheWriteTokens;
  const AiUsageData({
    required this.id,
    required this.at,
    required this.feature,
    required this.model,
    required this.inputTokens,
    required this.outputTokens,
    required this.cacheReadTokens,
    required this.cacheWriteTokens,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<int>(at);
    map['feature'] = Variable<String>(feature);
    map['model'] = Variable<String>(model);
    map['input_tokens'] = Variable<int>(inputTokens);
    map['output_tokens'] = Variable<int>(outputTokens);
    map['cache_read_tokens'] = Variable<int>(cacheReadTokens);
    map['cache_write_tokens'] = Variable<int>(cacheWriteTokens);
    return map;
  }

  AiUsageCompanion toCompanion(bool nullToAbsent) {
    return AiUsageCompanion(
      id: Value(id),
      at: Value(at),
      feature: Value(feature),
      model: Value(model),
      inputTokens: Value(inputTokens),
      outputTokens: Value(outputTokens),
      cacheReadTokens: Value(cacheReadTokens),
      cacheWriteTokens: Value(cacheWriteTokens),
    );
  }

  factory AiUsageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiUsageData(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<int>(json['at']),
      feature: serializer.fromJson<String>(json['feature']),
      model: serializer.fromJson<String>(json['model']),
      inputTokens: serializer.fromJson<int>(json['inputTokens']),
      outputTokens: serializer.fromJson<int>(json['outputTokens']),
      cacheReadTokens: serializer.fromJson<int>(json['cacheReadTokens']),
      cacheWriteTokens: serializer.fromJson<int>(json['cacheWriteTokens']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<int>(at),
      'feature': serializer.toJson<String>(feature),
      'model': serializer.toJson<String>(model),
      'inputTokens': serializer.toJson<int>(inputTokens),
      'outputTokens': serializer.toJson<int>(outputTokens),
      'cacheReadTokens': serializer.toJson<int>(cacheReadTokens),
      'cacheWriteTokens': serializer.toJson<int>(cacheWriteTokens),
    };
  }

  AiUsageData copyWith({
    int? id,
    int? at,
    String? feature,
    String? model,
    int? inputTokens,
    int? outputTokens,
    int? cacheReadTokens,
    int? cacheWriteTokens,
  }) => AiUsageData(
    id: id ?? this.id,
    at: at ?? this.at,
    feature: feature ?? this.feature,
    model: model ?? this.model,
    inputTokens: inputTokens ?? this.inputTokens,
    outputTokens: outputTokens ?? this.outputTokens,
    cacheReadTokens: cacheReadTokens ?? this.cacheReadTokens,
    cacheWriteTokens: cacheWriteTokens ?? this.cacheWriteTokens,
  );
  AiUsageData copyWithCompanion(AiUsageCompanion data) {
    return AiUsageData(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      feature: data.feature.present ? data.feature.value : this.feature,
      model: data.model.present ? data.model.value : this.model,
      inputTokens: data.inputTokens.present
          ? data.inputTokens.value
          : this.inputTokens,
      outputTokens: data.outputTokens.present
          ? data.outputTokens.value
          : this.outputTokens,
      cacheReadTokens: data.cacheReadTokens.present
          ? data.cacheReadTokens.value
          : this.cacheReadTokens,
      cacheWriteTokens: data.cacheWriteTokens.present
          ? data.cacheWriteTokens.value
          : this.cacheWriteTokens,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageData(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('feature: $feature, ')
          ..write('model: $model, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('cacheReadTokens: $cacheReadTokens, ')
          ..write('cacheWriteTokens: $cacheWriteTokens')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    at,
    feature,
    model,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    cacheWriteTokens,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiUsageData &&
          other.id == this.id &&
          other.at == this.at &&
          other.feature == this.feature &&
          other.model == this.model &&
          other.inputTokens == this.inputTokens &&
          other.outputTokens == this.outputTokens &&
          other.cacheReadTokens == this.cacheReadTokens &&
          other.cacheWriteTokens == this.cacheWriteTokens);
}

class AiUsageCompanion extends UpdateCompanion<AiUsageData> {
  final Value<int> id;
  final Value<int> at;
  final Value<String> feature;
  final Value<String> model;
  final Value<int> inputTokens;
  final Value<int> outputTokens;
  final Value<int> cacheReadTokens;
  final Value<int> cacheWriteTokens;
  const AiUsageCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.feature = const Value.absent(),
    this.model = const Value.absent(),
    this.inputTokens = const Value.absent(),
    this.outputTokens = const Value.absent(),
    this.cacheReadTokens = const Value.absent(),
    this.cacheWriteTokens = const Value.absent(),
  });
  AiUsageCompanion.insert({
    this.id = const Value.absent(),
    required int at,
    required String feature,
    required String model,
    this.inputTokens = const Value.absent(),
    this.outputTokens = const Value.absent(),
    this.cacheReadTokens = const Value.absent(),
    this.cacheWriteTokens = const Value.absent(),
  }) : at = Value(at),
       feature = Value(feature),
       model = Value(model);
  static Insertable<AiUsageData> custom({
    Expression<int>? id,
    Expression<int>? at,
    Expression<String>? feature,
    Expression<String>? model,
    Expression<int>? inputTokens,
    Expression<int>? outputTokens,
    Expression<int>? cacheReadTokens,
    Expression<int>? cacheWriteTokens,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (feature != null) 'feature': feature,
      if (model != null) 'model': model,
      if (inputTokens != null) 'input_tokens': inputTokens,
      if (outputTokens != null) 'output_tokens': outputTokens,
      if (cacheReadTokens != null) 'cache_read_tokens': cacheReadTokens,
      if (cacheWriteTokens != null) 'cache_write_tokens': cacheWriteTokens,
    });
  }

  AiUsageCompanion copyWith({
    Value<int>? id,
    Value<int>? at,
    Value<String>? feature,
    Value<String>? model,
    Value<int>? inputTokens,
    Value<int>? outputTokens,
    Value<int>? cacheReadTokens,
    Value<int>? cacheWriteTokens,
  }) {
    return AiUsageCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      feature: feature ?? this.feature,
      model: model ?? this.model,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      cacheReadTokens: cacheReadTokens ?? this.cacheReadTokens,
      cacheWriteTokens: cacheWriteTokens ?? this.cacheWriteTokens,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<int>(at.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (inputTokens.present) {
      map['input_tokens'] = Variable<int>(inputTokens.value);
    }
    if (outputTokens.present) {
      map['output_tokens'] = Variable<int>(outputTokens.value);
    }
    if (cacheReadTokens.present) {
      map['cache_read_tokens'] = Variable<int>(cacheReadTokens.value);
    }
    if (cacheWriteTokens.present) {
      map['cache_write_tokens'] = Variable<int>(cacheWriteTokens.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiUsageCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('feature: $feature, ')
          ..write('model: $model, ')
          ..write('inputTokens: $inputTokens, ')
          ..write('outputTokens: $outputTokens, ')
          ..write('cacheReadTokens: $cacheReadTokens, ')
          ..write('cacheWriteTokens: $cacheWriteTokens')
          ..write(')'))
        .toString();
  }
}

class $DailyRollupTable extends DailyRollup
    with TableInfo<$DailyRollupTable, DailyRollupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRollupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesByCategoryJsonMeta =
      const VerificationMeta('minutesByCategoryJson');
  @override
  late final GeneratedColumn<String> minutesByCategoryJson =
      GeneratedColumn<String>(
        'minutes_by_category_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _wastedMinMeta = const VerificationMeta(
    'wastedMin',
  );
  @override
  late final GeneratedColumn<int> wastedMin = GeneratedColumn<int>(
    'wasted_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _workMinMeta = const VerificationMeta(
    'workMin',
  );
  @override
  late final GeneratedColumn<int> workMin = GeneratedColumn<int>(
    'work_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _learningMinMeta = const VerificationMeta(
    'learningMin',
  );
  @override
  late final GeneratedColumn<int> learningMin = GeneratedColumn<int>(
    'learning_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _topAppsJsonMeta = const VerificationMeta(
    'topAppsJson',
  );
  @override
  late final GeneratedColumn<String> topAppsJson = GeneratedColumn<String>(
    'top_apps_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    minutesByCategoryJson,
    wastedMin,
    workMin,
    learningMin,
    topAppsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_rollup';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyRollupData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('minutes_by_category_json')) {
      context.handle(
        _minutesByCategoryJsonMeta,
        minutesByCategoryJson.isAcceptableOrUnknown(
          data['minutes_by_category_json']!,
          _minutesByCategoryJsonMeta,
        ),
      );
    }
    if (data.containsKey('wasted_min')) {
      context.handle(
        _wastedMinMeta,
        wastedMin.isAcceptableOrUnknown(data['wasted_min']!, _wastedMinMeta),
      );
    }
    if (data.containsKey('work_min')) {
      context.handle(
        _workMinMeta,
        workMin.isAcceptableOrUnknown(data['work_min']!, _workMinMeta),
      );
    }
    if (data.containsKey('learning_min')) {
      context.handle(
        _learningMinMeta,
        learningMin.isAcceptableOrUnknown(
          data['learning_min']!,
          _learningMinMeta,
        ),
      );
    }
    if (data.containsKey('top_apps_json')) {
      context.handle(
        _topAppsJsonMeta,
        topAppsJson.isAcceptableOrUnknown(
          data['top_apps_json']!,
          _topAppsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyRollupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRollupData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      minutesByCategoryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}minutes_by_category_json'],
      )!,
      wastedMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wasted_min'],
      )!,
      workMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_min'],
      )!,
      learningMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}learning_min'],
      )!,
      topAppsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_apps_json'],
      )!,
    );
  }

  @override
  $DailyRollupTable createAlias(String alias) {
    return $DailyRollupTable(attachedDatabase, alias);
  }
}

class DailyRollupData extends DataClass implements Insertable<DailyRollupData> {
  final String date;
  final String minutesByCategoryJson;
  final int wastedMin;
  final int workMin;
  final int learningMin;
  final String topAppsJson;
  const DailyRollupData({
    required this.date,
    required this.minutesByCategoryJson,
    required this.wastedMin,
    required this.workMin,
    required this.learningMin,
    required this.topAppsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['minutes_by_category_json'] = Variable<String>(minutesByCategoryJson);
    map['wasted_min'] = Variable<int>(wastedMin);
    map['work_min'] = Variable<int>(workMin);
    map['learning_min'] = Variable<int>(learningMin);
    map['top_apps_json'] = Variable<String>(topAppsJson);
    return map;
  }

  DailyRollupCompanion toCompanion(bool nullToAbsent) {
    return DailyRollupCompanion(
      date: Value(date),
      minutesByCategoryJson: Value(minutesByCategoryJson),
      wastedMin: Value(wastedMin),
      workMin: Value(workMin),
      learningMin: Value(learningMin),
      topAppsJson: Value(topAppsJson),
    );
  }

  factory DailyRollupData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRollupData(
      date: serializer.fromJson<String>(json['date']),
      minutesByCategoryJson: serializer.fromJson<String>(
        json['minutesByCategoryJson'],
      ),
      wastedMin: serializer.fromJson<int>(json['wastedMin']),
      workMin: serializer.fromJson<int>(json['workMin']),
      learningMin: serializer.fromJson<int>(json['learningMin']),
      topAppsJson: serializer.fromJson<String>(json['topAppsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'minutesByCategoryJson': serializer.toJson<String>(minutesByCategoryJson),
      'wastedMin': serializer.toJson<int>(wastedMin),
      'workMin': serializer.toJson<int>(workMin),
      'learningMin': serializer.toJson<int>(learningMin),
      'topAppsJson': serializer.toJson<String>(topAppsJson),
    };
  }

  DailyRollupData copyWith({
    String? date,
    String? minutesByCategoryJson,
    int? wastedMin,
    int? workMin,
    int? learningMin,
    String? topAppsJson,
  }) => DailyRollupData(
    date: date ?? this.date,
    minutesByCategoryJson: minutesByCategoryJson ?? this.minutesByCategoryJson,
    wastedMin: wastedMin ?? this.wastedMin,
    workMin: workMin ?? this.workMin,
    learningMin: learningMin ?? this.learningMin,
    topAppsJson: topAppsJson ?? this.topAppsJson,
  );
  DailyRollupData copyWithCompanion(DailyRollupCompanion data) {
    return DailyRollupData(
      date: data.date.present ? data.date.value : this.date,
      minutesByCategoryJson: data.minutesByCategoryJson.present
          ? data.minutesByCategoryJson.value
          : this.minutesByCategoryJson,
      wastedMin: data.wastedMin.present ? data.wastedMin.value : this.wastedMin,
      workMin: data.workMin.present ? data.workMin.value : this.workMin,
      learningMin: data.learningMin.present
          ? data.learningMin.value
          : this.learningMin,
      topAppsJson: data.topAppsJson.present
          ? data.topAppsJson.value
          : this.topAppsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRollupData(')
          ..write('date: $date, ')
          ..write('minutesByCategoryJson: $minutesByCategoryJson, ')
          ..write('wastedMin: $wastedMin, ')
          ..write('workMin: $workMin, ')
          ..write('learningMin: $learningMin, ')
          ..write('topAppsJson: $topAppsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    minutesByCategoryJson,
    wastedMin,
    workMin,
    learningMin,
    topAppsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRollupData &&
          other.date == this.date &&
          other.minutesByCategoryJson == this.minutesByCategoryJson &&
          other.wastedMin == this.wastedMin &&
          other.workMin == this.workMin &&
          other.learningMin == this.learningMin &&
          other.topAppsJson == this.topAppsJson);
}

class DailyRollupCompanion extends UpdateCompanion<DailyRollupData> {
  final Value<String> date;
  final Value<String> minutesByCategoryJson;
  final Value<int> wastedMin;
  final Value<int> workMin;
  final Value<int> learningMin;
  final Value<String> topAppsJson;
  final Value<int> rowid;
  const DailyRollupCompanion({
    this.date = const Value.absent(),
    this.minutesByCategoryJson = const Value.absent(),
    this.wastedMin = const Value.absent(),
    this.workMin = const Value.absent(),
    this.learningMin = const Value.absent(),
    this.topAppsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyRollupCompanion.insert({
    required String date,
    this.minutesByCategoryJson = const Value.absent(),
    this.wastedMin = const Value.absent(),
    this.workMin = const Value.absent(),
    this.learningMin = const Value.absent(),
    this.topAppsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyRollupData> custom({
    Expression<String>? date,
    Expression<String>? minutesByCategoryJson,
    Expression<int>? wastedMin,
    Expression<int>? workMin,
    Expression<int>? learningMin,
    Expression<String>? topAppsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (minutesByCategoryJson != null)
        'minutes_by_category_json': minutesByCategoryJson,
      if (wastedMin != null) 'wasted_min': wastedMin,
      if (workMin != null) 'work_min': workMin,
      if (learningMin != null) 'learning_min': learningMin,
      if (topAppsJson != null) 'top_apps_json': topAppsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyRollupCompanion copyWith({
    Value<String>? date,
    Value<String>? minutesByCategoryJson,
    Value<int>? wastedMin,
    Value<int>? workMin,
    Value<int>? learningMin,
    Value<String>? topAppsJson,
    Value<int>? rowid,
  }) {
    return DailyRollupCompanion(
      date: date ?? this.date,
      minutesByCategoryJson:
          minutesByCategoryJson ?? this.minutesByCategoryJson,
      wastedMin: wastedMin ?? this.wastedMin,
      workMin: workMin ?? this.workMin,
      learningMin: learningMin ?? this.learningMin,
      topAppsJson: topAppsJson ?? this.topAppsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (minutesByCategoryJson.present) {
      map['minutes_by_category_json'] = Variable<String>(
        minutesByCategoryJson.value,
      );
    }
    if (wastedMin.present) {
      map['wasted_min'] = Variable<int>(wastedMin.value);
    }
    if (workMin.present) {
      map['work_min'] = Variable<int>(workMin.value);
    }
    if (learningMin.present) {
      map['learning_min'] = Variable<int>(learningMin.value);
    }
    if (topAppsJson.present) {
      map['top_apps_json'] = Variable<String>(topAppsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRollupCompanion(')
          ..write('date: $date, ')
          ..write('minutesByCategoryJson: $minutesByCategoryJson, ')
          ..write('wastedMin: $wastedMin, ')
          ..write('workMin: $workMin, ')
          ..write('learningMin: $learningMin, ')
          ..write('topAppsJson: $topAppsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, valueJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String valueJson;
  const Setting({required this.key, required this.valueJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), valueJson: Value(valueJson));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
    };
  }

  Setting copyWith({String? key, String? valueJson}) =>
      Setting(key: key ?? this.key, valueJson: valueJson ?? this.valueJson);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.valueJson == this.valueJson);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String valueJson,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       valueJson = Value(valueJson);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? valueJson,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $StagesTable stages = $StagesTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $AppCategoriesTable appCategories = $AppCategoriesTable(this);
  late final $UsageSessionsTable usageSessions = $UsageSessionsTable(this);
  late final $ContentItemsTable contentItems = $ContentItemsTable(this);
  late final $ContentRulesTable contentRules = $ContentRulesTable(this);
  late final $ActivityDailyTable activityDaily = $ActivityDailyTable(this);
  late final $MoneyEntriesTable moneyEntries = $MoneyEntriesTable(this);
  late final $MoneyRecurringTable moneyRecurring = $MoneyRecurringTable(this);
  late final $NudgeLogTable nudgeLog = $NudgeLogTable(this);
  late final $EventLogTable eventLog = $EventLogTable(this);
  late final $AiCacheTable aiCache = $AiCacheTable(this);
  late final $AiUsageTable aiUsage = $AiUsageTable(this);
  late final $DailyRollupTable dailyRollup = $DailyRollupTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final Index idxTodosStatusScore = Index(
    'idx_todos_status_score',
    'CREATE INDEX idx_todos_status_score ON todos (status, score)',
  );
  late final Index idxUsageStarted = Index(
    'idx_usage_started',
    'CREATE INDEX idx_usage_started ON usage_sessions (started_at)',
  );
  late final Index idxContentStarted = Index(
    'idx_content_started',
    'CREATE INDEX idx_content_started ON content_items (started_at)',
  );
  late final Index idxMoneyDate = Index(
    'idx_money_date',
    'CREATE INDEX idx_money_date ON money_entries (date)',
  );
  late final Index idxNudgeAt = Index(
    'idx_nudge_at',
    'CREATE INDEX idx_nudge_at ON nudge_log (at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    goals,
    stages,
    todos,
    focusSessions,
    routines,
    contacts,
    appCategories,
    usageSessions,
    contentItems,
    contentRules,
    activityDaily,
    moneyEntries,
    moneyRecurring,
    nudgeLog,
    eventLog,
    aiCache,
    aiUsage,
    dailyRollup,
    settings,
    idxTodosStatusScore,
    idxUsageStarted,
    idxContentStarted,
    idxMoneyDate,
    idxNudgeAt,
  ];
}

typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required String title,
  Value<String> why,
  Value<String> type,
  Value<int?> targetPaise,
  required int startAt,
  required int deadlineAt,
  Value<int> priority,
  required int color,
  Value<String> status,
  Value<String?> digest,
  Value<bool> digestStale,
  Value<int?> digestAt,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> why,
  Value<String> type,
  Value<int?> targetPaise,
  Value<int> startAt,
  Value<int> deadlineAt,
  Value<int> priority,
  Value<int> color,
  Value<String> status,
  Value<String?> digest,
  Value<bool> digestStale,
  Value<int?> digestAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDb, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get why => $composableBuilder(
    column: $table.why,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get digestStale => $composableBuilder(
    column: $table.digestStale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get digestAt => $composableBuilder(
    column: $table.digestAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer extends Composer<_$AppDb, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get why => $composableBuilder(
    column: $table.why,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get digestStale => $composableBuilder(
    column: $table.digestStale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get digestAt => $composableBuilder(
    column: $table.digestAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer extends Composer<_$AppDb, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get why =>
      $composableBuilder(column: $table.why, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<int> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get digest =>
      $composableBuilder(column: $table.digest, builder: (column) => column);

  GeneratedColumn<bool> get digestStale => $composableBuilder(
    column: $table.digestStale,
    builder: (column) => column,
  );

  GeneratedColumn<int> get digestAt =>
      $composableBuilder(column: $table.digestAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDb, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDb db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> why = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> targetPaise = const Value.absent(),
                Value<int> startAt = const Value.absent(),
                Value<int> deadlineAt = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> digest = const Value.absent(),
                Value<bool> digestStale = const Value.absent(),
                Value<int?> digestAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                title: title,
                why: why,
                type: type,
                targetPaise: targetPaise,
                startAt: startAt,
                deadlineAt: deadlineAt,
                priority: priority,
                color: color,
                status: status,
                digest: digest,
                digestStale: digestStale,
                digestAt: digestAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> why = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> targetPaise = const Value.absent(),
                required int startAt,
                required int deadlineAt,
                Value<int> priority = const Value.absent(),
                required int color,
                Value<String> status = const Value.absent(),
                Value<String?> digest = const Value.absent(),
                Value<bool> digestStale = const Value.absent(),
                Value<int?> digestAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                title: title,
                why: why,
                type: type,
                targetPaise: targetPaise,
                startAt: startAt,
                deadlineAt: deadlineAt,
                priority: priority,
                color: color,
                status: status,
                digest: digest,
                digestStale: digestStale,
                digestAt: digestAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, Goal>(table),
                  BaseReferences<_$AppDb, $GoalsTable, Goal>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDb, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $$StagesTableCreateCompanionBuilder = StagesCompanion Function({
  required String id,
  required String goalId,
  required String title,
  Value<String> doneWhen,
  required int dueAt,
  Value<int> weight,
  Value<int> orderIndex,
  Value<String> status,
  Value<String> source,
  Value<int?> alignScore,
  required int createdAt,
  Value<int?> doneAt,
  Value<int> rowid,
});
typedef $$StagesTableUpdateCompanionBuilder = StagesCompanion Function({
  Value<String> id,
  Value<String> goalId,
  Value<String> title,
  Value<String> doneWhen,
  Value<int> dueAt,
  Value<int> weight,
  Value<int> orderIndex,
  Value<String> status,
  Value<String> source,
  Value<int?> alignScore,
  Value<int> createdAt,
  Value<int?> doneAt,
  Value<int> rowid,
});

class $$StagesTableFilterComposer extends Composer<_$AppDb, $StagesTable> {
  $$StagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doneWhen => $composableBuilder(
    column: $table.doneWhen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alignScore => $composableBuilder(
    column: $table.alignScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StagesTableOrderingComposer extends Composer<_$AppDb, $StagesTable> {
  $$StagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doneWhen => $composableBuilder(
    column: $table.doneWhen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alignScore => $composableBuilder(
    column: $table.alignScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StagesTableAnnotationComposer extends Composer<_$AppDb, $StagesTable> {
  $$StagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get doneWhen =>
      $composableBuilder(column: $table.doneWhen, builder: (column) => column);

  GeneratedColumn<int> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get alignScore => $composableBuilder(
    column: $table.alignScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);
}

class $$StagesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $StagesTable,
          Stage,
          $$StagesTableFilterComposer,
          $$StagesTableOrderingComposer,
          $$StagesTableAnnotationComposer,
          $$StagesTableCreateCompanionBuilder,
          $$StagesTableUpdateCompanionBuilder,
          (Stage, BaseReferences<_$AppDb, $StagesTable, Stage>),
          Stage,
          PrefetchHooks Function()
        > {
  $$StagesTableTableManager(_$AppDb db, $StagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> doneWhen = const Value.absent(),
                Value<int> dueAt = const Value.absent(),
                Value<int> weight = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int?> alignScore = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StagesCompanion(
                id: id,
                goalId: goalId,
                title: title,
                doneWhen: doneWhen,
                dueAt: dueAt,
                weight: weight,
                orderIndex: orderIndex,
                status: status,
                source: source,
                alignScore: alignScore,
                createdAt: createdAt,
                doneAt: doneAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required String title,
                Value<String> doneWhen = const Value.absent(),
                required int dueAt,
                Value<int> weight = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int?> alignScore = const Value.absent(),
                required int createdAt,
                Value<int?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StagesCompanion.insert(
                id: id,
                goalId: goalId,
                title: title,
                doneWhen: doneWhen,
                dueAt: dueAt,
                weight: weight,
                orderIndex: orderIndex,
                status: status,
                source: source,
                alignScore: alignScore,
                createdAt: createdAt,
                doneAt: doneAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StagesTable, Stage>(table),
                  BaseReferences<_$AppDb, $StagesTable, Stage>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $StagesTable,
      Stage,
      $$StagesTableFilterComposer,
      $$StagesTableOrderingComposer,
      $$StagesTableAnnotationComposer,
      $$StagesTableCreateCompanionBuilder,
      $$StagesTableUpdateCompanionBuilder,
      (Stage, BaseReferences<_$AppDb, $StagesTable, Stage>),
      Stage,
      PrefetchHooks Function()
    >;
typedef $$TodosTableCreateCompanionBuilder = TodosCompanion Function({
  required String id,
  Value<String?> goalId,
  Value<String?> stageId,
  required String title,
  required String normHash,
  Value<int> estimateMin,
  Value<int?> dueAt,
  Value<int?> remindAt,
  Value<String> recurrence,
  Value<int?> score,
  Value<String> scoreSource,
  Value<String?> reason,
  Value<String> status,
  required int createdAt,
  Value<int?> doneAt,
  Value<int> rowid,
});
typedef $$TodosTableUpdateCompanionBuilder = TodosCompanion Function({
  Value<String> id,
  Value<String?> goalId,
  Value<String?> stageId,
  Value<String> title,
  Value<String> normHash,
  Value<int> estimateMin,
  Value<int?> dueAt,
  Value<int?> remindAt,
  Value<String> recurrence,
  Value<int?> score,
  Value<String> scoreSource,
  Value<String?> reason,
  Value<String> status,
  Value<int> createdAt,
  Value<int?> doneAt,
  Value<int> rowid,
});

class $$TodosTableFilterComposer extends Composer<_$AppDb, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stageId => $composableBuilder(
    column: $table.stageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normHash => $composableBuilder(
    column: $table.normHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimateMin => $composableBuilder(
    column: $table.estimateMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scoreSource => $composableBuilder(
    column: $table.scoreSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodosTableOrderingComposer extends Composer<_$AppDb, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stageId => $composableBuilder(
    column: $table.stageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normHash => $composableBuilder(
    column: $table.normHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimateMin => $composableBuilder(
    column: $table.estimateMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scoreSource => $composableBuilder(
    column: $table.scoreSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer extends Composer<_$AppDb, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get stageId =>
      $composableBuilder(column: $table.stageId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get normHash =>
      $composableBuilder(column: $table.normHash, builder: (column) => column);

  GeneratedColumn<int> get estimateMin => $composableBuilder(
    column: $table.estimateMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get scoreSource => $composableBuilder(
    column: $table.scoreSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDb, $TodosTable, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $$TodosTableTableManager(_$AppDb db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String?> stageId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> normHash = const Value.absent(),
                Value<int> estimateMin = const Value.absent(),
                Value<int?> dueAt = const Value.absent(),
                Value<int?> remindAt = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<String> scoreSource = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                goalId: goalId,
                stageId: stageId,
                title: title,
                normHash: normHash,
                estimateMin: estimateMin,
                dueAt: dueAt,
                remindAt: remindAt,
                recurrence: recurrence,
                score: score,
                scoreSource: scoreSource,
                reason: reason,
                status: status,
                createdAt: createdAt,
                doneAt: doneAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> goalId = const Value.absent(),
                Value<String?> stageId = const Value.absent(),
                required String title,
                required String normHash,
                Value<int> estimateMin = const Value.absent(),
                Value<int?> dueAt = const Value.absent(),
                Value<int?> remindAt = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<String> scoreSource = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int createdAt,
                Value<int?> doneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion.insert(
                id: id,
                goalId: goalId,
                stageId: stageId,
                title: title,
                normHash: normHash,
                estimateMin: estimateMin,
                dueAt: dueAt,
                remindAt: remindAt,
                recurrence: recurrence,
                score: score,
                scoreSource: scoreSource,
                reason: reason,
                status: status,
                createdAt: createdAt,
                doneAt: doneAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TodosTable, Todo>(table),
                  BaseReferences<_$AppDb, $TodosTable, Todo>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDb, $TodosTable, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<String?> todoId,
      Value<String> category,
      required int startedAt,
      Value<int?> endedAt,
      Value<String> source,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<String?> todoId,
      Value<String> category,
      Value<int> startedAt,
      Value<int?> endedAt,
      Value<String> source,
      Value<int> rowid,
    });

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDb, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDb, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDb, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get todoId =>
      $composableBuilder(column: $table.todoId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (
            FocusSession,
            BaseReferences<_$AppDb, $FocusSessionsTable, FocusSession>,
          ),
          FocusSession,
          PrefetchHooks Function()
        > {
  $$FocusSessionsTableTableManager(_$AppDb db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> todoId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                todoId: todoId,
                category: category,
                startedAt: startedAt,
                endedAt: endedAt,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> todoId = const Value.absent(),
                Value<String> category = const Value.absent(),
                required int startedAt,
                Value<int?> endedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                todoId: todoId,
                category: category,
                startedAt: startedAt,
                endedAt: endedAt,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FocusSessionsTable, FocusSession>(table),
                  BaseReferences<_$AppDb, $FocusSessionsTable, FocusSession>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (
        FocusSession,
        BaseReferences<_$AppDb, $FocusSessionsTable, FocusSession>,
      ),
      FocusSession,
      PrefetchHooks Function()
    >;
typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  required String id,
  required String kind,
  required String title,
  Value<String> timeHhmm,
  Value<int> daysMask,
  Value<bool> enabled,
  Value<String> configJson,
  Value<int> rowid,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  Value<String> kind,
  Value<String> title,
  Value<String> timeHhmm,
  Value<int> daysMask,
  Value<bool> enabled,
  Value<String> configJson,
  Value<int> rowid,
});

class $$RoutinesTableFilterComposer extends Composer<_$AppDb, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeHhmm => $composableBuilder(
    column: $table.timeHhmm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysMask => $composableBuilder(
    column: $table.daysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDb, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeHhmm => $composableBuilder(
    column: $table.timeHhmm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysMask => $composableBuilder(
    column: $table.daysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDb, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get timeHhmm =>
      $composableBuilder(column: $table.timeHhmm, builder: (column) => column);

  GeneratedColumn<int> get daysMask =>
      $composableBuilder(column: $table.daysMask, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, BaseReferences<_$AppDb, $RoutinesTable, Routine>),
          Routine,
          PrefetchHooks Function()
        > {
  $$RoutinesTableTableManager(_$AppDb db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> timeHhmm = const Value.absent(),
                Value<int> daysMask = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                kind: kind,
                title: title,
                timeHhmm: timeHhmm,
                daysMask: daysMask,
                enabled: enabled,
                configJson: configJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String title,
                Value<String> timeHhmm = const Value.absent(),
                Value<int> daysMask = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                timeHhmm: timeHhmm,
                daysMask: daysMask,
                enabled: enabled,
                configJson: configJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinesTable, Routine>(table),
                  BaseReferences<_$AppDb, $RoutinesTable, Routine>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, BaseReferences<_$AppDb, $RoutinesTable, Routine>),
      Routine,
      PrefetchHooks Function()
    >;
typedef $$ContactsTableCreateCompanionBuilder = ContactsCompanion Function({
  required String id,
  required String name,
  required String phoneE164,
  Value<String> channel,
  Value<int> rowid,
});
typedef $$ContactsTableUpdateCompanionBuilder = ContactsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> phoneE164,
  Value<String> channel,
  Value<int> rowid,
});

class $$ContactsTableFilterComposer extends Composer<_$AppDb, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneE164 => $composableBuilder(
    column: $table.phoneE164,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDb, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneE164 => $composableBuilder(
    column: $table.phoneE164,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDb, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneE164 =>
      $composableBuilder(column: $table.phoneE164, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, BaseReferences<_$AppDb, $ContactsTable, Contact>),
          Contact,
          PrefetchHooks Function()
        > {
  $$ContactsTableTableManager(_$AppDb db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phoneE164 = const Value.absent(),
                Value<String> channel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                name: name,
                phoneE164: phoneE164,
                channel: channel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String phoneE164,
                Value<String> channel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion.insert(
                id: id,
                name: name,
                phoneE164: phoneE164,
                channel: channel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContactsTable, Contact>(table),
                  BaseReferences<_$AppDb, $ContactsTable, Contact>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, BaseReferences<_$AppDb, $ContactsTable, Contact>),
      Contact,
      PrefetchHooks Function()
    >;
typedef $$AppCategoriesTableCreateCompanionBuilder =
    AppCategoriesCompanion Function({
      required String package,
      required String label,
      required String category,
      Value<bool> userSet,
      Value<int> rowid,
    });
typedef $$AppCategoriesTableUpdateCompanionBuilder =
    AppCategoriesCompanion Function({
      Value<String> package,
      Value<String> label,
      Value<String> category,
      Value<bool> userSet,
      Value<int> rowid,
    });

class $$AppCategoriesTableFilterComposer
    extends Composer<_$AppDb, $AppCategoriesTable> {
  $$AppCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userSet => $composableBuilder(
    column: $table.userSet,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppCategoriesTableOrderingComposer
    extends Composer<_$AppDb, $AppCategoriesTable> {
  $$AppCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userSet => $composableBuilder(
    column: $table.userSet,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppCategoriesTableAnnotationComposer
    extends Composer<_$AppDb, $AppCategoriesTable> {
  $$AppCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get package =>
      $composableBuilder(column: $table.package, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get userSet =>
      $composableBuilder(column: $table.userSet, builder: (column) => column);
}

class $$AppCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AppCategoriesTable,
          AppCategory,
          $$AppCategoriesTableFilterComposer,
          $$AppCategoriesTableOrderingComposer,
          $$AppCategoriesTableAnnotationComposer,
          $$AppCategoriesTableCreateCompanionBuilder,
          $$AppCategoriesTableUpdateCompanionBuilder,
          (
            AppCategory,
            BaseReferences<_$AppDb, $AppCategoriesTable, AppCategory>,
          ),
          AppCategory,
          PrefetchHooks Function()
        > {
  $$AppCategoriesTableTableManager(_$AppDb db, $AppCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> package = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> userSet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppCategoriesCompanion(
                package: package,
                label: label,
                category: category,
                userSet: userSet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String package,
                required String label,
                required String category,
                Value<bool> userSet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppCategoriesCompanion.insert(
                package: package,
                label: label,
                category: category,
                userSet: userSet,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppCategoriesTable, AppCategory>(table),
                  BaseReferences<_$AppDb, $AppCategoriesTable, AppCategory>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AppCategoriesTable,
      AppCategory,
      $$AppCategoriesTableFilterComposer,
      $$AppCategoriesTableOrderingComposer,
      $$AppCategoriesTableAnnotationComposer,
      $$AppCategoriesTableCreateCompanionBuilder,
      $$AppCategoriesTableUpdateCompanionBuilder,
      (AppCategory, BaseReferences<_$AppDb, $AppCategoriesTable, AppCategory>),
      AppCategory,
      PrefetchHooks Function()
    >;
typedef $$UsageSessionsTableCreateCompanionBuilder =
    UsageSessionsCompanion Function({
      Value<int> id,
      required String package,
      required int startedAt,
      required int endedAt,
      required String category,
    });
typedef $$UsageSessionsTableUpdateCompanionBuilder =
    UsageSessionsCompanion Function({
      Value<int> id,
      Value<String> package,
      Value<int> startedAt,
      Value<int> endedAt,
      Value<String> category,
    });

class $$UsageSessionsTableFilterComposer
    extends Composer<_$AppDb, $UsageSessionsTable> {
  $$UsageSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageSessionsTableOrderingComposer
    extends Composer<_$AppDb, $UsageSessionsTable> {
  $$UsageSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageSessionsTableAnnotationComposer
    extends Composer<_$AppDb, $UsageSessionsTable> {
  $$UsageSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get package =>
      $composableBuilder(column: $table.package, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$UsageSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $UsageSessionsTable,
          UsageSession,
          $$UsageSessionsTableFilterComposer,
          $$UsageSessionsTableOrderingComposer,
          $$UsageSessionsTableAnnotationComposer,
          $$UsageSessionsTableCreateCompanionBuilder,
          $$UsageSessionsTableUpdateCompanionBuilder,
          (
            UsageSession,
            BaseReferences<_$AppDb, $UsageSessionsTable, UsageSession>,
          ),
          UsageSession,
          PrefetchHooks Function()
        > {
  $$UsageSessionsTableTableManager(_$AppDb db, $UsageSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> package = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int> endedAt = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => UsageSessionsCompanion(
                id: id,
                package: package,
                startedAt: startedAt,
                endedAt: endedAt,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String package,
                required int startedAt,
                required int endedAt,
                required String category,
              }) => UsageSessionsCompanion.insert(
                id: id,
                package: package,
                startedAt: startedAt,
                endedAt: endedAt,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsageSessionsTable, UsageSession>(table),
                  BaseReferences<_$AppDb, $UsageSessionsTable, UsageSession>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $UsageSessionsTable,
      UsageSession,
      $$UsageSessionsTableFilterComposer,
      $$UsageSessionsTableOrderingComposer,
      $$UsageSessionsTableAnnotationComposer,
      $$UsageSessionsTableCreateCompanionBuilder,
      $$UsageSessionsTableUpdateCompanionBuilder,
      (
        UsageSession,
        BaseReferences<_$AppDb, $UsageSessionsTable, UsageSession>,
      ),
      UsageSession,
      PrefetchHooks Function()
    >;
typedef $$ContentItemsTableCreateCompanionBuilder =
    ContentItemsCompanion Function({
      Value<int> id,
      required String package,
      required String title,
      Value<String?> channelOrDomain,
      Value<String> kind,
      required int startedAt,
      Value<int?> endedAt,
      Value<String?> category,
      Value<String> classifiedBy,
      required String titleHash,
    });
typedef $$ContentItemsTableUpdateCompanionBuilder =
    ContentItemsCompanion Function({
      Value<int> id,
      Value<String> package,
      Value<String> title,
      Value<String?> channelOrDomain,
      Value<String> kind,
      Value<int> startedAt,
      Value<int?> endedAt,
      Value<String?> category,
      Value<String> classifiedBy,
      Value<String> titleHash,
    });

class $$ContentItemsTableFilterComposer
    extends Composer<_$AppDb, $ContentItemsTable> {
  $$ContentItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelOrDomain => $composableBuilder(
    column: $table.channelOrDomain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classifiedBy => $composableBuilder(
    column: $table.classifiedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleHash => $composableBuilder(
    column: $table.titleHash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentItemsTableOrderingComposer
    extends Composer<_$AppDb, $ContentItemsTable> {
  $$ContentItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelOrDomain => $composableBuilder(
    column: $table.channelOrDomain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classifiedBy => $composableBuilder(
    column: $table.classifiedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleHash => $composableBuilder(
    column: $table.titleHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentItemsTableAnnotationComposer
    extends Composer<_$AppDb, $ContentItemsTable> {
  $$ContentItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get package =>
      $composableBuilder(column: $table.package, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get channelOrDomain => $composableBuilder(
    column: $table.channelOrDomain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get classifiedBy => $composableBuilder(
    column: $table.classifiedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get titleHash =>
      $composableBuilder(column: $table.titleHash, builder: (column) => column);
}

class $$ContentItemsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ContentItemsTable,
          ContentItem,
          $$ContentItemsTableFilterComposer,
          $$ContentItemsTableOrderingComposer,
          $$ContentItemsTableAnnotationComposer,
          $$ContentItemsTableCreateCompanionBuilder,
          $$ContentItemsTableUpdateCompanionBuilder,
          (
            ContentItem,
            BaseReferences<_$AppDb, $ContentItemsTable, ContentItem>,
          ),
          ContentItem,
          PrefetchHooks Function()
        > {
  $$ContentItemsTableTableManager(_$AppDb db, $ContentItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> package = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> channelOrDomain = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> classifiedBy = const Value.absent(),
                Value<String> titleHash = const Value.absent(),
              }) => ContentItemsCompanion(
                id: id,
                package: package,
                title: title,
                channelOrDomain: channelOrDomain,
                kind: kind,
                startedAt: startedAt,
                endedAt: endedAt,
                category: category,
                classifiedBy: classifiedBy,
                titleHash: titleHash,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String package,
                required String title,
                Value<String?> channelOrDomain = const Value.absent(),
                Value<String> kind = const Value.absent(),
                required int startedAt,
                Value<int?> endedAt = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> classifiedBy = const Value.absent(),
                required String titleHash,
              }) => ContentItemsCompanion.insert(
                id: id,
                package: package,
                title: title,
                channelOrDomain: channelOrDomain,
                kind: kind,
                startedAt: startedAt,
                endedAt: endedAt,
                category: category,
                classifiedBy: classifiedBy,
                titleHash: titleHash,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentItemsTable, ContentItem>(table),
                  BaseReferences<_$AppDb, $ContentItemsTable, ContentItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ContentItemsTable,
      ContentItem,
      $$ContentItemsTableFilterComposer,
      $$ContentItemsTableOrderingComposer,
      $$ContentItemsTableAnnotationComposer,
      $$ContentItemsTableCreateCompanionBuilder,
      $$ContentItemsTableUpdateCompanionBuilder,
      (ContentItem, BaseReferences<_$AppDb, $ContentItemsTable, ContentItem>),
      ContentItem,
      PrefetchHooks Function()
    >;
typedef $$ContentRulesTableCreateCompanionBuilder =
    ContentRulesCompanion Function({
      Value<int> id,
      required String matchType,
      required String value,
      required String category,
    });
typedef $$ContentRulesTableUpdateCompanionBuilder =
    ContentRulesCompanion Function({
      Value<int> id,
      Value<String> matchType,
      Value<String> value,
      Value<String> category,
    });

class $$ContentRulesTableFilterComposer
    extends Composer<_$AppDb, $ContentRulesTable> {
  $$ContentRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchType => $composableBuilder(
    column: $table.matchType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentRulesTableOrderingComposer
    extends Composer<_$AppDb, $ContentRulesTable> {
  $$ContentRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchType => $composableBuilder(
    column: $table.matchType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentRulesTableAnnotationComposer
    extends Composer<_$AppDb, $ContentRulesTable> {
  $$ContentRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get matchType =>
      $composableBuilder(column: $table.matchType, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$ContentRulesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ContentRulesTable,
          ContentRule,
          $$ContentRulesTableFilterComposer,
          $$ContentRulesTableOrderingComposer,
          $$ContentRulesTableAnnotationComposer,
          $$ContentRulesTableCreateCompanionBuilder,
          $$ContentRulesTableUpdateCompanionBuilder,
          (
            ContentRule,
            BaseReferences<_$AppDb, $ContentRulesTable, ContentRule>,
          ),
          ContentRule,
          PrefetchHooks Function()
        > {
  $$ContentRulesTableTableManager(_$AppDb db, $ContentRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> matchType = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => ContentRulesCompanion(
                id: id,
                matchType: matchType,
                value: value,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String matchType,
                required String value,
                required String category,
              }) => ContentRulesCompanion.insert(
                id: id,
                matchType: matchType,
                value: value,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentRulesTable, ContentRule>(table),
                  BaseReferences<_$AppDb, $ContentRulesTable, ContentRule>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ContentRulesTable,
      ContentRule,
      $$ContentRulesTableFilterComposer,
      $$ContentRulesTableOrderingComposer,
      $$ContentRulesTableAnnotationComposer,
      $$ContentRulesTableCreateCompanionBuilder,
      $$ContentRulesTableUpdateCompanionBuilder,
      (ContentRule, BaseReferences<_$AppDb, $ContentRulesTable, ContentRule>),
      ContentRule,
      PrefetchHooks Function()
    >;
typedef $$ActivityDailyTableCreateCompanionBuilder =
    ActivityDailyCompanion Function({
      required String date,
      Value<int> steps,
      Value<int> distanceM,
      Value<int> activeMin,
      Value<int> exerciseMin,
      Value<int> rowid,
    });
typedef $$ActivityDailyTableUpdateCompanionBuilder =
    ActivityDailyCompanion Function({
      Value<String> date,
      Value<int> steps,
      Value<int> distanceM,
      Value<int> activeMin,
      Value<int> exerciseMin,
      Value<int> rowid,
    });

class $$ActivityDailyTableFilterComposer
    extends Composer<_$AppDb, $ActivityDailyTable> {
  $$ActivityDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeMin => $composableBuilder(
    column: $table.activeMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseMin => $composableBuilder(
    column: $table.exerciseMin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityDailyTableOrderingComposer
    extends Composer<_$AppDb, $ActivityDailyTable> {
  $$ActivityDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeMin => $composableBuilder(
    column: $table.activeMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseMin => $composableBuilder(
    column: $table.exerciseMin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityDailyTableAnnotationComposer
    extends Composer<_$AppDb, $ActivityDailyTable> {
  $$ActivityDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<int> get activeMin =>
      $composableBuilder(column: $table.activeMin, builder: (column) => column);

  GeneratedColumn<int> get exerciseMin => $composableBuilder(
    column: $table.exerciseMin,
    builder: (column) => column,
  );
}

class $$ActivityDailyTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ActivityDailyTable,
          ActivityDailyData,
          $$ActivityDailyTableFilterComposer,
          $$ActivityDailyTableOrderingComposer,
          $$ActivityDailyTableAnnotationComposer,
          $$ActivityDailyTableCreateCompanionBuilder,
          $$ActivityDailyTableUpdateCompanionBuilder,
          (
            ActivityDailyData,
            BaseReferences<_$AppDb, $ActivityDailyTable, ActivityDailyData>,
          ),
          ActivityDailyData,
          PrefetchHooks Function()
        > {
  $$ActivityDailyTableTableManager(_$AppDb db, $ActivityDailyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityDailyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityDailyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<int> distanceM = const Value.absent(),
                Value<int> activeMin = const Value.absent(),
                Value<int> exerciseMin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityDailyCompanion(
                date: date,
                steps: steps,
                distanceM: distanceM,
                activeMin: activeMin,
                exerciseMin: exerciseMin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int> steps = const Value.absent(),
                Value<int> distanceM = const Value.absent(),
                Value<int> activeMin = const Value.absent(),
                Value<int> exerciseMin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityDailyCompanion.insert(
                date: date,
                steps: steps,
                distanceM: distanceM,
                activeMin: activeMin,
                exerciseMin: exerciseMin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityDailyTable, ActivityDailyData>(table),
                  BaseReferences<
                    _$AppDb,
                    $ActivityDailyTable,
                    ActivityDailyData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityDailyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ActivityDailyTable,
      ActivityDailyData,
      $$ActivityDailyTableFilterComposer,
      $$ActivityDailyTableOrderingComposer,
      $$ActivityDailyTableAnnotationComposer,
      $$ActivityDailyTableCreateCompanionBuilder,
      $$ActivityDailyTableUpdateCompanionBuilder,
      (
        ActivityDailyData,
        BaseReferences<_$AppDb, $ActivityDailyTable, ActivityDailyData>,
      ),
      ActivityDailyData,
      PrefetchHooks Function()
    >;
typedef $$MoneyEntriesTableCreateCompanionBuilder =
    MoneyEntriesCompanion Function({
      required String id,
      Value<String?> goalId,
      required int date,
      required int amountPaise,
      required String kind,
      Value<String> category,
      Value<String?> note,
      Value<String?> recurringId,
      Value<int> rowid,
    });
typedef $$MoneyEntriesTableUpdateCompanionBuilder =
    MoneyEntriesCompanion Function({
      Value<String> id,
      Value<String?> goalId,
      Value<int> date,
      Value<int> amountPaise,
      Value<String> kind,
      Value<String> category,
      Value<String?> note,
      Value<String?> recurringId,
      Value<int> rowid,
    });

class $$MoneyEntriesTableFilterComposer
    extends Composer<_$AppDb, $MoneyEntriesTable> {
  $$MoneyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoneyEntriesTableOrderingComposer
    extends Composer<_$AppDb, $MoneyEntriesTable> {
  $$MoneyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoneyEntriesTableAnnotationComposer
    extends Composer<_$AppDb, $MoneyEntriesTable> {
  $$MoneyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => column,
  );
}

class $$MoneyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MoneyEntriesTable,
          MoneyEntry,
          $$MoneyEntriesTableFilterComposer,
          $$MoneyEntriesTableOrderingComposer,
          $$MoneyEntriesTableAnnotationComposer,
          $$MoneyEntriesTableCreateCompanionBuilder,
          $$MoneyEntriesTableUpdateCompanionBuilder,
          (MoneyEntry, BaseReferences<_$AppDb, $MoneyEntriesTable, MoneyEntry>),
          MoneyEntry,
          PrefetchHooks Function()
        > {
  $$MoneyEntriesTableTableManager(_$AppDb db, $MoneyEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoneyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoneyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoneyEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> recurringId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoneyEntriesCompanion(
                id: id,
                goalId: goalId,
                date: date,
                amountPaise: amountPaise,
                kind: kind,
                category: category,
                note: note,
                recurringId: recurringId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> goalId = const Value.absent(),
                required int date,
                required int amountPaise,
                required String kind,
                Value<String> category = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> recurringId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoneyEntriesCompanion.insert(
                id: id,
                goalId: goalId,
                date: date,
                amountPaise: amountPaise,
                kind: kind,
                category: category,
                note: note,
                recurringId: recurringId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoneyEntriesTable, MoneyEntry>(table),
                  BaseReferences<_$AppDb, $MoneyEntriesTable, MoneyEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoneyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MoneyEntriesTable,
      MoneyEntry,
      $$MoneyEntriesTableFilterComposer,
      $$MoneyEntriesTableOrderingComposer,
      $$MoneyEntriesTableAnnotationComposer,
      $$MoneyEntriesTableCreateCompanionBuilder,
      $$MoneyEntriesTableUpdateCompanionBuilder,
      (MoneyEntry, BaseReferences<_$AppDb, $MoneyEntriesTable, MoneyEntry>),
      MoneyEntry,
      PrefetchHooks Function()
    >;
typedef $$MoneyRecurringTableCreateCompanionBuilder =
    MoneyRecurringCompanion Function({
      required String id,
      required String title,
      required int amountPaise,
      required String kind,
      Value<String> category,
      required int dayOfMonth,
      Value<String?> goalId,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$MoneyRecurringTableUpdateCompanionBuilder =
    MoneyRecurringCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> amountPaise,
      Value<String> kind,
      Value<String> category,
      Value<int> dayOfMonth,
      Value<String?> goalId,
      Value<bool> enabled,
      Value<int> rowid,
    });

class $$MoneyRecurringTableFilterComposer
    extends Composer<_$AppDb, $MoneyRecurringTable> {
  $$MoneyRecurringTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoneyRecurringTableOrderingComposer
    extends Composer<_$AppDb, $MoneyRecurringTable> {
  $$MoneyRecurringTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoneyRecurringTableAnnotationComposer
    extends Composer<_$AppDb, $MoneyRecurringTable> {
  $$MoneyRecurringTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$MoneyRecurringTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MoneyRecurringTable,
          MoneyRecurringData,
          $$MoneyRecurringTableFilterComposer,
          $$MoneyRecurringTableOrderingComposer,
          $$MoneyRecurringTableAnnotationComposer,
          $$MoneyRecurringTableCreateCompanionBuilder,
          $$MoneyRecurringTableUpdateCompanionBuilder,
          (
            MoneyRecurringData,
            BaseReferences<_$AppDb, $MoneyRecurringTable, MoneyRecurringData>,
          ),
          MoneyRecurringData,
          PrefetchHooks Function()
        > {
  $$MoneyRecurringTableTableManager(_$AppDb db, $MoneyRecurringTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoneyRecurringTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoneyRecurringTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoneyRecurringTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoneyRecurringCompanion(
                id: id,
                title: title,
                amountPaise: amountPaise,
                kind: kind,
                category: category,
                dayOfMonth: dayOfMonth,
                goalId: goalId,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required int amountPaise,
                required String kind,
                Value<String> category = const Value.absent(),
                required int dayOfMonth,
                Value<String?> goalId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoneyRecurringCompanion.insert(
                id: id,
                title: title,
                amountPaise: amountPaise,
                kind: kind,
                category: category,
                dayOfMonth: dayOfMonth,
                goalId: goalId,
                enabled: enabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoneyRecurringTable, MoneyRecurringData>(table),
                  BaseReferences<
                    _$AppDb,
                    $MoneyRecurringTable,
                    MoneyRecurringData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoneyRecurringTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MoneyRecurringTable,
      MoneyRecurringData,
      $$MoneyRecurringTableFilterComposer,
      $$MoneyRecurringTableOrderingComposer,
      $$MoneyRecurringTableAnnotationComposer,
      $$MoneyRecurringTableCreateCompanionBuilder,
      $$MoneyRecurringTableUpdateCompanionBuilder,
      (
        MoneyRecurringData,
        BaseReferences<_$AppDb, $MoneyRecurringTable, MoneyRecurringData>,
      ),
      MoneyRecurringData,
      PrefetchHooks Function()
    >;
typedef $$NudgeLogTableCreateCompanionBuilder = NudgeLogCompanion Function({
  Value<int> id,
  required int at,
  required String type,
  Value<String?> package,
  Value<String?> todoId,
  required String text_,
  required String action,
});
typedef $$NudgeLogTableUpdateCompanionBuilder = NudgeLogCompanion Function({
  Value<int> id,
  Value<int> at,
  Value<String> type,
  Value<String?> package,
  Value<String?> todoId,
  Value<String> text_,
  Value<String> action,
});

class $$NudgeLogTableFilterComposer extends Composer<_$AppDb, $NudgeLogTable> {
  $$NudgeLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NudgeLogTableOrderingComposer
    extends Composer<_$AppDb, $NudgeLogTable> {
  $$NudgeLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get package => $composableBuilder(
    column: $table.package,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NudgeLogTableAnnotationComposer
    extends Composer<_$AppDb, $NudgeLogTable> {
  $$NudgeLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get package =>
      $composableBuilder(column: $table.package, builder: (column) => column);

  GeneratedColumn<String> get todoId =>
      $composableBuilder(column: $table.todoId, builder: (column) => column);

  GeneratedColumn<String> get text_ =>
      $composableBuilder(column: $table.text_, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);
}

class $$NudgeLogTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $NudgeLogTable,
          NudgeLogData,
          $$NudgeLogTableFilterComposer,
          $$NudgeLogTableOrderingComposer,
          $$NudgeLogTableAnnotationComposer,
          $$NudgeLogTableCreateCompanionBuilder,
          $$NudgeLogTableUpdateCompanionBuilder,
          (NudgeLogData, BaseReferences<_$AppDb, $NudgeLogTable, NudgeLogData>),
          NudgeLogData,
          PrefetchHooks Function()
        > {
  $$NudgeLogTableTableManager(_$AppDb db, $NudgeLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NudgeLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NudgeLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NudgeLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> at = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> package = const Value.absent(),
                Value<String?> todoId = const Value.absent(),
                Value<String> text_ = const Value.absent(),
                Value<String> action = const Value.absent(),
              }) => NudgeLogCompanion(
                id: id,
                at: at,
                type: type,
                package: package,
                todoId: todoId,
                text_: text_,
                action: action,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int at,
                required String type,
                Value<String?> package = const Value.absent(),
                Value<String?> todoId = const Value.absent(),
                required String text_,
                required String action,
              }) => NudgeLogCompanion.insert(
                id: id,
                at: at,
                type: type,
                package: package,
                todoId: todoId,
                text_: text_,
                action: action,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NudgeLogTable, NudgeLogData>(table),
                  BaseReferences<_$AppDb, $NudgeLogTable, NudgeLogData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NudgeLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $NudgeLogTable,
      NudgeLogData,
      $$NudgeLogTableFilterComposer,
      $$NudgeLogTableOrderingComposer,
      $$NudgeLogTableAnnotationComposer,
      $$NudgeLogTableCreateCompanionBuilder,
      $$NudgeLogTableUpdateCompanionBuilder,
      (NudgeLogData, BaseReferences<_$AppDb, $NudgeLogTable, NudgeLogData>),
      NudgeLogData,
      PrefetchHooks Function()
    >;
typedef $$EventLogTableCreateCompanionBuilder = EventLogCompanion Function({
  Value<int> id,
  required int at,
  required String source,
  Value<String> level,
  required String message,
  Value<String?> dataJson,
});
typedef $$EventLogTableUpdateCompanionBuilder = EventLogCompanion Function({
  Value<int> id,
  Value<int> at,
  Value<String> source,
  Value<String> level,
  Value<String> message,
  Value<String?> dataJson,
});

class $$EventLogTableFilterComposer extends Composer<_$AppDb, $EventLogTable> {
  $$EventLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventLogTableOrderingComposer
    extends Composer<_$AppDb, $EventLogTable> {
  $$EventLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventLogTableAnnotationComposer
    extends Composer<_$AppDb, $EventLogTable> {
  $$EventLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);
}

class $$EventLogTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $EventLogTable,
          EventLogData,
          $$EventLogTableFilterComposer,
          $$EventLogTableOrderingComposer,
          $$EventLogTableAnnotationComposer,
          $$EventLogTableCreateCompanionBuilder,
          $$EventLogTableUpdateCompanionBuilder,
          (EventLogData, BaseReferences<_$AppDb, $EventLogTable, EventLogData>),
          EventLogData,
          PrefetchHooks Function()
        > {
  $$EventLogTableTableManager(_$AppDb db, $EventLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> at = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
              }) => EventLogCompanion(
                id: id,
                at: at,
                source: source,
                level: level,
                message: message,
                dataJson: dataJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int at,
                required String source,
                Value<String> level = const Value.absent(),
                required String message,
                Value<String?> dataJson = const Value.absent(),
              }) => EventLogCompanion.insert(
                id: id,
                at: at,
                source: source,
                level: level,
                message: message,
                dataJson: dataJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventLogTable, EventLogData>(table),
                  BaseReferences<_$AppDb, $EventLogTable, EventLogData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $EventLogTable,
      EventLogData,
      $$EventLogTableFilterComposer,
      $$EventLogTableOrderingComposer,
      $$EventLogTableAnnotationComposer,
      $$EventLogTableCreateCompanionBuilder,
      $$EventLogTableUpdateCompanionBuilder,
      (EventLogData, BaseReferences<_$AppDb, $EventLogTable, EventLogData>),
      EventLogData,
      PrefetchHooks Function()
    >;
typedef $$AiCacheTableCreateCompanionBuilder = AiCacheCompanion Function({
  required String key,
  required String kind,
  required String responseJson,
  required int createdAt,
  Value<int?> expiresAt,
  Value<int> rowid,
});
typedef $$AiCacheTableUpdateCompanionBuilder = AiCacheCompanion Function({
  Value<String> key,
  Value<String> kind,
  Value<String> responseJson,
  Value<int> createdAt,
  Value<int?> expiresAt,
  Value<int> rowid,
});

class $$AiCacheTableFilterComposer extends Composer<_$AppDb, $AiCacheTable> {
  $$AiCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiCacheTableOrderingComposer extends Composer<_$AppDb, $AiCacheTable> {
  $$AiCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiCacheTableAnnotationComposer
    extends Composer<_$AppDb, $AiCacheTable> {
  $$AiCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$AiCacheTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AiCacheTable,
          AiCacheData,
          $$AiCacheTableFilterComposer,
          $$AiCacheTableOrderingComposer,
          $$AiCacheTableAnnotationComposer,
          $$AiCacheTableCreateCompanionBuilder,
          $$AiCacheTableUpdateCompanionBuilder,
          (AiCacheData, BaseReferences<_$AppDb, $AiCacheTable, AiCacheData>),
          AiCacheData,
          PrefetchHooks Function()
        > {
  $$AiCacheTableTableManager(_$AppDb db, $AiCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> responseJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiCacheCompanion(
                key: key,
                kind: kind,
                responseJson: responseJson,
                createdAt: createdAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String kind,
                required String responseJson,
                required int createdAt,
                Value<int?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiCacheCompanion.insert(
                key: key,
                kind: kind,
                responseJson: responseJson,
                createdAt: createdAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiCacheTable, AiCacheData>(table),
                  BaseReferences<_$AppDb, $AiCacheTable, AiCacheData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AiCacheTable,
      AiCacheData,
      $$AiCacheTableFilterComposer,
      $$AiCacheTableOrderingComposer,
      $$AiCacheTableAnnotationComposer,
      $$AiCacheTableCreateCompanionBuilder,
      $$AiCacheTableUpdateCompanionBuilder,
      (AiCacheData, BaseReferences<_$AppDb, $AiCacheTable, AiCacheData>),
      AiCacheData,
      PrefetchHooks Function()
    >;
typedef $$AiUsageTableCreateCompanionBuilder = AiUsageCompanion Function({
  Value<int> id,
  required int at,
  required String feature,
  required String model,
  Value<int> inputTokens,
  Value<int> outputTokens,
  Value<int> cacheReadTokens,
  Value<int> cacheWriteTokens,
});
typedef $$AiUsageTableUpdateCompanionBuilder = AiUsageCompanion Function({
  Value<int> id,
  Value<int> at,
  Value<String> feature,
  Value<String> model,
  Value<int> inputTokens,
  Value<int> outputTokens,
  Value<int> cacheReadTokens,
  Value<int> cacheWriteTokens,
});

class $$AiUsageTableFilterComposer extends Composer<_$AppDb, $AiUsageTable> {
  $$AiUsageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cacheReadTokens => $composableBuilder(
    column: $table.cacheReadTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cacheWriteTokens => $composableBuilder(
    column: $table.cacheWriteTokens,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiUsageTableOrderingComposer extends Composer<_$AppDb, $AiUsageTable> {
  $$AiUsageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cacheReadTokens => $composableBuilder(
    column: $table.cacheReadTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cacheWriteTokens => $composableBuilder(
    column: $table.cacheWriteTokens,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiUsageTableAnnotationComposer
    extends Composer<_$AppDb, $AiUsageTable> {
  $$AiUsageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get inputTokens => $composableBuilder(
    column: $table.inputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outputTokens => $composableBuilder(
    column: $table.outputTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cacheReadTokens => $composableBuilder(
    column: $table.cacheReadTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cacheWriteTokens => $composableBuilder(
    column: $table.cacheWriteTokens,
    builder: (column) => column,
  );
}

class $$AiUsageTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AiUsageTable,
          AiUsageData,
          $$AiUsageTableFilterComposer,
          $$AiUsageTableOrderingComposer,
          $$AiUsageTableAnnotationComposer,
          $$AiUsageTableCreateCompanionBuilder,
          $$AiUsageTableUpdateCompanionBuilder,
          (AiUsageData, BaseReferences<_$AppDb, $AiUsageTable, AiUsageData>),
          AiUsageData,
          PrefetchHooks Function()
        > {
  $$AiUsageTableTableManager(_$AppDb db, $AiUsageTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiUsageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiUsageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiUsageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> at = const Value.absent(),
                Value<String> feature = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> inputTokens = const Value.absent(),
                Value<int> outputTokens = const Value.absent(),
                Value<int> cacheReadTokens = const Value.absent(),
                Value<int> cacheWriteTokens = const Value.absent(),
              }) => AiUsageCompanion(
                id: id,
                at: at,
                feature: feature,
                model: model,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                cacheReadTokens: cacheReadTokens,
                cacheWriteTokens: cacheWriteTokens,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int at,
                required String feature,
                required String model,
                Value<int> inputTokens = const Value.absent(),
                Value<int> outputTokens = const Value.absent(),
                Value<int> cacheReadTokens = const Value.absent(),
                Value<int> cacheWriteTokens = const Value.absent(),
              }) => AiUsageCompanion.insert(
                id: id,
                at: at,
                feature: feature,
                model: model,
                inputTokens: inputTokens,
                outputTokens: outputTokens,
                cacheReadTokens: cacheReadTokens,
                cacheWriteTokens: cacheWriteTokens,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiUsageTable, AiUsageData>(table),
                  BaseReferences<_$AppDb, $AiUsageTable, AiUsageData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiUsageTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AiUsageTable,
      AiUsageData,
      $$AiUsageTableFilterComposer,
      $$AiUsageTableOrderingComposer,
      $$AiUsageTableAnnotationComposer,
      $$AiUsageTableCreateCompanionBuilder,
      $$AiUsageTableUpdateCompanionBuilder,
      (AiUsageData, BaseReferences<_$AppDb, $AiUsageTable, AiUsageData>),
      AiUsageData,
      PrefetchHooks Function()
    >;
typedef $$DailyRollupTableCreateCompanionBuilder =
    DailyRollupCompanion Function({
      required String date,
      Value<String> minutesByCategoryJson,
      Value<int> wastedMin,
      Value<int> workMin,
      Value<int> learningMin,
      Value<String> topAppsJson,
      Value<int> rowid,
    });
typedef $$DailyRollupTableUpdateCompanionBuilder =
    DailyRollupCompanion Function({
      Value<String> date,
      Value<String> minutesByCategoryJson,
      Value<int> wastedMin,
      Value<int> workMin,
      Value<int> learningMin,
      Value<String> topAppsJson,
      Value<int> rowid,
    });

class $$DailyRollupTableFilterComposer
    extends Composer<_$AppDb, $DailyRollupTable> {
  $$DailyRollupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get minutesByCategoryJson => $composableBuilder(
    column: $table.minutesByCategoryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wastedMin => $composableBuilder(
    column: $table.wastedMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workMin => $composableBuilder(
    column: $table.workMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get learningMin => $composableBuilder(
    column: $table.learningMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topAppsJson => $composableBuilder(
    column: $table.topAppsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyRollupTableOrderingComposer
    extends Composer<_$AppDb, $DailyRollupTable> {
  $$DailyRollupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get minutesByCategoryJson => $composableBuilder(
    column: $table.minutesByCategoryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wastedMin => $composableBuilder(
    column: $table.wastedMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workMin => $composableBuilder(
    column: $table.workMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get learningMin => $composableBuilder(
    column: $table.learningMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topAppsJson => $composableBuilder(
    column: $table.topAppsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyRollupTableAnnotationComposer
    extends Composer<_$AppDb, $DailyRollupTable> {
  $$DailyRollupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get minutesByCategoryJson => $composableBuilder(
    column: $table.minutesByCategoryJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wastedMin =>
      $composableBuilder(column: $table.wastedMin, builder: (column) => column);

  GeneratedColumn<int> get workMin =>
      $composableBuilder(column: $table.workMin, builder: (column) => column);

  GeneratedColumn<int> get learningMin => $composableBuilder(
    column: $table.learningMin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topAppsJson => $composableBuilder(
    column: $table.topAppsJson,
    builder: (column) => column,
  );
}

class $$DailyRollupTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $DailyRollupTable,
          DailyRollupData,
          $$DailyRollupTableFilterComposer,
          $$DailyRollupTableOrderingComposer,
          $$DailyRollupTableAnnotationComposer,
          $$DailyRollupTableCreateCompanionBuilder,
          $$DailyRollupTableUpdateCompanionBuilder,
          (
            DailyRollupData,
            BaseReferences<_$AppDb, $DailyRollupTable, DailyRollupData>,
          ),
          DailyRollupData,
          PrefetchHooks Function()
        > {
  $$DailyRollupTableTableManager(_$AppDb db, $DailyRollupTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyRollupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyRollupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyRollupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> minutesByCategoryJson = const Value.absent(),
                Value<int> wastedMin = const Value.absent(),
                Value<int> workMin = const Value.absent(),
                Value<int> learningMin = const Value.absent(),
                Value<String> topAppsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyRollupCompanion(
                date: date,
                minutesByCategoryJson: minutesByCategoryJson,
                wastedMin: wastedMin,
                workMin: workMin,
                learningMin: learningMin,
                topAppsJson: topAppsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<String> minutesByCategoryJson = const Value.absent(),
                Value<int> wastedMin = const Value.absent(),
                Value<int> workMin = const Value.absent(),
                Value<int> learningMin = const Value.absent(),
                Value<String> topAppsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyRollupCompanion.insert(
                date: date,
                minutesByCategoryJson: minutesByCategoryJson,
                wastedMin: wastedMin,
                workMin: workMin,
                learningMin: learningMin,
                topAppsJson: topAppsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyRollupTable, DailyRollupData>(table),
                  BaseReferences<_$AppDb, $DailyRollupTable, DailyRollupData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyRollupTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $DailyRollupTable,
      DailyRollupData,
      $$DailyRollupTableFilterComposer,
      $$DailyRollupTableOrderingComposer,
      $$DailyRollupTableAnnotationComposer,
      $$DailyRollupTableCreateCompanionBuilder,
      $$DailyRollupTableUpdateCompanionBuilder,
      (
        DailyRollupData,
        BaseReferences<_$AppDb, $DailyRollupTable, DailyRollupData>,
      ),
      DailyRollupData,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String valueJson,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> valueJson,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer extends Composer<_$AppDb, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDb, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDb, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDb, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDb db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> valueJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, valueJson: valueJson, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String valueJson,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                valueJson: valueJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDb, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDb, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$StagesTableTableManager get stages =>
      $$StagesTableTableManager(_db, _db.stages);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$AppCategoriesTableTableManager get appCategories =>
      $$AppCategoriesTableTableManager(_db, _db.appCategories);
  $$UsageSessionsTableTableManager get usageSessions =>
      $$UsageSessionsTableTableManager(_db, _db.usageSessions);
  $$ContentItemsTableTableManager get contentItems =>
      $$ContentItemsTableTableManager(_db, _db.contentItems);
  $$ContentRulesTableTableManager get contentRules =>
      $$ContentRulesTableTableManager(_db, _db.contentRules);
  $$ActivityDailyTableTableManager get activityDaily =>
      $$ActivityDailyTableTableManager(_db, _db.activityDaily);
  $$MoneyEntriesTableTableManager get moneyEntries =>
      $$MoneyEntriesTableTableManager(_db, _db.moneyEntries);
  $$MoneyRecurringTableTableManager get moneyRecurring =>
      $$MoneyRecurringTableTableManager(_db, _db.moneyRecurring);
  $$NudgeLogTableTableManager get nudgeLog =>
      $$NudgeLogTableTableManager(_db, _db.nudgeLog);
  $$EventLogTableTableManager get eventLog =>
      $$EventLogTableTableManager(_db, _db.eventLog);
  $$AiCacheTableTableManager get aiCache =>
      $$AiCacheTableTableManager(_db, _db.aiCache);
  $$AiUsageTableTableManager get aiUsage =>
      $$AiUsageTableTableManager(_db, _db.aiUsage);
  $$DailyRollupTableTableManager get dailyRollup =>
      $$DailyRollupTableTableManager(_db, _db.dailyRollup);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
