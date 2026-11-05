const db = require('../data/db');
const { v4: uuidv4 } = require('uuid');

exports.getAllServices = (req, res) => {
  const { categoryId } = req.query;
  let services = db.data.services;

  if (categoryId) {
    services = services.filter(s => s.categoryId === categoryId);
  }

  res.json({
    success: true,
    count: services.length,
    services
  });
};

exports.getServiceById = (req, res) => {
  const service = db.data.services.find(s => s.id === req.params.id);
  if (!service) {
    return res.status(404).json({ success: false, message: 'Service not found' });
  }
  res.json({ success: true, service });
};

exports.createService = (req, res) => {
  const { categoryId, name, basePrice, duration, description } = req.body;
  if (!categoryId || !name || !basePrice) {
    return res.status(400).json({ success: false, message: 'Category, name, and base price are required' });
  }

  const newService = {
    id: `srv_${uuidv4().substring(0, 8)}`,
    categoryId,
    name,
    basePrice: Number(basePrice),
    duration: duration || '30 mins',
    description: description || '',
    rating: 5.0,
    totalBookings: 0
  };

  db.data.services.push(newService);

  // Update category count
  const cat = db.data.categories.find(c => c.id === categoryId);
  if (cat) cat.servicesCount = (cat.servicesCount || 0) + 1;

  db.save();

  res.status(201).json({
    success: true,
    message: 'Service created successfully',
    service: newService
  });
};

exports.deleteService = (req, res) => {
  const { id } = req.params;
  const index = db.data.services.findIndex(s => s.id === id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Service not found' });
  }

  const deleted = db.data.services.splice(index, 1)[0];
  const cat = db.data.categories.find(c => c.id === deleted.categoryId);
  if (cat && cat.servicesCount > 0) cat.servicesCount -= 1;

  db.save();
  res.json({ success: true, message: 'Service deleted successfully' });
};
