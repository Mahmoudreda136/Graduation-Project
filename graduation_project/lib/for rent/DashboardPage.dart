import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../globals.dart';
import 'AddEditPropertyDialog.dart';
import 'globalforrent.dart';

class DashboardWithLoginPage extends StatefulWidget {
  @override
  _DashboardWithLoginPageState createState() => _DashboardWithLoginPageState();
}

class _DashboardWithLoginPageState extends State<DashboardWithLoginPage> {
  bool _isLoggedIn = true; // No password, login is defaulted to true
  String selectedRegion = 'Dahab';
  String selectedCategory = 'For Rent';

  void _showEditPropertyDialog(Map<String, dynamic> property, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AddEditPropertyDialog(
          title: "Edit Property",
          property: property,
          onConfirm: (updatedProperty) {
            setState(() {
              RegionData.properties[selectedRegion]![selectedCategory]![index] = {
                ...property, // الاحتفاظ بالبيانات القديمة
                ...updatedProperty, // تحديث الحقول
              };
            });
          },
        );
      },
    );
  }

  void _deleteProperty(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Property"),
        content: Text("Are you sure you want to delete this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                RegionData.properties[selectedRegion]![selectedCategory]!.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(List<dynamic> userProperties) {
    // Filter properties by category and user
    final forRentCount = userProperties
        .where((property) => property['category'] == 'For Rent' && property['user']['email'] == registeredEmail)
        .length;

    final forSaleCount = userProperties
        .where((property) => property['category'] == 'For Sale' && property['user']['email'] == registeredEmail)
        .length;

    final hotelsCount = userProperties
        .where((property) => property['category'] == 'Hotels' && property['user']['email'] == registeredEmail)
        .length;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(toY: forRentCount.toDouble(), color: Colors.green),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: forSaleCount.toDouble(), color: Colors.blue),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(toY: hotelsCount.toDouble(), color: Colors.orange),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text("For Rent", style: TextStyle(fontSize: 12));
                            case 1:
                              return Text("For Sale", style: TextStyle(fontSize: 12));
                            case 2:
                              return Text("Hotels", style: TextStyle(fontSize: 12));
                            default:
                              return Text("");
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter the properties for the selected category and current user
    final userProperties = RegionData.properties[selectedRegion]?[selectedCategory]?.where((property) {
      return property['user']['email'] == registeredEmail;
    }).toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedRegion,
                  items: RegionData.properties.keys.map((region) {
                    return DropdownMenuItem(
                      value: region,
                      child: Text(region),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: ['For Rent', 'For Sale', 'Hotels'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildStatisticsSection(userProperties),
            SizedBox(height: 16),
            Expanded(
              child: userProperties.isNotEmpty
                  ? Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.brown[200]!),
                      columns: [
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("Price")),
                        DataColumn(label: Text("Floor")),
                        DataColumn(label: Text("Building")),
                        DataColumn(label: Text("Apartment")),
                        DataColumn(label: Text("Phone")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: List<DataRow>.generate(
                        userProperties.length,
                            (index) {
                          final property = userProperties[index];
                          return DataRow(cells: [
                            DataCell(Text(property["user"]["name"] ?? "Unknown")),
                            DataCell(Text(property["address"] ?? "N/A")),
                            DataCell(Text(property["price"].toString())),
                            DataCell(Text(property["floor"] ?? "N/A")),
                            DataCell(Text(property["building_num"] ?? "N/A")),
                            DataCell(Text(property["apartment_num"] ?? "N/A")),
                            DataCell(Text(property["user"]["phone"] ?? "N/A")),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showEditPropertyDialog(property, index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteProperty(index),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ),
                ),
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: Colors.grey, size: 64),
                    SizedBox(height: 16),
                    Text(
                      "No properties available.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}