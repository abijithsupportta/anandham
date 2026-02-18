// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $KrithisLocalTable extends KrithisLocal
    with TableInfo<$KrithisLocalTable, KrithisLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KrithisLocalTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _youtubeUrlMeta = const VerificationMeta(
    'youtubeUrl',
  );
  @override
  late final GeneratedColumn<String> youtubeUrl = GeneratedColumn<String>(
    'youtube_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    defaultValue: const Constant('published'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    youtubeUrl,
    displayOrder,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'krithis_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<KrithisLocalData> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('youtube_url')) {
      context.handle(
        _youtubeUrlMeta,
        youtubeUrl.isAcceptableOrUnknown(data['youtube_url']!, _youtubeUrlMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KrithisLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KrithisLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      youtubeUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}youtube_url'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KrithisLocalTable createAlias(String alias) {
    return $KrithisLocalTable(attachedDatabase, alias);
  }
}

class KrithisLocalData extends DataClass
    implements Insertable<KrithisLocalData> {
  final String id;
  final String title;
  final String? description;
  final String? youtubeUrl;
  final int? displayOrder;
  final String status;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime updatedAt;
  const KrithisLocalData({
    required this.id,
    required this.title,
    this.description,
    this.youtubeUrl,
    this.displayOrder,
    required this.status,
    required this.isDeleted,
    this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || youtubeUrl != null) {
      map['youtube_url'] = Variable<String>(youtubeUrl);
    }
    if (!nullToAbsent || displayOrder != null) {
      map['display_order'] = Variable<int>(displayOrder);
    }
    map['status'] = Variable<String>(status);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KrithisLocalCompanion toCompanion(bool nullToAbsent) {
    return KrithisLocalCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      youtubeUrl: youtubeUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(youtubeUrl),
      displayOrder: displayOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(displayOrder),
      status: Value(status),
      isDeleted: Value(isDeleted),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KrithisLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KrithisLocalData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      youtubeUrl: serializer.fromJson<String?>(json['youtubeUrl']),
      displayOrder: serializer.fromJson<int?>(json['displayOrder']),
      status: serializer.fromJson<String>(json['status']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'youtubeUrl': serializer.toJson<String?>(youtubeUrl),
      'displayOrder': serializer.toJson<int?>(displayOrder),
      'status': serializer.toJson<String>(status),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KrithisLocalData copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> youtubeUrl = const Value.absent(),
    Value<int?> displayOrder = const Value.absent(),
    String? status,
    bool? isDeleted,
    Value<DateTime?> createdAt = const Value.absent(),
    DateTime? updatedAt,
  }) => KrithisLocalData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    youtubeUrl: youtubeUrl.present ? youtubeUrl.value : this.youtubeUrl,
    displayOrder: displayOrder.present ? displayOrder.value : this.displayOrder,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KrithisLocalData copyWithCompanion(KrithisLocalCompanion data) {
    return KrithisLocalData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      youtubeUrl: data.youtubeUrl.present
          ? data.youtubeUrl.value
          : this.youtubeUrl,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      status: data.status.present ? data.status.value : this.status,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KrithisLocalData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    youtubeUrl,
    displayOrder,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KrithisLocalData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.youtubeUrl == this.youtubeUrl &&
          other.displayOrder == this.displayOrder &&
          other.status == this.status &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KrithisLocalCompanion extends UpdateCompanion<KrithisLocalData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> youtubeUrl;
  final Value<int?> displayOrder;
  final Value<String> status;
  final Value<bool> isDeleted;
  final Value<DateTime?> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KrithisLocalCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KrithisLocalCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<KrithisLocalData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? youtubeUrl,
    Expression<int>? displayOrder,
    Expression<String>? status,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (youtubeUrl != null) 'youtube_url': youtubeUrl,
      if (displayOrder != null) 'display_order': displayOrder,
      if (status != null) 'status': status,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KrithisLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? youtubeUrl,
    Value<int?>? displayOrder,
    Value<String>? status,
    Value<bool>? isDeleted,
    Value<DateTime?>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return KrithisLocalCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (youtubeUrl.present) {
      map['youtube_url'] = Variable<String>(youtubeUrl.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KrithisLocalCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KeerthanamsLocalTable extends KeerthanamsLocal
    with TableInfo<$KeerthanamsLocalTable, KeerthanamsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeerthanamsLocalTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _youtubeUrlMeta = const VerificationMeta(
    'youtubeUrl',
  );
  @override
  late final GeneratedColumn<String> youtubeUrl = GeneratedColumn<String>(
    'youtube_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    defaultValue: const Constant('published'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    authorName,
    description,
    youtubeUrl,
    displayOrder,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keerthanams_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeerthanamsLocalData> instance, {
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
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('youtube_url')) {
      context.handle(
        _youtubeUrlMeta,
        youtubeUrl.isAcceptableOrUnknown(data['youtube_url']!, _youtubeUrlMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KeerthanamsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeerthanamsLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      youtubeUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}youtube_url'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KeerthanamsLocalTable createAlias(String alias) {
    return $KeerthanamsLocalTable(attachedDatabase, alias);
  }
}

class KeerthanamsLocalData extends DataClass
    implements Insertable<KeerthanamsLocalData> {
  final String id;
  final String title;
  final String? authorName;
  final String? description;
  final String? youtubeUrl;
  final int? displayOrder;
  final String status;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime updatedAt;
  const KeerthanamsLocalData({
    required this.id,
    required this.title,
    this.authorName,
    this.description,
    this.youtubeUrl,
    this.displayOrder,
    required this.status,
    required this.isDeleted,
    this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || authorName != null) {
      map['author_name'] = Variable<String>(authorName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || youtubeUrl != null) {
      map['youtube_url'] = Variable<String>(youtubeUrl);
    }
    if (!nullToAbsent || displayOrder != null) {
      map['display_order'] = Variable<int>(displayOrder);
    }
    map['status'] = Variable<String>(status);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KeerthanamsLocalCompanion toCompanion(bool nullToAbsent) {
    return KeerthanamsLocalCompanion(
      id: Value(id),
      title: Value(title),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      youtubeUrl: youtubeUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(youtubeUrl),
      displayOrder: displayOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(displayOrder),
      status: Value(status),
      isDeleted: Value(isDeleted),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KeerthanamsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeerthanamsLocalData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      authorName: serializer.fromJson<String?>(json['authorName']),
      description: serializer.fromJson<String?>(json['description']),
      youtubeUrl: serializer.fromJson<String?>(json['youtubeUrl']),
      displayOrder: serializer.fromJson<int?>(json['displayOrder']),
      status: serializer.fromJson<String>(json['status']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'authorName': serializer.toJson<String?>(authorName),
      'description': serializer.toJson<String?>(description),
      'youtubeUrl': serializer.toJson<String?>(youtubeUrl),
      'displayOrder': serializer.toJson<int?>(displayOrder),
      'status': serializer.toJson<String>(status),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KeerthanamsLocalData copyWith({
    String? id,
    String? title,
    Value<String?> authorName = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> youtubeUrl = const Value.absent(),
    Value<int?> displayOrder = const Value.absent(),
    String? status,
    bool? isDeleted,
    Value<DateTime?> createdAt = const Value.absent(),
    DateTime? updatedAt,
  }) => KeerthanamsLocalData(
    id: id ?? this.id,
    title: title ?? this.title,
    authorName: authorName.present ? authorName.value : this.authorName,
    description: description.present ? description.value : this.description,
    youtubeUrl: youtubeUrl.present ? youtubeUrl.value : this.youtubeUrl,
    displayOrder: displayOrder.present ? displayOrder.value : this.displayOrder,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KeerthanamsLocalData copyWithCompanion(KeerthanamsLocalCompanion data) {
    return KeerthanamsLocalData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      description: data.description.present
          ? data.description.value
          : this.description,
      youtubeUrl: data.youtubeUrl.present
          ? data.youtubeUrl.value
          : this.youtubeUrl,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      status: data.status.present ? data.status.value : this.status,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeerthanamsLocalData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authorName: $authorName, ')
          ..write('description: $description, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    authorName,
    description,
    youtubeUrl,
    displayOrder,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeerthanamsLocalData &&
          other.id == this.id &&
          other.title == this.title &&
          other.authorName == this.authorName &&
          other.description == this.description &&
          other.youtubeUrl == this.youtubeUrl &&
          other.displayOrder == this.displayOrder &&
          other.status == this.status &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KeerthanamsLocalCompanion extends UpdateCompanion<KeerthanamsLocalData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> authorName;
  final Value<String?> description;
  final Value<String?> youtubeUrl;
  final Value<int?> displayOrder;
  final Value<String> status;
  final Value<bool> isDeleted;
  final Value<DateTime?> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KeerthanamsLocalCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.authorName = const Value.absent(),
    this.description = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeerthanamsLocalCompanion.insert({
    required String id,
    required String title,
    this.authorName = const Value.absent(),
    this.description = const Value.absent(),
    this.youtubeUrl = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<KeerthanamsLocalData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? authorName,
    Expression<String>? description,
    Expression<String>? youtubeUrl,
    Expression<int>? displayOrder,
    Expression<String>? status,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (authorName != null) 'author_name': authorName,
      if (description != null) 'description': description,
      if (youtubeUrl != null) 'youtube_url': youtubeUrl,
      if (displayOrder != null) 'display_order': displayOrder,
      if (status != null) 'status': status,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeerthanamsLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? authorName,
    Value<String?>? description,
    Value<String?>? youtubeUrl,
    Value<int?>? displayOrder,
    Value<String>? status,
    Value<bool>? isDeleted,
    Value<DateTime?>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return KeerthanamsLocalCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      description: description ?? this.description,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (youtubeUrl.present) {
      map['youtube_url'] = Variable<String>(youtubeUrl.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeerthanamsLocalCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authorName: $authorName, ')
          ..write('description: $description, ')
          ..write('youtubeUrl: $youtubeUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DharmasLocalTable extends DharmasLocal
    with TableInfo<$DharmasLocalTable, DharmasLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DharmasLocalTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    defaultValue: const Constant('published'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    translation,
    displayOrder,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dharmas_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<DharmasLocalData> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DharmasLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DharmasLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DharmasLocalTable createAlias(String alias) {
    return $DharmasLocalTable(attachedDatabase, alias);
  }
}

class DharmasLocalData extends DataClass
    implements Insertable<DharmasLocalData> {
  final String id;
  final String title;
  final String? description;
  final String? translation;
  final int? displayOrder;
  final String status;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime updatedAt;
  const DharmasLocalData({
    required this.id,
    required this.title,
    this.description,
    this.translation,
    this.displayOrder,
    required this.status,
    required this.isDeleted,
    this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || translation != null) {
      map['translation'] = Variable<String>(translation);
    }
    if (!nullToAbsent || displayOrder != null) {
      map['display_order'] = Variable<int>(displayOrder);
    }
    map['status'] = Variable<String>(status);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DharmasLocalCompanion toCompanion(bool nullToAbsent) {
    return DharmasLocalCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      translation: translation == null && nullToAbsent
          ? const Value.absent()
          : Value(translation),
      displayOrder: displayOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(displayOrder),
      status: Value(status),
      isDeleted: Value(isDeleted),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DharmasLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DharmasLocalData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      translation: serializer.fromJson<String?>(json['translation']),
      displayOrder: serializer.fromJson<int?>(json['displayOrder']),
      status: serializer.fromJson<String>(json['status']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'translation': serializer.toJson<String?>(translation),
      'displayOrder': serializer.toJson<int?>(displayOrder),
      'status': serializer.toJson<String>(status),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DharmasLocalData copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> translation = const Value.absent(),
    Value<int?> displayOrder = const Value.absent(),
    String? status,
    bool? isDeleted,
    Value<DateTime?> createdAt = const Value.absent(),
    DateTime? updatedAt,
  }) => DharmasLocalData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    translation: translation.present ? translation.value : this.translation,
    displayOrder: displayOrder.present ? displayOrder.value : this.displayOrder,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DharmasLocalData copyWithCompanion(DharmasLocalCompanion data) {
    return DharmasLocalData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      status: data.status.present ? data.status.value : this.status,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DharmasLocalData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('translation: $translation, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    translation,
    displayOrder,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DharmasLocalData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.translation == this.translation &&
          other.displayOrder == this.displayOrder &&
          other.status == this.status &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DharmasLocalCompanion extends UpdateCompanion<DharmasLocalData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> translation;
  final Value<int?> displayOrder;
  final Value<String> status;
  final Value<bool> isDeleted;
  final Value<DateTime?> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DharmasLocalCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.translation = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DharmasLocalCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.translation = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<DharmasLocalData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? translation,
    Expression<int>? displayOrder,
    Expression<String>? status,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (translation != null) 'translation': translation,
      if (displayOrder != null) 'display_order': displayOrder,
      if (status != null) 'status': status,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DharmasLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? translation,
    Value<int?>? displayOrder,
    Value<String>? status,
    Value<bool>? isDeleted,
    Value<DateTime?>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DharmasLocalCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      translation: translation ?? this.translation,
      displayOrder: displayOrder ?? this.displayOrder,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DharmasLocalCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('translation: $translation, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DharmaItemsLocalTable extends DharmaItemsLocal
    with TableInfo<$DharmaItemsLocalTable, DharmaItemsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DharmaItemsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dharmaIdMeta = const VerificationMeta(
    'dharmaId',
  );
  @override
  late final GeneratedColumn<String> dharmaId = GeneratedColumn<String>(
    'dharma_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemNumberMeta = const VerificationMeta(
    'itemNumber',
  );
  @override
  late final GeneratedColumn<int> itemNumber = GeneratedColumn<int>(
    'item_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textValueMeta = const VerificationMeta(
    'textValue',
  );
  @override
  late final GeneratedColumn<String> textValue = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    dharmaId,
    itemNumber,
    textValue,
    explanation,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dharma_items_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<DharmaItemsLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dharma_id')) {
      context.handle(
        _dharmaIdMeta,
        dharmaId.isAcceptableOrUnknown(data['dharma_id']!, _dharmaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dharmaIdMeta);
    }
    if (data.containsKey('item_number')) {
      context.handle(
        _itemNumberMeta,
        itemNumber.isAcceptableOrUnknown(data['item_number']!, _itemNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNumberMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _textValueMeta,
        textValue.isAcceptableOrUnknown(data['text']!, _textValueMeta),
      );
    } else if (isInserting) {
      context.missing(_textValueMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dharmaId, itemNumber};
  @override
  DharmaItemsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DharmaItemsLocalData(
      dharmaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dharma_id'],
      )!,
      itemNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_number'],
      )!,
      textValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DharmaItemsLocalTable createAlias(String alias) {
    return $DharmaItemsLocalTable(attachedDatabase, alias);
  }
}

class DharmaItemsLocalData extends DataClass
    implements Insertable<DharmaItemsLocalData> {
  final String dharmaId;
  final int itemNumber;
  final String textValue;
  final String? explanation;
  final bool isDeleted;
  const DharmaItemsLocalData({
    required this.dharmaId,
    required this.itemNumber,
    required this.textValue,
    this.explanation,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dharma_id'] = Variable<String>(dharmaId);
    map['item_number'] = Variable<int>(itemNumber);
    map['text'] = Variable<String>(textValue);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DharmaItemsLocalCompanion toCompanion(bool nullToAbsent) {
    return DharmaItemsLocalCompanion(
      dharmaId: Value(dharmaId),
      itemNumber: Value(itemNumber),
      textValue: Value(textValue),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      isDeleted: Value(isDeleted),
    );
  }

  factory DharmaItemsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DharmaItemsLocalData(
      dharmaId: serializer.fromJson<String>(json['dharmaId']),
      itemNumber: serializer.fromJson<int>(json['itemNumber']),
      textValue: serializer.fromJson<String>(json['textValue']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dharmaId': serializer.toJson<String>(dharmaId),
      'itemNumber': serializer.toJson<int>(itemNumber),
      'textValue': serializer.toJson<String>(textValue),
      'explanation': serializer.toJson<String?>(explanation),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  DharmaItemsLocalData copyWith({
    String? dharmaId,
    int? itemNumber,
    String? textValue,
    Value<String?> explanation = const Value.absent(),
    bool? isDeleted,
  }) => DharmaItemsLocalData(
    dharmaId: dharmaId ?? this.dharmaId,
    itemNumber: itemNumber ?? this.itemNumber,
    textValue: textValue ?? this.textValue,
    explanation: explanation.present ? explanation.value : this.explanation,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  DharmaItemsLocalData copyWithCompanion(DharmaItemsLocalCompanion data) {
    return DharmaItemsLocalData(
      dharmaId: data.dharmaId.present ? data.dharmaId.value : this.dharmaId,
      itemNumber: data.itemNumber.present
          ? data.itemNumber.value
          : this.itemNumber,
      textValue: data.textValue.present ? data.textValue.value : this.textValue,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DharmaItemsLocalData(')
          ..write('dharmaId: $dharmaId, ')
          ..write('itemNumber: $itemNumber, ')
          ..write('textValue: $textValue, ')
          ..write('explanation: $explanation, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dharmaId, itemNumber, textValue, explanation, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DharmaItemsLocalData &&
          other.dharmaId == this.dharmaId &&
          other.itemNumber == this.itemNumber &&
          other.textValue == this.textValue &&
          other.explanation == this.explanation &&
          other.isDeleted == this.isDeleted);
}

class DharmaItemsLocalCompanion extends UpdateCompanion<DharmaItemsLocalData> {
  final Value<String> dharmaId;
  final Value<int> itemNumber;
  final Value<String> textValue;
  final Value<String?> explanation;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const DharmaItemsLocalCompanion({
    this.dharmaId = const Value.absent(),
    this.itemNumber = const Value.absent(),
    this.textValue = const Value.absent(),
    this.explanation = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DharmaItemsLocalCompanion.insert({
    required String dharmaId,
    required int itemNumber,
    required String textValue,
    this.explanation = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dharmaId = Value(dharmaId),
       itemNumber = Value(itemNumber),
       textValue = Value(textValue);
  static Insertable<DharmaItemsLocalData> custom({
    Expression<String>? dharmaId,
    Expression<int>? itemNumber,
    Expression<String>? textValue,
    Expression<String>? explanation,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dharmaId != null) 'dharma_id': dharmaId,
      if (itemNumber != null) 'item_number': itemNumber,
      if (textValue != null) 'text': textValue,
      if (explanation != null) 'explanation': explanation,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DharmaItemsLocalCompanion copyWith({
    Value<String>? dharmaId,
    Value<int>? itemNumber,
    Value<String>? textValue,
    Value<String?>? explanation,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return DharmaItemsLocalCompanion(
      dharmaId: dharmaId ?? this.dharmaId,
      itemNumber: itemNumber ?? this.itemNumber,
      textValue: textValue ?? this.textValue,
      explanation: explanation ?? this.explanation,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dharmaId.present) {
      map['dharma_id'] = Variable<String>(dharmaId.value);
    }
    if (itemNumber.present) {
      map['item_number'] = Variable<int>(itemNumber.value);
    }
    if (textValue.present) {
      map['text'] = Variable<String>(textValue.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DharmaItemsLocalCompanion(')
          ..write('dharmaId: $dharmaId, ')
          ..write('itemNumber: $itemNumber, ')
          ..write('textValue: $textValue, ')
          ..write('explanation: $explanation, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DharmaWordsLocalTable extends DharmaWordsLocal
    with TableInfo<$DharmaWordsLocalTable, DharmaWordsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DharmaWordsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dharmaIdMeta = const VerificationMeta(
    'dharmaId',
  );
  @override
  late final GeneratedColumn<String> dharmaId = GeneratedColumn<String>(
    'dharma_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [dharmaId, displayOrder, word, meaning];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dharma_words_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<DharmaWordsLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dharma_id')) {
      context.handle(
        _dharmaIdMeta,
        dharmaId.isAcceptableOrUnknown(data['dharma_id']!, _dharmaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dharmaIdMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dharmaId, displayOrder, word};
  @override
  DharmaWordsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DharmaWordsLocalData(
      dharmaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dharma_id'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
    );
  }

  @override
  $DharmaWordsLocalTable createAlias(String alias) {
    return $DharmaWordsLocalTable(attachedDatabase, alias);
  }
}

class DharmaWordsLocalData extends DataClass
    implements Insertable<DharmaWordsLocalData> {
  final String dharmaId;
  final int displayOrder;
  final String word;
  final String meaning;
  const DharmaWordsLocalData({
    required this.dharmaId,
    required this.displayOrder,
    required this.word,
    required this.meaning,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dharma_id'] = Variable<String>(dharmaId);
    map['display_order'] = Variable<int>(displayOrder);
    map['word'] = Variable<String>(word);
    map['meaning'] = Variable<String>(meaning);
    return map;
  }

  DharmaWordsLocalCompanion toCompanion(bool nullToAbsent) {
    return DharmaWordsLocalCompanion(
      dharmaId: Value(dharmaId),
      displayOrder: Value(displayOrder),
      word: Value(word),
      meaning: Value(meaning),
    );
  }

  factory DharmaWordsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DharmaWordsLocalData(
      dharmaId: serializer.fromJson<String>(json['dharmaId']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      word: serializer.fromJson<String>(json['word']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dharmaId': serializer.toJson<String>(dharmaId),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'word': serializer.toJson<String>(word),
      'meaning': serializer.toJson<String>(meaning),
    };
  }

  DharmaWordsLocalData copyWith({
    String? dharmaId,
    int? displayOrder,
    String? word,
    String? meaning,
  }) => DharmaWordsLocalData(
    dharmaId: dharmaId ?? this.dharmaId,
    displayOrder: displayOrder ?? this.displayOrder,
    word: word ?? this.word,
    meaning: meaning ?? this.meaning,
  );
  DharmaWordsLocalData copyWithCompanion(DharmaWordsLocalCompanion data) {
    return DharmaWordsLocalData(
      dharmaId: data.dharmaId.present ? data.dharmaId.value : this.dharmaId,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      word: data.word.present ? data.word.value : this.word,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DharmaWordsLocalData(')
          ..write('dharmaId: $dharmaId, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('word: $word, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dharmaId, displayOrder, word, meaning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DharmaWordsLocalData &&
          other.dharmaId == this.dharmaId &&
          other.displayOrder == this.displayOrder &&
          other.word == this.word &&
          other.meaning == this.meaning);
}

class DharmaWordsLocalCompanion extends UpdateCompanion<DharmaWordsLocalData> {
  final Value<String> dharmaId;
  final Value<int> displayOrder;
  final Value<String> word;
  final Value<String> meaning;
  final Value<int> rowid;
  const DharmaWordsLocalCompanion({
    this.dharmaId = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.word = const Value.absent(),
    this.meaning = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DharmaWordsLocalCompanion.insert({
    required String dharmaId,
    required int displayOrder,
    required String word,
    required String meaning,
    this.rowid = const Value.absent(),
  }) : dharmaId = Value(dharmaId),
       displayOrder = Value(displayOrder),
       word = Value(word),
       meaning = Value(meaning);
  static Insertable<DharmaWordsLocalData> custom({
    Expression<String>? dharmaId,
    Expression<int>? displayOrder,
    Expression<String>? word,
    Expression<String>? meaning,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dharmaId != null) 'dharma_id': dharmaId,
      if (displayOrder != null) 'display_order': displayOrder,
      if (word != null) 'word': word,
      if (meaning != null) 'meaning': meaning,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DharmaWordsLocalCompanion copyWith({
    Value<String>? dharmaId,
    Value<int>? displayOrder,
    Value<String>? word,
    Value<String>? meaning,
    Value<int>? rowid,
  }) {
    return DharmaWordsLocalCompanion(
      dharmaId: dharmaId ?? this.dharmaId,
      displayOrder: displayOrder ?? this.displayOrder,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dharmaId.present) {
      map['dharma_id'] = Variable<String>(dharmaId.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DharmaWordsLocalCompanion(')
          ..write('dharmaId: $dharmaId, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('word: $word, ')
          ..write('meaning: $meaning, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedItemsLocalTable extends SavedItemsLocal
    with TableInfo<$SavedItemsLocalTable, SavedItemsLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedItemsLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    contentType,
    contentId,
    position,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_items_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedItemsLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, contentType, contentId};
  @override
  SavedItemsLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedItemsLocalData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavedItemsLocalTable createAlias(String alias) {
    return $SavedItemsLocalTable(attachedDatabase, alias);
  }
}

class SavedItemsLocalData extends DataClass
    implements Insertable<SavedItemsLocalData> {
  final String userId;
  final String contentType;
  final String contentId;
  final int? position;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SavedItemsLocalData({
    required this.userId,
    required this.contentType,
    required this.contentId,
    this.position,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['content_type'] = Variable<String>(contentType);
    map['content_id'] = Variable<String>(contentId);
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<int>(position);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SavedItemsLocalCompanion toCompanion(bool nullToAbsent) {
    return SavedItemsLocalCompanion(
      userId: Value(userId),
      contentType: Value(contentType),
      contentId: Value(contentId),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavedItemsLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedItemsLocalData(
      userId: serializer.fromJson<String>(json['userId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      contentId: serializer.fromJson<String>(json['contentId']),
      position: serializer.fromJson<int?>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'contentType': serializer.toJson<String>(contentType),
      'contentId': serializer.toJson<String>(contentId),
      'position': serializer.toJson<int?>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SavedItemsLocalData copyWith({
    String? userId,
    String? contentType,
    String? contentId,
    Value<int?> position = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SavedItemsLocalData(
    userId: userId ?? this.userId,
    contentType: contentType ?? this.contentType,
    contentId: contentId ?? this.contentId,
    position: position.present ? position.value : this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavedItemsLocalData copyWithCompanion(SavedItemsLocalCompanion data) {
    return SavedItemsLocalData(
      userId: data.userId.present ? data.userId.value : this.userId,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsLocalData(')
          ..write('userId: $userId, ')
          ..write('contentType: $contentType, ')
          ..write('contentId: $contentId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    contentType,
    contentId,
    position,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedItemsLocalData &&
          other.userId == this.userId &&
          other.contentType == this.contentType &&
          other.contentId == this.contentId &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavedItemsLocalCompanion extends UpdateCompanion<SavedItemsLocalData> {
  final Value<String> userId;
  final Value<String> contentType;
  final Value<String> contentId;
  final Value<int?> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SavedItemsLocalCompanion({
    this.userId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.contentId = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedItemsLocalCompanion.insert({
    required String userId,
    required String contentType,
    required String contentId,
    this.position = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       contentType = Value(contentType),
       contentId = Value(contentId),
       createdAt = Value(createdAt);
  static Insertable<SavedItemsLocalData> custom({
    Expression<String>? userId,
    Expression<String>? contentType,
    Expression<String>? contentId,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (contentType != null) 'content_type': contentType,
      if (contentId != null) 'content_id': contentId,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedItemsLocalCompanion copyWith({
    Value<String>? userId,
    Value<String>? contentType,
    Value<String>? contentId,
    Value<int?>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SavedItemsLocalCompanion(
      userId: userId ?? this.userId,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsLocalCompanion(')
          ..write('userId: $userId, ')
          ..write('contentType: $contentType, ')
          ..write('contentId: $contentId, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentTypesLocalTable extends ContentTypesLocal
    with TableInfo<$ContentTypesLocalTable, ContentTypesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentTypesLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tableRefMeta = const VerificationMeta(
    'tableRef',
  );
  @override
  late final GeneratedColumn<String> tableRef = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    name,
    displayName,
    description,
    icon,
    color,
    tableRef,
    displayOrder,
    isActive,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_types_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentTypesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _tableRefMeta,
        tableRef.isAcceptableOrUnknown(data['table_name']!, _tableRefMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  ContentTypesLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentTypesLocalData(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      tableRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ContentTypesLocalTable createAlias(String alias) {
    return $ContentTypesLocalTable(attachedDatabase, alias);
  }
}

class ContentTypesLocalData extends DataClass
    implements Insertable<ContentTypesLocalData> {
  final String name;
  final String displayName;
  final String? description;
  final String? icon;
  final String? color;
  final String? tableRef;
  final int? displayOrder;
  final bool isActive;
  final DateTime updatedAt;
  const ContentTypesLocalData({
    required this.name,
    required this.displayName,
    this.description,
    this.icon,
    this.color,
    this.tableRef,
    this.displayOrder,
    required this.isActive,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || tableRef != null) {
      map['table_name'] = Variable<String>(tableRef);
    }
    if (!nullToAbsent || displayOrder != null) {
      map['display_order'] = Variable<int>(displayOrder);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ContentTypesLocalCompanion toCompanion(bool nullToAbsent) {
    return ContentTypesLocalCompanion(
      name: Value(name),
      displayName: Value(displayName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      tableRef: tableRef == null && nullToAbsent
          ? const Value.absent()
          : Value(tableRef),
      displayOrder: displayOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(displayOrder),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContentTypesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentTypesLocalData(
      name: serializer.fromJson<String>(json['name']),
      displayName: serializer.fromJson<String>(json['displayName']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      tableRef: serializer.fromJson<String?>(json['tableRef']),
      displayOrder: serializer.fromJson<int?>(json['displayOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'displayName': serializer.toJson<String>(displayName),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'tableRef': serializer.toJson<String?>(tableRef),
      'displayOrder': serializer.toJson<int?>(displayOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ContentTypesLocalData copyWith({
    String? name,
    String? displayName,
    Value<String?> description = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> tableRef = const Value.absent(),
    Value<int?> displayOrder = const Value.absent(),
    bool? isActive,
    DateTime? updatedAt,
  }) => ContentTypesLocalData(
    name: name ?? this.name,
    displayName: displayName ?? this.displayName,
    description: description.present ? description.value : this.description,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    tableRef: tableRef.present ? tableRef.value : this.tableRef,
    displayOrder: displayOrder.present ? displayOrder.value : this.displayOrder,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ContentTypesLocalData copyWithCompanion(ContentTypesLocalCompanion data) {
    return ContentTypesLocalData(
      name: data.name.present ? data.name.value : this.name,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      tableRef: data.tableRef.present ? data.tableRef.value : this.tableRef,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentTypesLocalData(')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('tableRef: $tableRef, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    name,
    displayName,
    description,
    icon,
    color,
    tableRef,
    displayOrder,
    isActive,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentTypesLocalData &&
          other.name == this.name &&
          other.displayName == this.displayName &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.tableRef == this.tableRef &&
          other.displayOrder == this.displayOrder &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt);
}

class ContentTypesLocalCompanion
    extends UpdateCompanion<ContentTypesLocalData> {
  final Value<String> name;
  final Value<String> displayName;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<String?> tableRef;
  final Value<int?> displayOrder;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ContentTypesLocalCompanion({
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.tableRef = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentTypesLocalCompanion.insert({
    required String name,
    required String displayName,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.tableRef = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       displayName = Value(displayName);
  static Insertable<ContentTypesLocalData> custom({
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<String>? tableRef,
    Expression<int>? displayOrder,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (tableRef != null) 'table_name': tableRef,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentTypesLocalCompanion copyWith({
    Value<String>? name,
    Value<String>? displayName,
    Value<String?>? description,
    Value<String?>? icon,
    Value<String?>? color,
    Value<String?>? tableRef,
    Value<int?>? displayOrder,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ContentTypesLocalCompanion(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      tableRef: tableRef ?? this.tableRef,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (tableRef.present) {
      map['table_name'] = Variable<String>(tableRef.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentTypesLocalCompanion(')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('tableRef: $tableRef, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuruPhotosLocalTable extends GuruPhotosLocal
    with TableInfo<$GuruPhotosLocalTable, GuruPhotosLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuruPhotosLocalTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
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
    defaultValue: const Constant('published'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    imageUrl,
    status,
    isDeleted,
    displayOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guru_photos_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<GuruPhotosLocalData> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuruPhotosLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuruPhotosLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GuruPhotosLocalTable createAlias(String alias) {
    return $GuruPhotosLocalTable(attachedDatabase, alias);
  }
}

class GuruPhotosLocalData extends DataClass
    implements Insertable<GuruPhotosLocalData> {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String status;
  final bool isDeleted;
  final int? displayOrder;
  final DateTime? createdAt;
  final DateTime updatedAt;
  const GuruPhotosLocalData({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.status,
    required this.isDeleted,
    this.displayOrder,
    this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['status'] = Variable<String>(status);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || displayOrder != null) {
      map['display_order'] = Variable<int>(displayOrder);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GuruPhotosLocalCompanion toCompanion(bool nullToAbsent) {
    return GuruPhotosLocalCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      status: Value(status),
      isDeleted: Value(isDeleted),
      displayOrder: displayOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(displayOrder),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GuruPhotosLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuruPhotosLocalData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      status: serializer.fromJson<String>(json['status']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      displayOrder: serializer.fromJson<int?>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'status': serializer.toJson<String>(status),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'displayOrder': serializer.toJson<int?>(displayOrder),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GuruPhotosLocalData copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    String? status,
    bool? isDeleted,
    Value<int?> displayOrder = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    DateTime? updatedAt,
  }) => GuruPhotosLocalData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    displayOrder: displayOrder.present ? displayOrder.value : this.displayOrder,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GuruPhotosLocalData copyWithCompanion(GuruPhotosLocalCompanion data) {
    return GuruPhotosLocalData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      status: data.status.present ? data.status.value : this.status,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuruPhotosLocalData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    imageUrl,
    status,
    isDeleted,
    displayOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuruPhotosLocalData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.status == this.status &&
          other.isDeleted == this.isDeleted &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GuruPhotosLocalCompanion extends UpdateCompanion<GuruPhotosLocalData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<String> status;
  final Value<bool> isDeleted;
  final Value<int?> displayOrder;
  final Value<DateTime?> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GuruPhotosLocalCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuruPhotosLocalCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<GuruPhotosLocalData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<String>? status,
    Expression<bool>? isDeleted,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (status != null) 'status': status,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuruPhotosLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<String>? status,
    Value<bool>? isDeleted,
    Value<int?>? displayOrder,
    Value<DateTime?>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GuruPhotosLocalCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      displayOrder: displayOrder ?? this.displayOrder,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuruPhotosLocalCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuruPhotoImagesLocalTable extends GuruPhotoImagesLocal
    with TableInfo<$GuruPhotoImagesLocalTable, GuruPhotoImagesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuruPhotoImagesLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guruPhotoIdMeta = const VerificationMeta(
    'guruPhotoId',
  );
  @override
  late final GeneratedColumn<String> guruPhotoId = GeneratedColumn<String>(
    'guru_photo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    guruPhotoId,
    imageUrl,
    displayOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guru_photo_images_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<GuruPhotoImagesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('guru_photo_id')) {
      context.handle(
        _guruPhotoIdMeta,
        guruPhotoId.isAcceptableOrUnknown(
          data['guru_photo_id']!,
          _guruPhotoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_guruPhotoIdMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuruPhotoImagesLocalData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuruPhotoImagesLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      guruPhotoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guru_photo_id'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GuruPhotoImagesLocalTable createAlias(String alias) {
    return $GuruPhotoImagesLocalTable(attachedDatabase, alias);
  }
}

class GuruPhotoImagesLocalData extends DataClass
    implements Insertable<GuruPhotoImagesLocalData> {
  final String id;
  final String guruPhotoId;
  final String imageUrl;
  final int displayOrder;
  final DateTime? createdAt;
  final DateTime updatedAt;
  const GuruPhotoImagesLocalData({
    required this.id,
    required this.guruPhotoId,
    required this.imageUrl,
    required this.displayOrder,
    this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['guru_photo_id'] = Variable<String>(guruPhotoId);
    map['image_url'] = Variable<String>(imageUrl);
    map['display_order'] = Variable<int>(displayOrder);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GuruPhotoImagesLocalCompanion toCompanion(bool nullToAbsent) {
    return GuruPhotoImagesLocalCompanion(
      id: Value(id),
      guruPhotoId: Value(guruPhotoId),
      imageUrl: Value(imageUrl),
      displayOrder: Value(displayOrder),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GuruPhotoImagesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuruPhotoImagesLocalData(
      id: serializer.fromJson<String>(json['id']),
      guruPhotoId: serializer.fromJson<String>(json['guruPhotoId']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'guruPhotoId': serializer.toJson<String>(guruPhotoId),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GuruPhotoImagesLocalData copyWith({
    String? id,
    String? guruPhotoId,
    String? imageUrl,
    int? displayOrder,
    Value<DateTime?> createdAt = const Value.absent(),
    DateTime? updatedAt,
  }) => GuruPhotoImagesLocalData(
    id: id ?? this.id,
    guruPhotoId: guruPhotoId ?? this.guruPhotoId,
    imageUrl: imageUrl ?? this.imageUrl,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GuruPhotoImagesLocalData copyWithCompanion(
    GuruPhotoImagesLocalCompanion data,
  ) {
    return GuruPhotoImagesLocalData(
      id: data.id.present ? data.id.value : this.id,
      guruPhotoId: data.guruPhotoId.present
          ? data.guruPhotoId.value
          : this.guruPhotoId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuruPhotoImagesLocalData(')
          ..write('id: $id, ')
          ..write('guruPhotoId: $guruPhotoId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    guruPhotoId,
    imageUrl,
    displayOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuruPhotoImagesLocalData &&
          other.id == this.id &&
          other.guruPhotoId == this.guruPhotoId &&
          other.imageUrl == this.imageUrl &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GuruPhotoImagesLocalCompanion
    extends UpdateCompanion<GuruPhotoImagesLocalData> {
  final Value<String> id;
  final Value<String> guruPhotoId;
  final Value<String> imageUrl;
  final Value<int> displayOrder;
  final Value<DateTime?> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GuruPhotoImagesLocalCompanion({
    this.id = const Value.absent(),
    this.guruPhotoId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuruPhotoImagesLocalCompanion.insert({
    required String id,
    required String guruPhotoId,
    required String imageUrl,
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       guruPhotoId = Value(guruPhotoId),
       imageUrl = Value(imageUrl);
  static Insertable<GuruPhotoImagesLocalData> custom({
    Expression<String>? id,
    Expression<String>? guruPhotoId,
    Expression<String>? imageUrl,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (guruPhotoId != null) 'guru_photo_id': guruPhotoId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuruPhotoImagesLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? guruPhotoId,
    Value<String>? imageUrl,
    Value<int>? displayOrder,
    Value<DateTime?>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GuruPhotoImagesLocalCompanion(
      id: id ?? this.id,
      guruPhotoId: guruPhotoId ?? this.guruPhotoId,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
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
    if (guruPhotoId.present) {
      map['guru_photo_id'] = Variable<String>(guruPhotoId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuruPhotoImagesLocalCompanion(')
          ..write('id: $id, ')
          ..write('guruPhotoId: $guruPhotoId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
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
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaData> instance, {
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
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String key;
  final String value;
  const SyncMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaData copyWith({String? key, String? value}) =>
      SyncMetaData(key: key ?? this.key, value: value ?? this.value);
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingOpsTable extends PendingOps
    with TableInfo<$PendingOpsTable, PendingOp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
    'op_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableRefMeta = const VerificationMeta(
    'tableRef',
  );
  @override
  late final GeneratedColumn<String> tableRef = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opTypeMeta = const VerificationMeta('opType');
  @override
  late final GeneratedColumn<String> opType = GeneratedColumn<String>(
    'op_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    opId,
    tableRef,
    opType,
    payloadJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_ops';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('op_id')) {
      context.handle(
        _opIdMeta,
        opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _tableRefMeta,
        tableRef.isAcceptableOrUnknown(data['table_name']!, _tableRefMeta),
      );
    } else if (isInserting) {
      context.missing(_tableRefMeta);
    }
    if (data.containsKey('op_type')) {
      context.handle(
        _opTypeMeta,
        opType.isAcceptableOrUnknown(data['op_type']!, _opTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_opTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  PendingOp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOp(
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      tableRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      opType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingOpsTable createAlias(String alias) {
    return $PendingOpsTable(attachedDatabase, alias);
  }
}

class PendingOp extends DataClass implements Insertable<PendingOp> {
  final String opId;
  final String tableRef;
  final String opType;
  final String payloadJson;
  final DateTime createdAt;
  const PendingOp({
    required this.opId,
    required this.tableRef,
    required this.opType,
    required this.payloadJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['op_id'] = Variable<String>(opId);
    map['table_name'] = Variable<String>(tableRef);
    map['op_type'] = Variable<String>(opType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingOpsCompanion toCompanion(bool nullToAbsent) {
    return PendingOpsCompanion(
      opId: Value(opId),
      tableRef: Value(tableRef),
      opType: Value(opType),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
    );
  }

  factory PendingOp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOp(
      opId: serializer.fromJson<String>(json['opId']),
      tableRef: serializer.fromJson<String>(json['tableRef']),
      opType: serializer.fromJson<String>(json['opType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opId': serializer.toJson<String>(opId),
      'tableRef': serializer.toJson<String>(tableRef),
      'opType': serializer.toJson<String>(opType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingOp copyWith({
    String? opId,
    String? tableRef,
    String? opType,
    String? payloadJson,
    DateTime? createdAt,
  }) => PendingOp(
    opId: opId ?? this.opId,
    tableRef: tableRef ?? this.tableRef,
    opType: opType ?? this.opType,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingOp copyWithCompanion(PendingOpsCompanion data) {
    return PendingOp(
      opId: data.opId.present ? data.opId.value : this.opId,
      tableRef: data.tableRef.present ? data.tableRef.value : this.tableRef,
      opType: data.opType.present ? data.opType.value : this.opType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOp(')
          ..write('opId: $opId, ')
          ..write('tableRef: $tableRef, ')
          ..write('opType: $opType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(opId, tableRef, opType, payloadJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOp &&
          other.opId == this.opId &&
          other.tableRef == this.tableRef &&
          other.opType == this.opType &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt);
}

class PendingOpsCompanion extends UpdateCompanion<PendingOp> {
  final Value<String> opId;
  final Value<String> tableRef;
  final Value<String> opType;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingOpsCompanion({
    this.opId = const Value.absent(),
    this.tableRef = const Value.absent(),
    this.opType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingOpsCompanion.insert({
    required String opId,
    required String tableRef,
    required String opType,
    required String payloadJson,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : opId = Value(opId),
       tableRef = Value(tableRef),
       opType = Value(opType),
       payloadJson = Value(payloadJson);
  static Insertable<PendingOp> custom({
    Expression<String>? opId,
    Expression<String>? tableRef,
    Expression<String>? opType,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (tableRef != null) 'table_name': tableRef,
      if (opType != null) 'op_type': opType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingOpsCompanion copyWith({
    Value<String>? opId,
    Value<String>? tableRef,
    Value<String>? opType,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingOpsCompanion(
      opId: opId ?? this.opId,
      tableRef: tableRef ?? this.tableRef,
      opType: opType ?? this.opType,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (tableRef.present) {
      map['table_name'] = Variable<String>(tableRef.value);
    }
    if (opType.present) {
      map['op_type'] = Variable<String>(opType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOpsCompanion(')
          ..write('opId: $opId, ')
          ..write('tableRef: $tableRef, ')
          ..write('opType: $opType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $KrithisLocalTable krithisLocal = $KrithisLocalTable(this);
  late final $KeerthanamsLocalTable keerthanamsLocal = $KeerthanamsLocalTable(
    this,
  );
  late final $DharmasLocalTable dharmasLocal = $DharmasLocalTable(this);
  late final $DharmaItemsLocalTable dharmaItemsLocal = $DharmaItemsLocalTable(
    this,
  );
  late final $DharmaWordsLocalTable dharmaWordsLocal = $DharmaWordsLocalTable(
    this,
  );
  late final $SavedItemsLocalTable savedItemsLocal = $SavedItemsLocalTable(
    this,
  );
  late final $ContentTypesLocalTable contentTypesLocal =
      $ContentTypesLocalTable(this);
  late final $GuruPhotosLocalTable guruPhotosLocal = $GuruPhotosLocalTable(
    this,
  );
  late final $GuruPhotoImagesLocalTable guruPhotoImagesLocal =
      $GuruPhotoImagesLocalTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final $PendingOpsTable pendingOps = $PendingOpsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    krithisLocal,
    keerthanamsLocal,
    dharmasLocal,
    dharmaItemsLocal,
    dharmaWordsLocal,
    savedItemsLocal,
    contentTypesLocal,
    guruPhotosLocal,
    guruPhotoImagesLocal,
    syncMeta,
    pendingOps,
  ];
}

typedef $$KrithisLocalTableCreateCompanionBuilder =
    KrithisLocalCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<String?> youtubeUrl,
      Value<int?> displayOrder,
      Value<String> status,
      Value<bool> isDeleted,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$KrithisLocalTableUpdateCompanionBuilder =
    KrithisLocalCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String?> youtubeUrl,
      Value<int?> displayOrder,
      Value<String> status,
      Value<bool> isDeleted,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$KrithisLocalTableFilterComposer
    extends Composer<_$AppDatabase, $KrithisLocalTable> {
  $$KrithisLocalTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KrithisLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $KrithisLocalTable> {
  $$KrithisLocalTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KrithisLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $KrithisLocalTable> {
  $$KrithisLocalTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KrithisLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KrithisLocalTable,
          KrithisLocalData,
          $$KrithisLocalTableFilterComposer,
          $$KrithisLocalTableOrderingComposer,
          $$KrithisLocalTableAnnotationComposer,
          $$KrithisLocalTableCreateCompanionBuilder,
          $$KrithisLocalTableUpdateCompanionBuilder,
          (
            KrithisLocalData,
            BaseReferences<_$AppDatabase, $KrithisLocalTable, KrithisLocalData>,
          ),
          KrithisLocalData,
          PrefetchHooks Function()
        > {
  $$KrithisLocalTableTableManager(_$AppDatabase db, $KrithisLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KrithisLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KrithisLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KrithisLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KrithisLocalCompanion(
                id: id,
                title: title,
                description: description,
                youtubeUrl: youtubeUrl,
                displayOrder: displayOrder,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KrithisLocalCompanion.insert(
                id: id,
                title: title,
                description: description,
                youtubeUrl: youtubeUrl,
                displayOrder: displayOrder,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KrithisLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KrithisLocalTable,
      KrithisLocalData,
      $$KrithisLocalTableFilterComposer,
      $$KrithisLocalTableOrderingComposer,
      $$KrithisLocalTableAnnotationComposer,
      $$KrithisLocalTableCreateCompanionBuilder,
      $$KrithisLocalTableUpdateCompanionBuilder,
      (
        KrithisLocalData,
        BaseReferences<_$AppDatabase, $KrithisLocalTable, KrithisLocalData>,
      ),
      KrithisLocalData,
      PrefetchHooks Function()
    >;
typedef $$KeerthanamsLocalTableCreateCompanionBuilder =
    KeerthanamsLocalCompanion Function({
      required String id,
      required String title,
      Value<String?> authorName,
      Value<String?> description,
      Value<String?> youtubeUrl,
      Value<int?> displayOrder,
      Value<String> status,
      Value<bool> isDeleted,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$KeerthanamsLocalTableUpdateCompanionBuilder =
    KeerthanamsLocalCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> authorName,
      Value<String?> description,
      Value<String?> youtubeUrl,
      Value<int?> displayOrder,
      Value<String> status,
      Value<bool> isDeleted,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$KeerthanamsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $KeerthanamsLocalTable> {
  $$KeerthanamsLocalTableFilterComposer({
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

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeerthanamsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $KeerthanamsLocalTable> {
  $$KeerthanamsLocalTableOrderingComposer({
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

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeerthanamsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeerthanamsLocalTable> {
  $$KeerthanamsLocalTableAnnotationComposer({
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

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get youtubeUrl => $composableBuilder(
    column: $table.youtubeUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KeerthanamsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeerthanamsLocalTable,
          KeerthanamsLocalData,
          $$KeerthanamsLocalTableFilterComposer,
          $$KeerthanamsLocalTableOrderingComposer,
          $$KeerthanamsLocalTableAnnotationComposer,
          $$KeerthanamsLocalTableCreateCompanionBuilder,
          $$KeerthanamsLocalTableUpdateCompanionBuilder,
          (
            KeerthanamsLocalData,
            BaseReferences<
              _$AppDatabase,
              $KeerthanamsLocalTable,
              KeerthanamsLocalData
            >,
          ),
          KeerthanamsLocalData,
          PrefetchHooks Function()
        > {
  $$KeerthanamsLocalTableTableManager(
    _$AppDatabase db,
    $KeerthanamsLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeerthanamsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeerthanamsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeerthanamsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> authorName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeerthanamsLocalCompanion(
                id: id,
                title: title,
                authorName: authorName,
                description: description,
                youtubeUrl: youtubeUrl,
                displayOrder: displayOrder,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> authorName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> youtubeUrl = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeerthanamsLocalCompanion.insert(
                id: id,
                title: title,
                authorName: authorName,
                description: description,
                youtubeUrl: youtubeUrl,
                displayOrder: displayOrder,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeerthanamsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeerthanamsLocalTable,
      KeerthanamsLocalData,
      $$KeerthanamsLocalTableFilterComposer,
      $$KeerthanamsLocalTableOrderingComposer,
      $$KeerthanamsLocalTableAnnotationComposer,
      $$KeerthanamsLocalTableCreateCompanionBuilder,
      $$KeerthanamsLocalTableUpdateCompanionBuilder,
      (
        KeerthanamsLocalData,
        BaseReferences<
          _$AppDatabase,
          $KeerthanamsLocalTable,
          KeerthanamsLocalData
        >,
      ),
      KeerthanamsLocalData,
      PrefetchHooks Function()
    >;
typedef $$DharmasLocalTableCreateCompanionBuilder =
    DharmasLocalCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<String?> translation,
      Value<int?> displayOrder,
      Value<String> status,
      Value<bool> isDeleted,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DharmasLocalTableUpdateCompanionBuilder =
    DharmasLocalCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String?> translation,
      Value<int?> displayOrder,
      Value<String> status,
      Value<bool> isDeleted,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DharmasLocalTableFilterComposer
    extends Composer<_$AppDatabase, $DharmasLocalTable> {
  $$DharmasLocalTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DharmasLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $DharmasLocalTable> {
  $$DharmasLocalTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DharmasLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $DharmasLocalTable> {
  $$DharmasLocalTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DharmasLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DharmasLocalTable,
          DharmasLocalData,
          $$DharmasLocalTableFilterComposer,
          $$DharmasLocalTableOrderingComposer,
          $$DharmasLocalTableAnnotationComposer,
          $$DharmasLocalTableCreateCompanionBuilder,
          $$DharmasLocalTableUpdateCompanionBuilder,
          (
            DharmasLocalData,
            BaseReferences<_$AppDatabase, $DharmasLocalTable, DharmasLocalData>,
          ),
          DharmasLocalData,
          PrefetchHooks Function()
        > {
  $$DharmasLocalTableTableManager(_$AppDatabase db, $DharmasLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DharmasLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DharmasLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DharmasLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DharmasLocalCompanion(
                id: id,
                title: title,
                description: description,
                translation: translation,
                displayOrder: displayOrder,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DharmasLocalCompanion.insert(
                id: id,
                title: title,
                description: description,
                translation: translation,
                displayOrder: displayOrder,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DharmasLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DharmasLocalTable,
      DharmasLocalData,
      $$DharmasLocalTableFilterComposer,
      $$DharmasLocalTableOrderingComposer,
      $$DharmasLocalTableAnnotationComposer,
      $$DharmasLocalTableCreateCompanionBuilder,
      $$DharmasLocalTableUpdateCompanionBuilder,
      (
        DharmasLocalData,
        BaseReferences<_$AppDatabase, $DharmasLocalTable, DharmasLocalData>,
      ),
      DharmasLocalData,
      PrefetchHooks Function()
    >;
typedef $$DharmaItemsLocalTableCreateCompanionBuilder =
    DharmaItemsLocalCompanion Function({
      required String dharmaId,
      required int itemNumber,
      required String textValue,
      Value<String?> explanation,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$DharmaItemsLocalTableUpdateCompanionBuilder =
    DharmaItemsLocalCompanion Function({
      Value<String> dharmaId,
      Value<int> itemNumber,
      Value<String> textValue,
      Value<String?> explanation,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$DharmaItemsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $DharmaItemsLocalTable> {
  $$DharmaItemsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dharmaId => $composableBuilder(
    column: $table.dharmaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemNumber => $composableBuilder(
    column: $table.itemNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DharmaItemsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $DharmaItemsLocalTable> {
  $$DharmaItemsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dharmaId => $composableBuilder(
    column: $table.dharmaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemNumber => $composableBuilder(
    column: $table.itemNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DharmaItemsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $DharmaItemsLocalTable> {
  $$DharmaItemsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dharmaId =>
      $composableBuilder(column: $table.dharmaId, builder: (column) => column);

  GeneratedColumn<int> get itemNumber => $composableBuilder(
    column: $table.itemNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textValue =>
      $composableBuilder(column: $table.textValue, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DharmaItemsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DharmaItemsLocalTable,
          DharmaItemsLocalData,
          $$DharmaItemsLocalTableFilterComposer,
          $$DharmaItemsLocalTableOrderingComposer,
          $$DharmaItemsLocalTableAnnotationComposer,
          $$DharmaItemsLocalTableCreateCompanionBuilder,
          $$DharmaItemsLocalTableUpdateCompanionBuilder,
          (
            DharmaItemsLocalData,
            BaseReferences<
              _$AppDatabase,
              $DharmaItemsLocalTable,
              DharmaItemsLocalData
            >,
          ),
          DharmaItemsLocalData,
          PrefetchHooks Function()
        > {
  $$DharmaItemsLocalTableTableManager(
    _$AppDatabase db,
    $DharmaItemsLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DharmaItemsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DharmaItemsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DharmaItemsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dharmaId = const Value.absent(),
                Value<int> itemNumber = const Value.absent(),
                Value<String> textValue = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DharmaItemsLocalCompanion(
                dharmaId: dharmaId,
                itemNumber: itemNumber,
                textValue: textValue,
                explanation: explanation,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dharmaId,
                required int itemNumber,
                required String textValue,
                Value<String?> explanation = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DharmaItemsLocalCompanion.insert(
                dharmaId: dharmaId,
                itemNumber: itemNumber,
                textValue: textValue,
                explanation: explanation,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DharmaItemsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DharmaItemsLocalTable,
      DharmaItemsLocalData,
      $$DharmaItemsLocalTableFilterComposer,
      $$DharmaItemsLocalTableOrderingComposer,
      $$DharmaItemsLocalTableAnnotationComposer,
      $$DharmaItemsLocalTableCreateCompanionBuilder,
      $$DharmaItemsLocalTableUpdateCompanionBuilder,
      (
        DharmaItemsLocalData,
        BaseReferences<
          _$AppDatabase,
          $DharmaItemsLocalTable,
          DharmaItemsLocalData
        >,
      ),
      DharmaItemsLocalData,
      PrefetchHooks Function()
    >;
typedef $$DharmaWordsLocalTableCreateCompanionBuilder =
    DharmaWordsLocalCompanion Function({
      required String dharmaId,
      required int displayOrder,
      required String word,
      required String meaning,
      Value<int> rowid,
    });
typedef $$DharmaWordsLocalTableUpdateCompanionBuilder =
    DharmaWordsLocalCompanion Function({
      Value<String> dharmaId,
      Value<int> displayOrder,
      Value<String> word,
      Value<String> meaning,
      Value<int> rowid,
    });

class $$DharmaWordsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $DharmaWordsLocalTable> {
  $$DharmaWordsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dharmaId => $composableBuilder(
    column: $table.dharmaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DharmaWordsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $DharmaWordsLocalTable> {
  $$DharmaWordsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dharmaId => $composableBuilder(
    column: $table.dharmaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DharmaWordsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $DharmaWordsLocalTable> {
  $$DharmaWordsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dharmaId =>
      $composableBuilder(column: $table.dharmaId, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);
}

class $$DharmaWordsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DharmaWordsLocalTable,
          DharmaWordsLocalData,
          $$DharmaWordsLocalTableFilterComposer,
          $$DharmaWordsLocalTableOrderingComposer,
          $$DharmaWordsLocalTableAnnotationComposer,
          $$DharmaWordsLocalTableCreateCompanionBuilder,
          $$DharmaWordsLocalTableUpdateCompanionBuilder,
          (
            DharmaWordsLocalData,
            BaseReferences<
              _$AppDatabase,
              $DharmaWordsLocalTable,
              DharmaWordsLocalData
            >,
          ),
          DharmaWordsLocalData,
          PrefetchHooks Function()
        > {
  $$DharmaWordsLocalTableTableManager(
    _$AppDatabase db,
    $DharmaWordsLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DharmaWordsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DharmaWordsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DharmaWordsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dharmaId = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DharmaWordsLocalCompanion(
                dharmaId: dharmaId,
                displayOrder: displayOrder,
                word: word,
                meaning: meaning,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dharmaId,
                required int displayOrder,
                required String word,
                required String meaning,
                Value<int> rowid = const Value.absent(),
              }) => DharmaWordsLocalCompanion.insert(
                dharmaId: dharmaId,
                displayOrder: displayOrder,
                word: word,
                meaning: meaning,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DharmaWordsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DharmaWordsLocalTable,
      DharmaWordsLocalData,
      $$DharmaWordsLocalTableFilterComposer,
      $$DharmaWordsLocalTableOrderingComposer,
      $$DharmaWordsLocalTableAnnotationComposer,
      $$DharmaWordsLocalTableCreateCompanionBuilder,
      $$DharmaWordsLocalTableUpdateCompanionBuilder,
      (
        DharmaWordsLocalData,
        BaseReferences<
          _$AppDatabase,
          $DharmaWordsLocalTable,
          DharmaWordsLocalData
        >,
      ),
      DharmaWordsLocalData,
      PrefetchHooks Function()
    >;
typedef $$SavedItemsLocalTableCreateCompanionBuilder =
    SavedItemsLocalCompanion Function({
      required String userId,
      required String contentType,
      required String contentId,
      Value<int?> position,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SavedItemsLocalTableUpdateCompanionBuilder =
    SavedItemsLocalCompanion Function({
      Value<String> userId,
      Value<String> contentType,
      Value<String> contentId,
      Value<int?> position,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SavedItemsLocalTableFilterComposer
    extends Composer<_$AppDatabase, $SavedItemsLocalTable> {
  $$SavedItemsLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedItemsLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedItemsLocalTable> {
  $$SavedItemsLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedItemsLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedItemsLocalTable> {
  $$SavedItemsLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SavedItemsLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedItemsLocalTable,
          SavedItemsLocalData,
          $$SavedItemsLocalTableFilterComposer,
          $$SavedItemsLocalTableOrderingComposer,
          $$SavedItemsLocalTableAnnotationComposer,
          $$SavedItemsLocalTableCreateCompanionBuilder,
          $$SavedItemsLocalTableUpdateCompanionBuilder,
          (
            SavedItemsLocalData,
            BaseReferences<
              _$AppDatabase,
              $SavedItemsLocalTable,
              SavedItemsLocalData
            >,
          ),
          SavedItemsLocalData,
          PrefetchHooks Function()
        > {
  $$SavedItemsLocalTableTableManager(
    _$AppDatabase db,
    $SavedItemsLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedItemsLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedItemsLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedItemsLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> contentId = const Value.absent(),
                Value<int?> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsLocalCompanion(
                userId: userId,
                contentType: contentType,
                contentId: contentId,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String contentType,
                required String contentId,
                Value<int?> position = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsLocalCompanion.insert(
                userId: userId,
                contentType: contentType,
                contentId: contentId,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedItemsLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedItemsLocalTable,
      SavedItemsLocalData,
      $$SavedItemsLocalTableFilterComposer,
      $$SavedItemsLocalTableOrderingComposer,
      $$SavedItemsLocalTableAnnotationComposer,
      $$SavedItemsLocalTableCreateCompanionBuilder,
      $$SavedItemsLocalTableUpdateCompanionBuilder,
      (
        SavedItemsLocalData,
        BaseReferences<
          _$AppDatabase,
          $SavedItemsLocalTable,
          SavedItemsLocalData
        >,
      ),
      SavedItemsLocalData,
      PrefetchHooks Function()
    >;
typedef $$ContentTypesLocalTableCreateCompanionBuilder =
    ContentTypesLocalCompanion Function({
      required String name,
      required String displayName,
      Value<String?> description,
      Value<String?> icon,
      Value<String?> color,
      Value<String?> tableRef,
      Value<int?> displayOrder,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ContentTypesLocalTableUpdateCompanionBuilder =
    ContentTypesLocalCompanion Function({
      Value<String> name,
      Value<String> displayName,
      Value<String?> description,
      Value<String?> icon,
      Value<String?> color,
      Value<String?> tableRef,
      Value<int?> displayOrder,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ContentTypesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ContentTypesLocalTable> {
  $$ContentTypesLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableRef => $composableBuilder(
    column: $table.tableRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentTypesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentTypesLocalTable> {
  $$ContentTypesLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableRef => $composableBuilder(
    column: $table.tableRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentTypesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentTypesLocalTable> {
  $$ContentTypesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get tableRef =>
      $composableBuilder(column: $table.tableRef, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContentTypesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentTypesLocalTable,
          ContentTypesLocalData,
          $$ContentTypesLocalTableFilterComposer,
          $$ContentTypesLocalTableOrderingComposer,
          $$ContentTypesLocalTableAnnotationComposer,
          $$ContentTypesLocalTableCreateCompanionBuilder,
          $$ContentTypesLocalTableUpdateCompanionBuilder,
          (
            ContentTypesLocalData,
            BaseReferences<
              _$AppDatabase,
              $ContentTypesLocalTable,
              ContentTypesLocalData
            >,
          ),
          ContentTypesLocalData,
          PrefetchHooks Function()
        > {
  $$ContentTypesLocalTableTableManager(
    _$AppDatabase db,
    $ContentTypesLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentTypesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentTypesLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentTypesLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> tableRef = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentTypesLocalCompanion(
                name: name,
                displayName: displayName,
                description: description,
                icon: icon,
                color: color,
                tableRef: tableRef,
                displayOrder: displayOrder,
                isActive: isActive,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String name,
                required String displayName,
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> tableRef = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentTypesLocalCompanion.insert(
                name: name,
                displayName: displayName,
                description: description,
                icon: icon,
                color: color,
                tableRef: tableRef,
                displayOrder: displayOrder,
                isActive: isActive,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentTypesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentTypesLocalTable,
      ContentTypesLocalData,
      $$ContentTypesLocalTableFilterComposer,
      $$ContentTypesLocalTableOrderingComposer,
      $$ContentTypesLocalTableAnnotationComposer,
      $$ContentTypesLocalTableCreateCompanionBuilder,
      $$ContentTypesLocalTableUpdateCompanionBuilder,
      (
        ContentTypesLocalData,
        BaseReferences<
          _$AppDatabase,
          $ContentTypesLocalTable,
          ContentTypesLocalData
        >,
      ),
      ContentTypesLocalData,
      PrefetchHooks Function()
    >;
typedef $$GuruPhotosLocalTableCreateCompanionBuilder =
    GuruPhotosLocalCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<String> status,
      Value<bool> isDeleted,
      Value<int?> displayOrder,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$GuruPhotosLocalTableUpdateCompanionBuilder =
    GuruPhotosLocalCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<String> status,
      Value<bool> isDeleted,
      Value<int?> displayOrder,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GuruPhotosLocalTableFilterComposer
    extends Composer<_$AppDatabase, $GuruPhotosLocalTable> {
  $$GuruPhotosLocalTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GuruPhotosLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $GuruPhotosLocalTable> {
  $$GuruPhotosLocalTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GuruPhotosLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuruPhotosLocalTable> {
  $$GuruPhotosLocalTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GuruPhotosLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GuruPhotosLocalTable,
          GuruPhotosLocalData,
          $$GuruPhotosLocalTableFilterComposer,
          $$GuruPhotosLocalTableOrderingComposer,
          $$GuruPhotosLocalTableAnnotationComposer,
          $$GuruPhotosLocalTableCreateCompanionBuilder,
          $$GuruPhotosLocalTableUpdateCompanionBuilder,
          (
            GuruPhotosLocalData,
            BaseReferences<
              _$AppDatabase,
              $GuruPhotosLocalTable,
              GuruPhotosLocalData
            >,
          ),
          GuruPhotosLocalData,
          PrefetchHooks Function()
        > {
  $$GuruPhotosLocalTableTableManager(
    _$AppDatabase db,
    $GuruPhotosLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuruPhotosLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuruPhotosLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuruPhotosLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuruPhotosLocalCompanion(
                id: id,
                title: title,
                description: description,
                imageUrl: imageUrl,
                status: status,
                isDeleted: isDeleted,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuruPhotosLocalCompanion.insert(
                id: id,
                title: title,
                description: description,
                imageUrl: imageUrl,
                status: status,
                isDeleted: isDeleted,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GuruPhotosLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GuruPhotosLocalTable,
      GuruPhotosLocalData,
      $$GuruPhotosLocalTableFilterComposer,
      $$GuruPhotosLocalTableOrderingComposer,
      $$GuruPhotosLocalTableAnnotationComposer,
      $$GuruPhotosLocalTableCreateCompanionBuilder,
      $$GuruPhotosLocalTableUpdateCompanionBuilder,
      (
        GuruPhotosLocalData,
        BaseReferences<
          _$AppDatabase,
          $GuruPhotosLocalTable,
          GuruPhotosLocalData
        >,
      ),
      GuruPhotosLocalData,
      PrefetchHooks Function()
    >;
typedef $$GuruPhotoImagesLocalTableCreateCompanionBuilder =
    GuruPhotoImagesLocalCompanion Function({
      required String id,
      required String guruPhotoId,
      required String imageUrl,
      Value<int> displayOrder,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$GuruPhotoImagesLocalTableUpdateCompanionBuilder =
    GuruPhotoImagesLocalCompanion Function({
      Value<String> id,
      Value<String> guruPhotoId,
      Value<String> imageUrl,
      Value<int> displayOrder,
      Value<DateTime?> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GuruPhotoImagesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $GuruPhotoImagesLocalTable> {
  $$GuruPhotoImagesLocalTableFilterComposer({
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

  ColumnFilters<String> get guruPhotoId => $composableBuilder(
    column: $table.guruPhotoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GuruPhotoImagesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $GuruPhotoImagesLocalTable> {
  $$GuruPhotoImagesLocalTableOrderingComposer({
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

  ColumnOrderings<String> get guruPhotoId => $composableBuilder(
    column: $table.guruPhotoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GuruPhotoImagesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuruPhotoImagesLocalTable> {
  $$GuruPhotoImagesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get guruPhotoId => $composableBuilder(
    column: $table.guruPhotoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GuruPhotoImagesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GuruPhotoImagesLocalTable,
          GuruPhotoImagesLocalData,
          $$GuruPhotoImagesLocalTableFilterComposer,
          $$GuruPhotoImagesLocalTableOrderingComposer,
          $$GuruPhotoImagesLocalTableAnnotationComposer,
          $$GuruPhotoImagesLocalTableCreateCompanionBuilder,
          $$GuruPhotoImagesLocalTableUpdateCompanionBuilder,
          (
            GuruPhotoImagesLocalData,
            BaseReferences<
              _$AppDatabase,
              $GuruPhotoImagesLocalTable,
              GuruPhotoImagesLocalData
            >,
          ),
          GuruPhotoImagesLocalData,
          PrefetchHooks Function()
        > {
  $$GuruPhotoImagesLocalTableTableManager(
    _$AppDatabase db,
    $GuruPhotoImagesLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuruPhotoImagesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuruPhotoImagesLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GuruPhotoImagesLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> guruPhotoId = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuruPhotoImagesLocalCompanion(
                id: id,
                guruPhotoId: guruPhotoId,
                imageUrl: imageUrl,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String guruPhotoId,
                required String imageUrl,
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuruPhotoImagesLocalCompanion.insert(
                id: id,
                guruPhotoId: guruPhotoId,
                imageUrl: imageUrl,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GuruPhotoImagesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GuruPhotoImagesLocalTable,
      GuruPhotoImagesLocalData,
      $$GuruPhotoImagesLocalTableFilterComposer,
      $$GuruPhotoImagesLocalTableOrderingComposer,
      $$GuruPhotoImagesLocalTableAnnotationComposer,
      $$GuruPhotoImagesLocalTableCreateCompanionBuilder,
      $$GuruPhotoImagesLocalTableUpdateCompanionBuilder,
      (
        GuruPhotoImagesLocalData,
        BaseReferences<
          _$AppDatabase,
          $GuruPhotoImagesLocalTable,
          GuruPhotoImagesLocalData
        >,
      ),
      GuruPhotoImagesLocalData,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
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

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
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

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaData,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaData,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
          ),
          SyncMetaData,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaData,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (
        SyncMetaData,
        BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
      ),
      SyncMetaData,
      PrefetchHooks Function()
    >;
typedef $$PendingOpsTableCreateCompanionBuilder =
    PendingOpsCompanion Function({
      required String opId,
      required String tableRef,
      required String opType,
      required String payloadJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PendingOpsTableUpdateCompanionBuilder =
    PendingOpsCompanion Function({
      Value<String> opId,
      Value<String> tableRef,
      Value<String> opType,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PendingOpsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingOpsTable> {
  $$PendingOpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableRef => $composableBuilder(
    column: $table.tableRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOpsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingOpsTable> {
  $$PendingOpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableRef => $composableBuilder(
    column: $table.tableRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opType => $composableBuilder(
    column: $table.opType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingOpsTable> {
  $$PendingOpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<String> get tableRef =>
      $composableBuilder(column: $table.tableRef, builder: (column) => column);

  GeneratedColumn<String> get opType =>
      $composableBuilder(column: $table.opType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingOpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingOpsTable,
          PendingOp,
          $$PendingOpsTableFilterComposer,
          $$PendingOpsTableOrderingComposer,
          $$PendingOpsTableAnnotationComposer,
          $$PendingOpsTableCreateCompanionBuilder,
          $$PendingOpsTableUpdateCompanionBuilder,
          (
            PendingOp,
            BaseReferences<_$AppDatabase, $PendingOpsTable, PendingOp>,
          ),
          PendingOp,
          PrefetchHooks Function()
        > {
  $$PendingOpsTableTableManager(_$AppDatabase db, $PendingOpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opId = const Value.absent(),
                Value<String> tableRef = const Value.absent(),
                Value<String> opType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOpsCompanion(
                opId: opId,
                tableRef: tableRef,
                opType: opType,
                payloadJson: payloadJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opId,
                required String tableRef,
                required String opType,
                required String payloadJson,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOpsCompanion.insert(
                opId: opId,
                tableRef: tableRef,
                opType: opType,
                payloadJson: payloadJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingOpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingOpsTable,
      PendingOp,
      $$PendingOpsTableFilterComposer,
      $$PendingOpsTableOrderingComposer,
      $$PendingOpsTableAnnotationComposer,
      $$PendingOpsTableCreateCompanionBuilder,
      $$PendingOpsTableUpdateCompanionBuilder,
      (PendingOp, BaseReferences<_$AppDatabase, $PendingOpsTable, PendingOp>),
      PendingOp,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$KrithisLocalTableTableManager get krithisLocal =>
      $$KrithisLocalTableTableManager(_db, _db.krithisLocal);
  $$KeerthanamsLocalTableTableManager get keerthanamsLocal =>
      $$KeerthanamsLocalTableTableManager(_db, _db.keerthanamsLocal);
  $$DharmasLocalTableTableManager get dharmasLocal =>
      $$DharmasLocalTableTableManager(_db, _db.dharmasLocal);
  $$DharmaItemsLocalTableTableManager get dharmaItemsLocal =>
      $$DharmaItemsLocalTableTableManager(_db, _db.dharmaItemsLocal);
  $$DharmaWordsLocalTableTableManager get dharmaWordsLocal =>
      $$DharmaWordsLocalTableTableManager(_db, _db.dharmaWordsLocal);
  $$SavedItemsLocalTableTableManager get savedItemsLocal =>
      $$SavedItemsLocalTableTableManager(_db, _db.savedItemsLocal);
  $$ContentTypesLocalTableTableManager get contentTypesLocal =>
      $$ContentTypesLocalTableTableManager(_db, _db.contentTypesLocal);
  $$GuruPhotosLocalTableTableManager get guruPhotosLocal =>
      $$GuruPhotosLocalTableTableManager(_db, _db.guruPhotosLocal);
  $$GuruPhotoImagesLocalTableTableManager get guruPhotoImagesLocal =>
      $$GuruPhotoImagesLocalTableTableManager(_db, _db.guruPhotoImagesLocal);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
  $$PendingOpsTableTableManager get pendingOps =>
      $$PendingOpsTableTableManager(_db, _db.pendingOps);
}
