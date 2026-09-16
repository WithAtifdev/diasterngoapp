class ApiConstants {
  ApiConstants._();

  // Open-Meteo Weather ()
  static const String weatherUrl =
      'https://api.open-meteo.com/v1/forecast';

  // Open-Meteo Flood API ()
  static const String floodUrl =
      'https://flood-api.open-meteo.com/v1/flood';

  // USGS Earthquake Feed ()
  static const String earthquakeUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson';

  // Nominatim reverse geocoding ()
  static const String geocodeUrl =
      'https://nominatim.openstreetmap.org/reverse';

  // GDACS Global Alerts ()
  static const String gdacsUrl =
      'https://www.gdacs.org/gdacsapi/api/events/geteventlist/SEARCH';

  static const int timeoutSeconds = 15;
}