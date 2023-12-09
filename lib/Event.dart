class EventDetails {
  final int claimedWalletAddress;
  final int eventId;
  final String walletAddress;
  final double latitude;
  final double longitude;
  final int timeDeadline; 
  final int members;
  final String eventName;
  final double tokenValue;

  EventDetails({
    required this.claimedWalletAddress,
    required this.eventId,
    required this.walletAddress,
    required this.latitude,
    required this.longitude,
    required this.timeDeadline,
    required this.members,
    required this.eventName,
    required this.tokenValue,
  });

  // factory EventDetails.fromJson(Map<String, dynamic> json) {
  //   return EventDetails(
  //     claimedWalletAddress: json['claimedWalletAddress'] ?? 0,
  //     eventId: json['EventId'] ?? 0,
  //     walletAddress: json['walletaddress'] ?? '',
  //     latitude: json['latitude'] ?? '',
  //     longitude: json['longitude'] ?? '',
  //     timeDeadline: json['timedeadline'] ?? 0,
  //     members: json['members'] ?? 0,
  //     eventName: json['EventName'] ?? '',
  //   );
  // }

  factory EventDetails.fromMap(Map<String, dynamic> map) {
    return EventDetails(
      claimedWalletAddress: map['claimedWalletAddress'],
      eventId: map['EventId'],
      walletAddress: map['walletaddress'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timeDeadline: map['timedeadline'],
      members: map['members'],
      eventName: map['EventName'],
      tokenValue: map['TokenValue']
    );
  }
}
