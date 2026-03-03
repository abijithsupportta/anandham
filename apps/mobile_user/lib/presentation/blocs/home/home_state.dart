import 'package:equatable/equatable.dart';

class HomeContentTypeItem extends Equatable {
  final String name;
  final String displayName;
  final String description;
  final String icon;
  final String? colorHex;

  const HomeContentTypeItem({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.colorHex,
  });

  factory HomeContentTypeItem.fromMap(Map<String, dynamic> map) {
    return HomeContentTypeItem(
      name: map['name'] as String? ?? '',
      displayName: map['display_name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      icon: map['icon'] as String? ?? '📚',
      colorHex: map['color'] as String?,
    );
  }

  String get localizedTitle {
    switch (name) {
      case 'guru_krithis':
        return 'ഗുരുദേവകൃതികൾ';
      case 'guru_dharmas':
        return 'ശ്രീനാരായണ ധർമ്മം';
      case 'guru_keerthanams':
        return 'ഗുരുദേവകീർത്തനം';
      case 'guru_stories':
        return 'ഗുരു കഥകൾ';
      case 'guru_photos':
        return 'ചിത്രങ്ങൾ';
      case 'sponsors':
        return 'സ്പോൺസേഴ്സ്';
      default:
        return displayName;
    }
  }

  String get localizedDescription {
    switch (name) {
      case 'sponsors':
        return 'Sponsor profiles with sponsored amount ranking';
      default:
        return description;
    }
  }

  int get displayOrder {
    switch (name) {
      case 'guru_krithis':
        return 1;
      case 'guru_dharmas':
        return 2;
      case 'guru_keerthanams':
        return 3;
      case 'guru_stories':
        return 4;
      case 'guru_photos':
        return 5;
      case 'sponsors':
        return 6;
      default:
        return 50;
    }
  }

  String get displayIcon {
    if (name == 'guru_krithis') {
      return '📚';
    }
    return icon;
  }

  @override
  List<Object?> get props => [name, displayName, description, icon, colorHex];
}

class HomeState extends Equatable {
  final bool isLoading;
  final List<HomeContentTypeItem> contentTypes;
  final String? profileName;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    required this.contentTypes,
    required this.profileName,
    required this.errorMessage,
  });

  const HomeState.initial()
    : isLoading = false,
      contentTypes = const [],
      profileName = null,
      errorMessage = null;

  HomeState copyWith({
    bool? isLoading,
    List<HomeContentTypeItem>? contentTypes,
    String? profileName,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      contentTypes: contentTypes ?? this.contentTypes,
      profileName: profileName ?? this.profileName,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    contentTypes,
    profileName,
    errorMessage,
  ];
}
