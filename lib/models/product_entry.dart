// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    String id;
    String name;
    String brand;
    String category;
    String size;
    String description;
    int price;
    int stock;
    String thumbnail;
    bool isFeatured;
    int userId;

    ProductEntry({
        required this.id,
        required this.name,
        required this.brand,
        required this.category,
        required this.size,
        required this.description,
        required this.price,
        required this.stock,
        required this.thumbnail,
        required this.isFeatured,
        required this.userId,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        id: json["id"],
        name: json["name"],
        brand: json["brand"],
        category: json["category"],
        size: json["size"],
        description: json["description"],
        price: json["price"],
        stock: json["stock"],
        thumbnail: json["thumbnail"],
        isFeatured: json["is_featured"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "brand": brand,
        "category": category,
        "size": size,
        "description": description,
        "price": price,
        "stock": stock,
        "thumbnail": thumbnail,
        "is_featured": isFeatured,
        "user_id": userId,
    };
}
