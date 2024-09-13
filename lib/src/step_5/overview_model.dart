// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';

/// （コントリビュータ）概要モデル
@immutable
class OverviewModel {
  final String login;
  final int id;
  final String node_id;
  final String avatar_url;
  final String gravatar_id;
  final String url;
  final String html_url;
  final String followers_url;
  final String following_url;
  final String gists_url;
  final String starred_url;
  final String subscriptions_url;
  final String organizations_url;
  final String repos_url;
  final String events_url;
  final String received_events_url;
  final String type;
  final bool site_admin;
  final int contributions;

  const OverviewModel({
    required this.login,
    required this.id,
    required this.node_id,
    required this.avatar_url,
    required this.gravatar_id,
    required this.url,
    required this.html_url,
    required this.followers_url,
    required this.following_url,
    required this.gists_url,
    required this.starred_url,
    required this.subscriptions_url,
    required this.organizations_url,
    required this.repos_url,
    required this.events_url,
    required this.received_events_url,
    required this.type,
    required this.site_admin,
    required this.contributions,
  });

  OverviewModel.fromJson(Map<String, dynamic> json) : this(
    login: json['login'] as String,
    id: json['id'] as int,
    node_id: json['node_id'] as String,
    avatar_url: json['avatar_url'] as String,
    gravatar_id: json['gravatar_id'] as String,
    url: json['url'] as String,
    html_url: json['html_url'] as String,
    followers_url: json['followers_url'] as String,
    following_url: json['following_url'] as String,
    gists_url: json['gists_url'] as String,
    starred_url: json['starred_url'] as String,
    subscriptions_url: json['subscriptions_url'] as String,
    organizations_url: json['organizations_url'] as String,
    repos_url: json['repos_url'] as String,
    events_url: json['events_url'] as String,
    received_events_url: json['received_events_url'] as String,
    type: json['type'] as String,
    site_admin: json['site_admin'] as bool,
    contributions: json['contributions'] as int,
  );

  static List<OverviewModel> fromJsonList(List<dynamic> jsonList) {
    return List.unmodifiable(jsonList.map((json) => OverviewModel.fromJson(json)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'node_id': node_id,
      'avatar_url': avatar_url,
      'gravatar_id': gravatar_id,
      'url': url,
      'html_url': html_url,
      'followers_url': followers_url,
      'following_url': following_url,
      'gists_url': gists_url,
      'starred_url': starred_url,
      'subscriptions_url': subscriptions_url,
      'organizations_url': organizations_url,
      'repos_url': repos_url,
      'events_url': events_url,
      'received_events_url': received_events_url,
      'type': type,
      'site_admin': site_admin,
      'contributions': contributions,
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
  "contributions": $contributions,
}""";
  }
}
