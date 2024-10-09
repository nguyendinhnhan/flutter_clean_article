import 'package:equatable/equatable.dart';

class Source extends Equatable {
  final String id;
  final String name;

  const Source({
    required this.id,
    required this.name,
  });

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'] != null ? map['id'] as String : '',
      name: map['name'] != null ? map['name'] as String : '',
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
