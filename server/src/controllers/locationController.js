const db = require('../data/db');
const { v4: uuidv4 } = require('uuid');

// Ensure db.data.locations is initialized with standard Telangana/Andhra regional seed
const ensureLocationsInit = () => {
  if (!db.data.locations || !Array.isArray(db.data.locations) || db.data.locations.length === 0) {
    db.data.locations = [
      {
        id: "dist_hyderabad",
        name: "Hyderabad",
        state: "Telangana",
        mandals: [
          {
            id: "mnd_serilingampally",
            name: "Serilingampally",
            villages: [
              { id: "vlg_madhapur", name: "Madhapur", pincode: "500081" },
              { id: "vlg_gachibowli", name: "Gachibowli", pincode: "500032" },
              { id: "vlg_kondapur", name: "Kondapur", pincode: "500084" }
            ]
          },
          {
            id: "mnd_khairatabad",
            name: "Khairatabad",
            villages: [
              { id: "vlg_banjara_hills", name: "Banjara Hills", pincode: "500034" },
              { id: "vlg_jubilee_hills", name: "Jubilee Hills", pincode: "500033" },
              { id: "vlg_somajiguda", name: "Somajiguda", pincode: "500082" }
            ]
          }
        ]
      },
      {
        id: "dist_rangareddy",
        name: "Rangareddy",
        state: "Telangana",
        mandals: [
          {
            id: "mnd_rajendranagar",
            name: "Rajendranagar",
            villages: [
              { id: "vlg_attapur", name: "Attapur", pincode: "500048" },
              { id: "vlg_bandlaguda", name: "Bandlaguda Jagir", pincode: "500086" },
              { id: "vlg_narsingi", name: "Narsingi", pincode: "500075" }
            ]
          },
          {
            id: "mnd_shamshabad",
            name: "Shamshabad",
            villages: [
              { id: "vlg_airport_colony", name: "Airport Colony", pincode: "501218" },
              { id: "vlg_mamidipally", name: "Mamidipally", pincode: "500005" }
            ]
          }
        ]
      },
      {
        id: "dist_medchal",
        name: "Medchal-Malkajgiri",
        state: "Telangana",
        mandals: [
          {
            id: "mnd_kukatpally",
            name: "Kukatpally",
            villages: [
              { id: "vlg_kphb", name: "KPHB Colony", pincode: "500072" },
              { id: "vlg_pragathi", name: "Pragathi Nagar", pincode: "500090" },
              { id: "vlg_nizampet", name: "Nizampet", pincode: "500090" }
            ]
          }
        ]
      }
    ];
    db.save();
  }
};

// 1. Get all locations hierarchy
exports.getAllLocations = (req, res) => {
  ensureLocationsInit();
  res.json({
    success: true,
    count: db.data.locations.length,
    locations: db.data.locations
  });
};

// 2. Add District
exports.createDistrict = (req, res) => {
  ensureLocationsInit();
  const { name, state } = req.body;
  if (!name || !name.trim()) {
    return res.status(400).json({ success: false, message: 'District name is required' });
  }

  const newDistrict = {
    id: `dist_${uuidv4().substring(0, 8)}`,
    name: name.trim(),
    state: state?.trim() || 'Telangana',
    mandals: []
  };

  db.data.locations.push(newDistrict);
  db.save();

  res.status(201).json({
    success: true,
    message: 'District created successfully',
    district: newDistrict,
    locations: db.data.locations
  });
};

// 3. Delete District
exports.deleteDistrict = (req, res) => {
  ensureLocationsInit();
  const { id } = req.params;
  const index = db.data.locations.findIndex(d => d.id === id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'District not found' });
  }

  db.data.locations.splice(index, 1);
  db.save();

  res.json({
    success: true,
    message: 'District deleted successfully',
    locations: db.data.locations
  });
};

// 4. Add Mandal under District
exports.createMandal = (req, res) => {
  ensureLocationsInit();
  const { districtId } = req.params;
  const { name } = req.body;

  const district = db.data.locations.find(d => d.id === districtId);
  if (!district) {
    return res.status(404).json({ success: false, message: 'District not found' });
  }

  if (!name || !name.trim()) {
    return res.status(400).json({ success: false, message: 'Mandal name is required' });
  }

  if (!district.mandals) {
    district.mandals = [];
  }

  const newMandal = {
    id: `mnd_${uuidv4().substring(0, 8)}`,
    name: name.trim(),
    villages: []
  };

  district.mandals.push(newMandal);
  db.save();

  res.status(201).json({
    success: true,
    message: 'Mandal added successfully',
    mandal: newMandal,
    district,
    locations: db.data.locations
  });
};

// 5. Delete Mandal
exports.deleteMandal = (req, res) => {
  ensureLocationsInit();
  const { districtId, mandalId } = req.params;

  const district = db.data.locations.find(d => d.id === districtId);
  if (!district || !district.mandals) {
    return res.status(404).json({ success: false, message: 'District or mandals not found' });
  }

  district.mandals = district.mandals.filter(m => m.id !== mandalId);
  db.save();

  res.json({
    success: true,
    message: 'Mandal deleted successfully',
    district,
    locations: db.data.locations
  });
};

// 6. Add Village under Mandal
exports.createVillage = (req, res) => {
  ensureLocationsInit();
  const { districtId, mandalId } = req.params;
  const { name, pincode } = req.body;

  const district = db.data.locations.find(d => d.id === districtId);
  if (!district || !district.mandals) {
    return res.status(404).json({ success: false, message: 'District not found' });
  }

  const mandal = district.mandals.find(m => m.id === mandalId);
  if (!mandal) {
    return res.status(404).json({ success: false, message: 'Mandal not found' });
  }

  if (!name || !name.trim()) {
    return res.status(400).json({ success: false, message: 'Village/Ward name is required' });
  }

  if (!mandal.villages) {
    mandal.villages = [];
  }

  const newVillage = {
    id: `vlg_${uuidv4().substring(0, 8)}`,
    name: name.trim(),
    pincode: pincode?.trim() || ''
  };

  mandal.villages.push(newVillage);
  db.save();

  res.status(201).json({
    success: true,
    message: 'Village added successfully',
    village: newVillage,
    mandal,
    district,
    locations: db.data.locations
  });
};

// 7. Delete Village
exports.deleteVillage = (req, res) => {
  ensureLocationsInit();
  const { districtId, mandalId, villageId } = req.params;

  const district = db.data.locations.find(d => d.id === districtId);
  if (!district || !district.mandals) {
    return res.status(404).json({ success: false, message: 'District not found' });
  }

  const mandal = district.mandals.find(m => m.id === mandalId);
  if (!mandal || !mandal.villages) {
    return res.status(404).json({ success: false, message: 'Mandal not found' });
  }

  mandal.villages = mandal.villages.filter(v => v.id !== villageId);
  db.save();

  res.json({
    success: true,
    message: 'Village deleted successfully',
    mandal,
    district,
    locations: db.data.locations
  });
};
