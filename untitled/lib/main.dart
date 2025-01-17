import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'login_page.dart';
import 'our_services_page.dart';
import 'globals.dart'; // استيراد المتغير isLoggedIn

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // استخدام خط حديث
      ),
      home: isLoggedIn
          ? OurServicesPage(
        userName: registeredName,
        userEmail: registeredEmail,
        userImage: userImage,
      )
          : OurServicesPage(userName: '', userEmail: '', userImage: ''),
    );
  }
}

class DestinationsPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;

  const DestinationsPage({Key? key, this.userName, this.userEmail}) : super(key: key);

  @override
  _DestinationsPageState createState() => _DestinationsPageState();
}

class _DestinationsPageState extends State<DestinationsPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  static const List<Map<String, String>> destinations = [
    {
      'title': 'Saint Catherine',
      'description':
      'Saint Catherine is a serene destination in Egypt\'s Sinai, famous for Mount Sinai, the historic Saint Catherine\'s Monastery, and stunning mountainous landscapes. Perfect for hiking, camping, and exploring nature.',
      'image': 'images/saint_catherine.jpg',
    },
    {
      'title': 'Dahab',
      'description':
      'Dahab, a charming town on Egypt\'s Sinai coast, is known for its laid-back vibe, golden beaches, and world-renowned diving spots like the Blue Hole.',
      'image': 'images/dahab.jpg',
    },
    {
      'title': 'Sharm El Sheikh',
      'description':
      'Sharm El Sheikh, Egypt\'s premier Red Sea resort, is famous for its crystal-clear waters, vibrant coral reefs, and luxury resorts.',
      'image': 'images/sharm.jpg',
    },
    {
      'title': 'El Tor',
      'description':
      'El Tor is a peaceful town on the Gulf of Suez, known for its serene beaches, historical significance, and stunning views of the mountains.',
      'image': 'images/el_tor.jpg',
    },
  ];

  void goToNextPage() {
    if (currentPage < destinations.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for destinations
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return Stack(
                children: [
                  // Background Image
                  Image.asset(
                    destination['image']!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // Content Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination['title']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          destination['description']!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 24),
                        // Buttons Row
                        Row(
                          children: [
                            // Let's Go Button
                            FloatingActionButton(
                              onPressed: () {
                                if (isLoggedIn) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OurServicesPage(
                                        userName: registeredName,
                                        userEmail: registeredEmail,
                                        userImage: userImage,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                }
                              },
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.arrow_forward, color: Colors.white),
                              tooltip: 'Let\'s Go',
                            ),
                            SizedBox(width: 10),
                            // Share Button
                            FloatingActionButton(
                              onPressed: () {
                                Share.share('اكتشف ${destination['title']}: ${destination['description']}');
                              },
                              backgroundColor: Colors.green,
                              child: Icon(Icons.share, color: Colors.white),
                              tooltip: 'مشاركة',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Navigation Buttons
          if (currentPage > 0)
            Positioned(
              left: 16,
              top: MediaQuery.of(context).size.height / 2 - 40,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 32),
                onPressed: goToPreviousPage,
              ),
            ),
          if (currentPage < destinations.length - 1)
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height / 2 - 40,
              child: IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white, size: 32),
                onPressed: goToNextPage,
              ),
            ),
          // Page Indicators
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                destinations.length,
                    (dotIndex) => Container(
                  width: 12,
                  height: 12,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotIndex == currentPage
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}