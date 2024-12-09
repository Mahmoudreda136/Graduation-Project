import 'dart:io';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'globals.dart';
import 'main.dart';
import 'for rent/rent_page.dart';

class OurServicesPage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userImage;

  const OurServicesPage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userImage,
  }) : super(key: key);

  @override
  State<OurServicesPage> createState() => _OurServicesPageState();
}

class _OurServicesPageState extends State<OurServicesPage> {
  late String userName;
  late String userEmail;
  late String userImage;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    userEmail = widget.userEmail;
    userImage = widget.userImage;
  }

  void updateProfile(String name, String email, String image) {
    setState(() {
      userName = name;
      userEmail = email;
      userImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> services = [
      {'icon': Icons.local_taxi, 'title': 'Taxi'},
      {'icon': Icons.map, 'title': 'AI Planning'},
      {'icon': Icons.hotel, 'title': 'For Rent'},
      {'icon': Icons.delivery_dining, 'title': 'Delivery'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Our Services"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.brown),
              accountName: Text(
                userName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: userImage.startsWith('/')
                    ? FileImage(File(userImage))
                    : AssetImage(userImage) as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back, color: Colors.brown),
              title: const Text("Destinations Page"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationsPage(
                      userName: registeredName,
                      userEmail: registeredEmail,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.brown),
              title: const Text("Edit Profile"),
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      userName: userName,
                      userEmail: userEmail,
                      userImage: userImage,
                    ),
                  ),
                );
                if (updatedData != null) {
                  updateProfile(
                    updatedData['name'],
                    updatedData['email'],
                    updatedData['image'],
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.brown),
              title: const Text("Logout"),
              onTap: () {
                isLoggedIn = false;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Our Services",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCard(
                    icon: service['icon'] as IconData,
                    title: service['title'] as String,
                    onTap: () {
                      if (service['title'] == 'For Rent') {
                        // فتح نافذة اختيار الوجهة
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select Destination'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text('Dahab'),
                                    onTap: () {
                                      Navigator.pop(context); // إغلاق النافذة
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'Dahab',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: Text('Saint Catherine'),
                                    onTap: () {
                                      Navigator.pop(context); // إغلاق النافذة
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'Saint Catherine',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: Text('Sharm El Sheikh'),
                                    onTap: () {
                                      Navigator.pop(context); // إغلاق النافذة
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'Sharm El Sheikh',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: Text('El Tor'),
                                    onTap: () {
                                      Navigator.pop(context); // إغلاق النافذة
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'El Tor',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Service '${service['title']}' is not implemented yet."),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ServiceCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.brown),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}