const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');
const { verifyToken } = require('../middleware/auth');

router.post('/', verifyToken, orderController.createOrder);
router.get('/my', verifyToken, orderController.getCustomerOrders);
router.get('/:id', verifyToken, orderController.getOrderDetails);
router.patch('/:id/status', verifyToken, orderController.updateOrderStatus);

module.exports = router;
