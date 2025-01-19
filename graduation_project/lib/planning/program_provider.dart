class RegionData {
  // هيكل البيانات لتخزين الشركات والبرامج حسب المنطقة
  static Map<String, Map<String, List<Map<String, dynamic>>>> companies = {
    'Dahab': {
      'Hotels': [], // يمكن تغيير "Hotels" إلى "Companies" إذا أردت
    },
    'Saint Catherine': {
      'Hotels': [],
    },
    'Sharm El Sheikh': {
      'Hotels': [],
    },
    'El Tor': {
      'Hotels': [],
    },
  };

  // دالة لإضافة شركة جديدة في منطقة معينة
  static void addCompany(String region, String category, Map<String, dynamic> companyDetails) {
    if (!companies.containsKey(region)) {
      companies[region] = {};
    }
    if (!companies[region]!.containsKey(category)) {
      companies[region]![category] = [];
    }
    companies[region]![category]!.add(companyDetails);
  }

  // دالة للحصول على جميع الشركات في منطقة معينة
  static List<Map<String, dynamic>> getCompaniesByRegion(String region, String category) {
    return companies[region]?[category] ?? [];
  }

  // دالة للحصول على جميع المناطق والشركات
  static Map<String, Map<String, List<Map<String, dynamic>>>> getAllCompanies() {
    return companies;
  }
}