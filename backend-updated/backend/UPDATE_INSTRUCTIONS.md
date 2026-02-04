# Backend Update - Owner Information Feature

## ✅ Changes Made

### 1. **User Model Updated** (`models/User.js`)
- Added `avatar` field (String, nullable) - stores profile picture URL
- Added `totalEarnings` field (Number, default 0.0) - tracks owner earnings
- Updated `role` enum to include 'owner' option: `['user', 'owner', 'admin']`

### 2. **Car Model Updated** (`models/Car.js`)
- Added `owner` field (ObjectId reference to User model)
- Owner field is required - every car must have an owner
- This creates a relationship between cars and their owners

### 3. **Car Routes Updated** (`routes/cars.js`)
All car routes now populate owner information:
- `GET /api/cars` - Returns all cars with owner details
- `GET /api/cars/:id` - Returns single car with owner details  
- `POST /api/cars` - Creates car and returns with owner details
- `PUT /api/cars/:id` - Updates car and returns with owner details

**Owner data included in responses:**
```json
{
  "owner": {
    "_id": "...",
    "name": "John Smith",
    "email": "john@example.com",
    "avatar": "https://...",
    "totalEarnings": 5420.50
  }
}
```

### 4. **Seed Script Updated** (`seed.js`)
New seed data includes:
- **3 Car Owners:**
  - John Smith (john@example.com / password123) - Total Earnings: $5,420.50
  - Sarah Johnson (sarah@example.com / password123) - Total Earnings: $7,850.25
  - Michael Davis (michael@example.com / password123) - Total Earnings: $3,200.00
- **1 Admin User:**
  - Admin (admin@rentapp.com / admin123)
- **6 Cars** - Each assigned to one of the three owners

## 🚀 How to Use

### Step 1: Seed the Database
Run the seed script to populate the database with the new structure:

```bash
node seed.js
```

This will:
1. Clear existing data
2. Create 3 owners with profile pictures and earnings
3. Create 1 admin user
4. Create 6 cars, each assigned to an owner

### Step 2: Test the API
Start your server:
```bash
npm start
# or
npm run dev
```

Test the endpoints:
```bash
# Get all cars (will include owner info)
GET http://localhost:5000/api/cars

# Get single car (will include owner info)
GET http://localhost:5000/api/cars/{car_id}
```

### Step 3: Update Your Flutter App
Use the updated `car.dart` model provided in the separate files to handle the new owner data structure in your Flutter app.

## 📊 Example API Response

```json
{
  "success": true,
  "count": 6,
  "data": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "model": "Tesla Model 3",
      "distance": 870,
      "fuelCapacity": 75,
      "pricePerHour": 45,
      "owner": {
        "_id": "507f1f77bcf86cd799439012",
        "name": "John Smith",
        "email": "john@example.com",
        "avatar": "https://i.pravatar.cc/150?img=12",
        "totalEarnings": 5420.50
      },
      "available": true,
      "features": ["Electric", "Autopilot", "Temperature Control"],
      "createdAt": "2024-02-03T10:00:00.000Z"
    }
  ]
}
```

## 🔧 Optional: Update Earnings When Booking Completes

To automatically update owner earnings when bookings are completed, add this to your booking completion logic:

```javascript
// In your booking controller, when completing a booking:
const completeBooking = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    
    if (!booking) {
      return res.status(404).json({
        success: false,
        message: 'Booking not found'
      });
    }

    // Update booking status
    booking.status = 'completed';
    await booking.save();

    // Update car owner's earnings
    const car = await Car.findById(booking.car).populate('owner');
    if (car && car.owner) {
      car.owner.totalEarnings += booking.totalPrice;
      await car.owner.save();
    }

    res.status(200).json({
      success: true,
      message: 'Booking completed',
      data: booking
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error completing booking',
      error: error.message
    });
  }
};
```

## 📝 Notes

- All existing routes remain compatible
- Password is still excluded from queries (select: false)
- Owner data is only included when explicitly populated
- Avatars use Pravatar.cc for demo - replace with your own storage solution for production
- Car creation now requires an owner ID

## 🎯 What's Different in Your App Now

Your Flutter app will now:
1. Display real owner names instead of "Jane Cooper"
2. Show actual earnings instead of hardcoded "$4,253"
3. Display owner profile pictures if available
4. Fall back to default icon if avatar is missing
5. Show "Unknown Owner" if owner data is unavailable

## ✨ All Done!

Your backend now supports full owner information for cars. Run `node seed.js` and you're ready to go!
