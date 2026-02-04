const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const Car = require('../models/Car');
const { protect, adminOnly } = require('../middleware/auth');

// @route   GET /api/cars
// @desc    Get all cars
// @access  Public
router.get('/', async (req, res) => {
  try {
    const { available } = req.query;
    
    let query = {};
    if (available !== undefined) {
      query.available = available === 'true';
    }

    const cars = await Car.find(query)
      .populate({
        path: 'owner',
        select: 'name email avatar totalEarnings'
      })
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: cars.length,
      data: cars
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

// @route   GET /api/cars/:id
// @desc    Get single car
// @access  Public
router.get('/:id', async (req, res) => {
  try {
    const car = await Car.findById(req.params.id)
      .populate({
        path: 'owner',
        select: 'name email avatar totalEarnings'
      });

    if (!car) {
      return res.status(404).json({
        success: false,
        message: 'Car not found'
      });
    }

    res.json({
      success: true,
      data: car
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

// @route   POST /api/cars
// @desc    Create a new car
// @access  Private/Admin
router.post('/', [protect, adminOnly], [
  body('model').notEmpty().withMessage('Car model is required'),
  body('distance').isNumeric().withMessage('Distance must be a number'),
  body('fuelCapacity').isNumeric().withMessage('Fuel capacity must be a number'),
  body('pricePerHour').isNumeric().withMessage('Price per hour must be a number')
], async (req, res) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const car = await Car.create(req.body);
    
    // Populate owner info in response
    await car.populate({
      path: 'owner',
      select: 'name email avatar totalEarnings'
    });

    res.status(201).json({
      success: true,
      message: 'Car created successfully',
      data: car
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

// @route   PUT /api/cars/:id
// @desc    Update a car
// @access  Private/Admin
router.put('/:id', [protect, adminOnly], async (req, res) => {
  try {
    let car = await Car.findById(req.params.id);

    if (!car) {
      return res.status(404).json({
        success: false,
        message: 'Car not found'
      });
    }

    car = await Car.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    }).populate({
      path: 'owner',
      select: 'name email avatar totalEarnings'
    });

    res.json({
      success: true,
      message: 'Car updated successfully',
      data: car
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

// @route   DELETE /api/cars/:id
// @desc    Delete a car
// @access  Private/Admin
router.delete('/:id', [protect, adminOnly], async (req, res) => {
  try {
    const car = await Car.findById(req.params.id);

    if (!car) {
      return res.status(404).json({
        success: false,
        message: 'Car not found'
      });
    }

    await car.deleteOne();

    res.json({
      success: true,
      message: 'Car deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

module.exports = router;
