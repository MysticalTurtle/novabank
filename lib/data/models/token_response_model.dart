class TokenResponseModel {
  final String accessToken;
  final String refreshToken;

  TokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
