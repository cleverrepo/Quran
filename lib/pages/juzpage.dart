import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';

import '../services/juzapi.dart';
import 'juz_details.dart';

class Juz extends StatefulWidget {
  const Juz({Key? key}) : super(key: key);

  @override
  State<Juz> createState() => _JuzState();
}

class _JuzState extends State<Juz> {
  Future<JuzApi> fetchJuz() async {
    final response = await http.get(Uri.parse('https://api.alquran.cloud/v1/juz/30/en.asad'));

    if (response.statusCode == 200) {
      return JuzApi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Juz');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FutureBuilder<JuzApi>(
        future: fetchJuz(),
        builder: (BuildContext context, AsyncSnapshot<JuzApi> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.red,
                  rightDotColor: Colors.lightBlue, size: 40),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData || snapshot.data!.data!.surahs.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.data!.surahs.length,
              itemBuilder: (context, int index) {
                final Surahs surah = snapshot.data!.data!.surahs.values.toList()[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => JuzDetailsPage(
                      juzNumber: snapshot.data!.data!.number!,
                      surahNumber: surah.number!, // Pass surah number
                    ));
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Stack(
                          children: [
                            SvgPicture.asset("Assets/nomor-surah.svg"),
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: Center(
                                child: Text("${surah.number}"),
                              ),
                            ),
                          ],
                        ),
                        title: Text(surah.englishName.toString()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(surah.englishNameTranslation.toString()),
                            Text(surah.revelationType.toString().split('.').last),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text(surah.name.toString(), style: GoogleFonts.roboto(fontSize: 18)),
                            Text(surah.numberOfAyahs.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
