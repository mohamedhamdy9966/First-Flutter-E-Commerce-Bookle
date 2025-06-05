class User {
  final String fullName, email, phone, password, address, dob, gender, image;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
    required this.dob,
    required this.gender,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'password': password,
    'address': address,
    'dob': dob,
    'gender': gender,
    'image': image,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json['fullName'],
    email: json['email'],
    phone: json['phone'],
    password: json['password'],
    address: json['address'],
    dob: json['dob'],
    gender: json['gender'],
    image: json['image'],
  );
}
