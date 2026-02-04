const mongoose = require('mongoose');

const carSchema = new mongoose.Schema({
  model: {
    type: String,
    required: [true, 'Please provide car model'],
    trim: true
  },
  distance: {
    type: Number,
    required: [true, 'Please provide distance'],
    min: 0
  },
  fuelCapacity: {
    type: Number,
    required: [true, 'Please provide fuel capacity'],
    min: 0
  },
  pricePerHour: {
    type: Number,
    required: [true, 'Please provide price per hour'],
    min: 0
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Car must have an owner']
  },
  image: {
    type: String,
    default: 'default-car.png'
  },
  available: {
    type: Boolean,
    default: true
  },
  features: {
    type: [String],
    default: ['Diesel', 'Acceleration 0-100km/s', 'Temperature Control']
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Car', carSchema);
