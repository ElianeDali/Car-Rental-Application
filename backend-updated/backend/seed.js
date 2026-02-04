const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Car = require('./models/Car');
const User = require('./models/User');

dotenv.config();

const seedDatabase = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Connected to MongoDB');

    // Clear existing data
    await Car.deleteMany();
    await User.deleteMany();
    console.log('🗑️  Cleared existing data');

    // Create owners first
    const owner1 = await User.create({
      name: 'John Smith',
      email: 'john@example.com',
      password: 'password123',
      role: 'owner',
      totalEarnings: 5420.50,
      avatar: 'https://i.pravatar.cc/150?img=12'
    });

    const owner2 = await User.create({
      name: 'Sarah Johnson',
      email: 'sarah@example.com',
      password: 'password123',
      role: 'owner',
      totalEarnings: 7850.25,
      avatar: 'https://i.pravatar.cc/150?img=45'
    });

    const owner3 = await User.create({
      name: 'Michael Davis',
      email: 'michael@example.com',
      password: 'password123',
      role: 'owner',
      totalEarnings: 3200.00,
      avatar: 'https://i.pravatar.cc/150?img=33'
    });

    console.log('✅ Created 3 car owners');

    // Create admin user
    const admin = await User.create({
      name: 'Admin',
      email: 'admin@rentapp.com',
      password: 'admin123',
      role: 'admin',
      totalEarnings: 0
    });
    console.log('✅ Created admin user');

    // Create cars with owners
    const cars = [
      {
        model: 'Tesla Model 3',
        distance: 870,
        fuelCapacity: 75,
        pricePerHour: 45,
        owner: owner1._id,
        available: true,
        features: ['Electric', 'Autopilot', 'Temperature Control']
      },
      {
        model: 'BMW i4',
        distance: 590,
        fuelCapacity: 80,
        pricePerHour: 55,
        owner: owner2._id,
        available: true,
        features: ['Electric', 'Sport Mode', 'Premium Sound']
      },
      {
        model: 'Audi e-tron',
        distance: 436,
        fuelCapacity: 95,
        pricePerHour: 60,
        owner: owner1._id,
        available: true,
        features: ['Electric', 'Quattro AWD', 'Virtual Cockpit']
      },
      {
        model: 'Mercedes EQS',
        distance: 770,
        fuelCapacity: 107.8,
        pricePerHour: 75,
        owner: owner3._id,
        available: true,
        features: ['Electric', 'MBUX', 'Air Suspension']
      },
      {
        model: 'Porsche Taycan',
        distance: 484,
        fuelCapacity: 93.4,
        pricePerHour: 85,
        owner: owner2._id,
        available: true,
        features: ['Electric', 'Sport Chrono', 'Adaptive Cruise']
      },
      {
        model: 'Ford Mustang Mach-E',
        distance: 480,
        fuelCapacity: 88,
        pricePerHour: 50,
        owner: owner3._id,
        available: true,
        features: ['Electric', 'BlueCruise', 'B&O Sound']
      }
    ];

    await Car.insertMany(cars);
    console.log('✅ Added 6 cars with owners');

    console.log('\n🎉 Database seeded successfully!');
    console.log('\n📧 Test Users:');
    console.log('   Admin: admin@rentapp.com / admin123');
    console.log('   Owner 1: john@example.com / password123');
    console.log('   Owner 2: sarah@example.com / password123');
    console.log('   Owner 3: michael@example.com / password123');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
};

seedDatabase();
