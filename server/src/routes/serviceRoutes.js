const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');
const { verifyToken, requireRole } = require('../middleware/auth');

router.get('/', serviceController.getAllServices);
router.get('/:id', serviceController.getServiceById);
router.post('/', verifyToken, requireRole('admin'), serviceController.createService);
router.delete('/:id', verifyToken, requireRole('admin'), serviceController.deleteService);

module.exports = router;
