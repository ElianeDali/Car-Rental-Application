import 'package:flutter/material.dart';
import 'package:rentapp/data/models/car.dart';
import 'package:rentapp/presentation/pages/MapsDetailsPage.dart';
import 'package:rentapp/presentation/pages/booking_page.dart';
import 'package:rentapp/presentation/widgets/car_card.dart';
import 'package:rentapp/presentation/widgets/more_card.dart';

class CardDetailsPage extends StatefulWidget {
  final Car car;

  const CardDetailsPage({super.key, required this.car});

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller!)
    ..addListener(() { setState(() {
    }); });

    _controller!.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline),
            Text(' Information')
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarCard(car: Car(
              id: widget.car.id,
              model: widget.car.model, 
              distance: widget.car.distance, 
              fuelCapacity: widget.car.fuelCapacity, 
              pricePerHour: widget.car.pricePerHour
            )),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Color(0xffF3F3F3),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 5
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          // Dynamic owner avatar
                          _buildOwnerAvatar(),
                          SizedBox(height: 10,),
                          // Dynamic owner name
                          Text(
                            widget.car.owner?.name ?? 'Unknown Owner',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          // Dynamic earnings or placeholder
                          Text(
                            widget.car.owner?.totalEarnings != null 
                                ? '\$${widget.car.owner!.totalEarnings!.toStringAsFixed(0)}'
                                : 'No data',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapsDetailsPage(car: widget.car))
                        );
                      },
                      child: Container(
                        height: 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  spreadRadius: 5
                              )
                            ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Transform.scale(
                            scale: _animation!.value,
                            alignment: Alignment.center,
                            child: Image.asset('assets/maps.png',fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            // Book Now Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(car: widget.car),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '\$${widget.car.pricePerHour}/hr',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // More Cars Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Similar Cars',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  MoreCard(car: Car(
                    model: "${widget.car.model}-1", 
                    distance: widget.car.distance+100, 
                    fuelCapacity: widget.car.fuelCapacity+100, 
                    pricePerHour: widget.car.pricePerHour+10
                  )),
                  SizedBox(height: 5,),
                  MoreCard(car: Car(
                    model: "${widget.car.model}-2", 
                    distance: widget.car.distance+200, 
                    fuelCapacity: widget.car.fuelCapacity+200, 
                    pricePerHour: widget.car.pricePerHour+20
                  )),
                  SizedBox(height: 5,),
                  MoreCard(car: Car(
                    model: "${widget.car.model}-3", 
                    distance: widget.car.distance+300, 
                    fuelCapacity: widget.car.fuelCapacity+300, 
                    pricePerHour: widget.car.pricePerHour+30
                  )),
                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Build owner avatar widget - supports both network images and local fallback
  Widget _buildOwnerAvatar() {
    if (widget.car.owner?.avatar != null && widget.car.owner!.avatar!.isNotEmpty) {
      // Try to load from network
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(widget.car.owner!.avatar!),
        onBackgroundImageError: (exception, stackTrace) {
          // If network image fails, it will show default icon
        },
        child: widget.car.owner!.avatar!.startsWith('http') 
            ? null 
            : Icon(Icons.person, size: 40, color: Colors.grey),
      );
    } else {
      // Fallback to local asset or default icon
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
      );
    }
  }
}
