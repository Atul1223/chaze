import 'package:web3dart/crypto.dart';

String truncateString(String text, int front, int end) {
  int size = front + end;

  if (text.length > size) {
    String finalString =
        "${text.substring(0, front)}...${text.substring(text.length - end)}";
    return finalString;
  }

  return text;
}

String generateSessionMessage(String accountAddress) {
  String message =
      'Hello $accountAddress, welcome to our app. By signing this message you agree to learn and have fun with blockchain';
  print(message);
  
  var hash = keccakUtf8(message);
  final hashString = '0x${bytesToHex(hash).toString()}';

  return hashString;
}

double calculateRadiusBasedOnZoom(double zoom) {
  // You can adjust this multiplier based on your preference
  double multiplier = 20;
  return multiplier * (2.0 / (1 << zoom.toInt()));
}