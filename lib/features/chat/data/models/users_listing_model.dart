import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users_listing_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class UsersListingModel extends Equatable {
  const UsersListingModel({required this.users});
  @HiveField(0)
  final List<User>? users;

  factory UsersListingModel.fromJson(Map<String, dynamic> json) =>
      _$UsersListingModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsersListingModelToJson(this);

  @override
  List<Object?> get props => [users];
}

@HiveType(typeId: 2)
@JsonSerializable()
class User extends Equatable {
  const User({
    required this.name,
    required this.profileImage,
    required this.id,
  });
  @HiveField(0)
  final String? name;
  @HiveField(1)
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @HiveField(2)
  @JsonKey(name: '_id')
  final String id;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [name, profileImage];
}
