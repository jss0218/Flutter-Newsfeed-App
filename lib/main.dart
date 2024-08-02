import 'package:flutter/material.dart';
import 'post.dart';
import 'package:intl/intl.dart';

import 'storage_manager.dart'; 


void main() async {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  
  final List<Post> posts = [
    Post(username: "Jasraj Sidhu", post: "Hello Daily Discovery!", dateAndTime: DateTime.now(), likes: 111892674, liked: false),
    Post(username: "Kevin Durant", post: "Excited for the game tonight! Dropping 50!", dateAndTime: DateTime.now(), likes: 2540000, liked: false),
    Post(username: "Donald Trump", post: "Great meeting today discussing future policies. Big things coming soon.", dateAndTime: DateTime.now().subtract(Duration(hours: 1)), likes: 3687268, liked: false),
    Post(username: "Oprah Winfrey", post: "Just finished a wonderful book that I can't wait to share on my next show!", dateAndTime: DateTime.now().subtract(Duration(hours: 3)), likes: 856971, liked: false),
    Post(username: "Elon Musk", post: "Rocket launch successful. Celebrating another milestone at SpaceX.", dateAndTime: DateTime.now().subtract(Duration(hours: 5)), likes: 51727869, liked: false),
    Post(username: "Rihanna", post: "New album drops next week!", dateAndTime: DateTime.now().subtract(Duration(hours: 8)), likes: 425641, liked: false),
    Post(username: "LeBron James", post: "Work hard, play harder. Gearing up for a tough season ahead.", dateAndTime: DateTime.now().subtract(Duration(days: 1)), likes: 3586247, liked: false),
    Post(username: "Dwayne Johnson", post: "Crushed my morning workout! Ready to tackle the day. #NoExcuses", dateAndTime: DateTime.now().subtract(Duration(minutes: 30)), likes: 4890345, liked: false),
    Post(username: "Kylian Mbappé", post: "Exciting times ahead with Madrid.", dateAndTime: DateTime.now().subtract(Duration(hours: 2)), likes: 2945000, liked: false),
    Post(username: "Emma Watson", post: "Join me in the fight against climate change. We have the power to make a difference!", dateAndTime: DateTime.now().subtract(Duration(hours: 6)), likes: 1827461, liked: false),
    Post(username: "Chris Hemsworth", post: "New Thor movie in the works, excited to share this with you all!", dateAndTime: DateTime.now().subtract(Duration(hours: 10)), likes: 6374829, liked: false),
    Post(username: "Serena Williams", post: "Feeling grateful for my team and fans. #Blessed", dateAndTime: DateTime.now().subtract(Duration(days: 1)), likes: 3356782, liked: false),
    Post(username: "Bill Gates", post: "Reading has always been a gateway to learning. What book are you reading this week?", dateAndTime: DateTime.now().subtract(Duration(days: 1, hours: 5)), likes: 1172944, liked: false),
  ];
    

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Discovery News Network',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(239, 109, 5, 5),
          primary: Colors.black,     
          secondary: Colors.redAccent, 
          background: Colors.black,    
          onPrimary: Colors.white,     
        ),
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 90, 6, 6),
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.redAccent
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(iconColor: Colors.redAccent),
        ),
      ),

      debugShowCheckedModeBanner: false,

      home: MyHomePage(title: 'Daily Discovery News Network', posts: posts),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Post> posts;
  MyHomePage({Key? key, required this.title, required this.posts}) : super(key: key);
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  void loadPosts() async {
    posts = await StorageManager.readPosts();
    setState(() {});
  }

  void savePosts() async {
    await StorageManager.writePosts(posts);
  }
  
  void deletePost(int index) {
    setState(() {
        widget.posts.removeAt(index);
        savePosts();
  });

  }
  void toggleLike(int index) {
  setState(() {
    widget.posts[index].liked = !widget.posts[index].liked;

    if (widget.posts[index].liked) {
      widget.posts[index].likes += 1;
    } else {
      widget.posts[index].likes -= 1;
    }
    savePosts();
  });
}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.red[900],
        title: Text("Daily Discovery News Network", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial')),
        ),
        body: ListView.builder(
          itemCount: widget.posts.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Text(
                  DateFormat('MM-dd-yyyy – kk:mm').format(widget.posts[index].dateAndTime),
                  style: TextStyle(color: Colors.black),
                ),
                title: Text(widget.posts[index].username, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.posts[index].post),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,  
                  children: [
                      Text('${widget.posts[index].likes} Likes', style: TextStyle(color: Colors.redAccent)),
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () => toggleLike(index),
                        color: widget.posts[index].liked ? Colors.redAccent : Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deletePost(index),
                      ),
                  ],
                ),
                isThreeLine: true,  
              ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPostDialog,
        tooltip: 'New Post?',
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddPostDialog() {
    TextEditingController username = TextEditingController();
    TextEditingController post = TextEditingController();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          title: Text('Create Post', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: username,
                decoration: InputDecoration(hintText: "Enter your username"),
              ),
              TextField(
                controller: post,
                decoration: InputDecoration(hintText: "Type away..."),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Post'),
              onPressed: () {
                setState(() {
                  widget.posts.insert(0, Post(
                    username: username.text,  
                    post: post.text,
                    dateAndTime: DateTime.now(),
                    likes: 0,
                    liked: false,
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}