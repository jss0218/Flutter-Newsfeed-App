import 'dart:convert';

class Comment {
  String username;
  String comment;
  DateTime timestamp;

  Comment({required this.username, required this.comment, required this.timestamp});
}
class Post {
  String username;
  String post;
  DateTime dateAndTime;
  int likes;
  bool liked;

  Post({required this.username, required this.post, required this.dateAndTime, required this.likes, required this.liked});

  Map<String, dynamic> toJson() {
  return {
    'username': username,
    'post': post,
    'dateAndTime': dateAndTime.toIso8601String(),
    'likes': likes,
    'liked': liked,
  };
}

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'] as String,
      post: json['post'] as String,
      dateAndTime: DateTime.parse(json['dateAndTime']),
      likes: json['likes'] as int,
      liked: json['liked'] as bool,
    );
  }
}
