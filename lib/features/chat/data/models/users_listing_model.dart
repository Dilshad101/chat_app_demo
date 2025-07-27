import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_listing_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class UsersListingModel extends Equatable {
  const UsersListingModel({required this.users});
  @HiveField(0)
  final List<User> users;

  factory UsersListingModel.fromJson(dynamic json) {
    if (json is List) {
      return UsersListingModel(
          users: json
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList());
    } else if (json is Map<String, dynamic>) {
      return UsersListingModel(
          users: (json['users'] as List<dynamic>)
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList());
    } else {
      throw Exception('Invalid json');
    }
  }

  Map<String, dynamic> toJson() => {'users': users};

  @override
  List<Object?> get props => [users];
}

@HiveType(typeId: 2)
@JsonSerializable()
class User extends Equatable {
  const User({
    required this.name,
    required this.avatar,
    required this.id,
  });
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String avatar;
  @HiveField(2)
  final int id;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [name, avatar, id];
}
