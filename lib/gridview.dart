import 'package:apiusingaccesstoken/models/api_model.dart';
import 'package:apiusingaccesstoken/responces/api_responce.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiResponce apiServices = ApiResponce();
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
      final fetchedPosts = await apiServices.fetchPosts(page, 10, searchQuery: query);

      setState(() {
        if (refresh) {
          posts = List.from(fetchedPosts);
        } else {
          posts.addAll(fetchedPosts);
        }

    
        if (query.isNotEmpty) {
          filteredPosts = List.from(posts.where((post) => post.title!.toLowerCase().contains(query.toLowerCase())));
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
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
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
      appBar: AppBar(title: const Text("GridView with Pagination & Search",style:TextStyle(
          color: Colors.teal,fontWeight: FontWeight.bold
        ),
      )),
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
              child: filteredPosts.isEmpty && !isLoading
                  ? const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: filteredPosts.length + (isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredPosts.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final post = filteredPosts[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.title!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("Area: ${post.area}"),
                                Text("Location: ${post.locationId!.title}"),
                              ],
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
