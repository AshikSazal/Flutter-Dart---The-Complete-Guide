const GOOGLE_API_KEY = 'AIzaSyDV65m8RB5GUksT05aXqY9XFZIln3NtX8c';
// const GOOGLE_API_KEY = 'AIzaSyBg9yn5JtQgKRFbg6FCTy4ewbF24kRuAYI';

class LocationHelper {
  static String generateLocationPreviewImage({required double latitude, required double longitude,}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=40.714%2c%20-73.998&zoom=12&size=400x400&key=$GOOGLE_API_KEY';
  }
}