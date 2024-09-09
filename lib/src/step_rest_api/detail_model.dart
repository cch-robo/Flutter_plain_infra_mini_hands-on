// ignore_for_file: non_constant_identifier_names
import "package:flutter/foundation.dart";

/// （コントリビュータ）詳細モデル
@immutable
class DetailModel {
  final String login;
  final int id;
  final String node_id;
  final String? avatar_url;
  final String? gravatar_id;
  final String? url;
  final String? html_url;
  final String? followers_url;
  final String? following_url;
  final String? gists_url;
  final String? starred_url;
  final String? subscriptions_url;
  final String? organizations_url;
  final String? repos_url;
  final String? events_url;
  final String? received_events_url;
  final String? type;
  final bool site_admin;
  final String? name;
  final String? company;
  final String? blog;
  final String? location;
  final String? email;
  final String? hireable;
  final String? bio;
  final String? twitter_username;
  final int followers;
  final int following;
  final int public_repos;
  final int public_gists;

  const DetailModel({
    required this.login,
    required this.id,
    required this.node_id,
    this.avatar_url,
    this.gravatar_id,
    this.url,
    this.html_url,
    this.followers_url,
    this.following_url,
    this.gists_url,
    this.starred_url,
    this.subscriptions_url,
    this.organizations_url,
    this.repos_url,
    this.events_url,
    this.received_events_url,
    this.type,
    required this.site_admin,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.hireable,
    this.bio,
    this.twitter_username,
    required this.followers,
    required this.following,
    required this.public_repos,
    required this.public_gists,
  });

  DetailModel.fromJson(Map<String, dynamic> json)
      : this(
          login: json["login"] as String,
          id: json["id"] as int,
          node_id: json["node_id"] as String,
          avatar_url: json["avatar_url"] as String?,
          gravatar_id: json["gravatar_id"] as String?,
          url: json["url"] as String?,
          html_url: json["html_url"] as String?,
          followers_url: json["followers_url"] as String?,
          following_url: json["following_url"] as String?,
          gists_url: json["gists_url"] as String?,
          starred_url: json["starred_url"] as String?,
          subscriptions_url: json["subscriptions_url"] as String?,
          organizations_url: json["organizations_url"] as String?,
          repos_url: json["repos_url"] as String?,
          events_url: json["events_url"] as String?,
          received_events_url: json["received_events_url"] as String?,
          type: json["type"] as String?,
          site_admin: json["site_admin"] as bool,
          name: json["name"] as String?,
          company: json["company"] as String?,
          blog: json["blog"] as String?,
          location: json["location"] as String?,
          email: json["email"] as String?,
          hireable: json["hireable"] as String?,
          bio: json["bio"] as String?,
          twitter_username: json["twitter_username"] as String?,
          followers: json["followers"] as int,
          following: json["following"] as int,
          public_repos: json["public_repos"] as int,
          public_gists: json["public_gists"] as int,
        );

  static List<DetailModel> fromJsonList(List<dynamic> jsonList) {
    return List.unmodifiable(jsonList.map((json) => DetailModel.fromJson(json)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "login": login,
      "id": id,
      "node_id": node_id,
      "avatar_url": avatar_url,
      "gravatar_id": gravatar_id,
      "url": url,
      "html_url": html_url,
      "followers_url": followers_url,
      "following_url": following_url,
      "gists_url": gists_url,
      "starred_url": starred_url,
      "subscriptions_url": subscriptions_url,
      "organizations_url": organizations_url,
      "repos_url": repos_url,
      "events_url": events_url,
      "received_events_url": received_events_url,
      "type": type,
      "site_admin": site_admin,
      "name": name,
      "company": company,
      "blog": blog,
      "location": location,
      "email": email,
      "hireable": hireable,
      "bio": bio,
      "twitter_username": twitter_username,
      "followers": followers,
      "following": following,
      "public_repos": public_repos,
      "public_gists": public_gists,
    };
  }

  @override
  String toString() {
    return """{
  "login": $login,
  "id": $id,
  "node_id": $node_id,
  "avatar_url": $avatar_url,
  "gravatar_id": $gravatar_id,
  "url": $url,
  "html_url": $html_url,
  "followers_url": $followers_url,
  "following_url": $following_url,
  "gists_url": $gists_url,
  "starred_url": $starred_url,
  "subscriptions_url": $subscriptions_url,
  "organizations_url": $organizations_url,
  "repos_url": $repos_url,
  "events_url": $events_url,
  "received_events_url": $received_events_url,
  "type": $type,
  "site_admin": $site_admin,
  "name": $name,
  "company": $company,
  "blog": $blog,
  "location": $location,
  "email": $email,
  "hireable": $hireable,
  "bio": $bio,
  "twitter_username": $twitter_username,
  "followers": $followers,
  "following": $following,
  "public_repos": $public_repos,
  "public_gists": $public_gists,
}""";
  }
}
