import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentapp/services/auth_service.dart';

class BookingService {
  final String baseUrl = 'http://localhost:5000/api';
  final AuthService authService = AuthService();

  // Create a new booking
  Future<Map<String, dynamic>> createBooking({
    required String carId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final token = await authService.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Please login first',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'car': carId,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'booking': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Booking failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Get all bookings for current user
  Future<Map<String, dynamic>> getMyBookings() async {
    try {
      final token = await authService.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Please login first',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'bookings': data['data'],
          'count': data['count'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get bookings',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Get single booking by ID
  Future<Map<String, dynamic>> getBookingById(String bookingId) async {
    try {
      final token = await authService.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Please login first',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/bookings/$bookingId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'booking': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get booking',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Cancel a booking
  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    try {
      final token = await authService.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Please login first',
        };
      }

      final response = await http.put(
        Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'booking': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to cancel booking',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
