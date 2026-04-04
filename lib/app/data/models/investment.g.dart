// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInvestmentCollection on Isar {
  IsarCollection<Investment> get investments => this.collection();
}

const InvestmentSchema = CollectionSchema(
  name: r'Investment',
  id: 7879499270061128774,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'bikeId': PropertySchema(
      id: 1,
      name: r'bikeId',
      type: IsarType.long,
    ),
    r'category': PropertySchema(
      id: 2,
      name: r'category',
      type: IsarType.byte,
      enumMap: _InvestmentcategoryEnumValueMap,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 4,
      name: r'description',
      type: IsarType.string,
    ),
    r'installmentContractId': PropertySchema(
      id: 5,
      name: r'installmentContractId',
      type: IsarType.long,
    ),
    r'profitAmount': PropertySchema(
      id: 6,
      name: r'profitAmount',
      type: IsarType.double,
    ),
    r'purchaseBatchId': PropertySchema(
      id: 7,
      name: r'purchaseBatchId',
      type: IsarType.long,
    ),
    r'returnLoan': PropertySchema(
      id: 8,
      name: r'returnLoan',
      type: IsarType.double,
    ),
    r'returnOther': PropertySchema(
      id: 9,
      name: r'returnOther',
      type: IsarType.double,
    ),
    r'returnPartnership': PropertySchema(
      id: 10,
      name: r'returnPartnership',
      type: IsarType.double,
    ),
    r'returnPersonal': PropertySchema(
      id: 11,
      name: r'returnPersonal',
      type: IsarType.double,
    ),
    r'saleId': PropertySchema(
      id: 12,
      name: r'saleId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 13,
      name: r'type',
      type: IsarType.byte,
      enumMap: _InvestmenttypeEnumValueMap,
    )
  },
  estimateSize: _investmentEstimateSize,
  serialize: _investmentSerialize,
  deserialize: _investmentDeserialize,
  deserializeProp: _investmentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _investmentGetId,
  getLinks: _investmentGetLinks,
  attach: _investmentAttach,
  version: '3.1.0+1',
);

int _investmentEstimateSize(
  Investment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _investmentSerialize(
  Investment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.bikeId);
  writer.writeByte(offsets[2], object.category.index);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeString(offsets[4], object.description);
  writer.writeLong(offsets[5], object.installmentContractId);
  writer.writeDouble(offsets[6], object.profitAmount);
  writer.writeLong(offsets[7], object.purchaseBatchId);
  writer.writeDouble(offsets[8], object.returnLoan);
  writer.writeDouble(offsets[9], object.returnOther);
  writer.writeDouble(offsets[10], object.returnPartnership);
  writer.writeDouble(offsets[11], object.returnPersonal);
  writer.writeLong(offsets[12], object.saleId);
  writer.writeByte(offsets[13], object.type.index);
}

Investment _investmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Investment();
  object.amount = reader.readDouble(offsets[0]);
  object.bikeId = reader.readLongOrNull(offsets[1]);
  object.category =
      _InvestmentcategoryValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          InvestmentCategoryEnum.personalCapital;
  object.date = reader.readDateTime(offsets[3]);
  object.description = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.installmentContractId = reader.readLongOrNull(offsets[5]);
  object.profitAmount = reader.readDouble(offsets[6]);
  object.purchaseBatchId = reader.readLongOrNull(offsets[7]);
  object.returnLoan = reader.readDouble(offsets[8]);
  object.returnOther = reader.readDouble(offsets[9]);
  object.returnPartnership = reader.readDouble(offsets[10]);
  object.returnPersonal = reader.readDouble(offsets[11]);
  object.saleId = reader.readLongOrNull(offsets[12]);
  object.type =
      _InvestmenttypeValueEnumMap[reader.readByteOrNull(offsets[13])] ??
          InvestmentTypeEnum.capitalInjection;
  return object;
}

P _investmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (_InvestmentcategoryValueEnumMap[reader.readByteOrNull(offset)] ??
          InvestmentCategoryEnum.personalCapital) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (_InvestmenttypeValueEnumMap[reader.readByteOrNull(offset)] ??
          InvestmentTypeEnum.capitalInjection) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _InvestmentcategoryEnumValueMap = {
  'personalCapital': 0,
  'loan': 1,
  'partnership': 2,
  'other': 3,
  'maintenance': 4,
  'personalUse': 5,
  'expense': 6,
};
const _InvestmentcategoryValueEnumMap = {
  0: InvestmentCategoryEnum.personalCapital,
  1: InvestmentCategoryEnum.loan,
  2: InvestmentCategoryEnum.partnership,
  3: InvestmentCategoryEnum.other,
  4: InvestmentCategoryEnum.maintenance,
  5: InvestmentCategoryEnum.personalUse,
  6: InvestmentCategoryEnum.expense,
};
const _InvestmenttypeEnumValueMap = {
  'capitalInjection': 0,
  'bikePurchase': 1,
  'withdrawal': 2,
  'bikeSale': 3,
  'installmentPayment': 4,
};
const _InvestmenttypeValueEnumMap = {
  0: InvestmentTypeEnum.capitalInjection,
  1: InvestmentTypeEnum.bikePurchase,
  2: InvestmentTypeEnum.withdrawal,
  3: InvestmentTypeEnum.bikeSale,
  4: InvestmentTypeEnum.installmentPayment,
};

Id _investmentGetId(Investment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _investmentGetLinks(Investment object) {
  return [];
}

void _investmentAttach(IsarCollection<dynamic> col, Id id, Investment object) {
  object.id = id;
}

extension InvestmentQueryWhereSort
    on QueryBuilder<Investment, Investment, QWhere> {
  QueryBuilder<Investment, Investment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InvestmentQueryWhere
    on QueryBuilder<Investment, Investment, QWhereClause> {
  QueryBuilder<Investment, Investment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Investment, Investment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Investment, Investment, QAfterWhereClause> idBetween(
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

extension InvestmentQueryFilter
    on QueryBuilder<Investment, Investment, QFilterCondition> {
  QueryBuilder<Investment, Investment, QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> bikeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bikeId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      bikeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bikeId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> bikeIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bikeId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> bikeIdGreaterThan(
    int? value, {
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition> bikeIdLessThan(
    int? value, {
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition> bikeIdBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition> categoryEqualTo(
      InvestmentCategoryEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      categoryGreaterThan(
    InvestmentCategoryEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> categoryLessThan(
    InvestmentCategoryEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> categoryBetween(
    InvestmentCategoryEnum lower,
    InvestmentCategoryEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      installmentContractIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'installmentContractId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      installmentContractIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'installmentContractId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      installmentContractIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installmentContractId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      installmentContractIdLessThan(
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      installmentContractIdBetween(
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

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      profitAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profitAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      profitAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profitAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      profitAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profitAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      profitAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profitAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      purchaseBatchIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaseBatchId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      purchaseBatchIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaseBatchId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      purchaseBatchIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseBatchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      purchaseBatchIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseBatchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      purchaseBatchIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseBatchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      purchaseBatchIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseBatchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> returnLoanEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'returnLoan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnLoanGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'returnLoan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnLoanLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'returnLoan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> returnLoanBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'returnLoan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnOtherEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'returnOther',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnOtherGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'returnOther',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnOtherLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'returnOther',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnOtherBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'returnOther',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPartnershipEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'returnPartnership',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPartnershipGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'returnPartnership',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPartnershipLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'returnPartnership',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPartnershipBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'returnPartnership',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPersonalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'returnPersonal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPersonalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'returnPersonal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPersonalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'returnPersonal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      returnPersonalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'returnPersonal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> saleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'saleId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition>
      saleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'saleId',
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> saleIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> saleIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> saleIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleId',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> saleIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeEqualTo(
      InvestmentTypeEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeGreaterThan(
    InvestmentTypeEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeLessThan(
    InvestmentTypeEnum value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Investment, Investment, QAfterFilterCondition> typeBetween(
    InvestmentTypeEnum lower,
    InvestmentTypeEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InvestmentQueryObject
    on QueryBuilder<Investment, Investment, QFilterCondition> {}

extension InvestmentQueryLinks
    on QueryBuilder<Investment, Investment, QFilterCondition> {}

extension InvestmentQuerySortBy
    on QueryBuilder<Investment, Investment, QSortBy> {
  QueryBuilder<Investment, Investment, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByBikeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      sortByInstallmentContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      sortByInstallmentContractIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByProfitAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitAmount', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByProfitAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitAmount', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByPurchaseBatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseBatchId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      sortByPurchaseBatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseBatchId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByReturnLoan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnLoan', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByReturnLoanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnLoan', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByReturnOther() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnOther', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByReturnOtherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnOther', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByReturnPartnership() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPartnership', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      sortByReturnPartnershipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPartnership', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByReturnPersonal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPersonal', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      sortByReturnPersonalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPersonal', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortBySaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortBySaleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InvestmentQuerySortThenBy
    on QueryBuilder<Investment, Investment, QSortThenBy> {
  QueryBuilder<Investment, Investment, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByBikeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      thenByInstallmentContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      thenByInstallmentContractIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installmentContractId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByProfitAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitAmount', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByProfitAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profitAmount', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByPurchaseBatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseBatchId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      thenByPurchaseBatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseBatchId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByReturnLoan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnLoan', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByReturnLoanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnLoan', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByReturnOther() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnOther', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByReturnOtherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnOther', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByReturnPartnership() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPartnership', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      thenByReturnPartnershipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPartnership', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByReturnPersonal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPersonal', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy>
      thenByReturnPersonalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'returnPersonal', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenBySaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenBySaleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleId', Sort.desc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Investment, Investment, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension InvestmentQueryWhereDistinct
    on QueryBuilder<Investment, Investment, QDistinct> {
  QueryBuilder<Investment, Investment, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bikeId');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Investment, Investment, QDistinct>
      distinctByInstallmentContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installmentContractId');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByProfitAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profitAmount');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByPurchaseBatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseBatchId');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByReturnLoan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnLoan');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByReturnOther() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnOther');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct>
      distinctByReturnPartnership() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnPartnership');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByReturnPersonal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'returnPersonal');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctBySaleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleId');
    });
  }

  QueryBuilder<Investment, Investment, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension InvestmentQueryProperty
    on QueryBuilder<Investment, Investment, QQueryProperty> {
  QueryBuilder<Investment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<Investment, int?, QQueryOperations> bikeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bikeId');
    });
  }

  QueryBuilder<Investment, InvestmentCategoryEnum, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<Investment, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Investment, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Investment, int?, QQueryOperations>
      installmentContractIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installmentContractId');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> profitAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profitAmount');
    });
  }

  QueryBuilder<Investment, int?, QQueryOperations> purchaseBatchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseBatchId');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> returnLoanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnLoan');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> returnOtherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnOther');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations>
      returnPartnershipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnPartnership');
    });
  }

  QueryBuilder<Investment, double, QQueryOperations> returnPersonalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'returnPersonal');
    });
  }

  QueryBuilder<Investment, int?, QQueryOperations> saleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleId');
    });
  }

  QueryBuilder<Investment, InvestmentTypeEnum, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
