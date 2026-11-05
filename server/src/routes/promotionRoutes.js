const express = require('express');
const router = express.Router();
const promotionController = require('../controllers/promotionController');

// Public route for Customer App & Admin View
router.get('/', promotionController.getAllPromotions);
router.get('/:id', promotionController.getPromotionById);

// Admin Management routes
router.post('/', promotionController.createPromotion);
router.put('/:id', promotionController.updatePromotion);
router.patch('/:id/toggle', promotionController.togglePromotionActive);
router.delete('/:id', promotionController.deletePromotion);

module.exports = router;

