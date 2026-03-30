// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bike.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBikeCollection on Isar {
  IsarCollection<Bike> get bikes => this.collection();
}

const BikeSchema = CollectionSchema(
  name: r'Bike',
  id: -6193120535060146724,
  properties: {
    r'brand': PropertySchema(
      id: 0,
      name: r'brand',
      type: IsarType.string,
    ),
    r'cashSalePrice': PropertySchema(
      id: 1,
      name: r'cashSalePrice',
      type: IsarType.double,
    ),
    r'chassisNumber': PropertySchema(
      id: 2,
      name: r'chassisNumber',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 3,
      name: r'color',
      type: IsarType.string,
    ),
    r'condition': PropertySchema(
      id: 4,
      name: r'condition',
      type: IsarType.byte,
      enumMap: _BikeconditionEnumValueMap,
    ),
    r'dateAdded': PropertySchema(
      id: 5,
      name: r'dateAdded',
      type: IsarType.dateTime,
    ),
    r'dateSold': PropertySchema(
      id: 6,
      name: r'dateSold',
      type: IsarType.dateTime,
    ),
    r'engineNumber': PropertySchema(
      id: 7,
      name: r'engineNumber',
      type: IsarType.string,
    ),
    r'fundedByLoan': PropertySchema(
      id: 8,
      name: r'fundedByLoan',
      type: IsarType.double,
    ),
    r'fundedByOther': PropertySchema(
      id: 9,
      name: r'fundedByOther',
      type: IsarType.double,
    ),
    r'fundedByPartnership': PropertySchema(
      id: 10,
      name: r'fundedByPartnership',
      type: IsarType.double,
    ),
    r'fundedByPersonal': PropertySchema(
      id: 11,
      name: r'fundedByPersonal',
      type: IsarType.double,
    ),
    r'imageFilename': PropertySchema(
      id: 12,
      name: r'imageFilename',
      type: IsarType.string,
    ),
    r'investmentAmount': PropertySchema(
      id: 13,
      name: r'investmentAmount',
      type: IsarType.double,
    ),
    r'model': PropertySchema(
      id: 14,
      name: r'model',
      type: IsarType.string,
    ),
    r'modelYear': PropertySchema(
      id: 15,
      name: r'modelYear',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 16,
      name: r'notes',
      type: IsarType.string,
    ),
    r'purchasePrice': PropertySchema(
      id: 17,
      name: r'purchasePrice',
      type: IsarType.double,
    ),
    r'purchaserCnic': PropertySchema(
      id: 18,
      name: r'purchaserCnic',
      type: IsarType.string,
    ),
    r'purchaserCnicBackFilename': PropertySchema(
      id: 19,
      name: r'purchaserCnicBackFilename',
      type: IsarType.string,
    ),
    r'purchaserCnicFrontFilename': PropertySchema(
      id: 20,
      name: r'purchaserCnicFrontFilename',
      type: IsarType.string,
    ),
    r'purchaserName': PropertySchema(
      id: 21,
      name: r'purchaserName',
      type: IsarType.string,
    ),
    r'purchaserPhone': PropertySchema(
      id: 22,
      name: r'purchaserPhone',
      type: IsarType.string,
    ),
    r'registrationNumber': PropertySchema(
      id: 23,
      name: r'registrationNumber',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 24,
      name: r'status',
      type: IsarType.byte,
      enumMap: _BikestatusEnumValueMap,
    )
  },
  estimateSize: _bikeEstimateSize,
  serialize: _bikeSerialize,
  deserialize: _bikeDeserialize,
  deserializeProp: _bikeDeserializeProp,
  idName: r'id',
  indexes: {
    r'engineNumber': IndexSchema(
      id: 1423583984092532627,
      name: r'engineNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'engineNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'chassisNumber': IndexSchema(
      id: -8936934506753505655,
      name: r'chassisNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chassisNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'cashSalePrice': IndexSchema(
      id: -9111366412202465075,
      name: r'cashSalePrice',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cashSalePrice',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'batch': LinkSchema(
      id: 2826581587529319531,
      name: r'batch',
      target: r'PurchaseBatch',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _bikeGetId,
  getLinks: _bikeGetLinks,
  attach: _bikeAttach,
  version: '3.1.0+1',
);

int _bikeEstimateSize(
  Bike object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.brand.length * 3;
  bytesCount += 3 + object.chassisNumber.length * 3;
  bytesCount += 3 + object.color.length * 3;
  bytesCount += 3 + object.engineNumber.length * 3;
  {
    final value = object.imageFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.model.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purchaserCnic;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purchaserCnicBackFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purchaserCnicFrontFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purchaserName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purchaserPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.registrationNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bikeSerialize(
  Bike object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.brand);
  writer.writeDouble(offsets[1], object.cashSalePrice);
  writer.writeString(offsets[2], object.chassisNumber);
  writer.writeString(offsets[3], object.color);
  writer.writeByte(offsets[4], object.condition.index);
  writer.writeDateTime(offsets[5], object.dateAdded);
  writer.writeDateTime(offsets[6], object.dateSold);
  writer.writeString(offsets[7], object.engineNumber);
  writer.writeDouble(offsets[8], object.fundedByLoan);
  writer.writeDouble(offsets[9], object.fundedByOther);
  writer.writeDouble(offsets[10], object.fundedByPartnership);
  writer.writeDouble(offsets[11], object.fundedByPersonal);
  writer.writeString(offsets[12], object.imageFilename);
  writer.writeDouble(offsets[13], object.investmentAmount);
  writer.writeString(offsets[14], object.model);
  writer.writeLong(offsets[15], object.modelYear);
  writer.writeString(offsets[16], object.notes);
  writer.writeDouble(offsets[17], object.purchasePrice);
  writer.writeString(offsets[18], object.purchaserCnic);
  writer.writeString(offsets[19], object.purchaserCnicBackFilename);
  writer.writeString(offsets[20], object.purchaserCnicFrontFilename);
  writer.writeString(offsets[21], object.purchaserName);
  writer.writeString(offsets[22], object.purchaserPhone);
  writer.writeString(offsets[23], object.registrationNumber);
  writer.writeByte(offsets[24], object.status.index);
}

Bike _bikeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Bike();
  object.brand = reader.readString(offsets[0]);
  object.cashSalePrice = reader.readDouble(offsets[1]);
  object.chassisNumber = reader.readString(offsets[2]);
  object.color = reader.readString(offsets[3]);
  object.condition =
      _BikeconditionValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          BikeConditionEnum.newBike;
  object.dateAdded = reader.readDateTime(offsets[5]);
  object.dateSold = reader.readDateTimeOrNull(offsets[6]);
  object.engineNumber = reader.readString(offsets[7]);
  object.fundedByLoan = reader.readDouble(offsets[8]);
  object.fundedByOther = reader.readDouble(offsets[9]);
  object.fundedByPartnership = reader.readDouble(offsets[10]);
  object.fundedByPersonal = reader.readDouble(offsets[11]);
  object.id = id;
  object.imageFilename = reader.readStringOrNull(offsets[12]);
  object.investmentAmount = reader.readDouble(offsets[13]);
  object.model = reader.readString(offsets[14]);
  object.modelYear = reader.readLong(offsets[15]);
  object.notes = reader.readStringOrNull(offsets[16]);
  object.purchasePrice = reader.readDouble(offsets[17]);
  object.purchaserCnic = reader.readStringOrNull(offsets[18]);
  object.purchaserCnicBackFilename = reader.readStringOrNull(offsets[19]);
  object.purchaserCnicFrontFilename = reader.readStringOrNull(offsets[20]);
  object.purchaserName = reader.readStringOrNull(offsets[21]);
  object.purchaserPhone = reader.readStringOrNull(offsets[22]);
  object.registrationNumber = reader.readStringOrNull(offsets[23]);
  object.status = _BikestatusValueEnumMap[reader.readByteOrNull(offsets[24])] ??
      BikeStatusEnum.available;
  return object;
}

P _bikeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_BikeconditionValueEnumMap[reader.readByteOrNull(offset)] ??
          BikeConditionEnum.newBike) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (_BikestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          BikeStatusEnum.available) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BikeconditionEnumValueMap = {
  'newBike': 0,
  'usedBike': 1,
};
const _BikeconditionValueEnumMap = {
  0: BikeConditionEnum.newBike,
  1: BikeConditionEnum.usedBike,
};
const _BikestatusEnumValueMap = {
  'available': 0,
  'sold': 1,
  'installment': 2,
};
const _BikestatusValueEnumMap = {
  0: BikeStatusEnum.available,
  1: BikeStatusEnum.sold,
  2: BikeStatusEnum.installment,
};

Id _bikeGetId(Bike object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bikeGetLinks(Bike object) {
  return [object.batch];
}

void _bikeAttach(IsarCollection<dynamic> col, Id id, Bike object) {
  object.id = id;
  object.batch.attach(col, col.isar.collection<PurchaseBatch>(), r'batch', id);
}

extension BikeByIndex on IsarCollection<Bike> {
  Future<Bike?> getByEngineNumber(String engineNumber) {
    return getByIndex(r'engineNumber', [engineNumber]);
  }

  Bike? getByEngineNumberSync(String engineNumber) {
    return getByIndexSync(r'engineNumber', [engineNumber]);
  }

  Future<bool> deleteByEngineNumber(String engineNumber) {
    return deleteByIndex(r'engineNumber', [engineNumber]);
  }

  bool deleteByEngineNumberSync(String engineNumber) {
    return deleteByIndexSync(r'engineNumber', [engineNumber]);
  }

  Future<List<Bike?>> getAllByEngineNumber(List<String> engineNumberValues) {
    final values = engineNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'engineNumber', values);
  }

  List<Bike?> getAllByEngineNumberSync(List<String> engineNumberValues) {
    final values = engineNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'engineNumber', values);
  }

  Future<int> deleteAllByEngineNumber(List<String> engineNumberValues) {
    final values = engineNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'engineNumber', values);
  }

  int deleteAllByEngineNumberSync(List<String> engineNumberValues) {
    final values = engineNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'engineNumber', values);
  }

  Future<Id> putByEngineNumber(Bike object) {
    return putByIndex(r'engineNumber', object);
  }

  Id putByEngineNumberSync(Bike object, {bool saveLinks = true}) {
    return putByIndexSync(r'engineNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEngineNumber(List<Bike> objects) {
    return putAllByIndex(r'engineNumber', objects);
  }

  List<Id> putAllByEngineNumberSync(List<Bike> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'engineNumber', objects, saveLinks: saveLinks);
  }

  Future<Bike?> getByChassisNumber(String chassisNumber) {
    return getByIndex(r'chassisNumber', [chassisNumber]);
  }

  Bike? getByChassisNumberSync(String chassisNumber) {
    return getByIndexSync(r'chassisNumber', [chassisNumber]);
  }

  Future<bool> deleteByChassisNumber(String chassisNumber) {
    return deleteByIndex(r'chassisNumber', [chassisNumber]);
  }

  bool deleteByChassisNumberSync(String chassisNumber) {
    return deleteByIndexSync(r'chassisNumber', [chassisNumber]);
  }

  Future<List<Bike?>> getAllByChassisNumber(List<String> chassisNumberValues) {
    final values = chassisNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'chassisNumber', values);
  }

  List<Bike?> getAllByChassisNumberSync(List<String> chassisNumberValues) {
    final values = chassisNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'chassisNumber', values);
  }

  Future<int> deleteAllByChassisNumber(List<String> chassisNumberValues) {
    final values = chassisNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'chassisNumber', values);
  }

  int deleteAllByChassisNumberSync(List<String> chassisNumberValues) {
    final values = chassisNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'chassisNumber', values);
  }

  Future<Id> putByChassisNumber(Bike object) {
    return putByIndex(r'chassisNumber', object);
  }

  Id putByChassisNumberSync(Bike object, {bool saveLinks = true}) {
    return putByIndexSync(r'chassisNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByChassisNumber(List<Bike> objects) {
    return putAllByIndex(r'chassisNumber', objects);
  }

  List<Id> putAllByChassisNumberSync(List<Bike> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'chassisNumber', objects, saveLinks: saveLinks);
  }
}

extension BikeQueryWhereSort on QueryBuilder<Bike, Bike, QWhere> {
  QueryBuilder<Bike, Bike, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhere> anyCashSalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cashSalePrice'),
      );
    });
  }
}

extension BikeQueryWhere on QueryBuilder<Bike, Bike, QWhereClause> {
  QueryBuilder<Bike, Bike, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> engineNumberEqualTo(
      String engineNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'engineNumber',
        value: [engineNumber],
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> engineNumberNotEqualTo(
      String engineNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'engineNumber',
              lower: [],
              upper: [engineNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'engineNumber',
              lower: [engineNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'engineNumber',
              lower: [engineNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'engineNumber',
              lower: [],
              upper: [engineNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> chassisNumberEqualTo(
      String chassisNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chassisNumber',
        value: [chassisNumber],
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> chassisNumberNotEqualTo(
      String chassisNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chassisNumber',
              lower: [],
              upper: [chassisNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chassisNumber',
              lower: [chassisNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chassisNumber',
              lower: [chassisNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chassisNumber',
              lower: [],
              upper: [chassisNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> cashSalePriceEqualTo(
      double cashSalePrice) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cashSalePrice',
        value: [cashSalePrice],
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> cashSalePriceNotEqualTo(
      double cashSalePrice) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashSalePrice',
              lower: [],
              upper: [cashSalePrice],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashSalePrice',
              lower: [cashSalePrice],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashSalePrice',
              lower: [cashSalePrice],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashSalePrice',
              lower: [],
              upper: [cashSalePrice],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> cashSalePriceGreaterThan(
    double cashSalePrice, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cashSalePrice',
        lower: [cashSalePrice],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> cashSalePriceLessThan(
    double cashSalePrice, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cashSalePrice',
        lower: [],
        upper: [cashSalePrice],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterWhereClause> cashSalePriceBetween(
    double lowerCashSalePrice,
    double upperCashSalePrice, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cashSalePrice',
        lower: [lowerCashSalePrice],
        includeLower: includeLower,
        upper: [upperCashSalePrice],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BikeQueryFilter on QueryBuilder<Bike, Bike, QFilterCondition> {
  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'brand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'brand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'brand',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'brand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'brand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'brand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'brand',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'brand',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> brandIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'brand',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> cashSalePriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashSalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> cashSalePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashSalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> cashSalePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashSalePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> cashSalePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashSalePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chassisNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chassisNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chassisNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> chassisNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chassisNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> conditionEqualTo(
      BikeConditionEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'condition',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> conditionGreaterThan(
    BikeConditionEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'condition',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> conditionLessThan(
    BikeConditionEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'condition',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> conditionBetween(
    BikeConditionEnum lower,
    BikeConditionEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'condition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateAddedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateAddedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateAddedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateAddedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateAdded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateSoldIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateSold',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateSoldIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateSold',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateSoldEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateSold',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateSoldGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateSold',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateSoldLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateSold',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> dateSoldBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateSold',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'engineNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'engineNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engineNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> engineNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'engineNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByLoanEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fundedByLoan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByLoanGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fundedByLoan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByLoanLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fundedByLoan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByLoanBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fundedByLoan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByOtherEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fundedByOther',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByOtherGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fundedByOther',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByOtherLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fundedByOther',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByOtherBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fundedByOther',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByPartnershipEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fundedByPartnership',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      fundedByPartnershipGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fundedByPartnership',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByPartnershipLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fundedByPartnership',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByPartnershipBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fundedByPartnership',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByPersonalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fundedByPersonal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByPersonalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fundedByPersonal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByPersonalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fundedByPersonal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> fundedByPersonalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fundedByPersonal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageFilename',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageFilename',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> imageFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> investmentAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'investmentAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> investmentAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'investmentAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> investmentAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'investmentAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> investmentAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'investmentAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'model',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelYearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelYearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelYearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> modelYearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchasePriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchasePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchasePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchasePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchasePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaserCnic',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaserCnic',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserCnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaserCnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaserCnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaserCnic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaserCnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaserCnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaserCnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaserCnic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserCnic',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserCnicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaserCnic',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaserCnicBackFilename',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaserCnicBackFilename',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserCnicBackFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaserCnicBackFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaserCnicBackFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaserCnicBackFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaserCnicBackFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaserCnicBackFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaserCnicBackFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaserCnicBackFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserCnicBackFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicBackFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaserCnicBackFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaserCnicFrontFilename',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaserCnicFrontFilename',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserCnicFrontFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaserCnicFrontFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaserCnicFrontFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaserCnicFrontFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaserCnicFrontFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaserCnicFrontFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaserCnicFrontFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaserCnicFrontFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserCnicFrontFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      purchaserCnicFrontFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaserCnicFrontFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaserName',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaserName',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaserName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaserName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserName',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaserName',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaserPhone',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaserPhone',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaserPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaserPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaserPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaserPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaserPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaserPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaserPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaserPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> purchaserPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaserPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'registrationNumber',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      registrationNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'registrationNumber',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'registrationNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registrationNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> registrationNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition>
      registrationNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> statusEqualTo(
      BikeStatusEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> statusGreaterThan(
    BikeStatusEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> statusLessThan(
    BikeStatusEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> statusBetween(
    BikeStatusEnum lower,
    BikeStatusEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BikeQueryObject on QueryBuilder<Bike, Bike, QFilterCondition> {}

extension BikeQueryLinks on QueryBuilder<Bike, Bike, QFilterCondition> {
  QueryBuilder<Bike, Bike, QAfterFilterCondition> batch(
      FilterQuery<PurchaseBatch> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'batch');
    });
  }

  QueryBuilder<Bike, Bike, QAfterFilterCondition> batchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'batch', 0, true, 0, true);
    });
  }
}

extension BikeQuerySortBy on QueryBuilder<Bike, Bike, QSortBy> {
  QueryBuilder<Bike, Bike, QAfterSortBy> sortByBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByCashSalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashSalePrice', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByCashSalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashSalePrice', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByChassisNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByChassisNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByDateSold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSold', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByDateSoldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSold', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByEngineNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByEngineNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByLoan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByLoan', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByLoanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByLoan', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByOther() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByOther', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByOtherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByOther', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByPartnership() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPartnership', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByPartnershipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPartnership', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByPersonal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPersonal', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByFundedByPersonalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPersonal', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByInvestmentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investmentAmount', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByInvestmentAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investmentAmount', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByModelYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelYear', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByModelYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelYear', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserCnic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnic', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserCnicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnic', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserCnicBackFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicBackFilename', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserCnicBackFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicBackFilename', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserCnicFrontFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicFrontFilename', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy>
      sortByPurchaserCnicFrontFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicFrontFilename', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserName', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserName', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserPhone', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByPurchaserPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserPhone', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension BikeQuerySortThenBy on QueryBuilder<Bike, Bike, QSortThenBy> {
  QueryBuilder<Bike, Bike, QAfterSortBy> thenByBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'brand', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByCashSalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashSalePrice', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByCashSalePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashSalePrice', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByChassisNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByChassisNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByDateSold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSold', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByDateSoldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateSold', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByEngineNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByEngineNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByLoan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByLoan', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByLoanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByLoan', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByOther() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByOther', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByOtherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByOther', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByPartnership() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPartnership', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByPartnershipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPartnership', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByPersonal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPersonal', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByFundedByPersonalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fundedByPersonal', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageFilename', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByInvestmentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investmentAmount', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByInvestmentAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'investmentAmount', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByModelYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelYear', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByModelYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelYear', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserCnic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnic', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserCnicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnic', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserCnicBackFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicBackFilename', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserCnicBackFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicBackFilename', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserCnicFrontFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicFrontFilename', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy>
      thenByPurchaserCnicFrontFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserCnicFrontFilename', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserName', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserName', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserPhone', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByPurchaserPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaserPhone', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Bike, Bike, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension BikeQueryWhereDistinct on QueryBuilder<Bike, Bike, QDistinct> {
  QueryBuilder<Bike, Bike, QDistinct> distinctByBrand(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'brand', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByCashSalePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashSalePrice');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByChassisNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chassisNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'condition');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAdded');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByDateSold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateSold');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByEngineNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'engineNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByFundedByLoan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fundedByLoan');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByFundedByOther() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fundedByOther');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByFundedByPartnership() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fundedByPartnership');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByFundedByPersonal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fundedByPersonal');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByImageFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByInvestmentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'investmentAmount');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByModelYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelYear');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchasePrice');
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByPurchaserCnic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaserCnic',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByPurchaserCnicBackFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaserCnicBackFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByPurchaserCnicFrontFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaserCnicFrontFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByPurchaserName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaserName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByPurchaserPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaserPhone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByRegistrationNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'registrationNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Bike, Bike, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension BikeQueryProperty on QueryBuilder<Bike, Bike, QQueryProperty> {
  QueryBuilder<Bike, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Bike, String, QQueryOperations> brandProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'brand');
    });
  }

  QueryBuilder<Bike, double, QQueryOperations> cashSalePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashSalePrice');
    });
  }

  QueryBuilder<Bike, String, QQueryOperations> chassisNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chassisNumber');
    });
  }

  QueryBuilder<Bike, String, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<Bike, BikeConditionEnum, QQueryOperations> conditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'condition');
    });
  }

  QueryBuilder<Bike, DateTime, QQueryOperations> dateAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAdded');
    });
  }

  QueryBuilder<Bike, DateTime?, QQueryOperations> dateSoldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateSold');
    });
  }

  QueryBuilder<Bike, String, QQueryOperations> engineNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'engineNumber');
    });
  }

  QueryBuilder<Bike, double, QQueryOperations> fundedByLoanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fundedByLoan');
    });
  }

  QueryBuilder<Bike, double, QQueryOperations> fundedByOtherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fundedByOther');
    });
  }

  QueryBuilder<Bike, double, QQueryOperations> fundedByPartnershipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fundedByPartnership');
    });
  }

  QueryBuilder<Bike, double, QQueryOperations> fundedByPersonalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fundedByPersonal');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations> imageFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageFilename');
    });
  }

  QueryBuilder<Bike, double, QQueryOperations> investmentAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'investmentAmount');
    });
  }

  QueryBuilder<Bike, String, QQueryOperations> modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<Bike, int, QQueryOperations> modelYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelYear');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Bike, double, QQueryOperations> purchasePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchasePrice');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations> purchaserCnicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaserCnic');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations>
      purchaserCnicBackFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaserCnicBackFilename');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations>
      purchaserCnicFrontFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaserCnicFrontFilename');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations> purchaserNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaserName');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations> purchaserPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaserPhone');
    });
  }

  QueryBuilder<Bike, String?, QQueryOperations> registrationNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationNumber');
    });
  }

  QueryBuilder<Bike, BikeStatusEnum, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
