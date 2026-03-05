import '../models/listing_model.dart';
import '../models/category.dart';

/// Mock listings data for demo mode
List<ListingModel> getMockListings() {
  return [
    ListingModel(
      id: '1',
      name: 'Kigali City Hospital',
      category: Category.hospital,
      address: 'KN 4 Ave, Nyarugenge, Kigali',
      contactNumber: '+250 788 123 456',
      description:
          'Main public hospital providing comprehensive healthcare services to Kigali residents.',
      latitude: -1.9536,
      longitude: 30.0606,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ListingModel(
      id: '2',
      name: 'Kicukiro Police Station',
      category: Category.policeStation,
      address: 'KK 15 Rd, Kicukiro, Kigali',
      contactNumber: '+250 788 234 567',
      description:
          'Local police station serving the Kicukiro district with 24/7 emergency response.',
      latitude: -1.9707,
      longitude: 30.1041,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ListingModel(
      id: '3',
      name: 'Kigali Public Library',
      category: Category.library,
      address: 'KN 3 Ave, Gasabo, Kigali',
      contactNumber: '+250 788 345 678',
      description:
          'Public library with extensive collection of books, study spaces, and digital resources.',
      latitude: -1.9441,
      longitude: 30.0619,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ListingModel(
      id: '4',
      name: 'Heaven Restaurant',
      category: Category.restaurant,
      address: 'KG 7 Ave, Kigali',
      contactNumber: '+250 788 456 789',
      description:
          'Fine dining restaurant offering international and local Rwandan cuisine with panoramic city views.',
      latitude: -1.9550,
      longitude: 30.0950,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ListingModel(
      id: '5',
      name: 'Question Coffee',
      category: Category.cafe,
      address: 'KN 78 St, Kimihurura, Kigali',
      contactNumber: '+250 788 567 890',
      description:
          'Cozy cafe serving specialty Rwandan coffee and light meals in a relaxed atmosphere.',
      latitude: -1.9419,
      longitude: 30.0944,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ListingModel(
      id: '6',
      name: 'Kigali Genocide Memorial',
      category: Category.touristAttraction,
      address: 'KG 14 Ave, Gisozi, Kigali',
      contactNumber: '+250 788 678 901',
      description:
          'Memorial site and museum commemorating the 1994 genocide. A place of remembrance and education.',
      latitude: -1.9411,
      longitude: 30.0714,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    ListingModel(
      id: '7',
      name: 'King Faisal Hospital',
      category: Category.hospital,
      address: 'KN 2 Ave, Kacyiru, Kigali',
      contactNumber: '+250 788 789 012',
      description:
          'Leading private hospital providing specialized medical care and state-of-the-art facilities.',
      latitude: -1.9462,
      longitude: 30.0875,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    ListingModel(
      id: '8',
      name: 'Nyamirambo Utility Office',
      category: Category.utilityOffice,
      address: 'Nyamirambo, Kigali',
      contactNumber: '+250 788 890 123',
      description:
          'District utility office for water, electricity, and other municipal services.',
      latitude: -1.9667,
      longitude: 30.0444,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ListingModel(
      id: '9',
      name: 'Rebero Park',
      category: Category.park,
      address: 'Rebero, Kigali',
      contactNumber: '+250 788 901 234',
      description:
          'Beautiful urban park offering walking trails, picnic areas, and stunning views of Kigali.',
      latitude: -1.9278,
      longitude: 30.0853,
      createdBy: 'demo-user',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ListingModel(
      id: '10',
      name: 'Inema Arts Center',
      category: Category.touristAttraction,
      address: 'KG 563 St, Kacyiru, Kigali',
      contactNumber: '+250 788 012 345',
      description:
          'Contemporary art gallery and cultural center showcasing Rwandan and African artists.',
      latitude: -1.9386,
      longitude: 30.1067,
      createdBy: 'admin-user',
      timestamp: DateTime.now(),
    ),
  ];
}
