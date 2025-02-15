import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

class GoToShitScreen extends StatefulWidget {
  final String placeName;
  final String placeId;
  final String latitude;
  final String longitude;

  const GoToShitScreen({
    super.key,
    required this.placeName,
    required this.placeId,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<GoToShitScreen> createState() => _GoToShitScreenState();
}

class _GoToShitScreenState extends State<GoToShitScreen> {
  Map<String, List<String>> placeContent = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generatePlaceContent();
  }

  Future<List<String>> _generateContent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/mistralai/Mixtral-8x7B-Instruct-v0.1'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['HUGGINGFACE_API_KEY']}',
        },
        body: jsonEncode({
          'inputs': """Sen tecrübeli bir yerel rehbersin. Aşağıdaki soruya en popüler ve önemli 5 örnek ile yanıt ver.
          Her yanıt 2-3 cümle olsun. Başlık veya giriş cümlesi yazma, doğrudan örneklere geç.
          Yanıtların akıcı ve doğal olsun, liste gibi görünmesin. Madde yazarken başına "1)" gibi ifadeler kullanma.
          
          Soru: $prompt""",
          'parameters': {
            'max_length': 800,
            'temperature': 0.7,
            'top_p': 0.9,
            'repetition_penalty': 1.2,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        String content = data[0]['generated_text'] as String;
        
        // Gereksiz metinleri temizle
        content = content.replaceAll(RegExp(r'Sen tecrübeli.*Soru:', dotAll: true), '');
        content = content.replaceAll(prompt, '');
        
        List<String> lines = content.split('\n')
            .where((line) => line.trim().isNotEmpty)
            .take(5)
            .map((line) => line.replaceAll(RegExp(r'^\d+[\.\)-]\s*'), '').trim())
            .where((line) => line.length > 10)
            .toList();
        
        return lines;
      }
    } catch (e) {
      print('Yapay zeka yanıt hatası: $e');
    }
    return ['Yanıt alınamadı. Lütfen tekrar deneyin.'];
  }

  Future<void> _generatePlaceContent() async {
    final placeName = widget.placeName;
    
    final prompts = {
      'Gezilecek Yerler': 
        "$placeName'nin en popüler turistik yerleri hangileridir? Her yer için konumunu, nasıl gidileceğini ve en güzel zamanını belirt. Her farklı yeri tek satırda yaz ve çok uzun olmasın. ",
      
      '$placeName Artıları': 
        "$placeName'nin en beğenilen özellikleri nelerdir? Her özellik için somut örnekler ver ve neden özel olduğunu açıkla fakat çok uzun olmasın. Her farklı özelliği tek satırda yaz.",
      
      '$placeName Eksileri': 
        "$placeName'de turistlerin en sık karşılaştığı sorunlar nelerdir? Her sorun için çözüm önerilerini de ekle fakat çok uzun olmasın. Her farklı sorunu tek satırda yaz.",
      
      'Önemli Tavsiyeler': 
        "$placeName'de yerel halkın en çok önerdiği şeyler nelerdir? Her öneri için püf noktalarını da ekle fakat çok uzun olmasın. Her farklı öneriyi tek satırda yaz.",
    };

    Map<String, List<String>> tempContent = {};
    
    for (var entry in prompts.entries) {
      tempContent[entry.key] = await _generateContent(entry.value);
    }

    setState(() {
      placeContent = tempContent;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B26),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFFBD93F9),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${widget.placeName} hakkında araştırma yapılıyor...',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.placeName,
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFBD93F9),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ...placeContent.entries.map((entry) {
                          return _buildSection(entry.key, entry.value);
                        }).toList(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        backgroundColor: const Color(0xFFBD93F9),
        elevation: 8,
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        label: Text(
          'Geri Dön',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBD93F9).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBD93F9).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFBD93F9).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFBD93F9),
                letterSpacing: -0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBD93F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          height: 1.6,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
} 