class CarOwner {
  final String? id;
  final String name;
  final String? email;
  final String? avatar;
  final double? totalEarnings;

  CarOwner({
    this.id,
    required this.name,
    this.email,
    this.avatar,
    this.totalEarnings,
  });

  factory CarOwner.fromMap(Map<String, dynamic> map) {
    return CarOwner(
      id: map['_id'],
      name: map['name'] ?? 'Unknown Owner',
      email: map['email'],
      avatar: map['avatar'],
      totalEarnings: map['totalEarnings'] != null 
          ? (map['totalEarnings'] as num).toDouble() 
          : 0.0,
    );
  }
}

class Car {
  final String? id;
  final String model;
  final double distance;
  final double fuelCapacity;
  final double pricePerHour;
  final CarOwner? owner;

  Car({
    this.id,
    required this.model,
    required this.distance,
    required this.fuelCapacity,
    required this.pricePerHour,
    this.owner,
  });

  // For Firebase (old - keep for compatibility)
  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['_id'],
      model: map['model'],
      distance: (map['distance'] as num).toDouble(),
      fuelCapacity: (map['fuelCapacity'] as num).toDouble(),
      pricePerHour: (map['pricePerHour'] as num).toDouble(),
      owner: map['owner'] != null ? CarOwner.fromMap(map['owner']) : null,
    );
  }

  // For Backend API (new)
  factory Car.fromApiMap(Map<String, dynamic> map) {
    return Car(
      id: map['_id'],
      model: map['model'],
      distance: (map['distance'] as num).toDouble(),
      fuelCapacity: (map['fuelCapacity'] as num).toDouble(),
      pricePerHour: (map['pricePerHour'] as num).toDouble(),
      owner: map['owner'] != null ? CarOwner.fromMap(map['owner']) : null,
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'distance': distance,
      'fuelCapacity': fuelCapacity,
      'pricePerHour': pricePerHour,
    };
  }
}
