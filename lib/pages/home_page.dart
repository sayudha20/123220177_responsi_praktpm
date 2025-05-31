import 'package:flutter/material.dart';
import 'package:responsi_123220177/models/smartphone.dart';
import 'package:responsi_123220177/services/api_services.dart';
import 'package:responsi_123220177/services/auth_services.dart';
import 'package:responsi_123220177/widgets/smartphone_card.dart';
import 'package:responsi_123220177/pages/edit_page.dart';
import 'package:responsi_123220177/pages/login_page.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  late Future<List<Smartphone>> _smartphonesFuture;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _smartphonesFuture = _apiService.getSmartphones();
  }

  Future<void> _checkAuth() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
    final username = await authService.getUsername();

    if (!isLoggedIn || username != AuthService.validUsername) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _loadUsername() async {
    final username = await _authService.getUsername();
    setState(() => _username = username);
  }

  Future<void> _refreshData() async {
    setState(() {
      _smartphonesFuture = _apiService.getSmartphones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_username != null ? 'Halo, $_username' : 'Smartphones'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Smartphone>>(
          future: _smartphonesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No smartphones found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final smartphone = snapshot.data![index];
                  return SmartphoneCard(
                    smartphone: smartphone,
                    onTap: () => _navigateToDetail(smartphone.id),
                    onEdit: () => _navigateToEdit(smartphone),
                    onDelete: () => _deleteSmartphone(smartphone.id),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToDetail(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(smartphoneId: id)),
    );
  }

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePage()),
    ).then((_) => _refreshData());
  }

  void _navigateToEdit(Smartphone smartphone) async {
    final fullSmartphone = await _apiService.getSmartphoneDetail(smartphone.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(smartphone: fullSmartphone),
      ),
    ).then((_) => _refreshData());
  }

  // Di bagian _deleteSmartphone:
  Future<void> _deleteSmartphone(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this smartphone?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteSmartphone(id);
        _refreshData();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Phone Removed')));
      } catch (e) {
        // Handle error khusus untuk 10 HP pertama
        if (e.toString().contains('Khusus HP ini gabisa dihapus')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Khusus HP ini gabisa dihapus')),
          );
        }
        // Handle error phone not found
        else if (e.toString().contains('Phone not found')) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Phone not found 😮')));
        }
        // Handle error lainnya
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Khusus HP ini gabisa dihapus')),
          );
        }
      }
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
