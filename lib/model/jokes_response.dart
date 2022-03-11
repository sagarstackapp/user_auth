import 'package:user_auth/common/method/methods.dart';

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['icon_url'] = iconUrl;
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['url'] = url;
    data['value'] = value;
    if (categories == null) {
      logs('JokesCategory data null');
    } else {
      data['categories'] = categories;
    }
    return data;
  }
}
