import 'package:flutter/material.dart';

import 'models.dart';

/// Sample data for the UI build. Replace with repository/API calls when the
/// backend is ready — every screen reads from here only.
abstract final class Facilities {
  static const Facility wifi = Facility('Wi-Fi', Icons.wifi_rounded);
  static const Facility meals = Facility('Meals', Icons.restaurant_rounded);
  static const Facility laundry = Facility('Laundry', Icons.local_laundry_service_outlined);
  static const Facility ups = Facility('UPS', Icons.bolt_rounded);
  static const Facility ac = Facility('AC', Icons.ac_unit_rounded);
  static const Facility cctv = Facility('CCTV', Icons.videocam_outlined);
  static const Facility study = Facility('Study room', Icons.menu_book_rounded);

  static const List<Facility> all = <Facility>[wifi, meals, laundry, ac, ups, cctv, study];
}

abstract final class MockData {
  static const String studentName = 'Ahmed Raza';
  static const String studentFirstName = 'Ahmed';
  static const String studentProgram = 'BS Computer Science · IUB';
  static const String campus = 'IUB, Baghdad Campus';
  static const String ownerName = 'Rashid Mehmood';
  static const String ownerFirstName = 'Rashid';

  static const List<RoomType> _alNoorRooms = <RoomType>[
    RoomType(
      name: 'Single room', features: 'Attached bath · AC · Study table',
      rent: 18000, freeBeds: 2, totalBeds: 4,
    ),
    RoomType(
      name: '2-seater', features: 'Shared bath · Fan · Cupboard each',
      rent: 12000, freeBeds: 5, totalBeds: 10,
    ),
    RoomType(
      name: '3-seater', features: 'Shared bath · Fan · Cupboard each',
      rent: 9500, freeBeds: 0, totalBeds: 9,
    ),
    RoomType(
      name: 'Dorm (6 beds)', features: 'Common bath · Lockers',
      rent: 7000, freeBeds: 3, totalBeds: 12,
    ),
  ];

  static const Hostel alNoor = Hostel(
    id: 'al-noor',
    name: 'Al-Noor Boys Hostel',
    type: HostelType.boys,
    area: 'Model Town A',
    address: 'Street 4, Model Town A, Bahawalpur',
    distanceKm: 0.8,
    rating: 4.6,
    reviewCount: 128,
    facilities: <Facility>[Facilities.wifi, Facilities.meals, Facilities.laundry, Facilities.ups],
    meals: 3,
    curfew: '10:30 PM',
    deposit: 10000,
    rooms: _alNoorRooms,
    owner: 'Rashid Mehmood',
    phone: '0300 1234567',
    ac: true,
    views: 1248,
    contacts: 228,
    mapPosition: Offset(0.62, 0.44),
  );

  static const Hostel iqra = Hostel(
    id: 'iqra',
    name: 'Iqra Girls Hostel',
    type: HostelType.girls,
    area: 'Satellite Town',
    address: 'Block C, Satellite Town, Bahawalpur',
    distanceKm: 1.2,
    rating: 4.6,
    reviewCount: 92,
    facilities: <Facility>[Facilities.wifi, Facilities.meals, Facilities.cctv, Facilities.ups],
    meals: 3,
    curfew: '9:00 PM',
    deposit: 8000,
    rooms: <RoomType>[
      RoomType(name: '2-seater', features: 'Shared bath · Fan', rent: 10500, freeBeds: 4, totalBeds: 12),
      RoomType(name: '3-seater', features: 'Shared bath · Fan', rent: 8500, freeBeds: 2, totalBeds: 9),
    ],
    owner: 'Nadia Bibi',
    phone: '0301 5558899',
    mapPosition: Offset(0.36, 0.72),
  );

  static const Hostel cholistan = Hostel(
    id: 'cholistan',
    name: 'Cholistan Residency',
    type: HostelType.boys,
    area: 'Satellite Town',
    address: 'Main Boulevard, Satellite Town, Bahawalpur',
    distanceKm: 1.9,
    rating: 4.8,
    reviewCount: 64,
    facilities: <Facility>[Facilities.wifi, Facilities.meals, Facilities.study],
    meals: 2,
    curfew: '11:00 PM',
    deposit: 8000,
    rooms: <RoomType>[
      RoomType(name: '2-seater', features: 'Shared bath · Fan', rent: 9500, freeBeds: 6, totalBeds: 14),
      RoomType(name: '3-seater', features: 'Shared bath · Fan', rent: 8000, freeBeds: 3, totalBeds: 12),
    ],
    owner: 'Imran Ali',
    phone: '0302 7766554',
    mapPosition: Offset(0.16, 0.22),
  );

  static const Hostel modelTown = Hostel(
    id: 'model-town',
    name: 'Model Town Boys Hostel',
    type: HostelType.boys,
    area: 'Model Town B',
    address: 'Street 11, Model Town B, Bahawalpur',
    distanceKm: 2.4,
    rating: 4.3,
    reviewCount: 41,
    facilities: <Facility>[Facilities.wifi, Facilities.laundry],
    meals: 2,
    curfew: '10:00 PM',
    deposit: 6000,
    rooms: <RoomType>[
      RoomType(name: '3-seater', features: 'Shared bath · Fan', rent: 8000, freeBeds: 4, totalBeds: 12),
      RoomType(name: 'Single room', features: 'Shared bath · Fan', rent: 13000, freeBeds: 0, totalBeds: 3),
    ],
    owner: 'Tariq Javed',
    phone: '0333 1122334',
    mapPosition: Offset(0.14, 0.58),
  );

  static const Hostel greenValley = Hostel(
    id: 'green-valley',
    name: 'Green Valley Hostel',
    type: HostelType.boys,
    area: 'Baghdad Road',
    address: 'Near Baghdad Road, Bahawalpur',
    distanceKm: 3.1,
    rating: 4.1,
    reviewCount: 27,
    facilities: <Facility>[Facilities.wifi, Facilities.ups],
    meals: 2,
    curfew: '10:30 PM',
    deposit: 5000,
    rooms: <RoomType>[
      RoomType(name: 'Dorm (6 beds)', features: 'Common bath · Lockers', rent: 7500, freeBeds: 5, totalBeds: 18),
    ],
    owner: 'Asif Nawaz',
    phone: '0345 9988776',
    mapPosition: Offset(0.80, 0.68),
  );

  static const Hostel rohi = Hostel(
    id: 'rohi',
    name: 'Rohi Boys Hostel',
    type: HostelType.boys,
    area: 'Baghdad Road',
    address: 'Baghdad Road, Bahawalpur',
    distanceKm: 2.9,
    rating: 4.0,
    reviewCount: 12,
    facilities: <Facility>[Facilities.wifi, Facilities.meals],
    meals: 3,
    curfew: '10:00 PM',
    deposit: 6000,
    rooms: <RoomType>[
      RoomType(name: '2-seater', features: 'Shared bath · Fan', rent: 15000, freeBeds: 4, totalBeds: 8),
    ],
    owner: 'Faisal Rohi',
    phone: '0311 4455667',
    mapPosition: Offset(0.82, 0.18),
  );

  static const Hostel alNoorAnnex = Hostel(
    id: 'al-noor-annex',
    name: 'Al-Noor Annex',
    type: HostelType.boys,
    area: 'Model Town A',
    address: 'Street 6, Model Town A, Bahawalpur',
    distanceKm: 0.9,
    rating: 0,
    reviewCount: 0,
    facilities: <Facility>[Facilities.wifi, Facilities.meals],
    meals: 3,
    curfew: '10:30 PM',
    deposit: 10000,
    rooms: <RoomType>[
      RoomType(name: '2-seater', features: 'Shared bath · Fan', rent: 11000, freeBeds: 8, totalBeds: 8),
    ],
    owner: 'Rashid Mehmood',
    phone: '0300 1234567',
    verified: false,
    status: ListingStatus.pending,
  );

  static const List<Hostel> hostels = <Hostel>[
    alNoor, iqra, cholistan, modelTown, greenValley, rohi,
  ];

  static const List<Hostel> savedHostels = <Hostel>[alNoor, cholistan, modelTown, greenValley];

  static const List<Review> reviews = <Review>[
    Review(
      author: 'Hamza R.',
      stayed: 'Stayed 8 months',
      ago: '2 weeks ago',
      rating: 5,
      text: 'Clean rooms and the warden is helpful. Food is good on most days. '
          'Wi-Fi gets slow at night.',
      ownerReply: 'Thanks Hamza. We upgraded the internet package this month.',
    ),
    Review(
      author: 'Usman A.',
      stayed: 'Stayed 1 year',
      ago: '1 month ago',
      rating: 4,
      text: 'Walking distance to campus and very safe. Rent is fair for what you get.',
    ),
    Review(
      author: 'Saad A.',
      stayed: 'Stayed 3 months',
      ago: '3 days ago',
      rating: 3,
      text: 'Rooms are good but hot water is not available in the morning.',
    ),
  ];

  static const Map<String, double> reviewBreakdown = <String, double>{
    'Cleanliness': 4.7, 'Safety': 4.8, 'Food': 4.2, 'Wi-Fi': 4.0,
  };

  /// Share of reviews for 5★ → 1★.
  static const List<double> ratingDistribution = <double>[0.72, 0.18, 0.06, 0.03, 0.01];

  static const List<VisitRequest> studentRequests = <VisitRequest>[
    VisitRequest(
      hostelName: 'Al-Noor Boys Hostel', studentName: studentName, program: studentProgram,
      room: '2-seater room', when: 'Sat 16 Nov, 4:00 PM', status: RequestStatus.accepted,
      note: 'Owner confirmed your visit. Bring your student card.',
    ),
    VisitRequest(
      hostelName: 'Cholistan Residency', studentName: studentName, program: studentProgram,
      room: '3-seater room', when: 'Sun 17 Nov, 11:00 AM', status: RequestStatus.pending,
      note: 'Owner usually replies within 2 hours.',
    ),
    VisitRequest(
      hostelName: 'Model Town Boys Hostel', studentName: studentName, program: studentProgram,
      room: 'Single room', when: 'Fri 15 Nov', status: RequestStatus.declined,
      note: 'Room is no longer available.',
    ),
  ];

  static const List<VisitRequest> ownerRequests = <VisitRequest>[
    VisitRequest(
      hostelName: 'Al-Noor Boys Hostel', studentName: 'Ahmed Raza',
      program: 'BS Computer Science · IUB', room: '2-seater', when: 'Sat 16 Nov, 4 PM',
      status: RequestStatus.pending,
      message: 'Is the room available from December? I\'d like to visit with my father.',
    ),
    VisitRequest(
      hostelName: 'Al-Noor Boys Hostel', studentName: 'Bilal Khan',
      program: 'BBA · IUB Abbasia Campus', room: 'Single room', when: 'Sun 17 Nov, 11 AM',
      status: RequestStatus.pending,
      message: 'Do you allow cooking in the room?',
    ),
    VisitRequest(
      hostelName: 'Al-Noor Boys Hostel', studentName: 'Usman Ali',
      program: 'BS Physics · IUB', room: 'Dorm (6 beds)', when: 'Thu 14 Nov, 5 PM',
      status: RequestStatus.accepted,
      message: 'Can I see the dorm lockers?',
    ),
    VisitRequest(
      hostelName: 'Al-Noor Boys Hostel', studentName: 'Kamran Zafar',
      program: 'MBBS · QAMC', room: '3-seater', when: 'Mon 4 Nov, 3 PM',
      status: RequestStatus.declined,
      message: 'Looking for a room for next semester.',
    ),
  ];

  static const List<AppUser> students = <AppUser>[
    AppUser(name: 'Ahmed Raza', phone: '0300 ••• 4567', institute: 'IUB'),
    AppUser(name: 'Hamza Rauf', phone: '0301 ••• 8812', institute: 'IUB'),
    AppUser(name: 'Saad Ahmed', phone: '0333 ••• 2290', institute: 'QAMC'),
    AppUser(name: 'Kamran Z.', phone: '0345 ••• 1173', institute: 'IUB', blocked: true),
    AppUser(name: 'Usman Ali', phone: '0302 ••• 6655', institute: 'IUB'),
    AppUser(name: 'Bilal Khan', phone: '0311 ••• 3409', institute: 'IUB'),
  ];

  static const List<AppUser> owners = <AppUser>[
    AppUser(name: 'Rashid Mehmood', phone: '0300 ••• 4567', institute: '2 hostels'),
    AppUser(name: 'Nadia Bibi', phone: '0301 ••• 5558', institute: '1 hostel'),
    AppUser(name: 'Imran Ali', phone: '0302 ••• 7766', institute: '1 hostel'),
    AppUser(name: 'Tariq Javed', phone: '0333 ••• 1122', institute: '1 hostel'),
    AppUser(name: 'Asif Nawaz', phone: '0345 ••• 9988', institute: '1 hostel', blocked: true),
  ];

  static const List<ListingReport> reports = <ListingReport>[
    ListingReport(
      kind: 'Fake listing', subject: 'Green View Hostel', reporter: '3 students · today',
      detail: 'Photos are copied from another hostel and the phone number is switched off.',
      severity: ReportSeverity.high,
    ),
    ListingReport(
      kind: 'Abusive review', subject: 'Review on Iqra Girls Hostel', reporter: 'Owner · yesterday',
      detail: 'Review contains personal insults about the warden.',
      severity: ReportSeverity.medium,
    ),
    ListingReport(
      kind: 'Wrong price', subject: 'Rohi Boys Hostel', reporter: '1 student · 2 days ago',
      detail: 'Listed rent is Rs 8,000 but owner asked for Rs 11,000.',
      severity: ReportSeverity.low,
    ),
  ];

  static const List<String> cities = <String>['Bahawalpur', 'Multan', 'Lahore'];

  static const List<University> universities = <University>[
    University('IUB, Baghdad-ul-Jadeed Campus', 86),
    University('IUB, Abbasia Campus', 34),
    University('Quaid-e-Azam Medical College', 22),
    University('Govt. Sadiq College Women University', 41),
  ];

  static const List<String> universityOptions = <String>[
    'Islamia University of Bahawalpur',
    'Quaid-e-Azam Medical College',
    'Govt. Sadiq College Women University',
    'NCBA&E Bahawalpur',
  ];

  static const List<int> ownerWeeklyViews = <int>[120, 145, 160, 210, 175, 260, 178];
  static const List<int> adminWeeklySignups = <int>[14, 19, 16, 24, 21, 34, 12];
}
