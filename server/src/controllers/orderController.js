const db = require('../data/db');
const { v4: uuidv4 } = require('uuid');

exports.createOrder = (req, res) => {
  try {
    const customerId = req.user.id;
    const { serviceId, providerId, notes, customerAddress, coordinates, paymentMethod } = req.body;

    const service = db.data.services.find(s => s.id === serviceId);
    if (!service) {
      return res.status(404).json({ success: false, message: 'Requested service not found' });
    }

    const customer = db.data.users.find(u => u.id === customerId);

    // If a specific provider wasn't selected, pick the closest online & approved provider
    let chosenProvider = null;
    if (providerId) {
      chosenProvider = db.data.providers.find(p => p.id === providerId);
    } else {
      chosenProvider = db.data.providers.find(p => p.category === service.categoryId && p.isOnline && p.kycStatus === 'approved');
    }

    const orderOtp = Math.floor(1000 + Math.random() * 9000).toString(); // 4-digit verification PIN

    const newOrder = {
      id: `ORD-${Math.floor(1000 + Math.random() * 9000)}`,
      customerId,
      customerName: customer ? customer.name : 'Customer',
      customerPhone: customer ? customer.phone : '',
      providerId: chosenProvider ? chosenProvider.id : null,
      providerName: chosenProvider ? chosenProvider.name : 'Searching for nearby specialist...',
      serviceId,
      serviceName: service.name,
      category: service.categoryId,
      amount: service.basePrice,
      paymentStatus: paymentMethod === 'Loki Wallet' ? 'PAID' : 'PENDING',
      paymentMethod: paymentMethod || 'Cash On Delivery / UPI',
      orderStatus: 'PENDING',
      customerAddress: customerAddress || (customer ? customer.address : 'Customer Spot'),
      coordinates: coordinates || (customer ? customer.coordinates : { lat: 17.4435, lng: 78.3772 }),
      providerLocation: chosenProvider ? chosenProvider.currentLocation : null,
      otp: orderOtp,
      notes: notes || '',
      createdAt: new Date().toISOString()
    };

    db.data.orders.unshift(newOrder);
    db.save();

    // Broadcast new order to providers & admin
    const io = req.app.get('io');
    if (io) {
      io.emit('order:created', newOrder);
      if (chosenProvider) {
        io.to(`provider_${chosenProvider.id}`).emit('job:new_alert', newOrder);
      }
    }

    res.status(201).json({
      success: true,
      message: 'Service order placed successfully!',
      order: newOrder
    });
  } catch (err) {
    console.error('Create order error:', err);
    res.status(500).json({ success: false, message: 'Internal Server Error' });
  }
};

exports.updateOrderStatus = (req, res) => {
  const { id } = req.params;
  const { status, otp } = req.body;
  const order = db.data.orders.find(o => o.id === id);

  if (!order) {
    return res.status(404).json({ success: false, message: 'Order not found' });
  }

  // OTP check when starting work
  if (status === 'IN_PROGRESS' && otp) {
    if (order.otp !== otp) {
      return res.status(400).json({ success: false, message: 'Invalid Start-Work OTP entered by customer' });
    }
  }

  order.orderStatus = status;

  if (status === 'ACCEPTED') {
    if (req.user.role === 'provider') {
      order.providerId = req.user.id;
      order.providerName = req.user.name;
    }
  }

  if (status === 'CANCELLED' || status === 'REJECTED') {
    if (order.providerId) {
      const provider = db.data.providers.find(p => p.id === order.providerId);
      if (provider) {
        provider.cancelledJobs = (provider.cancelledJobs || 0) + 1;
        provider.leadsReceived = (provider.leadsReceived || 314) + 1;
      }
    }
  }

  if (status === 'COMPLETED') {
    order.paymentStatus = 'PAID';
    // Credit partner wallet (deduct 0% platform commission on subscription)
    if (order.providerId) {
      const provider = db.data.providers.find(p => p.id === order.providerId);
      if (provider) {
        provider.jobsCompleted = (provider.jobsCompleted || 0) + 1;
        provider.leadsReceived = (provider.leadsReceived || 314) + 1;
      }
    }
  }

  db.save();

  const io = req.app.get('io');
  if (io) {
    io.emit('order:status_updated', order);
  }

  res.json({
    success: true,
    message: `Order status updated to ${status}`,
    order
  });
};

exports.getCustomerOrders = (req, res) => {
  const customerId = req.user.id;
  const orders = db.data.orders.filter(o => o.customerId === customerId);

  res.json({
    success: true,
    orders: orders.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
  });
};

exports.getOrderDetails = (req, res) => {
  const { id } = req.params;
  const order = db.data.orders.find(o => o.id === id);
  if (!order) {
    return res.status(404).json({ success: false, message: 'Order not found' });
  }
  res.json({ success: true, order });
};
