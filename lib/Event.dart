import 'dart:ffi';

class EventDetails {
  final int claimedWalletAddress;
  final int eventId;
  final String walletAddress;
  final double latitude;
  final double longitude;
  final int timeDeadline;
  final int members;
  final String eventName;

  EventDetails({
    required this.claimedWalletAddress,
    required this.eventId,
    required this.walletAddress,
    required this.latitude,
    required this.longitude,
    required this.timeDeadline,
    required this.members,
    required this.eventName,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      claimedWalletAddress: json['claimedWalletAddress'] ?? 0,
      eventId: json['EventId'] ?? 0,
      walletAddress: json['walletaddress'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      timeDeadline: json['timedeadline'] ?? 0,
      members: json['members'] ?? 0,
      eventName: json['EventName'] ?? '',
    );
  }
}
