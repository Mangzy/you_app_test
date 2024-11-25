class ProfileResponse {
  final String? name;
  final String? birthday;
  final int? height;
  final int? weight;
  final List<String>? interests;

  ProfileResponse({
    required this.name,
    required this.birthday,
    required this.height,
    required this.weight,
    this.interests,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      name: json['name'],
      birthday: json['birthday'],
      height: json['height'],
      weight: json['weight'],
      interests:
          json['interests'] != null ? List<String>.from(json['interests']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (birthday != null) data['birthday'] = birthday;
    if (height != null) data['height'] = height;
    if (weight != null) data['weight'] = weight;
    if (interests != null) data['interests'] = interests;
    return data;
  }
}
