class Address {
  String addressLine1;
  String addressLine2;
  String postalCode;
  String city;
  String province;
  String country;
  String addressType;

  Address(this.addressLine1, this.addressLine2, this.postalCode, this.city,
      this.province, this.country, this.addressType);

  factory Address.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Address(
          json['addressLine1'],
          json['addressLine2'],
          json['postalCode'],
          json['city'],
          json['province'],
          json['country'],
          json['addressType']);
    } else {
      return Address('NA', '', 'NA', '', '', '', '');
    }
  }
}

class OrderListData {
  String id;
  String status;
  String deliveryStatus;
  String deliveryFirstName;
  String deliveryLastName;
  String deliveryMobileNumber;
  Address deliveryAddress;
  Address storeAddress;
  String storeName;
  String storeMobileNumber;
  String storeDistance;
  String deliveryDistance;
  String formatDate;
  String storeETATime;
  String customerETATime;

  String deliveryNotes;
  String storeNotes;

  double baseFare;
  double tip;
  double latitude;
  double longitude;
  double storeLatitude;
  double storeLongitude;

  String signatureFile;

  String collectionType;
  double collectionAmount;

  OrderListData(
      this.id,
      this.status,
      this.deliveryStatus,
      this.deliveryFirstName,
      this.deliveryLastName,
      this.deliveryMobileNumber,
      this.deliveryAddress,
      this.storeAddress,
      this.storeName,
      this.storeMobileNumber,
      this.storeDistance,
      this.deliveryDistance,
      this.formatDate,
      this.storeETATime,
      this.customerETATime,
      this.deliveryNotes,
      this.storeNotes,
      this.baseFare,
      this.tip,
      this.latitude,
      this.longitude,
      this.storeLatitude,
      this.storeLongitude,
      this.signatureFile,
      this.collectionType,
      this.collectionAmount);

  factory OrderListData.fromJson(Map<String, dynamic> json) {
    return OrderListData(
        json['id'],
        json['status'],
        json['deliveryStatus'],
        json['deliveryFirstName'] == null || json['deliveryFirstName'] == ''
            ? 'NA'
            : json['deliveryFirstName'],
        json['deliveryLastName'] == null || json['deliveryLastName'] == ''
            ? 'NA'
            : json['deliveryLastName'],
        json['deliveryMobileNumber'] == null ||
                json['deliveryMobileNumber'] == ''
            ? 'NA'
            : json['deliveryMobileNumber'],
        Address.fromJson(json['deliveryAddress']),
        Address.fromJson(json['storeAddress']),
        json['storeName'],
        json['storeMobileNumber'] == null ? 'NA' : json['storeMobileNumber'],
        json['storeDistance'] == null ? 'NA' : json['storeDistance'],
        json['distance'] == null ? 'NA' : json['distance'],
        json['formatDate'],
        json['storeETATime'],
        json['customerETATime'],
        json['notes'] == null || json['notes'] == '' ? 'None' : json['notes'],
        json['storeNotes'] == null || json['storeNotes'] == ''
            ? 'None'
            : json['storeNotes'],
        json['driverPay'],
        json['tipCharges'],
        json['location'] != null ? json['location'][0] : 0,
        json['location'] != null ? json['location'][1] : 0,
        json['storeLocation'] != null ? json['storeLocation'][0] : 0,
        json['storeLocation'] != null ? json['storeLocation'][1] : 0,
        json['signatureFile'],
        json['collectionType'],
        json['collectionAmount']);
  }
}
