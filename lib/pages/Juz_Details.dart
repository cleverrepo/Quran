import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/juzapi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JuzDetailsPage extends StatelessWidget {
  final int juzNumber;
  final int surahNumber;

  JuzDetailsPage({required this.juzNumber, required this.surahNumber});

  Future<List<Ayahs>> fetchAyahs(int surahNumber) async {
    final responseArabic = await http.get(Uri.parse(
        'https://api.alquran.cloud/v1/surah/$surahNumber/quran-uthmani'));
    final responseEnglish = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/en.asad'));

    if (responseArabic.statusCode == 200 && responseEnglish.statusCode == 200) {
      List<dynamic> arabicAyahsJson =
          jsonDecode(responseArabic.body)['data']['ayahs'];
      List<dynamic> englishAyahsJson =
          jsonDecode(responseEnglish.body)['data']['ayahs'];

      List<Ayahs> arabicAyahs =
          arabicAyahsJson.map((json) => Ayahs.fromJson(json)).toList();
      List<Ayahs> englishAyahs =
          englishAyahsJson.map((json) => Ayahs.fromJson(json)).toList();

      for (int i = 0; i < arabicAyahs.length; i++) {
        arabicAyahs[i].englishText = englishAyahs[i].arabicText;
      }

      return arabicAyahs;
    } else {
      throw Exception('Failed to load Ayahs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juz Details'),
      ),
      body: Column(
        children: [
          Container(
            child: Image.network(
              "https://img.freepik.com/free-photo/famous-abu-dhabi-sheikh-zayed-mosque-by-night-uae_268835-1068.jpg?uid=R107878224&ga=GA1.1.940840709.1719007816&semt=sph",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            width: 370,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          FutureBuilder<List<Ayahs>>(
            future: fetchAyahs(surahNumber),
            builder:
                (BuildContext context, AsyncSnapshot<List<Ayahs>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No data available'),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, int index) {
                      final Ayahs ayah = snapshot.data![index];
                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            trailing: Text('Juz ${ayah.page}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  ayah.arabicText!,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    height: 4), // Adjust as needed for spacing
                                Text(
                                  ayah.englishText!,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
/*
      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ayah.arabicText!,
                            style: GoogleFonts.montserrat(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ayah.englishText!,
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      subtitle: Text('Page ${ayah.page}'),
                      trailing: Text('Juz ${ayah.page}'),*/
