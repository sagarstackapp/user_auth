class JokesResponse {
  final List<String> categories;
  final String createdAt;
  final String iconUrl;
  final String id;
  final String updatedAt;
  final String url;
  final String value;

  JokesResponse({
    this.categories,
    this.createdAt,
    this.iconUrl,
    this.id,
    this.updatedAt,
    this.url,
    this.value,
  });

  factory JokesResponse.fromJson(Map<String, dynamic> responseList) {
    return JokesResponse(
      categories: responseList['categories'] == null
          ? null
          : List<String>.from(responseList['categories']),
      createdAt: responseList['created_at'] ?? 'NULL',
      iconUrl: responseList['icon_url'] ?? 'NULL',
      id: responseList['id'] ?? 'NULL',
      updatedAt: responseList['updated_at'] ?? 'NULL',
      url: responseList['url'] ?? 'NULL',
      value: responseList['value'] ?? 'NULL',
    );
  }

  Map<String, dynamic> categoryMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['icon_url'] = this.iconUrl;
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    data['value'] = this.value;
    if (this.categories == null) {
      print('JokesCategory data null');
    } else {
      data['categories'] = this.categories;
    }
    return data;
  }
}
