class Smartphone {
  final int id;
  final String model;
  final String brand;
  final double price;
  final String imageUrl;
  final int ram;
  final int storage;
  final String? websiteUrl;

  Smartphone({
    required this.id,
    required this.model,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.ram,
    required this.storage,
    this.websiteUrl,
  });

  factory Smartphone.fromJson(Map<String, dynamic> json) {
    return Smartphone(
      id: json['id'] as int,
      model: json['model'],
      brand: json['brand'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      ram: json['ram'] ?? 4,
      storage: json['storage'] ?? 128,
      websiteUrl: json['websiteUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'brand': brand,
      'price': price,
      if (ram != null) 'ram': ram,
      if (storage != null) 'storage': storage,
      if (imageUrl.isNotEmpty) 'imageUrl': imageUrl,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
    };
  }
}

class ApiResponse {
  final String status;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}
