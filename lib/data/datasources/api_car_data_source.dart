import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentapp/data/models/car.dart';

class ApiCarDataSource {
  // Use your computer's IP address if testing on a real device
  // Find it by running 'ipconfig' in PowerShell and look for IPv4 Address
  final String baseUrl = 'http://localhost:5000/api';
  
  // For testing on real Android/iOS devices, use your computer's IP:
  // final String baseUrl = 'http://192.168.1.XXX:5000/api';

  Future<List<Car>> getCars() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cars'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Backend returns: { "success": true, "count": 6, "data": [...] }
        final List<dynamic> carsJson = jsonResponse['data'];
        
        return carsJson.map((carJson) => Car.fromApiMap(carJson)).toList();
      } else {
        throw Exception('Failed to load cars: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cars: $e');
    }
  }

  Future<Car> getCarById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cars/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Car.fromApiMap(jsonResponse['data']);
      } else {
        throw Exception('Failed to load car: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching car: $e');
    }
  }
}
