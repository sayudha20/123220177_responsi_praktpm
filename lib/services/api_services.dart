import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/smartphone.dart';

class ApiService {
  static const String baseUrl =
      'https://tpm-api-responsi-e-f-872136705893.us-central1.run.app/api/v1';

  Future<List<Smartphone>> getSmartphones() async {
    final response = await http.get(
      Uri.parse('$baseUrl/phones'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(json.decode(response.body));
      if (apiResponse.status == 'Success') {
        List<dynamic> data = apiResponse.data;
        return data.map((json) => Smartphone.fromJson(json)).toList();
      } else {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception('Failed to load smartphones: ${response.statusCode}');
    }
  }

  Future<Smartphone> getSmartphoneDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/phones/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(json.decode(response.body));
      if (apiResponse.status == 'Success') {
        return Smartphone.fromJson(apiResponse.data);
      } else {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception(
        'Failed to load smartphone details: ${response.statusCode}',
      );
    }
  }

  Future<Smartphone> createSmartphone(Smartphone smartphone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phones'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(smartphone.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final apiResponse = ApiResponse.fromJson(json.decode(response.body));
      if (apiResponse.status == 'Success') {
        return Smartphone.fromJson(apiResponse.data);
      } else {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception('Failed to create smartphone: ${response.statusCode}');
    }
  }

  Future<void> updateSmartphone(Smartphone smartphone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/phones/${smartphone.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(smartphone.toJson()),
    );

    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(json.decode(response.body));
      if (apiResponse.status != 'Success') {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception('Failed to update smartphone: ${response.statusCode}');
    }
  }

  Future<void> deleteSmartphone(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/phones/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(json.decode(response.body));
      if (apiResponse.status != 'Success') {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception('Failed to delete smartphone: ${response.statusCode}');
    }
  }
}
