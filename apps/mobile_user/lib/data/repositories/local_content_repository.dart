import 'package:anandham_user/data/local/db/app_database.dart';
import 'package:anandham_user/presentation/blocs/dharmas/dharmas_state.dart';
import 'package:drift/drift.dart';

class LocalContentRepository {
  final AppDatabase _db;

  LocalContentRepository(this._db);

  Future<List<Map<String, dynamic>>> getKrithis() async {
    final query = _db.select(_db.krithisLocal)
      ..where((table) => table.status.equals('published'))
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) => OrderingTerm(
          expression: table.displayOrder,
          mode: OrderingMode.asc,
          nulls: NullsOrder.last,
        ),
        (table) => OrderingTerm.desc(table.createdAt),
      ]);

    final rows = await query.get();

    return rows
        .map(
          (row) => <String, dynamic>{
            'id': row.id,
            'title': row.title,
            'description': row.description ?? '',
            'youtube_url': row.youtubeUrl,
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> getKrithisByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return const [];
    }

    final query = _db.select(_db.krithisLocal)
      ..where((table) => table.id.isIn(ids))
      ..where((table) => table.status.equals('published'))
      ..where((table) => table.isDeleted.equals(false));

    final rows = await query.get();
    final byId = {
      for (final row in rows)
        row.id: <String, dynamic>{
          'id': row.id,
          'title': row.title,
          'description': row.description ?? '',
          'youtube_url': row.youtubeUrl,
        },
    };

    return ids.map((id) => byId[id]).whereType<Map<String, dynamic>>().toList();
  }

  Future<List<Map<String, dynamic>>> getKeerthanamsByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) {
      return const [];
    }

    final query = _db.select(_db.keerthanamsLocal)
      ..where((table) => table.id.isIn(ids))
      ..where((table) => table.status.equals('published'))
      ..where((table) => table.isDeleted.equals(false));

    final rows = await query.get();
    final byId = {
      for (final row in rows)
        row.id: <String, dynamic>{
          'id': row.id,
          'title': row.title,
          'author_name': row.authorName ?? '',
          'description': row.description ?? '',
          'youtube_url': row.youtubeUrl,
        },
    };

    return ids.map((id) => byId[id]).whereType<Map<String, dynamic>>().toList();
  }

  Future<List<Map<String, dynamic>>> getKeerthanams() async {
    final query = _db.select(_db.keerthanamsLocal)
      ..where((table) => table.status.equals('published'))
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) => OrderingTerm(
          expression: table.displayOrder,
          mode: OrderingMode.asc,
          nulls: NullsOrder.last,
        ),
        (table) => OrderingTerm.desc(table.createdAt),
      ]);

    final rows = await query.get();
    return rows
        .map(
          (row) => <String, dynamic>{
            'id': row.id,
            'title': row.title,
            'author_name': row.authorName ?? '',
            'description': row.description ?? '',
            'youtube_url': row.youtubeUrl,
          },
        )
        .toList();
  }

  Future<List<DharmaItemView>> getDharmas() async {
    final dharmaQuery = _db.select(_db.dharmasLocal)
      ..where((table) => table.status.equals('published'))
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) => OrderingTerm(
          expression: table.displayOrder,
          mode: OrderingMode.asc,
          nulls: NullsOrder.last,
        ),
        (table) => OrderingTerm.desc(table.createdAt),
      ]);

    final dharmaRows = await dharmaQuery.get();
    if (dharmaRows.isEmpty) {
      return const [];
    }

    final dharmaIds = dharmaRows.map((row) => row.id).toList();

    final slokaQuery = _db.select(_db.dharmaItemsLocal)
      ..where((table) => table.dharmaId.isIn(dharmaIds))
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([(table) => OrderingTerm.asc(table.itemNumber)]);

    final wordQuery = _db.select(_db.dharmaWordsLocal)
      ..where((table) => table.dharmaId.isIn(dharmaIds))
      ..orderBy([(table) => OrderingTerm.asc(table.displayOrder)]);

    final slokaRows = await slokaQuery.get();
    final wordRows = await wordQuery.get();

    final slokaMap = <String, List<DharmaSloka>>{};
    for (final row in slokaRows) {
      slokaMap
          .putIfAbsent(row.dharmaId, () => [])
          .add(
            DharmaSloka(
              itemNumber: row.itemNumber,
              text: row.textValue,
              explanation: row.explanation ?? '',
            ),
          );
    }

    final wordMap = <String, List<DharmaWord>>{};
    for (final row in wordRows) {
      wordMap
          .putIfAbsent(row.dharmaId, () => [])
          .add(DharmaWord(word: row.word, meaning: row.meaning));
    }

    return dharmaRows
        .map(
          (row) => DharmaItemView(
            id: row.id,
            title: row.title,
            description: row.description ?? '',
            translation: row.translation ?? '',
            slokas: slokaMap[row.id] ?? const [],
            words: wordMap[row.id] ?? const [],
          ),
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> getHomeContentTypes() async {
    final query = _db.select(_db.contentTypesLocal)
      ..where((table) => table.isActive.equals(true))
      ..orderBy([(table) => OrderingTerm.asc(table.displayOrder)]);

    final rows = await query.get();
    return rows
        .map(
          (row) => <String, dynamic>{
            'name': row.name,
            'display_name': row.displayName,
            'description': row.description ?? '',
            'icon': row.icon ?? '📚',
            'color': row.color,
            'table_name': row.tableRef,
            'display_order': row.displayOrder,
            'is_active': row.isActive,
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> getGuruPhotos() async {
    final query = _db.select(_db.guruPhotosLocal)
      ..where((table) => table.status.equals('published'))
      ..where((table) => table.isDeleted.equals(false))
      ..orderBy([
        (table) => OrderingTerm(
          expression: table.displayOrder,
          mode: OrderingMode.asc,
          nulls: NullsOrder.last,
        ),
        (table) => OrderingTerm.desc(table.createdAt),
      ]);

    final rows = await query.get();
    final result = <Map<String, dynamic>>[];

    for (final row in rows) {
      final imageQuery = _db.select(_db.guruPhotoImagesLocal)
        ..where((table) => table.guruPhotoId.equals(row.id))
        ..orderBy([(table) => OrderingTerm.asc(table.displayOrder)]);

      final imageRows = await imageQuery.get();
      final images = imageRows.map((item) => item.imageUrl).toList();

      result.add(<String, dynamic>{
        'id': row.id,
        'title': row.title,
        'description': row.description ?? '',
        'image_url': row.imageUrl,
        'images': images,
      });
    }

    return result;
  }

  Future<List<String>> getSavedContentIds({
    required String userId,
    required String contentType,
  }) async {
    final query = _db.select(_db.savedItemsLocal)
      ..where((table) => table.userId.equals(userId))
      ..where((table) => table.contentType.equals(contentType))
      ..orderBy([
        (table) => OrderingTerm(
          expression: table.position,
          mode: OrderingMode.asc,
          nulls: NullsOrder.last,
        ),
        (table) => OrderingTerm.asc(table.createdAt),
      ]);

    final rows = await query.get();
    return rows.map((row) => row.contentId).toList();
  }

  Future<void> upsertSavedItem({
    required String userId,
    required String contentType,
    required String contentId,
    int? position,
    DateTime? createdAt,
  }) async {
    await _db
        .into(_db.savedItemsLocal)
        .insertOnConflictUpdate(
          SavedItemsLocalCompanion(
            userId: Value(userId),
            contentType: Value(contentType),
            contentId: Value(contentId),
            position: Value(position),
            createdAt: Value(createdAt ?? DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> removeSavedItem({
    required String userId,
    required String contentType,
    required String contentId,
  }) async {
    await (_db.delete(_db.savedItemsLocal)
          ..where((table) => table.userId.equals(userId))
          ..where((table) => table.contentType.equals(contentType))
          ..where((table) => table.contentId.equals(contentId)))
        .go();
  }

  Future<int?> getMaxSavedPosition({
    required String userId,
    required String contentType,
  }) async {
    final query = _db.select(_db.savedItemsLocal)
      ..where((table) => table.userId.equals(userId))
      ..where((table) => table.contentType.equals(contentType))
      ..orderBy([(table) => OrderingTerm.desc(table.position)])
      ..limit(1);

    final rows = await query.get();
    return rows.isEmpty ? null : rows.first.position;
  }

  Future<void> replaceSavedItemsForType({
    required String userId,
    required String contentType,
    required List<Map<String, dynamic>> rows,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.savedItemsLocal)
            ..where((table) => table.userId.equals(userId))
            ..where((table) => table.contentType.equals(contentType)))
          .go();

      await _db.batch((batch) {
        for (final row in rows) {
          final contentId = row['content_id'] as String?;
          if (contentId == null || contentId.isEmpty) {
            continue;
          }

          batch.insert(
            _db.savedItemsLocal,
            SavedItemsLocalCompanion.insert(
              userId: userId,
              contentType: contentType,
              contentId: contentId,
              position: Value(row['position'] as int?),
              createdAt: _toDateTime(row['created_at']) ?? DateTime.now(),
              updatedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    });
  }

  Future<void> updateSavedPosition({
    required String userId,
    required String contentType,
    required String contentId,
    required int position,
  }) async {
    await (_db.update(_db.savedItemsLocal)
          ..where((table) => table.userId.equals(userId))
          ..where((table) => table.contentType.equals(contentType))
          ..where((table) => table.contentId.equals(contentId)))
        .write(
          SavedItemsLocalCompanion(
            position: Value(position),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
