import 'dart:convert';
import 'package:crypto/crypto.dart';

String getHexoDeviceName(String pin) {
  if (pin.length != 4) {
    throw ArgumentError("The PIN must be a 4-digit string.");
  }
  List<int> pinBytes = utf8.encode(pin);
  Digest sha1Hash = sha1.convert(pinBytes);
  String hexString = sha1Hash.toString();
  String last8HexDigits = hexString.substring(hexString.length - 8);
  String deviceName = "CREAID${last8HexDigits}";
  return deviceName;
}
