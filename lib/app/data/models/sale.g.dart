// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaleCollection on Isar {
  IsarCollection<Sale> get sales => this.collection();
}

const SaleSchema = CollectionSchema(
  name: r'Sale',
  id: 2760258395233294300,
  properties: {
    r'bikeId': PropertySchema(
      id: 0,
      name: r'bikeId',
      type: IsarType.long,
    ),
    r'customerId': PropertySchema(
      id: 1,
      name: r'customerId',
      type: IsarType.long,
    ),
    r'installmentContractId': PropertySchema(
      id: 2,
      name: r'installmentContractId',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'receivedAmount': PropertySchema(
      id: 4,
      name: r'receivedAmount',
      type: IsarType.double,
    ),
    r'saleDate': PropertySchema(
      id: 5,
      name: r'saleDate',
      type: IsarType.dateTime,
    ),
    r'saleType': PropertySchema(
      id: 6,
      name: r'saleType',
      type: IsarType.byte,
      enumMap: _SalesaleTypeEnumValueMap,
    ),
    r'totalAmount': PropertySchema(
      id: 7,
      name: r'totalAmount',
      type: IsarType.double,
    )
  },
  estimateSize: _saleEstimateSize,
  serialize: _saleSerialize,
  deserialize: _saleDeserialize,
  deserializeProp: _saleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _saleGetId,
  getLinks: _saleGetLinks,
  attach: _saleAttach,
  version: '3.1.0+1',
);

int _saleEstimateSize(
  Sale object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _saleSerialize(
  Sale object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bikeId);
  writer.writeLong(offsets[1], object.customerId);
  writer.writeLong(offsets[2], object.installmentContractId);
  writer.writeString(offsets[3], object.notes);
  writer.writeDouble(offsets[4], object.receivedAmount);
  writer.writeDateTime(offsets[5], object.saleDate);
  writer.writeByte(offsets[6], object.saleType.index);
  writer.writeDouble(offsets[7], object.totalAmount);
}

Sale _saleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Sale();
  object.bikeId = reader.readLong(offsets[0]);
  object.customerId = reader.readLong(offsets[1]);
  object.id = id;
  object.installmentContractId = reader.readLongOrNull(offsets[2]);
  object.notes = reader.readStringOrNull(offsets[3]);
  object.receivedAmount = reader.readDouble(offsets[4]);
  object.saleDate = reader.readDateTime(offsets[5]);
  object.saleType =
      _SalesaleTypeValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          SaleType.cash;
  object.totalAmount = reader.readDouble(offsets[7]);
  return object;
}

P _saleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (_SalesaleTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          SaleType.cash) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SalesaleTypeEnumValueMap = {
  'cash': 0,
  'installment': 1,
};
const _SalesaleTypeValueEnumMap = {
  0: SaleType.cash,
  1: SaleType.installment,
};

Id _saleGetId(Sale object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _saleGetLinks(Sale object) {
  return [];
}

void _saleAttach(IsarCollection<dynamic> col, Id id, Sale object) {
  object.id = id;
}

extension SaleQueryWhereSort on QueryBuilder<Sale, Sale, QWhere> {
  QueryBuilder<Sale, Sale, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SaleQueryWhere on QueryBuilder<Sale, Sale, QWhereClause> {
  QueryBuilder<Sale, Sale, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Sale, Sale, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Sale, Sale, QAfterWhereClause> idBetween(
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

extension SaleQueryFilter on QueryBuilder<Sale, Sale, QFilterCondition> {
  QueryBuilder<Sale, Sale, QAfterFilterCondition> bikeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bikeId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> bikeIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bikeId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> bikeIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bikeId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> bikeIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bikeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> customerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition>
      installmentContractIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'installmentContractId',
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition>
      installmentContractIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'installmentContractId',
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> installmentContractIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installmentContractId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition>
      installmentContractIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'installmentContractId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> installmentContractIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'installmentContractId',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> installmentContractIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'installmentContractId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesEqualTo(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesBetween(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesStartsWith(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesEndsWith(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> receivedAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> receivedAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receivedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> receivedAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receivedAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> receivedAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receivedAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleTypeEqualTo(
      SaleType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleType',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleTypeGreaterThan(
    SaleType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleType',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleTypeLessThan(
    SaleType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleType',
        value: value,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> saleTypeBetween(
    SaleType lower,
    SaleType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalAmountEqualTo(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalAmountGreaterThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalAmountLessThan(
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

  QueryBuilder<Sale, Sale, QAfterFilterCondition> totalAmountBetween(
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
}

extension SaleQueryObject on QueryBuilder<Sale, Sale, QFilterCondition> {}

extension SaleQueryLinks on QueryBuilder<Sale, Sale, QFilterCondition> {}

extension SaleQuerySortBy on QueryBuilder<Sale, Sale, QSortBy> {
  QueryBuilder<Sale, Sale, QAfterSortBy> sortByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByBikeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByInstallmentContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByInstallmentContractIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByReceivedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByReceivedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAmount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySaleDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleDate', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySaleDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleDate', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySaleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleType', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortBySaleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleType', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension SaleQuerySortThenBy on QueryBuilder<Sale, Sale, QSortThenBy> {
  QueryBuilder<Sale, Sale, QAfterSortBy> thenByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByBikeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByInstallmentContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByInstallmentContractIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByReceivedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByReceivedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAmount', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySaleDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleDate', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySaleDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleDate', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySaleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleType', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenBySaleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleType', Sort.desc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<Sale, Sale, QAfterSortBy> thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension SaleQueryWhereDistinct on QueryBuilder<Sale, Sale, QDistinct> {
  QueryBuilder<Sale, Sale, QDistinct> distinctByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bikeId');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByInstallmentContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installmentContractId');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByReceivedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receivedAmount');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctBySaleDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleDate');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctBySaleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleType');
    });
  }

  QueryBuilder<Sale, Sale, QDistinct> distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }
}

extension SaleQueryProperty on QueryBuilder<Sale, Sale, QQueryProperty> {
  QueryBuilder<Sale, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Sale, int, QQueryOperations> bikeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bikeId');
    });
  }

  QueryBuilder<Sale, int, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<Sale, int?, QQueryOperations> installmentContractIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installmentContractId');
    });
  }

  QueryBuilder<Sale, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> receivedAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receivedAmount');
    });
  }

  QueryBuilder<Sale, DateTime, QQueryOperations> saleDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleDate');
    });
  }

  QueryBuilder<Sale, SaleType, QQueryOperations> saleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleType');
    });
  }

  QueryBuilder<Sale, double, QQueryOperations> totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }
}
