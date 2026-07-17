// dummy_data.dart
// Dummy data for the Frozen Food Shop Flutter app
// Prices in EGP. Image URLs use picsum.photos seeded placeholders —
// swap with real product photos before shipping.

import 'dart:math';

import 'package:flutter/material.dart';

class ProductCategory {
  final String id;
  final String name;
  final IconData icon; // Material icon name, e.g. Icons.eco

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final double? oldPrice; // null if no discount
  final String unit; // e.g. "500 g", "1 kg", "6 pcs"
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> branchIds;
  bool isFavorite;
  bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.oldPrice,
    required this.unit,
    required this.imageUrl,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.description = '',
    this.isFavorite = false,
    this.inStock = true,
    required this.branchIds,
  });
}

class Branch {
  final String id;
  final String name;
  final String city;
  final String address;
  final String phone;

  const Branch({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
  });
}

/// Junction table linking a product to a branch — mirrors a real
/// `branch_stock` table you'd have in SQL (productId, branchId, inStock, quantity).
/// Not every product/branch pair has a row: if no row exists, that branch
/// simply doesn't carry that product at all.
class BranchStock {
  final String productId;
  final String branchId;
  final bool inStock;
  final int quantity;

  const BranchStock({
    required this.productId,
    required this.branchId,
    required this.inStock,
    this.quantity = 0,
  });
}

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------

final List<ProductCategory> dummyCategories = [
  const ProductCategory(id: 'veg',      name: 'Frozen Vegetables',       icon: Icons.eco),
const ProductCategory(id: 'meat',     name: 'Frozen Meat',             icon: Icons.kebab_dining),
const ProductCategory(id: 'seafood',  name: 'Frozen Seafood',          icon: Icons.set_meal),
const ProductCategory(id: 'icecream', name: 'Ice Cream & Desserts',    icon: Icons.icecream),
const ProductCategory(id: 'fruit',    name: 'Frozen Fruits',           icon: Icons.local_florist),
const ProductCategory(id: 'bakery',   name: 'Frozen Bakery & Dough',   icon: Icons.bakery_dining),
];

// ---------------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------------

final List<Product> dummyProducts = [
  // Frozen Vegetables
  Product(
    id: 'p001',
    name: 'Mixed Vegetables',
    categoryId: 'veg',
    branchIds: [
      'b1',
      'b2',
      'b3',
      'b4',
      'b5',
      'b6',
      'b7',
      'b8',
    ], // all branches – staple item
    price: 45.0,
    unit: '500 g',
    imageUrl:
        'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
    rating: 4.6,
    reviewCount: 128,
    description:
        'A blend of carrots, peas, corn, and green beans, flash-frozen to lock in freshness.',
  ),
  Product(
    id: 'p002',
    name: 'Green Peas',
    categoryId: 'veg',
    branchIds: ['b1', 'b3', 'b5', 'b7'], // 4 branches
    price: 32.0,
    oldPrice: 38.0,
    unit: '450 g',
    imageUrl:
        'https://images.pexels.com/photos/768090/pexels-photo-768090.jpeg',
    rating: 4.4,
    reviewCount: 76,
    description: 'Sweet green peas, picked at peak ripeness and snap-frozen.',
  ),
  Product(
    id: 'p003',
    name: 'Okra (Bamya)',
    categoryId: 'veg',
    branchIds: ['b3'], // single branch
    price: 50.0,
    unit: '500 g',
    imageUrl:
        'https://images.pexels.com/photos/10487763/pexels-photo-10487763.jpeg',
    rating: 4.7,
    reviewCount: 54,
    description: 'Whole frozen okra, ready for stews and traditional dishes.',
  ),

  // Frozen Meat
  Product(
    id: 'p101',
    name: 'Beef Cubes',
    categoryId: 'meat',
    branchIds: ['b2', 'b4', 'b6'], // 3 branches
    price: 320.0,
    unit: '1 kg',
    imageUrl:
        'https://images.pexels.com/photos/112781/pexels-photo-112781.jpeg',
    rating: 4.5,
    reviewCount: 92,
    description: 'Premium beef, cubed and quick-frozen for stews and tagines.',
  ),
  Product(
    id: 'p102',
    name: 'Chicken Breast Fillets',
    categoryId: 'meat',
    branchIds: [
      'b1',
      'b2',
      'b3',
      'b4',
      'b5',
      'b6',
      'b7',
      'b8',
    ], // all branches – most popular
    price: 180.0,
    oldPrice: 200.0,
    unit: '1 kg',
    imageUrl:
        'https://images.pexels.com/photos/13698108/pexels-photo-13698108.jpeg',
    rating: 4.6,
    reviewCount: 150,
    description: 'Boneless, skinless chicken breast fillets.',
  ),
  Product(
    id: 'p103',
    name: 'Beef Burger Patties',
    categoryId: 'meat',
    branchIds: ['b1', 'b2', 'b5'], // 3 branches
    price: 150.0,
    unit: '8 pcs',
    imageUrl:
        'https://images.pexels.com/photos/3877668/pexels-photo-3877668.jpeg',
    rating: 4.3,
    reviewCount: 64,
    description: 'Juicy, seasoned beef patties ready for the grill.',
  ),
  Product(
    id: 'p104',
    name: 'Lamb Chops',
    categoryId: 'meat',
    branchIds: ['b5'], // single branch – premium/limited item
    price: 410.0,
    unit: '1 kg',
    imageUrl:
        'https://images.pexels.com/photos/17988080/pexels-photo-17988080.jpeg',
    rating: 4.7,
    reviewCount: 38,
    description: 'Tender lamb chops, individually quick-frozen.',
  ),

  // Frozen Seafood
  Product(
    id: 'p201',
    name: 'Tilapia Fillets',
    categoryId: 'seafood',
    branchIds: ['b2', 'b4', 'b7', 'b8'], // 4 branches
    price: 140.0,
    unit: '1 kg',
    imageUrl:
        'https://images.pexels.com/photos/8352786/pexels-photo-8352786.jpeg',
    rating: 4.4,
    reviewCount: 47,
    description: 'Boneless tilapia fillets, mild flavor, great for frying.',
  ),
  Product(
    id: 'p202',
    name: 'Shrimp (Peeled & Deveined)',
    categoryId: 'seafood',
    branchIds: [
      'b1',
      'b2',
      'b3',
      'b4',
      'b5',
      'b6',
      'b7',
      'b8',
    ], // all branches – high demand
    price: 260.0,
    oldPrice: 290.0,
    unit: '500 g',
    imageUrl:
        'https://images.pexels.com/photos/8351657/pexels-photo-8351657.jpeg',
    rating: 4.8,
    reviewCount: 133,
    description: 'Cleaned and deveined shrimp, ready to cook.',
  ),

  // Ice Cream & Desserts
  Product(
    id: 'p301',
    name: 'Vanilla Ice Cream Tub',
    categoryId: 'icecream',
    branchIds: [
      'b1',
      'b2',
      'b3',
      'b4',
      'b5',
      'b6',
      'b7',
      'b8',
    ], // all branches – classic
    price: 95.0,
    unit: '1 L',
    imageUrl:
        'https://images.pexels.com/photos/1582628/pexels-photo-1582628.jpeg',
    rating: 4.5,
    reviewCount: 187,
    description: 'Classic creamy vanilla ice cream.',
  ),
  Product(
    id: 'p302',
    name: 'Chocolate Fudge Ice Cream',
    categoryId: 'icecream',
    branchIds: ['b1', 'b3', 'b5', 'b6', 'b8'], // 5 branches
    price: 105.0,
    unit: '1 L',
    imageUrl:
        'https://images.pexels.com/photos/14132776/pexels-photo-14132776.jpeg',
    rating: 4.7,
    reviewCount: 204,
    description: 'Rich chocolate ice cream swirled with fudge.',
  ),
  Product(
    id: 'p303',
    name: 'Mango Sorbet',
    categoryId: 'icecream',
    branchIds: ['b6'], // single branch
    price: 88.0,
    unit: '750 ml',
    imageUrl:
        'https://images.pexels.com/photos/5060377/pexels-photo-5060377.jpeg',
    rating: 4.3,
    reviewCount: 41,
    description: 'Refreshing dairy-free mango sorbet.',
  ),

  // Frozen Fruits
  Product(
    id: 'p501',
    name: 'Mixed Berries',
    categoryId: 'fruit',
    branchIds: ['b2', 'b4', 'b6', 'b8'], // 4 branches
    price: 75.0,
    unit: '400 g',
    imageUrl:
        'https://images.pexels.com/photos/15048305/pexels-photo-15048305.jpeg',
    rating: 4.6,
    reviewCount: 89,
    description:
        'Strawberries, blueberries, and raspberries, individually frozen.',
  ),
  Product(
    id: 'p502',
    name: 'Mango Chunks',
    categoryId: 'fruit',
    branchIds: ['b1', 'b3', 'b5', 'b7', 'b8'], // 5 branches
    price: 60.0,
    unit: '500 g',
    imageUrl:
        'https://images.pexels.com/photos/5150156/pexels-photo-5150156.jpeg',
    rating: 4.5,
    reviewCount: 61,
    description: 'Sweet mango chunks, great for smoothies.',
  ),
  Product(
    id: 'p503',
    name: 'Sliced Strawberries',
    categoryId: 'fruit',
    branchIds: ['b1'], // single branch
    price: 58.0,
    unit: '450 g',
    imageUrl:
        'https://images.pexels.com/photos/4038803/pexels-photo-4038803.jpeg',
    rating: 4.4,
    reviewCount: 45,
    description: 'Ripe strawberries, sliced and quick-frozen.',
  ),

  // Frozen Bakery & Dough
  Product(
    id: 'p601',
    name: 'Puff Pastry Sheets',
    categoryId: 'bakery',
    branchIds: ['b3', 'b5', 'b7'], // 3 branches
    price: 48.0,
    unit: '500 g',
    imageUrl:
        'https://images.pexels.com/photos/6215300/pexels-photo-6215300.jpeg',
    rating: 4.3,
    reviewCount: 67,
    description: 'Ready-to-bake puff pastry sheets.',
  ),
  Product(
    id: 'p602',
    name: 'Frozen Pizza Dough Balls',
    categoryId: 'bakery',
    branchIds: ['b2', 'b6'], // 2 branches
    price: 40.0,
    unit: '4 pcs',
    imageUrl:
        'https://images.pexels.com/photos/10009356/pexels-photo-10009356.jpeg',
    rating: 4.2,
    reviewCount: 39,
    description: 'Pre-portioned pizza dough balls, just thaw and roll.',
  ),
  Product(
    id: 'p603',
    name: 'Frozen Croissants (Unbaked)',
    categoryId: 'bakery',
    branchIds: ['b1', 'b4', 'b6', 'b8'], // 4 branches
    price: 70.0,
    oldPrice: 80.0,
    unit: '6 pcs',
    imageUrl:
        'https://images.pexels.com/photos/29407561/pexels-photo-29407561.jpeg',
    rating: 4.6,
    reviewCount: 102,
    description: 'Bake-at-home butter croissants.',
  ),
];

// ---------------------------------------------------------------------------
// Branches
// ---------------------------------------------------------------------------

final List<Branch> dummyBranches = [
  const Branch(
    id: 'b1',
    name: 'Branch1',
    city: 'Sohag',
    address: 'Al Gomhoria St, Sohag',
    phone: '0934567801',
  ),
  const Branch(
    id: 'b2',
    name: 'Branch2',
    city: 'Cairo',
    address: 'Nasr City, Cairo',
    phone: '0227654802',
  ),
  const Branch(
    id: 'b3',
    name: 'Branch3',
    city: 'Giza',
    address: 'Dokki, Giza',
    phone: '0233452803',
  ),
  const Branch(
    id: 'b4',
    name: 'Branch4',
    city: 'Alexandria',
    address: 'Smouha, Alexandria',
    phone: '0354321804',
  ),
  const Branch(
    id: 'b5',
    name: 'Branch5',
    city: 'Assiut',
    address: 'Al Walidia, Assiut',
    phone: '0882345805',
  ),
  const Branch(
    id: 'b6',
    name: 'Branch6',
    city: 'Qena',
    address: 'Corniche St, Qena',
    phone: '0965432806',
  ),
  const Branch(
    id: 'b7',
    name: 'Branch7',
    city: 'Luxor',
    address: 'Karnak St, Luxor',
    phone: '0952341807',
  ),
  const Branch(
    id: 'b8',
    name: 'Branch8',
    city: 'Minya',
    address: 'Central Minya',
    phone: '0863452808',
  ),
];

// ---------------------------------------------------------------------------
// Branch Stock
// ---------------------------------------------------------------------------
// Generated with a fixed seed so the data is varied but reproducible every
// time the app runs: each product randomly lands in 1–8 branches, and within
// those branches it has an 80% chance of currently being in stock (the rest
// are "carried here but temporarily out of stock").

final List<BranchStock> dummyBranchStock = _generateBranchStock();

List<BranchStock> _generateBranchStock() {
  final random = Random(42);
  final List<BranchStock> stock = [];

  for (final product in dummyProducts) {
    final branchCount = 1 + random.nextInt(dummyBranches.length); // 1..8
    final shuffled = [...dummyBranches]..shuffle(random);
    final carryingBranches = shuffled.take(branchCount);

    for (final branch in carryingBranches) {
      final inStock = random.nextDouble() > 0.2; // ~80% in stock
      stock.add(
        BranchStock(
          productId: product.id,
          branchId: branch.id,
          inStock: inStock,
          quantity: inStock ? 5 + random.nextInt(46) : 0,
        ),
      );
    }
  }
  return stock;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns all products belonging to the given category id.
List<Product> getProductsByCategory(String categoryId) {
  return dummyProducts.where((p) => p.categoryId == categoryId).toList();
}

/// Returns a category by its id, or null if not found.
ProductCategory? getCategoryById(String id) {
  try {
    return dummyCategories.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

/// Products currently on discount (oldPrice is set and higher than price).
List<Product> get discountedProducts => dummyProducts
    .where((p) => p.oldPrice != null && p.oldPrice! > p.price)
    .toList();

/// Products marked as favorite, useful for seeding a "Favorites" screen.
List<Product> get favoriteProducts =>
    dummyProducts.where((p) => p.isFavorite).toList();

/// Top-rated products, useful for a "Featured" or "Popular" section.
List<Product> get featuredProducts {
  final sorted = [...dummyProducts]
    ..sort((a, b) => b.rating.compareTo(a.rating));
  return sorted.take(6).toList();
}

// --- Branch-aware helpers ---------------------------------------------------

/// All branches that carry [productId] at all (in stock or temporarily not).
List<Branch> getBranchesCarrying(String productId) {
  final ids = dummyBranchStock
      .where((s) => s.productId == productId)
      .map((s) => s.branchId)
      .toSet();
  return dummyBranches.where((b) => ids.contains(b.id)).toList();
}

/// Branches where [productId] is currently in stock (qty > 0).
List<Branch> getBranchesInStock(String productId) {
  final ids = dummyBranchStock
      .where((s) => s.productId == productId && s.inStock)
      .map((s) => s.branchId)
      .toSet();
  return dummyBranches.where((b) => ids.contains(b.id)).toList();
}

/// All products carried by [branchId], regardless of current stock.
List<Product> getProductsForBranch(String branchId) {
  final ids = dummyBranchStock
      .where((s) => s.branchId == branchId)
      .map((s) => s.productId)
      .toSet();
  return dummyProducts.where((p) => ids.contains(p.id)).toList();
}

/// Products currently in stock (qty > 0) at [branchId].
List<Product> getAvailableProductsForBranch(String branchId) {
  final ids = dummyBranchStock
      .where((s) => s.branchId == branchId && s.inStock)
      .map((s) => s.productId)
      .toSet();
  return dummyProducts.where((p) => ids.contains(p.id)).toList();
}

/// Whether [productId] is currently in stock at [branchId].
/// Returns false both when the branch doesn't carry it and when it's
/// temporarily out of stock there.
bool isProductAvailableAt(String productId, String branchId) {
  final match = dummyBranchStock.where(
    (s) => s.productId == productId && s.branchId == branchId,
  );
  return match.isNotEmpty && match.first.inStock;
}

/// Remaining quantity of [productId] at [branchId]. Returns 0 if the branch
/// doesn't carry it or it's out of stock.
int getQuantityAt(String productId, String branchId) {
  final match = dummyBranchStock.where(
    (s) => s.productId == productId && s.branchId == branchId,
  );
  return match.isEmpty ? 0 : match.first.quantity;
}

/// Products carried by only a single branch — useful for testing
/// "limited availability" badges in the UI.
List<Product> get singleBranchProducts {
  return dummyProducts
      .where((p) => getBranchesCarrying(p.id).length == 1)
      .toList();
}

/// Products carried by every branch — useful for a "Available everywhere"
/// filter or for sanity-checking the generator.
List<Product> get allBranchProducts {
  return dummyProducts
      .where((p) => getBranchesCarrying(p.id).length == dummyBranches.length)
      .toList();
}
