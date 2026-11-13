import 'package:flutter/material.dart';

enum HostelType { boys, girls }

extension HostelTypeX on HostelType {
  String get label => this == HostelType.boys ? 'Boys' : 'Girls';
}

enum ListingStatus { live, pending, suspended }

enum RequestStatus { pending, accepted, declined }

class Facility {
  const Facility(this.label, this.icon);
  final String label;
  final IconData icon;
}

class RoomType {
  const RoomType({
    required this.name,
    required this.features,
    required this.rent,
    required this.freeBeds,
    required this.totalBeds,
    this.accepting = true,
  });

  final String name;
  final String features;
  final int rent;
  final int freeBeds;
  final int totalBeds;
  final bool accepting;

  bool get isFull => freeBeds == 0;
}

class Review {
  const Review({
    required this.author,
    required this.stayed,
    required this.ago,
    required this.rating,
    required this.text,
    this.ownerReply,
  });

  final String author;
  final String stayed;
  final String ago;
  final int rating;
  final String text;
  final String? ownerReply;
}

class Hostel {
  const Hostel({
    required this.id,
    required this.name,
    required this.type,
    required this.area,
    required this.address,
    required this.distanceKm,
    required this.rating,
    required this.reviewCount,
    required this.facilities,
    required this.meals,
    required this.curfew,
    required this.deposit,
    required this.rooms,
    required this.owner,
    required this.phone,
    this.verified = true,
    this.ac = false,
    this.status = ListingStatus.live,
    this.photoCount = 8,
    this.views = 0,
    this.contacts = 0,
    this.mapPosition = const Offset(0.5, 0.5),
  });

  final String id;
  final String name;
  final HostelType type;
  final String area;
  final String address;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final List<Facility> facilities;
  final int meals;
  final String curfew;
  final int deposit;
  final List<RoomType> rooms;
  final String owner;
  final String phone;
  final bool verified;
  final bool ac;
  final ListingStatus status;
  final int photoCount;
  final int views;
  final int contacts;

  /// Relative position (0–1) on the illustrative map.
  final Offset mapPosition;

  int get startingRent =>
      rooms.map((RoomType r) => r.rent).reduce((int a, int b) => a < b ? a : b);

  int get freeBeds => rooms.fold(0, (int sum, RoomType r) => sum + r.freeBeds);

  int rentFor(String roomName) => rooms
      .firstWhere((RoomType r) => r.name == roomName, orElse: () => rooms.first)
      .rent;
}

class VisitRequest {
  const VisitRequest({
    required this.hostelName,
    required this.studentName,
    required this.program,
    required this.room,
    required this.when,
    required this.status,
    this.message,
    this.note,
  });

  final String hostelName;
  final String studentName;
  final String program;
  final String room;
  final String when;
  final RequestStatus status;
  final String? message;
  final String? note;
}

class AppUser {
  const AppUser({
    required this.name,
    required this.phone,
    required this.institute,
    this.blocked = false,
  });

  final String name;
  final String phone;
  final String institute;
  final bool blocked;
}

class ListingReport {
  const ListingReport({
    required this.kind,
    required this.subject,
    required this.reporter,
    required this.detail,
    required this.severity,
  });

  final String kind;
  final String subject;
  final String reporter;
  final String detail;
  final ReportSeverity severity;
}

enum ReportSeverity { high, medium, low }

class University {
  const University(this.name, this.hostelsNearby);
  final String name;
  final int hostelsNearby;
}
