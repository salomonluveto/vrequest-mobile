const String baseUrl = 'https://nominatim.openstreetmap.org/search';
const String apiKey = '5b3ce3597851110001cf6248526bc25a67dd4a0ebc8d08344c84088c';

getRouteUrl(String request){
  return Uri.parse('$baseUrl?format=json&q=$request');
}