class Member {
  final String id;
  final String? email;
  final String? username;
  final List<String>? roles;
  final dynamic geo;
  Member({required this.id, this.email, this.username, this.roles, this.geo});
}
