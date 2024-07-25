import 'package:country_pickers/countries.dart';
import 'package:phonenumbers/phonenumbers.dart';

bool startsWithAnyCountryCode(String phoneNumber) {
  return countryList.any((country) => phoneNumber.startsWith
    ('+${country.phoneCode}'));
}

bool isValidPhoneNumber(String phoneNumber) {
  return PhoneNumber.parse(phoneNumber).isValid;
}

