import 'package:flutter/material.dart';
import 'package:rentapp/data/models/car.dart';
import 'package:rentapp/services/booking_service.dart';
import 'package:rentapp/presentation/pages/my_bookings_page.dart';

class BookingPage extends StatefulWidget {
  final Car car;

  const BookingPage({Key? key, required this.car}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? startDate;
  DateTime? endDate;
  final BookingService _bookingService = BookingService();
  bool _isLoading = false;

  int get totalHours {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inHours;
  }

  double get totalPrice {
    return totalHours * widget.car.pricePerHour;
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          // Reset end date if it's before start date
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        });
      }
    }
  }

  Future<void> _selectEndDate() async {
    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select start date first')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate!.add(Duration(days: 1)),
      firstDate: startDate!,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _bookCar() async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }

    if (widget.car.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Car ID not found')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _bookingService.createBooking(
      carId: widget.car.id!,
      startDate: startDate!,
      endDate: endDate!,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Booking Successful!'),
          content: Text('Your car has been booked successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to car details
                // Navigate to bookings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBookingsPage()),
                );
              },
              child: Text('View My Bookings'),
            ),
          ],
        ),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Booking failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.car.model}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Car Info Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.car.model,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.directions_car, size: 16),
                        SizedBox(width: 5),
                        Text('${widget.car.distance} km'),
                        SizedBox(width: 20),
                        Icon(Icons.battery_full, size: 16),
                        SizedBox(width: 5),
                        Text('${widget.car.fuelCapacity} L'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${widget.car.pricePerHour}/hour',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Date Selection
            Text(
              'Select Rental Period',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Start Date
            InkWell(
              onTap: _selectStartDate,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start Date & Time'),
                        SizedBox(height: 4),
                        Text(
                          startDate == null
                              ? 'Select date'
                              : '${startDate!.day}/${startDate!.month}/${startDate!.year} ${startDate!.hour}:${startDate!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // End Date
            InkWell(
              onTap: _selectEndDate,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('End Date & Time'),
                        SizedBox(height: 4),
                        Text(
                          endDate == null
                              ? 'Select date'
                              : '${endDate!.day}/${endDate!.month}/${endDate!.year} ${endDate!.hour}:${endDate!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Price Summary
            if (startDate != null && endDate != null) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Hours:'),
                        Text(
                          '$totalHours hours',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price per hour:'),
                        Text('\$${widget.car.pricePerHour}'),
                      ],
                    ),
                    Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],

            // Book Button
            ElevatedButton(
              onPressed: _isLoading ? null : _bookCar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
