import 'package:flutter/material.dart';
import 'package:responsi_123220177/models/smartphone.dart';
import 'package:responsi_123220177/services/api_services.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _websiteController = TextEditingController();
  int _ram = 4;
  int _storage = 128;
  bool _isLoading = false;

  final List<int> _ramOptions = [2, 4, 6, 8, 12, 16];
  final List<int> _storageOptions = [128, 256, 512];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Smartphone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Brand',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the brand';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (USD)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website URL (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _ram,
                  items:
                      _ramOptions.map((ram) {
                        return DropdownMenuItem(
                          value: ram,
                          child: Text('$ram GB'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _ram = value!);
                  },
                  decoration: const InputDecoration(
                    labelText: 'RAM',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value % 2 != 0) {
                      return 'RAM must be multiple of 2';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _storage,
                  items:
                      _storageOptions.map((storage) {
                        return DropdownMenuItem(
                          value: storage,
                          child: Text('$storage GB'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _storage = value!);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Storage',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Add Smartphone'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final smartphone = Smartphone(
        id: 0, // ID akan digenerate oleh server
        model: _modelController.text,
        brand: _brandController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        ram: _ram,
        storage: _storage,
        websiteUrl:
            _websiteController.text.isNotEmpty ? _websiteController.text : null,
      );

      try {
        await ApiService().createSmartphone(smartphone);
        Navigator.pop(context, true); // Return true untuk trigger refresh
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _modelController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}
