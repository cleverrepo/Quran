import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../services/api.dart';

class Details extends StatelessWidget {
  Details({
    super.key,
    required this.surah,
    required this.editionName,
    required this.editionIdentifier,
    required this.editionLanguage,
    required this.type,
    required this.format,
    required this.name,
    this.juzNumber,
  });

  final Surah surah;
  final String editionName;
  final String editionIdentifier;
  final String editionLanguage;
  final String type;
  final String format;
  final String name;
  final juzNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder<List<Ayah>>(
        future: fetchAyahs(surah.number),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ayahs found'));
          } else {
            final ayahs = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Container(
                    child: Image.network("https://img.freepik.com/premium-photo/black-building-kaaba-mecca-kaaba-with-moon-meccasaudi-arabia_851826-1490.jpg?w=360",width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    ),
                    width: 370,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 320,
                        height: 50,
                        child: Center(
                          child: Text(
                            surah.name,
                            style: GoogleFonts.montserrat(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (_, int index) {
                            final Ayah ayah = ayahs[index];

                            return Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ListTile(
                                    leading: Stack(
                                      children: [
                                        SvgPicture.asset(
                                            "Assets/images/nomor-surah.svg"),
                                        SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: Center(
                                            child: Text(
                                              ayah.numberInSurah.toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          ayah.arabicText,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                4), // Adjust as needed for spacing
                                        Text(
                                          ayah.englishText,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                  )),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            final Ayah ayah = ayahs[index];
                            return Container(
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15),
                              width: 70,
                              height: 35,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.share),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.copy),
                                  ),
                                  Text(
                                    "Juz'u ${ayah.juz}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: ayahs.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
