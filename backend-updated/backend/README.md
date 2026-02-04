# Car Rental App - Node.js Backend

A RESTful API backend for the Car Rental mobile application built with Node.js, Express, and MongoDB.

## Features

- ✅ User Authentication (Register/Login with JWT)
- ✅ Car Management (CRUD operations)
- ✅ Booking System
- ✅ Role-based Access Control (User/Admin)
- ✅ Input Validation
- ✅ Error Handling

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** MongoDB
- **Authentication:** JWT (JSON Web Tokens)
- **Password Hashing:** bcryptjs
- **Validation:** express-validator

## Prerequisites

Before running this backend, make sure you have:

- Node.js (v14 or higher) installed
- MongoDB installed locally OR MongoDB Atlas account (cloud database)
- npm or yarn package manager

## Installation

### Step 1: Install Node.js

Download and install from: https://nodejs.org/

Verify installation:
```bash
node --version
npm --version
```

### Step 2: Install MongoDB

**Option A: Local MongoDB**
- Download from: https://www.mongodb.com/try/download/community
- Install and start MongoDB service

**Option B: MongoDB Atlas (Cloud - Recommended for beginners)**
1. Go to: https://www.mongodb.com/cloud/atlas
2. Create a free account
3. Create a new cluster
4. Get your connection string

### Step 3: Install Dependencies

```bash
cd backend
npm install
```

### Step 4: Configure Environment Variables

Edit the `.env` file with your settings:

```env
PORT=5000
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key_here
JWT_EXPIRE=7d
```

**Important:** Change `JWT_SECRET` to a random string for security!

### Step 5: Seed Database (Optional)

You can add initial car data manually or use the MongoDB compass/shell.

## Running the Server

### Development Mode (with auto-restart)
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

Server will run on: `http://localhost:5000`

## API Endpoints

### Authentication

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| POST | `/api/auth/register` | Register new user | Public |
| POST | `/api/auth/login` | Login user | Public |
| GET | `/api/auth/me` | Get current user | Private |

### Cars

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/api/cars` | Get all cars | Public |
| GET | `/api/cars/:id` | Get single car | Public |
| POST | `/api/cars` | Create car | Admin |
| PUT | `/api/cars/:id` | Update car | Admin |
| DELETE | `/api/cars/:id` | Delete car | Admin |

### Bookings

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| POST | `/api/bookings` | Create booking | Private |
| GET | `/api/bookings` | Get user bookings | Private |
| GET | `/api/bookings/:id` | Get single booking | Private |
| PUT | `/api/bookings/:id/cancel` | Cancel booking | Private |

## API Usage Examples

### Register a New User

```bash
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

### Login

```bash
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "...",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "user"
  }
}
```

### Get All Cars

```bash
GET http://localhost:5000/api/cars
```

### Create a Booking (Requires Authentication)

```bash
POST http://localhost:5000/api/bookings
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json

{
  "car": "car_id_here",
  "startDate": "2026-02-10T10:00:00Z",
  "endDate": "2026-02-12T10:00:00Z"
}
```

## Database Models

### User
- name: String
- email: String (unique)
- password: String (hashed)
- role: String (user/admin)

### Car
- model: String
- distance: Number
- fuelCapacity: Number
- pricePerHour: Number
- image: String
- available: Boolean
- features: [String]

### Booking
- user: ObjectId (ref: User)
- car: ObjectId (ref: Car)
- startDate: Date
- endDate: Date
- totalHours: Number
- totalPrice: Number
- status: String (pending/confirmed/completed/cancelled)
- paymentStatus: String (pending/paid/refunded)

## Testing the API

### Using Postman
1. Download Postman: https://www.postman.com/downloads/
2. Import the API endpoints
3. Test each endpoint

### Using Thunder Client (VS Code Extension)
1. Install Thunder Client extension in VS Code
2. Create requests for each endpoint
3. Test the API

## Connecting Flutter App to Backend

In your Flutter app, update the API base URL:

```dart
// lib/data/datasources/api_car_data_source.dart
class ApiCarDataSource {
  final String baseUrl = 'http://localhost:5000/api';
  // or use your computer's IP address for testing on real devices
  // final String baseUrl = 'http://192.168.1.100:5000/api';
  
  Future<List<Car>> getCars() async {
    final response = await http.get(Uri.parse('$baseUrl/cars'));
    // ... handle response
  }
}
```

## Project Structure

```
backend/
├── models/
│   ├── User.js           # User model
│   ├── Car.js            # Car model
│   └── Booking.js        # Booking model
├── routes/
│   ├── auth.js           # Authentication routes
│   ├── cars.js           # Car routes
│   └── bookings.js       # Booking routes
├── middleware/
│   └── auth.js           # JWT authentication middleware
├── .env                  # Environment variables
├── server.js             # Main server file
├── package.json          # Dependencies
└── README.md             # This file
```

## Common Issues & Solutions

### MongoDB Connection Error
- Make sure MongoDB is running
- Check your MONGODB_URI in .env file
- If using Atlas, whitelist your IP address

### Port Already in Use
- Change PORT in .env file
- Or kill the process using port 5000

### JWT Token Invalid
- Make sure you're sending the token in headers
- Format: `Authorization: Bearer YOUR_TOKEN`

## Deployment

### Deploy to Heroku
```bash
heroku create your-app-name
git push heroku main
heroku config:set MONGODB_URI=your_mongodb_uri
heroku config:set JWT_SECRET=your_secret
```

### Deploy to Railway
1. Go to railway.app
2. Connect your GitHub repo
3. Add environment variables
4. Deploy

## Security Notes

- ✅ Passwords are hashed with bcrypt
- ✅ JWT tokens expire after 7 days
- ✅ Input validation on all routes
- ✅ CORS enabled for Flutter app
- ⚠️ Change JWT_SECRET in production
- ⚠️ Use HTTPS in production
- ⚠️ Add rate limiting for production

## License

MIT

## Support

For issues or questions, please create an issue on GitHub or contact support.
