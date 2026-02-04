import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentapp/data/models/car.dart';

class FirebaseCarDataSource {
  final FirebaseFirestore? firestore;

  FirebaseCarDataSource({this.firestore});

  Future<List<Car>> getCars() async {
    // TEMPORARY: Return mock data instead of fetching from Firebase
    // Remove this and uncomment the code below when Firebase is properly configured

    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    return [
      Car(
        model: 'Tesla Model 3',
        distance: 870.0,
        fuelCapacity: 75.0,
        pricePerHour: 45.0,
      ),
      Car(
        model: 'BMW i4',
        distance: 590.0,
        fuelCapacity: 80.0,
        pricePerHour: 55.0,
      ),
      Car(
        model: 'Audi e-tron',
        distance: 436.0,
        fuelCapacity: 95.0,
        pricePerHour: 60.0,
      ),
      Car(
        model: 'Mercedes EQS',
        distance: 770.0,
        fuelCapacity: 107.8,
        pricePerHour: 75.0,
      ),
      Car(
        model: 'Porsche Taycan',
        distance: 484.0,
        fuelCapacity: 93.4,
        pricePerHour: 85.0,
      ),
      Car(
        model: 'Ford Mustang Mach-E',
        distance: 480.0,
        fuelCapacity: 88.0,
        pricePerHour: 50.0,
      ),
    ];

    // ORIGINAL CODE (uncomment when Firebase is configured for web):
    // if (firestore == null) {
    //   throw Exception('Firebase is not initialized');
    // }
    // var snapshot = await firestore!.collection('cars').get();
    // return snapshot.docs.map((doc) => Car.fromMap(doc.data())).toList();
  }
}