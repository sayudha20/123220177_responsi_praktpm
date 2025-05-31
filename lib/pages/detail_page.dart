import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:responsi_123220177/models/smartphone.dart';
import 'package:responsi_123220177/services/api_services.dart';

class DetailPage extends StatefulWidget {
  final int smartphoneId; // Ubah dari String ke int

  const DetailPage({Key? key, required this.smartphoneId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Smartphone> _smartphoneFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _smartphoneFuture = _apiService.getSmartphoneDetail(widget.smartphoneId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smartphone Details')),
      body: FutureBuilder<Smartphone>(
        future: _smartphoneFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final phone = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      phone.imageUrl,
                      height: 200,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.phone_android, size: 200),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Model: ${phone.model}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Brand: ${phone.brand}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Price: \$${phone.price}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'RAM: ${phone.ram} GB',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Storage: ${phone.storage} GB',
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (phone.websiteUrl != null) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _launchWebsite(phone.websiteUrl!),
                        child: const Text('Visit Website'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _launchWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }
}
