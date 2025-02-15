import 'package:apiusingaccesstoken/models/api_model.dart';
import 'package:apiusingaccesstoken/responces/api_responce.dart';
import 'package:flutter/material.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final ApiResponce apiResponce = ApiResponce();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int page = 1;
  bool isLoading = false;
  String searchQuery = "";
  List<Datum> posts = [];
  List<Datum> filteredPosts = [];
  Future<void> fetchPosts({String query = "", bool refresh = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (refresh) {
        page = 1;
        posts.clear();
        filteredPosts.clear();
      }
    });

    try {
      final fetchedPosts =
          await apiResponce.fetchPosts(page, 20, searchQuery: query);

      setState(() {
        if (refresh) {
          posts = List.from(fetchedPosts);
        } else {
          posts.addAll(fetchedPosts);
        }

        if (query.isNotEmpty) {
          filteredPosts = List.from(posts.where((post) =>
              post.title!.toLowerCase().contains(query.toLowerCase())));
        } else {
          filteredPosts = List.from(posts);
        }

        page++;
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshPosts() async {
    await fetchPosts(query: searchQuery, refresh: true);
  }

  void _search(String query) {
    setState(() {
      searchQuery = query;
    });
    fetchPosts(query: query, refresh: true);
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchPosts(query: searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView with Pagination & Search",style:TextStyle(
          color: Colors.teal,fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'Search...',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox.shrink();
                  }
                  final post = posts[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(post.title!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("area : ${post.area!}"),
                            Text("location : ${post.locationId!.title}")
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
