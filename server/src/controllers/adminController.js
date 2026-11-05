const db = require('../data/db');

exports.getDashboardStats = (req, res) => {
  const totalOrders = db.data.orders.length;
  const completedOrders = db.data.orders.filter(o => o.orderStatus === 'COMPLETED');
  const activeOrders = db.data.orders.filter(o => ['PENDING', 'ACCEPTED', 'IN_PROGRESS'].includes(o.orderStatus));

  const totalRevenue = completedOrders.reduce((sum, o) => sum + (o.amount || 0), 0);
  const platformEarnings = Math.round(totalRevenue * 0.10); // 10% platform commission

  const totalProviders = db.data.providers.length;
  const onlineProviders = db.data.providers.filter(p => p.isOnline).length;
  const pendingKycCount = db.data.providers.filter(p => p.kycStatus === 'pending').length;

  const totalCustomers = db.data.users.filter(u => u.role === 'customer').length;

  // Breakdown by category
  const categoryStats = db.data.categories.map(c => {
    const ordersInCat = db.data.orders.filter(o => o.category === c.id);
    const revenueInCat = ordersInCat.reduce((sum, o) => sum + (o.amount || 0), 0);
    return {
      id: c.id,
      name: c.name,
      icon: c.icon,
      color: c.color,
      totalOrders: ordersInCat.length,
      revenue: revenueInCat,
      providersCount: db.data.providers.filter(p => p.category === c.id).length
    };
  });

  res.json({
    success: true,
    stats: {
      totalRevenue,
      platformEarnings,
      totalOrders,
      activeOrdersCount: activeOrders.length,
      completedOrdersCount: completedOrders.length,
      totalProviders,
      onlineProviders,
      pendingKycCount,
      totalCustomers
    },
    categoryStats,
    recentOrders: db.data.orders.slice(0, 8),
    pendingKycPartners: db.data.providers.filter(p => p.kycStatus === 'pending')
  });
};

const ensureSeedUsersAndProviders = () => {
  if (!db.data.users || db.data.users.filter(u => u.role === 'customer').length <= 1) {
    const extraCustomers = [
      {
        id: "usr_cust_2",
        name: "Sneha Reddy",
        email: "sneha.reddy@gmail.com",
        phone: "+91 98480 12345",
        role: "customer",
        address: "Plot 42, Pillar 143, Attapur, Hyderabad",
        district: "Rangareddy",
        mandal: "Rajendranagar",
        village: "Attapur",
        walletBalance: 1200,
        totalBookings: 8,
        status: "active",
        createdAt: "2026-10-15T10:30:00.000Z"
      },
      {
        id: "usr_cust_3",
        name: "Vikram Varma",
        email: "vikram.varma@outlook.com",
        phone: "+91 94401 98765",
        role: "customer",
        address: "Road No. 4, KPHB Phase 1, Hyderabad",
        district: "Medchal-Malkajgiri",
        mandal: "Kukatpally",
        village: "KPHB Colony",
        walletBalance: 450,
        totalBookings: 14,
        status: "active",
        createdAt: "2026-09-20T14:15:00.000Z"
      },
      {
        id: "usr_cust_4",
        name: "Priya Sharma",
        email: "priya.sharma@yahoo.com",
        phone: "+91 97000 55443",
        role: "customer",
        address: "Villa 18, Road No. 12, Banjara Hills",
        district: "Hyderabad",
        mandal: "Khairatabad",
        village: "Banjara Hills",
        walletBalance: 2100,
        totalBookings: 19,
        status: "active",
        createdAt: "2026-08-05T09:00:00.000Z"
      },
      {
        id: "usr_cust_5",
        name: "Ravi Teja",
        email: "raviteja.b@gmail.com",
        phone: "+91 98855 67890",
        role: "customer",
        address: "Near ORR Toll, Narsingi",
        district: "Rangareddy",
        mandal: "Rajendranagar",
        village: "Narsingi",
        walletBalance: 300,
        totalBookings: 3,
        status: "active",
        createdAt: "2026-10-28T16:45:00.000Z"
      }
    ];
    db.data.users = [...(db.data.users || []), ...extraCustomers];
    db.save();
  }

  if (!db.data.providers || db.data.providers.length <= 4) {
    const extraProviders = [
      {
        id: "prv_5",
        name: "Shiva Kumar",
        email: "shiva.mechanic@loki.com",
        phone: "+91 98765 66666",
        role: "provider",
        category: "cat_mechanic",
        serviceName: "24/7 Bike & Car Doctor",
        rating: 4.95,
        jobsCompleted: 620,
        isOnline: true,
        kycStatus: "approved",
        aadhaarNumber: "XXXX-XXXX-3341",
        district: "Hyderabad",
        mandal: "Serilingampally",
        village: "Gachibowli",
        walletBalance: 5800,
        createdAt: "2026-09-10T11:00:00.000Z"
      },
      {
        id: "prv_6",
        name: "K. Venkatesh",
        email: "venkatesh.ac@loki.com",
        phone: "+91 98765 77777",
        role: "provider",
        category: "cat_appliances",
        serviceName: "AC & Cooling Specialist",
        rating: 4.89,
        jobsCompleted: 410,
        isOnline: false,
        kycStatus: "approved",
        aadhaarNumber: "XXXX-XXXX-8920",
        district: "Medchal-Malkajgiri",
        mandal: "Kukatpally",
        village: "Nizampet",
        walletBalance: 3450,
        createdAt: "2026-09-18T15:20:00.000Z"
      }
    ];
    db.data.providers = [...(db.data.providers || []), ...extraProviders];
    db.save();
  }
};

exports.getAllProviders = (req, res) => {
  ensureSeedUsersAndProviders();
  const { kycStatus } = req.query;
  let list = db.data.providers;
  if (kycStatus) {
    list = list.filter(p => p.kycStatus === kycStatus);
  }

  const safeList = list.map(p => {
    const copy = { ...p };
    delete copy.passwordHash;
    return copy;
  });

  res.json({ success: true, count: safeList.length, providers: safeList });
};

exports.updateKycStatus = (req, res) => {
  const { id } = req.params;
  const { status } = req.body; // 'approved' or 'rejected'

  if (!['approved', 'rejected', 'pending'].includes(status)) {
    return res.status(400).json({ success: false, message: 'Status must be approved, rejected or pending' });
  }

  const provider = db.data.providers.find(p => p.id === id);
  if (!provider) {
    return res.status(404).json({ success: false, message: 'Provider not found' });
  }

  provider.kycStatus = status;
  if (status === 'rejected') {
    provider.isOnline = false;
  }
  db.save();

  const io = req.app.get('io');
  if (io) {
    io.emit('provider:kyc_updated', { providerId: provider.id, status });
  }

  res.json({
    success: true,
    message: `Provider KYC ${status.toUpperCase()} successfully`,
    provider: { id: provider.id, name: provider.name, kycStatus: provider.kycStatus }
  });
};

exports.getAllUsers = (req, res) => {
  ensureSeedUsersAndProviders();
  const customers = db.data.users.filter(u => u.role === 'customer').map(u => {
    const copy = { ...u };
    delete copy.passwordHash;
    return copy;
  });

  res.json({ success: true, count: customers.length, users: customers });
};

// Create Customer
exports.createCustomer = (req, res) => {
  const { name, phone, email, address, district, mandal, village } = req.body;
  if (!name || !phone) {
    return res.status(400).json({ success: false, message: 'Name and phone are required' });
  }

  const { v4: uuidv4 } = require('uuid');
  const newCustomer = {
    id: `usr_cust_${uuidv4().substring(0, 8)}`,
    name: name.trim(),
    phone: phone.trim(),
    email: email?.trim() || `${phone.replace(/\s+/g, '')}@loki.customer`,
    address: address?.trim() || (village ? `${village}, ${mandal}, ${district}` : 'Hyderabad, Telangana'),
    district: district || 'Hyderabad',
    mandal: mandal || 'Serilingampally',
    village: village || 'Madhapur',
    role: 'customer',
    walletBalance: 0,
    totalBookings: 0,
    status: 'active',
    createdAt: new Date().toISOString()
  };

  db.data.users.push(newCustomer);
  db.save();

  res.status(201).json({
    success: true,
    message: 'Customer registered successfully',
    customer: newCustomer
  });
};

// Delete Customer
exports.deleteCustomer = (req, res) => {
  const { id } = req.params;
  const index = db.data.users.findIndex(u => u.id === id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Customer not found' });
  }

  db.data.users.splice(index, 1);
  db.save();

  res.json({ success: true, message: 'Customer removed successfully' });
};

// Create Provider (Service Partner)
exports.createProvider = (req, res) => {
  const { name, phone, email, category, serviceName, aadhaarNumber, vehicleNumber, district, mandal, village } = req.body;
  if (!name || !phone || !category) {
    return res.status(400).json({ success: false, message: 'Name, phone, and service category are required' });
  }

  const { v4: uuidv4 } = require('uuid');
  const newProvider = {
    id: `prv_${uuidv4().substring(0, 8)}`,
    name: name.trim(),
    phone: phone.trim(),
    email: email?.trim() || `${phone.replace(/\s+/g, '')}@loki.partner`,
    role: 'provider',
    category,
    serviceName: serviceName?.trim() || 'Certified Specialist',
    rating: 5.0,
    jobsCompleted: 0,
    isOnline: true,
    kycStatus: 'approved',
    aadhaarNumber: aadhaarNumber?.trim() || 'XXXX-XXXX-0000',
    vehicleNumber: vehicleNumber?.trim() || '',
    district: district || 'Hyderabad',
    mandal: mandal || 'Serilingampally',
    village: village || 'Madhapur',
    walletBalance: 0,
    createdAt: new Date().toISOString()
  };

  db.data.providers.push(newProvider);
  db.save();

  res.status(201).json({
    success: true,
    message: 'Service Partner onboarded successfully',
    provider: newProvider
  });
};

// Delete Provider
exports.deleteProvider = (req, res) => {
  const { id } = req.params;
  const index = db.data.providers.findIndex(p => p.id === id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Provider not found' });
  }

  db.data.providers.splice(index, 1);
  db.save();

  res.json({ success: true, message: 'Provider removed successfully' });
};

// Toggle Provider Online/Offline Status
exports.toggleProviderOnline = (req, res) => {
  const { id } = req.params;
  const provider = db.data.providers.find(p => p.id === id);
  if (!provider) {
    return res.status(404).json({ success: false, message: 'Provider not found' });
  }

  provider.isOnline = !provider.isOnline;
  db.save();

  res.json({
    success: true,
    message: `Provider is now ${provider.isOnline ? 'ONLINE' : 'OFFLINE'}`,
    isOnline: provider.isOnline
  });
};

exports.getAllOrders = (req, res) => {
  res.json({
    success: true,
    count: db.data.orders.length,
    orders: db.data.orders
  });
};
