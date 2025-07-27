import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/users_listing_model.dart';

abstract class ChatRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UsersListingModel> getAllUsers();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSourceImpl({required this.client});

  @override
  Future<UsersListingModel> getAllUsers() => _getTriviaFromUrl(
    'https://mocki.io/v1/6ecdc9fe-01f5-4f6a-83a8-38e8419103be',
  );

  Future<UsersListingModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return UsersListingModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
