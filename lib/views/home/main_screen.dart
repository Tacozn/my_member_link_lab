import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link_lab/models/news.dart';
import 'package:my_member_link_lab/myconfig.dart';
import 'package:my_member_link_lab/views/home/mydrawer.dart';
import 'package:my_member_link_lab/views/news/new_news.dart';
import 'package:http/http.dart' as http;
import 'package:animations/animations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  List<News> newsList = [];
  List<News> filteredNewsList = [];
  final df = DateFormat('dd MMM yyyy, hh:mm a');

  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;

  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  Map<String, bool> likedStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    loadNewsData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _searchNews(String query) {
    setState(() {
      filteredNewsList = newsList
          .where((news) =>
              news.newsTitle.toString().toLowerCase().contains(query.toLowerCase()) ||
              news.newsDetails.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void loadNewsData() {
    setState(() {
      _isLoading = true;
    });

    http.get(Uri.parse(
        "${MyConfig.servername}/memberlink/api/load_news.php?pageno=$curpage"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
            likedStatus.putIfAbsent(news.newsId.toString(), () => false);
          }
          filteredNewsList = List.from(newsList);
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load news'), backgroundColor: Colors.red),
        );
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
      );
    });
  }

  Widget _buildNewsCard(News news) {
    return OpenContainer(
      closedColor: Colors.white,
      openColor: Colors.blue,
      transitionDuration: const Duration(milliseconds: 500),
      closedBuilder: (context, action) => Card(
        color: Colors.blue.shade50,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          title: Text(
            news.newsTitle.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    df.format(DateTime.parse(news.newsDate.toString())),
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                news.newsDetails.toString(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              likedStatus[news.newsId] == true 
                  ? Icons.favorite 
                  : Icons.favorite_border,
              color: likedStatus[news.newsId] == true 
                  ? Colors.red 
                  : Colors.grey,
            ),
            onPressed: () {
              _toggleLike(news);
            },
          ),
        ),
      ),
      openBuilder: (context, action) => Scaffold(
        appBar: AppBar(title: Text(news.newsTitle.toString())),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.newsTitle.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                df.format(DateTime.parse(news.newsDate.toString())),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                news.newsDetails.toString(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleLike(News news) {
    setState(() {
      final newsId = news.newsId ?? '';
      bool isLiked = likedStatus[newsId] ?? false;
      likedStatus[newsId] = !isLiked;

      if (!isLiked) {
        // Move liked news to top
        newsList.remove(news);
        newsList.insert(0, news);
        filteredNewsList = List.from(newsList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'News Hub',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,  // Update text color
        ),
      ),
      backgroundColor: Colors.blue[800],  // Match membership blue
      iconTheme: IconThemeData(color: Colors.white),  // White icons
      actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadNewsData,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (content) => const NewNewsScreen())
              );
              loadNewsData();
            },
          ),
        ],
        bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: Colors.blue[800],  // Match app bar color
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _searchNews,
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (filteredNewsList.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No news found',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredNewsList.length,
                      itemBuilder: (context, index) {
                        return _buildNewsCard(filteredNewsList[index]);
                      },
                    ),
                  ),
                if (filteredNewsList.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        numofpage,
                        (index) => TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadNewsData();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: (curpage - 1) == index 
                                ? Colors.white
                                : Colors.black,
                            backgroundColor: (curpage - 1) == index 
                                ? Colors.blue.shade500 
                                : Colors.transparent,
                          ),
                          child: Text((index + 1).toString()),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
