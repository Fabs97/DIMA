import 'package:geocoding/geocoding.dart';

// TODO: iOS version neeeds to be configured
class GeocodingService {
  static Future<String> getAddressFrom(
    double lat,
    double long,
  ) async {
    return placemarkFromCoordinates(lat, long).then((results) {
      var result = results.first;
      if (result != null) {
        // ! Known bug: abroad addresses are not rendered correctly due to different definitions
        return "${result.street ?? ""}, ${result.name ?? ""}, ${result.postalCode ?? ""} ${result.locality ?? ""}, ${result.country ?? ""}";
      } else
        return null;
    });
  }
}
