class SchoolConnectModel {
  String? schoolName;
  String? address;
  String? phoneNumber;
  String? email;
  String? website;
  String? emergencyContactName;
  String? emergencyContactNumber;

  SchoolConnectModel({
    this.schoolName,
    this.address,
    this.phoneNumber,
    this.email,
    this.website,
    this.emergencyContactName,
    this.emergencyContactNumber,
  });

  factory SchoolConnectModel.fromMap(Map<String, dynamic> map) {
    return SchoolConnectModel(
      schoolName: map['school_name'],
      address: map['address'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      website: map['website'],
      emergencyContactName: map['emergency_contact_name'],
      emergencyContactNumber: map['emergency_contact_number'],
    );
  }
}
