const express = require('express');
const router = express.Router();
const locationController = require('../controllers/locationController');

// 1. Get all Locations
router.get('/', locationController.getAllLocations);

// 2. District Routes
router.post('/districts', locationController.createDistrict);
router.delete('/districts/:id', locationController.deleteDistrict);

// 3. Mandal Routes
router.post('/districts/:districtId/mandals', locationController.createMandal);
router.delete('/districts/:districtId/mandals/:mandalId', locationController.deleteMandal);

// 4. Village Routes
router.post('/districts/:districtId/mandals/:mandalId/villages', locationController.createVillage);
router.delete('/districts/:districtId/mandals/:mandalId/villages/:villageId', locationController.deleteVillage);

module.exports = router;
