class Address {
  final int id;
  final String zipCode;
  final String state;
  final String city;
  final String district;
  final String street;
  final String number;
  final String? complement;

  Address({
    required this.id,
    required this.zipCode,
    required this.state,
    required this.city,
    required this.district,
    required this.street,
    required this.number,
    this.complement,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      zipCode: json['zipCode'],
      state: json['state'],
      city: json['city'],
      district: json['district'],
      street: json['street'],
      number: json['number'],
      complement: json['complement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zipCode': zipCode,
      'state': state,
      'city': city,
      'district': district,
      'street': street,
      'number': number,
      'complement': complement,
    };
  }
}
