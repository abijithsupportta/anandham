import 'dart:io';

import 'package:anandham_user/core/constants/app_constants.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class KrithisLocal extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get youtubeUrl => text().nullable()();
  IntColumn get displayOrder => integer().nullable().named('display_order')();
  TextColumn get status => text().withDefault(const Constant('published'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class KeerthanamsLocal extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get authorName => text().nullable().named('author_name')();
  TextColumn get description => text().nullable()();
  TextColumn get youtubeUrl => text().nullable().named('youtube_url')();
  IntColumn get displayOrder => integer().nullable().named('display_order')();
  TextColumn get status => text().withDefault(const Constant('published'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class DharmasLocal extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get translation => text().nullable()();
  IntColumn get displayOrder => integer().nullable().named('display_order')();
  TextColumn get status => text().withDefault(const Constant('published'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class DharmaItemsLocal extends Table {
  TextColumn get dharmaId => text()();
  IntColumn get itemNumber => integer()();
  TextColumn get textValue => text().named('text')();
  TextColumn get explanation => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {dharmaId, itemNumber};
}

class DharmaWordsLocal extends Table {
  TextColumn get dharmaId => text()();
  IntColumn get displayOrder => integer()();
  TextColumn get word => text()();
  TextColumn get meaning => text()();

  @override
  Set<Column> get primaryKey => {dharmaId, displayOrder, word};
}

class SavedItemsLocal extends Table {
  TextColumn get userId => text().named('user_id')();
  TextColumn get contentType => text().named('content_type')();
  TextColumn get contentId => text().named('content_id')();
  IntColumn get position => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {userId, contentType, contentId};
}

class ContentTypesLocal extends Table {
  TextColumn get name => text()();
  TextColumn get displayName => text().named('display_name')();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get tableRef => text().nullable().named('table_name')();
  IntColumn get displayOrder => integer().nullable().named('display_order')();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true)).named('is_active')();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {name};
}

class GuruPhotosLocal extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable().named('image_url')();
  TextColumn get status => text().withDefault(const Constant('published'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get displayOrder => integer().nullable().named('display_order')();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class GuruPhotoImagesLocal extends Table {
  TextColumn get id => text()();
  TextColumn get guruPhotoId => text().named('guru_photo_id')();
  TextColumn get imageUrl => text().named('image_url')();
  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0)).named('display_order')();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class PendingOps extends Table {
  TextColumn get opId => text()();
  TextColumn get tableRef => text().named('table_name')();
  TextColumn get opType => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {opId};
}

@DriftDatabase(
  tables: [
    KrithisLocal,
    KeerthanamsLocal,
    DharmasLocal,
    DharmaItemsLocal,
    DharmaWordsLocal,
    SavedItemsLocal,
    ContentTypesLocal,
    GuruPhotosLocal,
    GuruPhotoImagesLocal,
    SyncMeta,
    PendingOps,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(syncMeta).insertOnConflictUpdate(
        SyncMetaCompanion(
          key: const Value('publication_version'),
          value: Value('${AppConstants.publicationVersion}'),
        ),
      );
    },
    onUpgrade: (m, from, to) async {
      try {
        if (from < 2) {
          await m.createTable(keerthanamsLocal);
          await m.createTable(savedItemsLocal);
          await m.createTable(contentTypesLocal);
        }
        if (from < 3) {
          await m.createTable(guruPhotosLocal);
        }
        if (from < 4) {
          await m.addColumn(krithisLocal, krithisLocal.displayOrder);
          await m.addColumn(keerthanamsLocal, keerthanamsLocal.displayOrder);
          await m.addColumn(dharmasLocal, dharmasLocal.displayOrder);
        }
        if (from < 5) {
          await m.createTable(guruPhotoImagesLocal);
        }
        if (from < 6) {
          await into(syncMeta).insertOnConflictUpdate(
            SyncMetaCompanion(
              key: const Value('publication_version'),
              value: Value('${AppConstants.publicationVersion}'),
            ),
          );
        }
      } catch (e) {
        // If migration fails, log error but don't crash app
        // ignore: avoid_print
        print(
          '[Drift Migration Error] Failed upgrading from v$from to v$to: $e',
        );
        rethrow;
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'anandham_offline.db'));
    return NativeDatabase.createInBackground(file);
  });
}
