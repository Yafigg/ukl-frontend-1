class Matkul {
  final String id; // We'll convert this from int to String in the constructor
  final String namaMatkul;
  final int sks;
  bool isSelected;

  Matkul({
    required this.id,
    required this.namaMatkul,
    required this.sks,
    this.isSelected = false,
  });

  factory Matkul.fromJson(Map<String, dynamic> json) {
    // Convert the id to String regardless of whether it's an int or String
    return Matkul(
      id:
          json['id']
              .toString(), // Convert to String to handle both int and String types
      namaMatkul: json['nama_matkul'] as String,
      sks: json['sks'] is int ? json['sks'] : int.parse(json['sks'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama_matkul': namaMatkul, 'sks': sks};
  }
}
