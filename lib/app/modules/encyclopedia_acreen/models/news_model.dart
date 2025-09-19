/// Model class for handling news API responses
/// Contains the main response structure with pagination and results
class NewsModel {
  final String status;
  final int limit;
  final String path;
  final int page;
  final bool hasNextPages;
  final String nextPage;
  final bool hasPreviousPage;
  final String previousPage;
  final List<NewsResult> results;

  NewsModel({
    required this.status,
    required this.limit,
    required this.path,
    required this.page,
    required this.hasNextPages,
    required this.nextPage,
    required this.hasPreviousPage,
    required this.previousPage,
    required this.results,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      status: json['status'] ?? '',
      limit: json['limit'] ?? 0,
      path: json['path'] ?? '',
      page: json['page'] ?? 0,
      hasNextPages: json['has_next_pages'] ?? false,
      nextPage: json['next_page'] ?? '',
      hasPreviousPage: json['has_previous_page'] ?? false,
      previousPage: json['previous_page'] ?? '',
      results: (json['results'] as List<dynamic>?)
              ?.map((result) => NewsResult.fromJson(result))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'limit': limit,
      'path': path,
      'page': page,
      'has_next_pages': hasNextPages,
      'next_page': nextPage,
      'has_previous_page': hasPreviousPage,
      'previous_page': previousPage,
      'results': results.map((result) => result.toJson()).toList(),
    };
  }
}

/// Model class for individual news articles
/// Contains title, description, image and other article details
class NewsResult {
  final int id;
  final String href;
  final String publishedAt;
  final String title;
  final String description;
  final String body;
  final String language;
  final String? author;
  final String image;
  final List<Category> categories;
  final Source source;
  final Sentiment sentiment;

  NewsResult({
    required this.id,
    required this.href,
    required this.publishedAt,
    required this.title,
    required this.description,
    required this.body,
    required this.language,
    this.author,
    required this.image,
    required this.categories,
    required this.source,
    required this.sentiment,
  });

  factory NewsResult.fromJson(Map<String, dynamic> json) {
    return NewsResult(
      id: json['id'] ?? 0,
      href: json['href']?.toString() ?? '',
      publishedAt: json['published_at']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      author: json['author']
          ?.toString(), // ### CHANGE THIS #### - Convert to string if it's a Map
      image: json['image']?.toString() ?? '',
      categories: (json['categories'] as List<dynamic>?)
              ?.map((category) => Category.fromJson(category))
              .toList() ??
          [],
      source: Source.fromJson(json['source'] ?? {}),
      sentiment: Sentiment.fromJson(json['sentiment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'href': href,
      'published_at': publishedAt,
      'title': title,
      'description': description,
      'body': body,
      'language': language,
      'author': author,
      'image': image,
      'categories': categories.map((category) => category.toJson()).toList(),
      'source': source.toJson(),
      'sentiment': sentiment.toJson(),
    };
  }
}

class Category {
  final String id;
  final String name;
  final double score;
  final String taxonomy;
  final Map<String, dynamic> links;

  Category({
    required this.id,
    required this.name,
    required this.score,
    required this.taxonomy,
    required this.links,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
      name: json['name']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
      score: (json['score'] ?? 0.0).toDouble(),
      taxonomy: json['taxonomy']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
      links: json['links'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'taxonomy': taxonomy,
      'links': links,
    };
  }
}

class Source {
  final int id;
  final String domain;
  final String homePageUrl;
  final String type;
  final String bias;
  final Map<String, dynamic> rankings;
  final Map<String, dynamic> location;
  final String favicon;

  Source({
    required this.id,
    required this.domain,
    required this.homePageUrl,
    required this.type,
    required this.bias,
    required this.rankings,
    required this.location,
    required this.favicon,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? 0,
      domain: json['domain']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
      homePageUrl: json['home_page_url']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
      type: json['type']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
      bias: json['bias']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
      rankings: json['rankings'] ?? {},
      location: json['location'] ?? {},
      favicon: json['favicon']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domain': domain,
      'home_page_url': homePageUrl,
      'type': type,
      'bias': bias,
      'rankings': rankings,
      'location': location,
      'favicon': favicon,
    };
  }
}

class Sentiment {
  final SentimentDetail overall;
  final SentimentDetail title;
  final SentimentDetail body;

  Sentiment({
    required this.overall,
    required this.title,
    required this.body,
  });

  factory Sentiment.fromJson(Map<String, dynamic> json) {
    return Sentiment(
      overall: SentimentDetail.fromJson(json['overall'] ?? {}),
      title: SentimentDetail.fromJson(json['title'] ?? {}),
      body: SentimentDetail.fromJson(json['body'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall.toJson(),
      'title': title.toJson(),
      'body': body.toJson(),
    };
  }
}

class SentimentDetail {
  final double score;
  final String polarity;

  SentimentDetail({
    required this.score,
    required this.polarity,
  });

  factory SentimentDetail.fromJson(Map<String, dynamic> json) {
    return SentimentDetail(
      score: (json['score'] ?? 0.0).toDouble(),
      polarity: json['polarity']?.toString() ??
          '', // ### CHANGE THIS #### - Convert to string if it's a Map
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'polarity': polarity,
    };
  }
}
