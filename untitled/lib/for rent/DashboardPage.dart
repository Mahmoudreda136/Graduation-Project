import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'globalforrent.dart';

class DashboardWithLoginPage extends StatefulWidget {
  @override
  _DashboardWithLoginPageState createState() => _DashboardWithLoginPageState();
}

class _DashboardWithLoginPageState extends State<DashboardWithLoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final String _correctPassword = "admin2134"; // الرقم السري الصحيح
  bool _isLoggedIn = false; // حالة تسجيل الدخول
  String selectedRegion = 'Dahab';
  String selectedCategory = 'For Rent';

  void _login() {
    if (_passwordController.text == _correctPassword) {
      setState(() {
        _isLoggedIn = true; // تغيير حالة تسجيل الدخول
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Incorrect Password! Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditPropertyDialog(Map<String, dynamic> property, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AddEditPropertyDialog(
          title: "Edit Property",
          property: property,
          onConfirm: (updatedProperty) {
            setState(() {
              RegionData.properties[selectedRegion]![selectedCategory]![index] = updatedProperty;
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

  Widget _buildStatisticsSection() {
    final forRentCount = RegionData.properties[selectedRegion]?['For Rent']?.length ?? 0;
    final forSaleCount = RegionData.properties[selectedRegion]?['For Sale']?.length ?? 0;
    final hotelsCount = RegionData.properties[selectedRegion]?['Hotels']?.length ?? 0;

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
    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: Colors.brown,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter Password to Access Dashboard",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true, // إخفاء النص عند الكتابة
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final properties = RegionData.properties[selectedRegion]![selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // فلاتر المنطقة والفئة
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
            // قسم الإحصائيات
            _buildStatisticsSection(),
            SizedBox(height: 16),
            // الجدول
            Expanded(
              child: properties.isNotEmpty
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
                        properties.length,
                            (index) {
                          final property = properties[index];
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

class AddEditPropertyDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? property;
  final Function(Map<String, dynamic>) onConfirm;

  AddEditPropertyDialog({
    required this.title,
    this.property,
    required this.onConfirm,
  });

  @override
  _AddEditPropertyDialogState createState() => _AddEditPropertyDialogState();
}

class _AddEditPropertyDialogState extends State<AddEditPropertyDialog> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController priceController;
  late TextEditingController phoneController;
  late TextEditingController floorController;
  late TextEditingController buildingController;
  late TextEditingController apartmentController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.property?["user"]["name"] ?? "");
    addressController = TextEditingController(text: widget.property?["address"] ?? "");
    priceController = TextEditingController(text: widget.property?["price"]?.toString() ?? "");
    phoneController = TextEditingController(text: widget.property?["user"]["phone"] ?? "");
    floorController = TextEditingController(text: widget.property?["floor"] ?? "");
    buildingController = TextEditingController(text: widget.property?["building_num"] ?? "");
    apartmentController = TextEditingController(text: widget.property?["apartment_num"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Price"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: floorController,
              decoration: InputDecoration(labelText: "Floor"),
            ),
            TextField(
              controller: buildingController,
              decoration: InputDecoration(labelText: "Building Number"),
            ),
            TextField(
              controller: apartmentController,
              decoration: InputDecoration(labelText: "Apartment Number"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm({
              "user": {"name": nameController.text, "phone": phoneController.text},
              "address": addressController.text,
              "price": priceController.text,
              "floor": floorController.text,
              "building_num": buildingController.text,
              "apartment_num": apartmentController.text,
            });
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}