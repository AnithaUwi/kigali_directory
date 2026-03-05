enum Category {
  hospital,
  policeStation,
  library,
  utilityOffice,
  restaurant,
  cafe,
  park,
  touristAttraction,
}

extension CategoryExtension on Category {
  String get displayName {
    switch (this) {
      case Category.hospital:
        return 'Hospital';
      case Category.policeStation:
        return 'Police Station';
      case Category.library:
        return 'Library';
      case Category.utilityOffice:
        return 'Utility Office';
      case Category.restaurant:
        return 'Restaurant';
      case Category.cafe:
        return 'Café';
      case Category.park:
        return 'Park';
      case Category.touristAttraction:
        return 'Tourist Attraction';
    }
  }

  String get value {
    return toString().split('.').last;
  }

  static Category fromString(String value) {
    return Category.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Category.restaurant,
    );
  }
}
