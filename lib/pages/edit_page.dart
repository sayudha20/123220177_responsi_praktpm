import 'package:flutter/material.dart';
import 'package:responsi_123220177/models/smartphone.dart';
import 'package:responsi_123220177/services/api_services.dart';

class EditPage extends StatefulWidget {
  final Smartphone smartphone;

  const EditPage({Key? key, required this.smartphone}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final Smartphone _originalSmartphone;
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _websiteController = TextEditingController();
  late int _ram;
  late int _storage;
  bool _isLoading = false;

  final List<int> _ramOptions = [2, 4, 6, 8, 12, 16];
  final List<int> _storageOptions = [128, 256, 512];

  @override
  void initState() {
    super.initState();
    _originalSmartphone = widget.smartphone;
    _modelController.text = _originalSmartphone.model;
    _brandController.text = _originalSmartphone.brand;
    _priceController.text = _originalSmartphone.price.toString();
    _imageUrlController.text = _originalSmartphone.imageUrl;
    _websiteController.text = _originalSmartphone.websiteUrl ?? '';
    _ram = _originalSmartphone.ram;
    _storage = _originalSmartphone.storage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Smartphone')),
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
                    labelText: 'Brand*',
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
                    labelText: 'Price*',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website URL',
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
                    labelText: 'RAM* (multiple of 2)',
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
                    labelText: 'Storage*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || !_storageOptions.contains(value)) {
                      return 'Storage must be 128, 256, or 512 GB';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Update Smartphone'),
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

      final updatedSmartphone = Smartphone(
        id: _originalSmartphone.id,
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
        await ApiService().updateSmartphone(updatedSmartphone);
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
