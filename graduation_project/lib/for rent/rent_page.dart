import 'package:flutter/material.dart';
import '../login_page.dart';
import '../our_services_page.dart';
import 'HotelListPage.dart';
import 'PropertyListPage.dart';
import 'PropertyRentPage.dart';
import 'SellPage.dart';
import 'DashboardPage.dart'; // استيراد صفحة Dashboard

class ForRentHomePage extends StatefulWidget {
  final String userName; // اسم المستخدم
  final String destination; // الوجهة المحددة
  final String selectedRegion; // المنطقة المحددة (تمت إضافتها)

  ForRentHomePage({
    required this.userName,
    required this.destination,
    required this.selectedRegion, // إضافة المعلمة الجديدة
  });

  @override
  _ForRentHomePageState createState() => _ForRentHomePageState();
}

class _ForRentHomePageState extends State<ForRentHomePage> {
  String searchQuery = ''; // نص البحث

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

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
                gradient: LinearGradient(
                  colors: [Colors.brown[400]!, Colors.brown[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                    "Welcome, ${widget.userName}",
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
              icon: Icons.dashboard,
              label: 'Dashboard',
              color: Colors.brown[400]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardWithLoginPage(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.shopping_cart,
              label: 'Buy Properties',
              color: Colors.brown[500]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyListPage(destination: widget.destination),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.bento,
              label: 'Rent Properties',
              color: Colors.brown[600]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyRentPage(destination: widget.destination),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.hotel,
              label: 'Hotels',
              color: Colors.brown[700]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelListPage(destination: widget.destination),
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/for_rent.JPG'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Padding(
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
                                    userName: widget.userName,
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
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: AssetImage('images/for_rent.JPG'),
                  height: MediaQuery.of(context).size.height * 0.65, // جعل الارتفاع متناسبًا مع الشاشة
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
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
                        Colors.brown[400]!,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyListPage(destination: widget.destination),
                            ),
                          );
                        },
                      ),
                      _buildOptionButton(
                        context,
                        "Rent",
                        Colors.brown[500]!,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyRentPage(destination: widget.destination),
                            ),
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[600]!,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text("Sell"),
                      ),
                      _buildOptionButton(
                        context,
                        "Hotels",
                        Colors.brown[700]!,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelListPage(destination: widget.destination),
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
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: _onSearch,
                            decoration: InputDecoration(
                              hintText: "Search for Hotel, Rent, Buy, or Sale...",
                              prefixIcon: Icon(Icons.search, color: Colors.brown[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          print("Search Clicked: $searchQuery");
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
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Text(label),
    );
  }
}