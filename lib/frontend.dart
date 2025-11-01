import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetmux_app/backend.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> animes = [];
  final TextEditingController _search = TextEditingController();
  String _currentStatus = 'airing';
  bool _isloading = false;

  void searchAnime() async {
    try {
      setState(() {
        _isloading = true;
      });
      final name = _search.text.trim();

      animes = await BackendService.animeSearch(
        query: name,
        status: (name == "") ? _currentStatus : null,
      );
      setState(() {
        _isloading = false;
      });
    } catch (e) {
      print("got error ${e}");
    }
  }

  @override
  void initState() {
    super.initState();
    searchAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchField(),
          Category(),
          Expanded(child: MainBody()),
        ],
      ),
    );
  }

  Widget MainBody() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 3)),
      child: _isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Wrap(
                children: [
                  for (int i = 0; i < animes.length; i++) AnimeCard(animes[i]),
                ],
              ),
            ),
    );
  }

  Widget Category() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyButton("upcoming"),
          MyButton("airing"),
          MyButton("complete"),
        ],
      ),
    );
  }

  Widget MyButton(String status) {
    return Container(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _currentStatus = status;
          searchAnime();
        },
        child: Text(status, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget SearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 3),
      ),
      margin: EdgeInsets.all(5),
      child: TextField(
        controller: _search,
        onSubmitted: (_) => searchAnime(),
        decoration: InputDecoration(hintText: "Search By Name"),
      ),
    );
  }

  Widget AnimeCard(Map<String, dynamic> anime) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(child: AnimeDetails(anime)),
        );
      },
      child: Container(
        width: 120,
        height: 250,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Anime Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                anime['images']?['jpg']?['image_url'] ??
                    anime['image_url'] ??
                    'https://via.placeholder.com/120x150',
                width: 120,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),

            // Anime Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                anime['title'] ?? anime['title_english'] ?? 'Unknown Title',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AnimeDetails(Map<String, dynamic> anime) {
    return Container(
      height: 1000,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Anime Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              anime['images']?['jpg']?['image_url'] ??
                  anime['image_url'] ??
                  'https://via.placeholder.com/120x150',
              width: 120,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),

          // Anime Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  anime['title'] ?? anime['title_english'] ?? 'Unknown Title',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  "RATING ::" + (anime['rating'] ?? "NA"),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "SYNOPSIS" + (anime['synopsis'] ?? "NA"),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "NUMBER OF EPISODE" +
                      (anime['episodes'] ?? "NO EPISOD AVAILABLE"),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
