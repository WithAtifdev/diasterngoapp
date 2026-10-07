class ApiConstants {
  ApiConstants._();

  // Open-Meteo Weather ()
  static const String weatherUrl =
      'https://api.open-meteo.com/v1/forecast';
//https://api.open-meteo.com/v1/forecast?latitude=33.6844&longitude=73.0479&current=temperature_2m,precipitation,wind_speed_10m,wind_gusts_10m,weather_code,relative_humidity_2m,uv_index

  // Open-Meteo Flood API ()
  static const String floodUrl =
      'https://flood-api.open-meteo.com/v1/flood';
//https://flood-api.open-meteo.com/v1/flood?latitude=33.6844&longitude=73.0479&daily=river_discharge
  //https://flood-api.open-meteo.com/v1/flood?latitude=33.6844&longitude=73.0479&daily=river_discharge_mean&forecast_days=1


  // USGS Earthquake Feed ()
  static const String earthquakeUrl =
      'https://earthquake.usgs.gov/fdsnws/event/1/query';
  //https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&limit=10
  //https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&latitude=34.0151&longitude=71.5249&maxradiuskm=500&minmagnitude=2.5&orderby=time

  // Nominatim reverse geocoding ()
  static const String geocodeUrl =
      'https://nominatim.openstreetmap.org/reverse';
  //https://nominatim.openstreetmap.org/reverse?lat=34.0151&lon=71.5249&format=json
  //User-Agent DisasterNGOApp/1.0
  // Accept-Language en

  // GDACS Global Alerts ()
  static const String gdacsUrl =
      'https://www.gdacs.org/gdacsapi/api/events/geteventlist/SEARCH';

  static const int timeoutSeconds = 15;

  // Earthquake search radius
  static const double earthquakeRadiusKm = 250;
}