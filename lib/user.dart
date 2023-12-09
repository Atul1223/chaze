class UserData {
  final String walletAddress;
  final String username;

  UserData({
    required this.walletAddress,
    required this.username,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      walletAddress: map['walletaddress'],
      username: map['username'],
    );
  }
}
