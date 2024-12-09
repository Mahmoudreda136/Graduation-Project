import 'package:flutter/material.dart';
import '../login_page.dart';
import '../our_services_page.dart';
import 'HotelListPage.dart';
import 'PropertyListPage.dart';
import 'PropertyRentPage.dart';

class ForRentHomePage extends StatelessWidget {
  final String userName; // User's name to display
  final String destination; // Selected destination

  ForRentHomePage({required this.userName, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.brown[400]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Welcome, $userName!", // Display user's name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Your Dream Home Awaits",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Drawer Items
            _buildDrawerItem(
              context,
              icon: Icons.shopping_cart,
              label: 'Buy Properties',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyListPage(destination: destination),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.bento,
              label: 'Rent Properties',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyRentPage(destination: destination),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.hotel,
              label: 'Hotels',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelListPage(destination: destination),
                  ),
                );
              },
            ),
            Divider(),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.red,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Stack(
              children: [
                Container(
                  height: 200,
                  color: Colors.brown[400],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Icon(Icons.menu, color: Colors.brown[400]),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OurServicesPage(
                                userName: userName,
                                userEmail: '',
                                userImage: '',
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(Icons.arrow_back, color: Colors.brown[400]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Find ",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: "Perfect ",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown[400]),
                        ),
                        TextSpan(
                          text: "Place",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "To Live Life.",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOptionButton(
                        context,
                        "Buy",
                        Colors.blue,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyListPage(destination: destination),
                            ),
                          );
                        },
                      ),
                      _buildOptionButton(
                        context,
                        "Rent",
                        Colors.green,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyRentPage(destination: destination),
                            ),
                          );
                        },
                      ),
                      _buildOptionButton(
                        context,
                        "Hotels",
                        Colors.orange,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelListPage(destination: destination),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search anything...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          print("Search Clicked");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer Item Builder
  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      onTap: onTap,
    );
  }

  // Button Builder
  Widget _buildOptionButton(
      BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label),
    );
  }
}