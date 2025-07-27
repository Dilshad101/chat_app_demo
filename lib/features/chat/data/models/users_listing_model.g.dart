// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_listing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsersListingModelAdapter extends TypeAdapter<UsersListingModel> {
  @override
  final int typeId = 1;

  @override
  UsersListingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsersListingModel(
      users: (fields[0] as List).cast<User>(),
    );
  }

  @override
  void write(BinaryWriter writer, UsersListingModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersListingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      name: fields[0] as String,
      avatar: fields[1] as String,
      id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersListingModel _$UsersListingModelFromJson(Map<String, dynamic> json) =>
    UsersListingModel(
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsersListingModelToJson(UsersListingModel instance) =>
    <String, dynamic>{
      'users': instance.users,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      id: json['id'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'avatar': instance.avatar,
      'id': instance.id,
    };
