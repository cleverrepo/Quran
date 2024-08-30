import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/services/AudioApi.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'AudioDetails.dart';


class QuranAudioList extends StatefulWidget {

  @override
  State<QuranAudioList> createState() => _QuranAudioListState();
}

class _QuranAudioListState extends State<QuranAudioList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  FutureBuilder<AudioPlayList>(
        future: fetchAudioPlayList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return const Center(child: Text('No data found.'));
          } else {
            final surahs = snapshot.data!.data!.surahs;
            return ListView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: Stack(
                        children: [
                          SvgPicture.asset("Assets/nomor-surah.svg"),
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: Text(surah.number.toString()),
                            ),
                          ),
                        ],
                      ),
                      title: Text(surah.name ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(surah.englishNameTranslation ?? ''),
                          Text(surah.revelationType ?? ''),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          Text(surah.englishName ?? '',
                              style: GoogleFonts.roboto(fontSize: 18)),
                          Text(surah.ayahs.length.toString()),
                        ],
                      ),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioDetailsPage(surah: surah),
                          ),
                        );
                      },
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


