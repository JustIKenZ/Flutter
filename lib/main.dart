import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.greenAccent),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.greenAccent, fontSize: 20),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController taskController = TextEditingController();
  final List<String> tasks = [];
  int selectedIndex = 0;

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();
      });

      // Show pop-up notification
      Fluttertoast.showToast(
        msg: "To-do added!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.black,
      );
    }
  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BGChangeScreen()),
      );
    } else if (index == 2) {
      showModalBottomSheet(
        context: context,
        builder: (context) => const MusicModal(),
      );
    }
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    style: const TextStyle(color: Colors.greenAccent),
                    decoration: const InputDecoration(
                      labelText: "Enter a to-do item",
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: addTask,
                  child: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.greenAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    child: Text(
                      tasks[index],
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: "BG Color"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music"),
        ],
      ),
    );
  }
}

class BGChangeScreen extends StatefulWidget {
  const BGChangeScreen({super.key});

  @override
  State<BGChangeScreen> createState() => BGChangeScreenState();
}

class BGChangeScreenState extends State<BGChangeScreen> {
  Color backgroundColor = Colors.black; // Default background color

  void changeColor(Color newColor) {
    setState(() {
      backgroundColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Background'),
        iconTheme: const IconThemeData(color: Colors.greenAccent), // Green back button
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe Right
            changeColor(Colors.yellow);
          } else {
            // Swipe Left
            changeColor(Colors.blue);
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe Down
            changeColor(Colors.green);
          } else {
            // Swipe Up
            changeColor(Colors.red);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Smooth transition effect
          color: backgroundColor,
          alignment: Alignment.center,
          child: const Text(
            "Swipe to Change Background Color",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}


class MusicModal extends StatefulWidget {
  const MusicModal({super.key});

  @override
  State<MusicModal> createState() => MusicModalState();
}

class MusicModalState extends State<MusicModal> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong = "";

  void playSong(String song) async {
    if (currentSong == song) return; // Allow switching even if playing

    await audioPlayer.stop();
    switch (song) {
      case "Song1":
        await audioPlayer.play(AssetSource('RickRoll.mp3'));
        break;
      case "Song2":
        await audioPlayer.play(AssetSource('JinSheng.mp3'));
        break;
    }
    setState(() {
      isPlaying = true;
      currentSong = song;
    });
  }

  void pauseSong() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void resumeSong() async {
    await audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("Choose a song", style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
                onPressed: () => playSong("Song1"),
                child: const Text("Song 1"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
                onPressed: () => playSong("Song2"),
                child: const Text("Song 2"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.pause, color: isPlaying ? Colors.greenAccent : Colors.grey), onPressed: isPlaying ? pauseSong : null),
              IconButton(icon: Icon(Icons.play_arrow, color: !isPlaying && currentSong.isNotEmpty ? Colors.greenAccent : Colors.grey), onPressed: !isPlaying && currentSong.isNotEmpty ? resumeSong : null),
            ],
          ),
        ],
      ),
    );
  }
}
