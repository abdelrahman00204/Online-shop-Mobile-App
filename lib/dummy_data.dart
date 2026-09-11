// dummy_data.dart
// Dummy data for the Frozen Food Shop Flutter app
// Prices in EGP. Image URLs use Pexels placeholders —
// swap with real product photos before shipping.

import 'dart:math';

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

class Images {
  final String url;
  final bool isPrimary;

  const Images({required this.url, this.isPrimary = false});
}

class SubCategory {
  final String id;
  final String name;
  final String categoryId; // links back to MainCategory.id
  final String imageUrl; // Added imageUrl for subcategory

  const SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.imageUrl,
  });
}

class MainCategory {
  final String id;
  final String name;
  final IconData icon;
  final String imageUrl; // Added imageUrl for main category
  final List<SubCategory> subCategories;

  const MainCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    this.subCategories = const [],
  });
}

class Products {
  final int id;
  final String name;
  final num oldPrice;
  final num newPrice;
  final num? discountPercentage;
  final bool hasDiscount;
  final String unitType; // e.g. "g", "kg", "ml", "L", "pcs"
  final num weight; // numeric magnitude paired with unitType
  final String? description;
  final List<Images> images;
  final String categoryName;
  final String subCategoryName;
  final String brandName;
  final num averageRating;
  final num reviewsCount;
  final bool isAvailable;

  const Products({
    required this.id,
    required this.name,
    required this.oldPrice,
    required this.newPrice,
    this.discountPercentage,
    required this.hasDiscount,
    required this.unitType,
    required this.weight,
    required this.description,
    required this.images,
    required this.categoryName,
    required this.subCategoryName,
    required this.brandName,
    required this.averageRating,
    required this.reviewsCount,
    required this.isAvailable,
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
// Main Categories & Subcategories
// ---------------------------------------------------------------------------

final List<MainCategory> dummyMainCategories = [
  const MainCategory(
    id: 'veg',
    name: 'Frozen Vegetables',
    icon: Icons.eco,
    imageUrl:
        'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
    subCategories: [
      SubCategory(
        id: 'veg-mix',
        name: 'Mixed & Blends',
        categoryId: 'veg',
        imageUrl:
            'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
      ),
      SubCategory(
        id: 'veg-single',
        name: 'Single Vegetables',
        categoryId: 'veg',
        imageUrl:
            'https://images.pexels.com/photos/768090/pexels-photo-768090.jpeg',
      ),
    ],
  ),
  const MainCategory(
    id: 'meat',
    name: 'Frozen Meat',
    icon: Icons.kebab_dining,
    imageUrl:
        'https://images.pexels.com/photos/112781/pexels-photo-112781.jpeg',
    subCategories: [
      SubCategory(
        id: 'meat-beef',
        name: 'Beef',
        categoryId: 'meat',
        imageUrl:
            'https://images.pexels.com/photos/112781/pexels-photo-112781.jpeg',
      ),
      SubCategory(
        id: 'meat-chicken',
        name: 'Chicken',
        categoryId: 'meat',
        imageUrl:
            'https://images.pexels.com/photos/13698108/pexels-photo-13698108.jpeg',
      ),
      SubCategory(
        id: 'meat-lamb',
        name: 'Lamb',
        categoryId: 'meat',
        imageUrl:
            'https://images.pexels.com/photos/17988080/pexels-photo-17988080.jpeg',
      ),
    ],
  ),
  const MainCategory(
    id: 'seafood',
    name: 'Frozen Seafood',
    icon: Icons.set_meal,
    imageUrl:
        'https://images.pexels.com/photos/8352786/pexels-photo-8352786.jpeg',
    subCategories: [
      SubCategory(
        id: 'sea-fish',
        name: 'Fish',
        categoryId: 'seafood',
        imageUrl:
            'https://images.pexels.com/photos/8352786/pexels-photo-8352786.jpeg',
      ),
      SubCategory(
        id: 'sea-shellfish',
        name: 'Shellfish',
        categoryId: 'seafood',
        imageUrl:
            'https://images.pexels.com/photos/8351657/pexels-photo-8351657.jpeg',
      ),
    ],
  ),
  const MainCategory(
    id: 'icecream',
    name: 'Ice Cream & Desserts',
    icon: Icons.icecream,
    imageUrl:
        'https://images.pexels.com/photos/1582628/pexels-photo-1582628.jpeg',
    subCategories: [
      SubCategory(
        id: 'ice-cream',
        name: 'Ice Cream',
        categoryId: 'icecream',
        imageUrl:
            'https://images.pexels.com/photos/1582628/pexels-photo-1582628.jpeg',
      ),
      SubCategory(
        id: 'ice-sorbet',
        name: 'Sorbet',
        categoryId: 'icecream',
        imageUrl:
            'https://images.pexels.com/photos/5060377/pexels-photo-5060377.jpeg',
      ),
    ],
  ),
  const MainCategory(
    id: 'fruit',
    name: 'Frozen Fruits',
    icon: Icons.local_florist,
    imageUrl:
        'https://images.pexels.com/photos/15048305/pexels-photo-15048305.jpeg',
    subCategories: [
      SubCategory(
        id: 'fruit-berries',
        name: 'Berries',
        categoryId: 'fruit',
        imageUrl:
            'https://images.pexels.com/photos/15048305/pexels-photo-15048305.jpeg',
      ),
      SubCategory(
        id: 'fruit-tropical',
        name: 'Tropical',
        categoryId: 'fruit',
        imageUrl:
            'https://images.pexels.com/photos/5150156/pexels-photo-5150156.jpeg',
      ),
    ],
  ),
  const MainCategory(
    id: 'bakery',
    name: 'Frozen Bakery & Dough',
    icon: Icons.bakery_dining,
    imageUrl:
        'https://images.pexels.com/photos/6215300/pexels-photo-6215300.jpeg',
    subCategories: [
      SubCategory(
        id: 'bake-dough',
        name: 'Dough',
        categoryId: 'bakery',
        imageUrl:
            'https://images.pexels.com/photos/10009356/pexels-photo-10009356.jpeg',
      ),
      SubCategory(
        id: 'bake-pastries',
        name: 'Pastries',
        categoryId: 'bakery',
        imageUrl:
            'https://images.pexels.com/photos/6215300/pexels-photo-6215300.jpeg',
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------------

final List<Products> dummyProducts = [
  // Frozen Vegetables
  const Products(
    id: 1,
    name: 'Mixed Vegetables',
    oldPrice: 45.0,
    newPrice: 45.0,
    hasDiscount: false,
    unitType: 'g',
    weight: 500,
    description:
        'A blend of carrots, peas, corn, and green beans, flash-frozen to lock in freshness.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Vegetables',
    subCategoryName: 'Mixed & Blends',
    brandName: 'GreenFrost',
    averageRating: 4.6,
    reviewsCount: 128,
    isAvailable: true,
  ),
  const Products(
    id: 2,
    name: 'Green Peas',
    oldPrice: 38.0,
    newPrice: 32.0,
    discountPercentage: 16,
    hasDiscount: true,
    unitType: 'g',
    weight: 450,
    description: 'Sweet green peas, picked at peak ripeness and snap-frozen.',
    images: [
      Images(
        url: 'https://images.pexels.com/photos/768090/pexels-photo-768090.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Vegetables',
    subCategoryName: 'Single Vegetables',
    brandName: 'GreenFrost',
    averageRating: 4.4,
    reviewsCount: 76,
    isAvailable: true,
  ),
  const Products(
    id: 3,
    name: 'Okra (Bamya)',
    oldPrice: 50.0,
    newPrice: 50.0,
    hasDiscount: false,
    unitType: 'g',
    weight: 500,
    description: 'Whole frozen okra, ready for stews and traditional dishes.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/10487763/pexels-photo-10487763.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Vegetables',
    subCategoryName: 'Single Vegetables',
    brandName: 'GreenFrost',
    averageRating: 4.7,
    reviewsCount: 54,
    isAvailable: true,
  ),

  // Frozen Meat
  const Products(
    id: 4,
    name: 'Beef Cubes',
    oldPrice: 320.0,
    newPrice: 320.0,
    hasDiscount: false,
    unitType: 'kg',
    weight: 1,
    description: 'Premium beef, cubed and quick-frozen for stews and tagines.',
    images: [
      Images(
        url: 'https://images.pexels.com/photos/112781/pexels-photo-112781.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Meat',
    subCategoryName: 'Beef',
    brandName: 'PrimeCut',
    averageRating: 4.5,
    reviewsCount: 92,
    isAvailable: true,
  ),
  const Products(
    id: 5,
    name: 'Chicken Breast Fillets',
    oldPrice: 200.0,
    newPrice: 180.0,
    discountPercentage: 10,
    hasDiscount: true,
    unitType: 'kg',
    weight: 1,
    description: 'Boneless, skinless chicken breast fillets.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/13698108/pexels-photo-13698108.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Meat',
    subCategoryName: 'Chicken',
    brandName: 'PrimeCut',
    averageRating: 4.6,
    reviewsCount: 150,
    isAvailable: true,
  ),
  const Products(
    id: 6,
    name: 'Beef Burger Patties',
    oldPrice: 150.0,
    newPrice: 150.0,
    hasDiscount: false,
    unitType: 'pcs',
    weight: 8,
    description: 'Juicy, seasoned beef patties ready for the grill.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/3877668/pexels-photo-3877668.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Meat',
    subCategoryName: 'Beef',
    brandName: 'PrimeCut',
    averageRating: 4.3,
    reviewsCount: 64,
    isAvailable: true,
  ),
  const Products(
    id: 7,
    name: 'Lamb Chops',
    oldPrice: 410.0,
    newPrice: 410.0,
    hasDiscount: false,
    unitType: 'kg',
    weight: 1,
    description: 'Tender lamb chops, individually quick-frozen.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/17988080/pexels-photo-17988080.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Meat',
    subCategoryName: 'Lamb',
    brandName: 'PrimeCut',
    averageRating: 4.7,
    reviewsCount: 38,
    isAvailable: true,
  ),

  // Frozen Seafood
  const Products(
    id: 8,
    name: 'Tilapia Fillets',
    oldPrice: 140.0,
    newPrice: 140.0,
    hasDiscount: false,
    unitType: 'kg',
    weight: 1,
    description: 'Boneless tilapia fillets, mild flavor, great for frying.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/8352786/pexels-photo-8352786.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Seafood',
    subCategoryName: 'Fish',
    brandName: 'OceanCatch',
    averageRating: 4.4,
    reviewsCount: 47,
    isAvailable: true,
  ),
  const Products(
    id: 9,
    name: 'Shrimp (Peeled & Deveined)',
    oldPrice: 290.0,
    newPrice: 260.0,
    discountPercentage: 10,
    hasDiscount: true,
    unitType: 'g',
    weight: 500,
    description: 'Cleaned and deveined shrimp, ready to cook.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/8351657/pexels-photo-8351657.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Seafood',
    subCategoryName: 'Shellfish',
    brandName: 'OceanCatch',
    averageRating: 4.8,
    reviewsCount: 133,
    isAvailable: true,
  ),

  // Ice Cream & Desserts
  const Products(
    id: 10,
    name: 'Vanilla Ice Cream Tub',
    oldPrice: 95.0,
    newPrice: 95.0,
    hasDiscount: false,
    unitType: 'L',
    weight: 1,
    description: 'Classic creamy vanilla ice cream.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/1582628/pexels-photo-1582628.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Ice Cream & Desserts',
    subCategoryName: 'Ice Cream',
    brandName: 'Creamy',
    averageRating: 4.5,
    reviewsCount: 187,
    isAvailable: true,
  ),
  const Products(
    id: 11,
    name: 'Chocolate Fudge Ice Cream',
    oldPrice: 120.0,
    newPrice: 105.0,
    discountPercentage: 13,
    hasDiscount: true,
    unitType: 'L',
    weight: 1,
    description: 'Rich chocolate ice cream swirled with fudge.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/14132776/pexels-photo-14132776.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Ice Cream & Desserts',
    subCategoryName: 'Ice Cream',
    brandName: 'Creamy',
    averageRating: 4.7,
    reviewsCount: 204,
    isAvailable: true,
  ),
  const Products(
    id: 12,
    name: 'Mango Sorbet',
    oldPrice: 88.0,
    newPrice: 88.0,
    hasDiscount: false,
    unitType: 'ml',
    weight: 750,
    description: 'Refreshing dairy-free mango sorbet.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/5060377/pexels-photo-5060377.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Ice Cream & Desserts',
    subCategoryName: 'Sorbet',
    brandName: 'Creamy',
    averageRating: 4.3,
    reviewsCount: 41,
    isAvailable: true,
  ),

  // Frozen Fruits
  const Products(
    id: 13,
    name: 'Mixed Berries',
    oldPrice: 85.0,
    newPrice: 75.0,
    discountPercentage: 12,
    hasDiscount: true,
    unitType: 'g',
    weight: 400,
    description:
        'Strawberries, blueberries, and raspberries, individually frozen.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/15048305/pexels-photo-15048305.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Fruits',
    subCategoryName: 'Berries',
    brandName: 'GreenFrost',
    averageRating: 4.6,
    reviewsCount: 89,
    isAvailable: true,
  ),
  const Products(
    id: 14,
    name: 'Mango Chunks',
    oldPrice: 60.0,
    newPrice: 60.0,
    hasDiscount: false,
    unitType: 'g',
    weight: 500,
    description: 'Sweet mango chunks, great for smoothies.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/5150156/pexels-photo-5150156.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Fruits',
    subCategoryName: 'Tropical',
    brandName: 'GreenFrost',
    averageRating: 4.5,
    reviewsCount: 61,
    isAvailable: true,
  ),
  const Products(
    id: 15,
    name: 'Sliced Strawberries',
    oldPrice: 58.0,
    newPrice: 58.0,
    hasDiscount: false,
    unitType: 'g',
    weight: 450,
    description: 'Ripe strawberries, sliced and quick-frozen.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/4038803/pexels-photo-4038803.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Fruits',
    subCategoryName: 'Berries',
    brandName: 'GreenFrost',
    averageRating: 4.4,
    reviewsCount: 45,
    isAvailable: true,
  ),

  // Frozen Bakery & Dough
  const Products(
    id: 16,
    name: 'Puff Pastry Sheets',
    oldPrice: 48.0,
    newPrice: 48.0,
    hasDiscount: false,
    unitType: 'g',
    weight: 500,
    description: 'Ready-to-bake puff pastry sheets.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/6215300/pexels-photo-6215300.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Bakery & Dough',
    subCategoryName: 'Pastries',
    brandName: 'BakeEasy',
    averageRating: 4.3,
    reviewsCount: 67,
    isAvailable: true,
  ),
  const Products(
    id: 17,
    name: 'Frozen Pizza Dough Balls',
    oldPrice: 45.0,
    newPrice: 40.0,
    discountPercentage: 11,
    hasDiscount: true,
    unitType: 'pcs',
    weight: 4,
    description: 'Pre-portioned pizza dough balls, just thaw and roll.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/10009356/pexels-photo-10009356.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Bakery & Dough',
    subCategoryName: 'Dough',
    brandName: 'BakeEasy',
    averageRating: 4.2,
    reviewsCount: 39,
    isAvailable: true,
  ),
  const Products(
    id: 18,
    name: 'Frozen Croissants (Unbaked)',
    oldPrice: 80.0,
    newPrice: 70.0,
    discountPercentage: 13,
    hasDiscount: true,
    unitType: 'pcs',
    weight: 6,
    description: 'Bake-at-home butter croissants.',
    images: [
      Images(
        url:
            'https://images.pexels.com/photos/29407561/pexels-photo-29407561.jpeg',
        isPrimary: true,
      ),
    ],
    categoryName: 'Frozen Bakery & Dough',
    subCategoryName: 'Pastries',
    brandName: 'BakeEasy',
    averageRating: 4.6,
    reviewsCount: 102,
    isAvailable: true,
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
          productId: product.id.toString(),
          branchId: branch.id,
          inStock: inStock,
          quantity: inStock ? 5 + random.nextInt(46) : 0,
        ),
      );
    }
  }
  return stock;
}
