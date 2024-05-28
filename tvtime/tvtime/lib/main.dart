import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tvtime/model/tv_show.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TVShow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red[900]!
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TV Shows'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentPage = 1;
  String _search = '';

  void _increment() {
    setState(() {
      _currentPage++;
    });
  }

  void _decrement() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void search(String q) {
    setState(() {
      _currentPage = 1;
      _search = q;
    });
  }

  Future<List<TvShow>> fetchTvShows(int currentPage, String q) async {
    var response = null;
    if (q.isNotEmpty) {
      response = await http.get(Uri.parse('https://www.episodate.com/api/search?q=' + q + '&page=' + currentPage.toString()));
    } else {
      response = await http.get(Uri.parse('https://www.episodate.com/api/most-popular?page=' + currentPage.toString()));
    }  

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<dynamic> tvShowsJson = jsonResponse['tv_shows'];
      return tvShowsJson.map((json) => TvShow.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load TV shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF01031C),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Text(widget.title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _currentPage = 1;
                _search = '';
              });
            },
          ),
        ],
        title: SizedBox(
          width: 300.0,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Rechercher',
              labelStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              search(value);
            },
          )
        ),
      ),
      body: FutureBuilder<List<TvShow>>(
        future: fetchTvShows(_currentPage, _search),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun résultat trouvé', style: TextStyle(color: Colors.white), textAlign: TextAlign.center, key: Key('no_result_text')));
          } else {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final tvShow = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      print('Item ${tvShow.id} clicked');
                      showDialog(
                        context: context,
                        builder: (context) => CenteredModal(
                          itemId: tvShow.id,
                        )
                      );
                    },
                    child: Card(
                      color: Color(0xFF202238),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                tvShow.imageThumbnailPath,
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tvShow.name,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            );
          }
        }
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _decrement,
            tooltip: 'Page précédente',
            backgroundColor: Colors.red[900]!,
            child: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
            decoration: BoxDecoration(
              color: Colors.red[900],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Page $_currentPage',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: _increment,
            tooltip: 'Page suivante',
            disabledElevation: 1,
            backgroundColor: Colors.red[900]!,
            child: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CenteredModal extends StatefulWidget {
  final int itemId;

  CenteredModal({required this.itemId});

  @override
  _CenteredModalState createState() => _CenteredModalState();
}

class _CenteredModalState extends State<CenteredModal> {
  bool _isLoading = true;
  Map<String, dynamic> _details = {};

  @override
  void initState() {
    super.initState();
    _fetchItemDetails();
  }

  Future<void> _fetchItemDetails() async {
    final response = await http.get(Uri.parse('https://www.episodate.com/api/show-details?q=${widget.itemId}'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _details = jsonResponse['tvShow'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _details = {'error': 'Failed to load item details'};
        _isLoading = false;
      });
    }
  }

  int _getEpisodeCount() {
    return _details['episodes']?.length ?? 0;
  }

  int _getSeasonCount() {
    final seasons = _details['episodes']?.map((e) => e['season'])?.toSet() ?? {};
    return seasons.length;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 16,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Item Details',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          _buildDetailRow('Nom', _details['name']),
                          _buildDetailRow(
                            'Description',
                            _details['description'],
                            maxLines: 3,
                          ),
                          _buildDetailRow('Date de sortie', _details['start_date']),
                          _buildDetailRow('Pays', _details['country']),
                          _buildDetailRow('Classement', '${_details['rating']}/10'),
                          _buildDetailRow('Genres', _details['genres'].join(', ')),
                          _buildDetailRow('Episodes', _getEpisodeCount().toString()),
                          _buildDetailRow('Saisons', _getSeasonCount().toString()),
                        ],
                  ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label : ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
            ),
            TextSpan(
              text: value,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ],
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}