import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:convert';
import 'dart:io';

class MapPage extends StatefulWidget {
  final LatLng? initialLocation;
  final String? initialAddress;

  const MapPage({super.key, this.initialLocation, this.initialAddress});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final LatLng damascusCenter = LatLng(33.5138, 36.2765);
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  LatLng? _selectedLocation;
  LatLng? _myCurrentLocation;
  String _selectedAddress = "لم يتم تحديد موقع";
  bool _isLoading = false;
  bool _isGettingLocation = false;

  final TextEditingController _searchController = TextEditingController();

  // قاموس لتحسين الأسماء والرموز
  final Map<String, String> _addressCorrections = {
    'F8RQ+PWW': 'الشارع الرئيسي',
    'Jaramana': 'جرمانا',
    'Damascus': 'دمشق',
    'Rif Dimashq Governorate': 'ريف دمشق',
    'Syria': 'سوريا',
  };

  @override
  void initState() {
    super.initState();

    // إذا كان هناك موقع مبدئي، استخدمه
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _selectedAddress = widget.initialAddress ?? "لم يتم تحديد موقع";
    }

    _addInitialMarker();
    _getCurrentLocation();
  }

  void _addInitialMarker() {
    _markers = [
      if (_myCurrentLocation != null)
        Marker(
          point: _myCurrentLocation!,
          width: 80,
          height: 80,
          child: Icon(Icons.location_pin, color: Colors.red, size: 40),
        ),
      Marker(
        point: damascusCenter,
        width: 80,
        height: 80,
        child: Icon(Icons.location_on, color: Colors.green, size: 40),
      ),
      if (_selectedLocation != null)
        Marker(
          point: _selectedLocation!,
          width: 80,
          height: 80,
          child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
        ),
    ];
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // التحقق من صلاحيات الموقع
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الرجاء تفعيل خدمة الموقع')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم رفض صلاحيات الموقع')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('صلاحيات الموقع مرفوضة بشكل دائم')),
        );
        return;
      }

      // جلب الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _myCurrentLocation = LatLng(position.latitude, position.longitude);
      });

      // تحديث الخريطة للانتقال إلى موقع المستخدم
      _mapController.move(_myCurrentLocation!, 15.0);

      // تحديث الماركرز
      _updateMarkers();

    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في الحصول على الموقع الحالي')),
      );
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers = [];

      // إضافة مؤشر الموقع الحالي (أحمر)
      if (_myCurrentLocation != null) {
        _markers.add(
          Marker(
            point: _myCurrentLocation!,
            width: 80,
            height: 80,
            child: Icon(Icons.my_location, color: Colors.red, size: 40),
          ),
        );
      }

      // إضافة مؤشر دمشق (أخضر)
      _markers.add(
        Marker(
          point: damascusCenter,
          width: 80,
          height: 80,
          child: Icon(Icons.location_city, color: Colors.green, size: 40),
        ),
      );

      // إضافة مؤشر الموقع المحدد (أزرق)
      if (_selectedLocation != null) {
        _markers.add(
          Marker(
            point: _selectedLocation!,
            width: 80,
            height: 80,
            child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
          ),
        );
      }
    });
  }

  Future<void> _handleTap(LatLng latLng) async {
    print('Tapped at: ${latLng.latitude}, ${latLng.longitude}');

    // تحديث الخريطة أولاً لتحريك المركز
    _mapController.move(latLng, _mapController.camera.zoom);

    setState(() {
      _isLoading = true;
      _selectedLocation = latLng;
    });

    // تحديث الماركرز
    _updateMarkers();

    // انتظار قليل لضمان تحديث الواجهة
    await Future.delayed(Duration(milliseconds: 100));

    try {
      String address = await _getEnhancedAddress(latLng);

      setState(() {
        _selectedAddress = address;
        _isLoading = false;
      });

      _showLocationDialog(latLng, address);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _selectedAddress = "تعذر جلب العنوان - الإحداثيات: ${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}";
      });

      _showLocationDialog(latLng, _selectedAddress);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء جلب العنوان: ${_getUserFriendlyError(e)}"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latLng) {
    print('Map tapped at: ${latLng.latitude}, ${latLng.longitude}');
    _handleTap(latLng);
  }

  Future<String> _getEnhancedAddress(LatLng latLng) async {
    // المحاولة الأولى: استخدام OpenStreetMap (يعطي نتائج أفضل)
    try {
      String osmAddress = await _getAddressFromOSM(latLng);
      if (osmAddress.isNotEmpty && _isAddressDetailedEnough(osmAddress)) {
        return _cleanAndTranslateAddress(osmAddress);
      }
    } catch (e) {
      print('OSM primary failed: $e');
    }

    // المحاولة الثانية: استخدام الخدمة الأساسية
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      ).timeout(Duration(seconds: 10));

      if (placemarks.isNotEmpty) {
        String address = _getDetailedArabicAddress(placemarks.first);
        return _cleanAndTranslateAddress(address);
      }
    } catch (e) {
      print('Geocoding failed: $e');
    }

    // إذا فشل كل شيء، نعيد إحداثيات الموقع
    return "موقع في دمشق - الإحداثيات: ${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}";
  }

  String _getDetailedArabicAddress(Placemark placemark) {
    List<String> parts = [];

    // نعطي أولوية للبيانات الأكثر أهمية
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add("${placemark.street}");
    } else if (placemark.thoroughfare != null && placemark.thoroughfare!.isNotEmpty) {
      parts.add("${placemark.thoroughfare}");
    }

    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add("${placemark.subLocality}");
    }

    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      //  parts.add("${placemark.locality}");
    }

    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
      parts.add("${placemark.administrativeArea}");
    }

    if (parts.isEmpty) {
      return "موقع في دمشق";
    }

    return parts.join("، ");
  }

  String _cleanAndTranslateAddress(String address) {
    String cleanedAddress = address;

    // استبدال الرموز والأسماء الإنجليزية بأسماء عربية
    _addressCorrections.forEach((key, value) {
      cleanedAddress = cleanedAddress.replaceAll(key, value);
    });

    // إزالة الرموز الغريبة والأكواد
    cleanedAddress = cleanedAddress.replaceAll(RegExp(r'[A-Z0-9+\-]+\+[A-Z0-9+\-]+'), '');
    cleanedAddress = cleanedAddress.replaceAll(RegExp(r'[A-Z]{2,}\d+'), '');
    cleanedAddress = cleanedAddress.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanedAddress;
  }

  bool _isAddressDetailedEnough(String address) {
    // نعتبر العنوان مفيداً إذا لم يحتوي على رموز غريبة
    return !address.contains(RegExp(r'[A-Z0-9]+\+[A-Z0-9]+')) &&
        !address.contains(RegExp(r'[A-Z]{3,}\d+'));
  }

  // خدمة OpenStreetMap Nominatim (تعطي نتائج أفضل)
  Future<String> _getAddressFromOSM(LatLng latLng) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(
          Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}&zoom=18&addressdetails=1&accept-language=ar')
      );

      final response = await request.close();
      final jsonString = await response.transform(utf8.decoder).join();
      final data = json.decode(jsonString);

      if (data['address'] != null) {
        return _parseOSMAddress(data['address']);
      }
    } catch (e) {
      print('OSM error: $e');
    }

    return '';
  }

  String _parseOSMAddress(Map<String, dynamic> address) {
    List<String> parts = [];

    // نعطي أولوية للبيانات الأكثر تحديداً
    if (address['road'] != null) {
      parts.add("${address['road']}");
    }

    if (address['quarter'] != null) {
      parts.add("${address['quarter']}");
    } else if (address['suburb'] != null) {
      parts.add("${address['suburb']}");
    }

    if (address['city'] != null) {
      parts.add("${address['city']}");
    } else if (address['town'] != null) {
      parts.add("${address['town']}");
    }

    if (address['state'] != null) {
      parts.add("${address['state']}");
    }

    if (address['country'] != null) {
      parts.add("دولة ${address['country']}");
    }

    return parts.isNotEmpty ? parts.join("، ") : '';
  }

  Future<void> _searchLocation() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String cleanedQuery = _cleanSearchQuery(query);

      List<Location> locations = await locationFromAddress(
        cleanedQuery,
      ).timeout(Duration(seconds: 15));

      if (locations.isNotEmpty) {
        final loc = locations.first;
        LatLng latLng = LatLng(loc.latitude, loc.longitude);

        // تحريك الخريطة أولاً ثم إضافة الماركر
        _mapController.move(latLng, 15.0);

        // انتظار حتى تكتمل حركة الخريطة
        await Future.delayed(Duration(milliseconds: 300));

        // الآن تحديث الماركر
        setState(() {
          _selectedLocation = latLng;
        });

        _updateMarkers();

        // ثم جلب العنوان
        await _handleTap(latLng);

      } else {
        await _tryAlternativeSearchMethods(query);
      }
    } catch (e) {
      print('Search error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في البحث: ${_getUserFriendlyError(e)}'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _cleanSearchQuery(String query) {
    return query
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _getUserFriendlyError(dynamic error) {
    if (error.toString().contains('timeout')) {
      return 'انتهت مدة البحث. يرجى المحاولة مرة أخرى';
    } else if (error.toString().contains('network') || error.toString().contains('SocketException')) {
      return 'مشكلة في الاتصال بالإنترنت';
    } else if (error.toString().contains('No result')) {
      return 'لم يتم العثور على الموقع. حاول استخدام اسم آخر';
    } else {
      return 'حدث خطأ غير متوقع';
    }
  }

  Future<void> _tryAlternativeSearchMethods(String query) async {
    List<String> searchVariations = [
      query,
      '$query, دمشق',
      '$query, سوريا',
    ];

    for (String variation in searchVariations) {
      try {
        List<Location> locations = await locationFromAddress(variation);
        if (locations.isNotEmpty) {
          final loc = locations.first;
          LatLng latLng = LatLng(loc.latitude, loc.longitude);

          _mapController.move(latLng, 15.0);
          await Future.delayed(Duration(milliseconds: 300));

          setState(() {
            _selectedLocation = latLng;
          });

          _updateMarkers();

          await _handleTap(latLng);
          return;
        }
      } catch (e) {
        continue;
      }
    }

    throw Exception('لم يتم العثور على الموقع بعد محاولات متعددة');
  }

  void _showLocationDialog(LatLng latLng, String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("الموقع المحدد", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 15),
          ],
        ),
        actions: [
          TextButton(
            child: Text("إلغاء", style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("تأكيد الموقع"),
            onPressed: () {
              // إرجاع البيانات إلى الصفحة السابقة
              Navigator.pop(context); // إغلاق الديالوج
              Navigator.pop(context, {
                'coordinates': latLng,
                'address': address,
              });
            },
          ),
        ],
      ),
    );
  }

  void _resetToInitialLocation() {
    if (_myCurrentLocation != null) {
      _mapController.move(_myCurrentLocation!, 15.0);
    } else {
      _mapController.move(damascusCenter, 13.0);
    }
    setState(() {
      _selectedLocation = null;
      _selectedAddress = "لم يتم تحديد موقع";
      _updateMarkers();
    });
  }

  void _goToMyLocation() {
    if (_myCurrentLocation != null) {
      _mapController.move(_myCurrentLocation!, 15.0);
    } else {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("حدد موقعك على الخريطة"),
        backgroundColor: Colors.blue[700],
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: Icon(Icons.check, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, {
                  'coordinates': _selectedLocation,
                  'address': _selectedAddress,
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetToInitialLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialLocation ?? damascusCenter,
              initialZoom: 13.0,
              onTap: _handleMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=MTmanIhapnF5Guj9lvvK',
                userAgentPackageName: 'com.complaints.app',
                tileProvider: NoCacheTileProvider(),
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'ابحث عن موقع في دمشق...',
                          border: InputBorder.none,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onSubmitted: (_) => _searchLocation(),
                      ),
                    ),
                    IconButton(
                      icon: _isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Icon(Icons.search),
                      onPressed: _isLoading ? null : _searchLocation,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading || _isGettingLocation)
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      _isGettingLocation ? "جاري تحديد موقعك..." : "جاري جلب البيانات...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

          if (_selectedLocation != null && !_isLoading)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الموقع المحدد:",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _selectedAddress,
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // مفتاح تفسير الألوان
          Positioned(
            top: 80,
            left: 10,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(Colors.red, "موقعك الحالي"),
                    _buildLegendItem(Colors.blue, "الموقع المحدد"),
                    _buildLegendItem(Colors.green, "مركز دمشق"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "my_location_btn",
            child: Icon(Icons.my_location),
            onPressed: _goToMyLocation,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "reset_btn",
            child: Icon(Icons.center_focus_strong),
            onPressed: _resetToInitialLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class NoCacheTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return NetworkImage(getTileUrl(coordinates, options));
  }
}