import 'package:cloud_firestore/cloud_firestore.dart';

class Referral {
  final String username;
  final String email;
  final DateTime referredOn;
  final List<Referral> subReferrals;

  Referral({
    required this.username,
    required this.email,
    required this.referredOn,
    this.subReferrals = const [],
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      username: json['username'],
      email: json['email'],
      referredOn: (json['referredOn'] as Timestamp).toDate(),
      subReferrals: (json['subReferrals'] as List<dynamic>?)
          ?.map((sub) => Referral.fromJson(sub))
          .toList() ?? [],
    );
  }
}
