import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/planning/planning_page.dart';
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
      {'icon': Icons.hotel, 'title': 'For Rent'},
      {'icon': Icons.event, 'title': 'Planning'},
      {'icon': Icons.delivery_dining, 'title': 'Delivery'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800], // لون أغمق قليلًا
        title: const Text(
          "Our Services",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown[800]!, Colors.brown[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                userEmail,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: userImage.startsWith('/')
                    ? FileImage(File(userImage))
                    : AssetImage(userImage) as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back, color: Colors.brown),
              title: const Text(
                "Destinations Page",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              title: const Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                color: Colors.brown,
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Destination'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('Dahab'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'Dahab',
                                            selectedRegion: '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Saint Catherine'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'Saint Catherine',
                                            selectedRegion: '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Sharm El Sheikh'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'Sharm El Sheikh',
                                            selectedRegion: '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('El Tor'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ForRentHomePage(
                                            userName: userName,
                                            destination: 'El Tor',
                                            selectedRegion: '',
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
                      } else if (service['title'] == 'Planning') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Destination for Planning'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('Dahab'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanningHomePage(
                                            userName: userName,
                                            destination: 'Dahab',
                                            selectedRegion: '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Saint Catherine'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanningHomePage(
                                            userName: userName,
                                            destination: 'Saint Catherine',
                                            selectedRegion: '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Sharm El Sheikh'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanningHomePage(
                                            userName: userName,
                                            destination: 'Sharm El Sheikh',
                                            selectedRegion: '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('El Tor'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanningHomePage(
                                            userName: userName,
                                            destination: 'El Tor',
                                            selectedRegion: '',
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
          gradient: LinearGradient(
            colors: [Colors.brown[100]!, Colors.brown[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.brown[800]),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}