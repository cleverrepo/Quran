import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../services/api.dart';
import 'details.dart';

class Sura extends StatefulWidget {
  const Sura({super.key});

  @override
  State<Sura> createState() => _SuraState();
}

List<Surah> surahList = [];
List<Surah> filteredSurahList = [];

class _SuraState extends State<Sura> {
  TextEditingController searchController = TextEditingController();
  List<Surah> surahList = [];
  List<Surah> filteredSurahList = [];

  @override
  void initState() {
    super.initState();
    fetchSurah().then((surahData) {
      setState(() {
        surahList = surahData.data.surahs;
        filteredSurahList = surahList;
      });
    });
  }

  void filterSurahList(String query) {
    setState(() {
      filteredSurahList = surahList.where((surah) =>
      surah.englishName!.toLowerCase().contains(query.toLowerCase()) ||
          surah.englishNameTranslation!
              .toLowerCase()
              .contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchController.clear();
                      filterSurahList(""); // Clear the filter when cancel is pressed
                    });
                  },
                  icon: Icon(Icons.cancel),
                )
                    : null,
                hintText: "Search surah",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (query) => filterSurahList(query), // Add this line
            ),
          ),
          Expanded(
            child: FutureBuilder<SurahClass>(
              future: fetchSurah(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.red,
                      rightDotColor: Colors.lightBlue,
                      size: 40,
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredSurahList.length, // Use filteredSurahList.length
                    itemBuilder: (_, int index) {
                      final Surah surah = filteredSurahList[index]; // Use filteredSurahList[index]
                      return GestureDetector(
                        onTap: () async {
                          final SurahClass statusRespond = await fetchSurah();
                          final Edition edition = statusRespond.data.edition;
                          Get.to(() => Details(
                            surah: surah,
                            editionName: edition.name,
                            editionIdentifier: edition.identifier,
                            editionLanguage: edition.language,
                            type: edition.type,
                            format: edition.format,
                            name: edition.name,
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
                              leading: Stack(children: [
                                SvgPicture.asset("Assets/nomor-surah.svg"),
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Center(
                                    child: Text("${surah.number.toString()}"),
                                  ),
                                )
                              ]),
                              title: Text(surah.englishName.toString()),
                              subtitle: Column(
                                children: [
                                  Text(surah.englishNameTranslation.toString()),
                                  Text(surah.revelationType
                                      .toString()
                                      .split('.')
                                      .last),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(surah.name.toString(),
                                      style: GoogleFonts.roboto(fontSize: 18)),
                                  Text(surah.ayahs.length.toString()),
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
          ),
        ],
      ),
    );
  }
}
