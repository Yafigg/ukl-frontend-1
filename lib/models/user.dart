class User {
  final String? id;
  final String? namaPelanggan; // sesuaikan dengan nama_pelanggan di API
  final String? alamat;
  final String? gender;
  final String? telepon;
  final String? foto;
  final String? username;

  User({
    this.id,
    this.namaPelanggan,
    this.alamat,
    this.gender,
    this.telepon,
    this.foto,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      namaPelanggan:
          json['nama_pelanggan'], // sesuaikan dengan nama_pelanggan di API
      alamat: json['alamat'],
      gender: json['gender'],
      telepon: json['telepon'],
      foto: json['foto'],
      username: json['username'],
    );
  }
}
