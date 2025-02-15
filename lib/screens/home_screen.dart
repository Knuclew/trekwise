import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'go_to_shit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<Map<String, dynamic>>> _searchPlaces(String query) async {
    if (query.length < 3) return [];

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&countrycodes=tr&limit=5');

    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'User-Agent': 'TrekWise/1.0',
      });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data.isEmpty) {
          return [{'display_name': 'Sonuç bulunamadı', 'is_empty': true}];
        }
        return data.map((place) => {
          'display_name': place['display_name'] as String,
          'place_id': place['place_id'].toString(),
          'lat': place['lat'],
          'lon': place['lon'],
          'is_empty': false,
        }).toList();
      }
    } catch (e) {
      print('Yer arama hatası: $e');
    }
    return [{'display_name': 'Bir hata oluştu', 'is_empty': true}];
  }

  String _extractMainLocation(String fullName) {
    return fullName.split(',')[0].trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1B26),
              const Color(0xFF1A1B26).withOpacity(0.8),
              const Color(0xFF1A1B26).withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Arka plan deseni
              Positioned.fill(
                child: CustomPaint(
                  painter: BackgroundPatternPainter(),
                ),
              ),
              // Ana içerik
              Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo ve başlık
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFFBD93F9),
                        const Color(0xFFBD93F9).withOpacity(0.8),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'TrekWise',
                      style: GoogleFonts.pacifico(
                        fontSize: 48,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFBD93F9).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Ana metin
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Text(
                            'Bugün Nereye Gidelim?',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // Arama alanı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFFBD93F9).withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFBD93F9).withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: TypeAheadField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Gitmek istediğiniz yeri yazın...',
                                          hintStyle: GoogleFonts.poppins(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 16,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return await _searchPlaces(pattern);
                                      },
                                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                        color: const Color(0xFF1A1B26),
                                        borderRadius: BorderRadius.circular(20),
                                        elevation: 10,
                                        shadowColor: const Color(0xFFBD93F9).withOpacity(0.2),
                                        constraints: const BoxConstraints(maxHeight: 400),
                                      ),
                                      itemBuilder: (context, Map<String, dynamic> suggestion) {
                                        if (suggestion['is_empty'] == true) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              suggestion['display_name'],
                                              style: GoogleFonts.poppins(
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        }
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFBD93F9).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Color(0xFFBD93F9),
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _extractMainLocation(suggestion['display_name'] as String),
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      (suggestion['display_name'] as String).split(',').skip(1).join(',').trim(),
                                                      style: GoogleFonts.poppins(
                                                        color: Colors.white.withOpacity(0.5),
                                                        fontSize: 12,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (Map<String, dynamic> suggestion) {
                                        if (suggestion['is_empty'] != true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GoToShitScreen(
                                                placeName: _extractMainLocation(suggestion['display_name'] as String),
                                                placeId: suggestion['place_id'] as String,
                                                latitude: suggestion['lat'] as String,
                                                longitude: suggestion['lon'] as String,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBD93F9).withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double spacing = 30;
    final double diagonal = size.width + size.height;
    final int lines = (diagonal / spacing).ceil();

    for (int i = 0; i < lines; i++) {
      final double start = i * spacing;
      canvas.drawLine(
        Offset(start, 0),
        Offset(0, start),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 