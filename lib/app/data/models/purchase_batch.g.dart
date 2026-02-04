// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_batch.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPurchaseBatchCollection on Isar {
  IsarCollection<PurchaseBatch> get purchaseBatchs => this.collection();
}

const PurchaseBatchSchema = CollectionSchema(
  name: r'PurchaseBatch',
  id: 4698716822576984932,
  properties: {
    r'billImageFilename': PropertySchema(
      id: 0,
      name: r'billImageFilename',
      type: IsarType.string,
    ),
    r'purchaseDate': PropertySchema(
      id: 1,
      name: r'purchaseDate',
      type: IsarType.dateTime,
    ),
    r'totalAmount': PropertySchema(
      id: 2,
      name: r'totalAmount',
      type: IsarType.double,
    ),
    r'totalUnits': PropertySchema(
      id: 3,
      name: r'totalUnits',
      type: IsarType.long,
    )
  },
  estimateSize: _purchaseBatchEstimateSize,
  serialize: _purchaseBatchSerialize,
  deserialize: _purchaseBatchDeserialize,
  deserializeProp: _purchaseBatchDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'supplier': LinkSchema(
      id: -8748962558048758775,
      name: r'supplier',
      target: r'Supplier',
      single: true,
    ),
    r'bikes': LinkSchema(
      id: 9146896879191537668,
      name: r'bikes',
      target: r'Bike',
      single: false,
      linkName: r'batch',
    )
  },
  embeddedSchemas: {},
  getId: _purchaseBatchGetId,
  getLinks: _purchaseBatchGetLinks,
  attach: _purchaseBatchAttach,
  version: '3.1.0+1',
);

int _purchaseBatchEstimateSize(
  PurchaseBatch object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.billImageFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _purchaseBatchSerialize(
  PurchaseBatch object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.billImageFilename);
  writer.writeDateTime(offsets[1], object.purchaseDate);
  writer.writeDouble(offsets[2], object.totalAmount);
  writer.writeLong(offsets[3], object.totalUnits);
}

PurchaseBatch _purchaseBatchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PurchaseBatch();
  object.billImageFilename = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.purchaseDate = reader.readDateTime(offsets[1]);
  object.totalAmount = reader.readDouble(offsets[2]);
  object.totalUnits = reader.readLong(offsets[3]);
  return object;
}

P _purchaseBatchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _purchaseBatchGetId(PurchaseBatch object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _purchaseBatchGetLinks(PurchaseBatch object) {
  return [object.supplier, object.bikes];
}

void _purchaseBatchAttach(
    IsarCollection<dynamic> col, Id id, PurchaseBatch object) {
  object.id = id;
  object.supplier.attach(col, col.isar.collection<Supplier>(), r'supplier', id);
  object.bikes.attach(col, col.isar.collection<Bike>(), r'bikes', id);
}

extension PurchaseBatchQueryWhereSort
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QWhere> {
  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PurchaseBatchQueryWhere
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QWhereClause> {
  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterWhereClause> idBetween(
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
}

extension PurchaseBatchQueryFilter
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QFilterCondition> {
  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'billImageFilename',
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'billImageFilename',
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'billImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'billImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'billImageFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'billImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'billImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'billImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'billImageFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'billImageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      billImageFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'billImageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      purchaseDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      purchaseDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      purchaseDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      purchaseDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalUnitsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalUnits',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalUnitsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalUnits',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalUnitsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalUnits',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      totalUnitsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalUnits',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PurchaseBatchQueryObject
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QFilterCondition> {}

extension PurchaseBatchQueryLinks
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QFilterCondition> {
  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition> supplier(
      FilterQuery<Supplier> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'supplier');
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      supplierIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'supplier', 0, true, 0, true);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition> bikes(
      FilterQuery<Bike> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bikes');
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      bikesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bikes', length, true, length, true);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      bikesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bikes', 0, true, 0, true);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      bikesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bikes', 0, false, 999999, true);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      bikesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bikes', 0, true, length, include);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      bikesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bikes', length, include, 999999, true);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterFilterCondition>
      bikesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'bikes', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PurchaseBatchQuerySortBy
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QSortBy> {
  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      sortByBillImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billImageFilename', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      sortByBillImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billImageFilename', Sort.desc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      sortByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      sortByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy> sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy> sortByTotalUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUnits', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      sortByTotalUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUnits', Sort.desc);
    });
  }
}

extension PurchaseBatchQuerySortThenBy
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QSortThenBy> {
  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      thenByBillImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billImageFilename', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      thenByBillImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'billImageFilename', Sort.desc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      thenByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      thenByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy> thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy> thenByTotalUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUnits', Sort.asc);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QAfterSortBy>
      thenByTotalUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUnits', Sort.desc);
    });
  }
}

extension PurchaseBatchQueryWhereDistinct
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QDistinct> {
  QueryBuilder<PurchaseBatch, PurchaseBatch, QDistinct>
      distinctByBillImageFilename({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'billImageFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QDistinct>
      distinctByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseDate');
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QDistinct>
      distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }

  QueryBuilder<PurchaseBatch, PurchaseBatch, QDistinct> distinctByTotalUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalUnits');
    });
  }
}

extension PurchaseBatchQueryProperty
    on QueryBuilder<PurchaseBatch, PurchaseBatch, QQueryProperty> {
  QueryBuilder<PurchaseBatch, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PurchaseBatch, String?, QQueryOperations>
      billImageFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'billImageFilename');
    });
  }

  QueryBuilder<PurchaseBatch, DateTime, QQueryOperations>
      purchaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseDate');
    });
  }

  QueryBuilder<PurchaseBatch, double, QQueryOperations> totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }

  QueryBuilder<PurchaseBatch, int, QQueryOperations> totalUnitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalUnits');
    });
  }
}
