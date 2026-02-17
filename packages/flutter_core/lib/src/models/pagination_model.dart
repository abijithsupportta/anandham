/// Holds pagination metadata returned by list endpoints.
class PaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  /// Whether more pages are available.
  bool get hasNextPage => currentPage < lastPage;

  /// Whether a previous page exists.
  bool get hasPreviousPage => currentPage > 1;

  /// The next page number, or `null` if already on the last page.
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }

  @override
  String toString() =>
      'PaginationModel(page: $currentPage/$lastPage, total: $total)';
}

/// A paginated list wrapping items of type [T] together with pagination meta.
class PaginatedList<T> {
  final List<T> items;
  final PaginationModel pagination;

  const PaginatedList({required this.items, required this.pagination});

  bool get hasNextPage => pagination.hasNextPage;
  bool get isEmpty => items.isEmpty;
  int get length => items.length;

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawItems = json['data'] as List<dynamic>? ?? [];
    return PaginatedList<T>(
      items: rawItems.map((e) => fromJsonT(e)).toList(),
      pagination: PaginationModel.fromJson(
        json['meta'] as Map<String, dynamic>? ?? json,
      ),
    );
  }
}
