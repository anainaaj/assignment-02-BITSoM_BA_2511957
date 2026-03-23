
//Q:2.2. MongoDB Operations for E-Commerce Product Catalog
// Collection name: products

// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    _id: "prod_001",
    category: "Electronics",
    name: "Samsung 4K Smart TV - 55 inch",
    brand: "Samsung",
    price: 55000,
    currency: "INR",
    in_stock: true,
    quantity_available: 12,
    specs: {
      screen_size_inch: 55,
      resolution: "4K UHD (3840 x 2160)",
      voltage: "220V",
      power_consumption_watts: 120,
      connectivity: ["WiFi", "Bluetooth", "HDMI x3", "USB x2"]
    },
    warranty: {
      duration_years: 2,
      type: "Manufacturer Warranty",
      covers: ["Manufacturing defects", "Panel issues"]
    },
    ratings: { average: 4.3, total_reviews: 284 },
    tags: ["television", "smart tv", "4k", "samsung"]
  },
  {
    _id: "prod_002",
    category: "Clothing",
    name: "Men's Regular Fit Cotton Shirt",
    brand: "Arrow",
    price: 1299,
    currency: "INR",
    in_stock: true,
    variants: [
      { size: "S",  color: "White", quantity_available: 20 },
      { size: "M",  color: "White", quantity_available: 35 },
      { size: "L",  color: "White", quantity_available: 18 },
      { size: "M",  color: "Blue",  quantity_available: 25 },
      { size: "L",  color: "Blue",  quantity_available: 10 }
    ],
    material: "100% Cotton",
    care_instructions: [
      "Machine wash cold",
      "Do not bleach",
      "Tumble dry low",
      "Iron on medium heat"
    ],
    fit_type: "Regular Fit",
    occasion: ["Casual", "Semi-formal"],
    ratings: { average: 4.1, total_reviews: 512 },
    tags: ["shirt", "men", "cotton", "formal", "arrow"]
  },
  {
    _id: "prod_003",
    category: "Groceries",
    name: "Amul Full Cream Milk - 1 Litre",
    brand: "Amul",
    price: 68,
    currency: "INR",
    in_stock: true,
    quantity_available: 200,
    dates: {
      manufactured_on: "2024-12-20",
      expiry_date: "2024-12-27",
      best_before_days: 7
    },
    storage_instructions: "Keep refrigerated below 4°C",
    nutritional_info_per_100ml: {
      energy_kcal: 61,
      protein_g: 3.2,
      fat_g: 3.5,
      carbohydrates_g: 4.7,
      calcium_mg: 120
    },
    certifications: ["FSSAI Approved", "ISO 22000"],
    allergens: ["Contains Milk"],
    package: { type: "Tetra Pack", volume_ml: 1000, weight_g: 1030 },
    ratings: { average: 4.6, total_reviews: 1830 },
    tags: ["milk", "dairy", "amul", "full cream"]
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000

db.products.find(
  {
    category: "Electronics",
    price: { $gt: 20000 }
  }
);

// OP3: find() — retrieve all Groceries expiring before 2025-01-01

db.products.find(
  {
    category: "Groceries",
    "dates.expiry_date": { $lt: "2025-01-01" }
  }
);

// OP4: updateOne() — add a "discount_percent" field to a specific product

db.products.updateOne(
  { _id: "prod_001" },
  { $set: { discount_percent: 10 } }
);

// OP5: createIndex() — create an index on the category field

db.products.createIndex(
  { category: 1 }
);