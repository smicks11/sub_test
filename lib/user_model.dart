class UserModel {
  final String name;
  final String password;
  final int point;
  final String email;

  UserModel(
      {required this.email,
      required this.name,
      required this.point,
      required this.password,
      });
}