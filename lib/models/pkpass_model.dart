// A complete Dart model for parsing a pass.json file from a .pkpass bundle.
// This model is structured to be easily serializable and deserializable from JSON.

import 'dart:convert';

/// Represents the top-level structure of a PKPass file.
/// All properties are optional as some fields may not be present.
class PKPass {
  final int? formatVersion;
  final String? passTypeIdentifier;
  final String? serialNumber;
  final String? teamIdentifier;
  final String? webServiceURL;
  final String? authenticationToken;
  final String? description;
  final String? logoText;
  final String? organizationName;
  final String? foregroundColor;
  final String? backgroundColor;
  final String? labelColor;
  final String? barcode;
  final List<Field>? headerFields;
  final List<Field>? primaryFields;
  final List<Field>? secondaryFields;
  final List<Field>? auxiliaryFields;
  final List<Field>? backFields;
  final Barcode? barcodeObject;
  final List<Location>? locations;
  final bool? voided;
  final String? nfc;

  PKPass({
    this.formatVersion,
    this.passTypeIdentifier,
    this.serialNumber,
    this.teamIdentifier,
    this.webServiceURL,
    this.authenticationToken,
    this.description,
    this.logoText,
    this.organizationName,
    this.foregroundColor,
    this.backgroundColor,
    this.labelColor,
    this.barcode,
    this.headerFields,
    this.primaryFields,
    this.secondaryFields,
    this.auxiliaryFields,
    this.backFields,
    this.barcodeObject,
    this.locations,
    this.voided,
    this.nfc,
  });

  /// Factory constructor to create a PKPass instance from a JSON map.
  factory PKPass.fromJson(Map<String, dynamic> json) {
    return PKPass(
      formatVersion: json['formatVersion'],
      passTypeIdentifier: json['passTypeIdentifier'],
      serialNumber: json['serialNumber'],
      teamIdentifier: json['teamIdentifier'],
      webServiceURL: json['webServiceURL'],
      authenticationToken: json['authenticationToken'],
      description: json['description'],
      logoText: json['logoText'],
      organizationName: json['organizationName'],
      foregroundColor: json['foregroundColor'],
      backgroundColor: json['backgroundColor'],
      labelColor: json['labelColor'],
      barcode: json['barcode'], // Legacy barcode key
      headerFields: (json['headerFields'] as List?)?.map((e) => Field.fromJson(e)).toList(),
      primaryFields: (json['primaryFields'] as List?)?.map((e) => Field.fromJson(e)).toList(),
      secondaryFields: (json['secondaryFields'] as List?)?.map((e) => Field.fromJson(e)).toList(),
      auxiliaryFields: (json['auxiliaryFields'] as List?)?.map((e) => Field.fromJson(e)).toList(),
      backFields: (json['backFields'] as List?)?.map((e) => Field.fromJson(e)).toList(),
      barcodeObject: json['barcode'] is Map ? Barcode.fromJson(json['barcode']) : null,
      locations: (json['locations'] as List?)?.map((e) => Location.fromJson(e)).toList(),
      voided: json['voided'],
      nfc: json['nfc'] != null ? jsonEncode(json['nfc']) : null, // NFC is a nested map, so we'll store it as a JSON string
    );
  }
}

/// Represents a single key-value field on the pass.
class Field {
  final String? key;
  final String? label;
  final dynamic value; // Value can be a String, number, or Date

  Field({this.key, this.label, this.value});

  /// Factory constructor to create a Field instance from a JSON map.
  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      key: json['key'],
      label: json['label'],
      value: json['value'],
    );
  }
}

/// Represents the barcode information.
class Barcode {
  final String? message;
  final String? format;
  final String? messageEncoding;

  Barcode({this.message, this.format, this.messageEncoding});

  /// Factory constructor to create a Barcode instance from a JSON map.
  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
      message: json['message'],
      format: json['format'],
      messageEncoding: json['messageEncoding'],
    );
  }
}

/// Represents location information for the pass.
class Location {
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final String? relevantText;

  Location({this.latitude, this.longitude, this.altitude, this.relevantText});

  /// Factory constructor to create a Location instance from a JSON map.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      relevantText: json['relevantText'],
    );
  }
}
