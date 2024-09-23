import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_scrape_api/models/channel_data.dart';

class YoutubeVideoModel {
  String title;
  String author;
  String description;
  String? views;
  Engagement engagement;
  ChannelId channelId;
  Channel channel;
  Duration? duration;
  bool hasWatchPage;
  String url;
  VideoId id;
  bool isLive;
  UnmodifiableListView<String> keywords;
  @override
  int hashCode;
  DateTime? publishDate;
  ThumbnailSet thumbnails;
  DateTime? uploadDate;
  String? uploadDateRaw;
  YoutubeVideoModel({
    required this.title,
    required this.author,
    required this.description,
    required this.views,
    required this.engagement,
    required this.channelId,
    required this.channel,
    required this.duration,
    required this.hasWatchPage,
    required this.url,
    required this.id,
    required this.isLive,
    required this.keywords,
    required this.hashCode,
    required this.publishDate,
    required this.thumbnails,
    required this.uploadDate,
    required this.uploadDateRaw,
  });

  YoutubeVideoModel copyWith({
    String? title,
    String? author,
    String? description,
    String? views,
    Engagement? engagement,
    ChannelId? channelId,
    ChannelData? channelData,
    ValueGetter<Duration?>? duration,
    bool? hasWatchPage,
    String? url,
    VideoId? id,
    bool? isLive,
    UnmodifiableListView<String>? keywords,
    int? hashCode,
    ValueGetter<DateTime?>? publishDate,
    ThumbnailSet? thumbnails,
    ValueGetter<DateTime?>? uploadDate,
    ValueGetter<String?>? uploadDateRaw,
  }) {
    return YoutubeVideoModel(
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      views: views ?? this.views,
      engagement: engagement ?? this.engagement,
      channelId: channelId ?? this.channelId,
      channel: channel ?? channel,
      duration: duration != null ? duration() : this.duration,
      hasWatchPage: hasWatchPage ?? this.hasWatchPage,
      url: url ?? this.url,
      id: id ?? this.id,
      isLive: isLive ?? this.isLive,
      keywords: keywords ?? this.keywords,
      hashCode: hashCode ?? this.hashCode,
      publishDate: publishDate != null ? publishDate() : this.publishDate,
      thumbnails: thumbnails ?? this.thumbnails,
      uploadDate: uploadDate != null ? uploadDate() : this.uploadDate,
      uploadDateRaw:
          uploadDateRaw != null ? uploadDateRaw() : this.uploadDateRaw,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is YoutubeVideoModel &&
        other.title == title &&
        other.author == author &&
        other.description == description &&
        other.views == views &&
        other.engagement == engagement &&
        other.channelId == channelId &&
        other.channel == channel &&
        other.duration == duration &&
        other.hasWatchPage == hasWatchPage &&
        other.url == url &&
        other.id == id &&
        other.isLive == isLive &&
        other.keywords == keywords &&
        other.hashCode == hashCode &&
        other.publishDate == publishDate &&
        other.thumbnails == thumbnails &&
        other.uploadDate == uploadDate &&
        other.uploadDateRaw == uploadDateRaw;
  }
}
