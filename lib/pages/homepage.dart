import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quran/pages/Audio.dart';
import 'package:quran/pages/juzpage.dart';
import 'package:quran/pages/AudioDetails.dart';
import 'package:quran/pages/surahpage.dart';
import 'package:quran/services/managment.dart';

import '../services/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<SurahClass> futureSurah;

  @override
  void initState() {
    super.initState();
    futureSurah = fetchSurah();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(),
              drawer: Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(child: Container()),
                    ListTile(
                      leading:
                          Text(value.isToggle ? "Dark Mode" : "Light Mode"),
                      trailing: IconButton(
                        onPressed: () {
                          value.changeTheme();
                        },
                        icon: value.isToggle
                            ? const Icon(Icons.nightlight_outlined)
                            : const Icon(Icons.sunny),
                      ),
                    )
                  ],
                ),
              ),
              body: Column(
                children: [

                  Container(
                    child: Image.network("https://img.freepik.com/free-photo/holy-quran-hand-with-arabic-calligraphy-meaning-al-quran_181624-49586.jpg?t=st=1720029528~exp=1720033128~hmac=f11ac0e15e2b749395b0bbf7c8df29c5e04664a9dbcde55fdb6ef5b25fbf0d3b&w=740",width: MediaQuery.of(context).size.width,
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

                  Container(
                    width: 260,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TabBar(
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tabs: const [
                        Tab(
                          text: "Surah",
                        ),
                        Tab(
                          text: "Juz",
                        ),
                        Tab(
                          text: "Audio",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                   Expanded(
                    child: TabBarView(
                      children: [
                        Sura(),
                        Juz(),
                        QuranAudioList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
