// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_contract.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInstallmentContractCollection on Isar {
  IsarCollection<InstallmentContract> get installmentContracts =>
      this.collection();
}

const InstallmentContractSchema = CollectionSchema(
  name: r'InstallmentContract',
  id: -8815295066666458563,
  properties: {
    r'bikeId': PropertySchema(
      id: 0,
      name: r'bikeId',
      type: IsarType.long,
    ),
    r'cashPrice': PropertySchema(
      id: 1,
      name: r'cashPrice',
      type: IsarType.double,
    ),
    r'contractDate': PropertySchema(
      id: 2,
      name: r'contractDate',
      type: IsarType.dateTime,
    ),
    r'customerId': PropertySchema(
      id: 3,
      name: r'customerId',
      type: IsarType.long,
    ),
    r'dayOfMonth': PropertySchema(
      id: 4,
      name: r'dayOfMonth',
      type: IsarType.long,
    ),
    r'discountAmount': PropertySchema(
      id: 5,
      name: r'discountAmount',
      type: IsarType.double,
    ),
    r'discountPercentage': PropertySchema(
      id: 6,
      name: r'discountPercentage',
      type: IsarType.double,
    ),
    r'downPayment': PropertySchema(
      id: 7,
      name: r'downPayment',
      type: IsarType.double,
    ),
    r'firstDueDate': PropertySchema(
      id: 8,
      name: r'firstDueDate',
      type: IsarType.dateTime,
    ),
    r'isOverdue': PropertySchema(
      id: 9,
      name: r'isOverdue',
      type: IsarType.bool,
    ),
    r'lastPaymentDate': PropertySchema(
      id: 10,
      name: r'lastPaymentDate',
      type: IsarType.dateTime,
    ),
    r'lateFeeEnabled': PropertySchema(
      id: 11,
      name: r'lateFeeEnabled',
      type: IsarType.bool,
    ),
    r'lateFeePercentage': PropertySchema(
      id: 12,
      name: r'lateFeePercentage',
      type: IsarType.double,
    ),
    r'markupType': PropertySchema(
      id: 13,
      name: r'markupType',
      type: IsarType.byte,
      enumMap: _InstallmentContractmarkupTypeEnumValueMap,
    ),
    r'markupValue': PropertySchema(
      id: 14,
      name: r'markupValue',
      type: IsarType.double,
    ),
    r'monthlyEMI': PropertySchema(
      id: 15,
      name: r'monthlyEMI',
      type: IsarType.double,
    ),
    r'months': PropertySchema(
      id: 16,
      name: r'months',
      type: IsarType.long,
    ),
    r'nextDueDate': PropertySchema(
      id: 17,
      name: r'nextDueDate',
      type: IsarType.dateTime,
    ),
    r'notes': PropertySchema(
      id: 18,
      name: r'notes',
      type: IsarType.string,
    ),
    r'paymentProgress': PropertySchema(
      id: 19,
      name: r'paymentProgress',
      type: IsarType.double,
    ),
    r'paymentsMade': PropertySchema(
      id: 20,
      name: r'paymentsMade',
      type: IsarType.long,
    ),
    r'paymentsRemaining': PropertySchema(
      id: 21,
      name: r'paymentsRemaining',
      type: IsarType.long,
    ),
    r'remainingBalance': PropertySchema(
      id: 22,
      name: r'remainingBalance',
      type: IsarType.double,
    ),
    r'status': PropertySchema(
      id: 23,
      name: r'status',
      type: IsarType.byte,
      enumMap: _InstallmentContractstatusEnumValueMap,
    ),
    r'totalAmount': PropertySchema(
      id: 24,
      name: r'totalAmount',
      type: IsarType.double,
    ),
    r'totalMarkupAmount': PropertySchema(
      id: 25,
      name: r'totalMarkupAmount',
      type: IsarType.double,
    ),
    r'totalPaid': PropertySchema(
      id: 26,
      name: r'totalPaid',
      type: IsarType.double,
    )
  },
  estimateSize: _installmentContractEstimateSize,
  serialize: _installmentContractSerialize,
  deserialize: _installmentContractDeserialize,
  deserializeProp: _installmentContractDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _installmentContractGetId,
  getLinks: _installmentContractGetLinks,
  attach: _installmentContractAttach,
  version: '3.1.0+1',
);

int _installmentContractEstimateSize(
  InstallmentContract object,
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

void _installmentContractSerialize(
  InstallmentContract object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bikeId);
  writer.writeDouble(offsets[1], object.cashPrice);
  writer.writeDateTime(offsets[2], object.contractDate);
  writer.writeLong(offsets[3], object.customerId);
  writer.writeLong(offsets[4], object.dayOfMonth);
  writer.writeDouble(offsets[5], object.discountAmount);
  writer.writeDouble(offsets[6], object.discountPercentage);
  writer.writeDouble(offsets[7], object.downPayment);
  writer.writeDateTime(offsets[8], object.firstDueDate);
  writer.writeBool(offsets[9], object.isOverdue);
  writer.writeDateTime(offsets[10], object.lastPaymentDate);
  writer.writeBool(offsets[11], object.lateFeeEnabled);
  writer.writeDouble(offsets[12], object.lateFeePercentage);
  writer.writeByte(offsets[13], object.markupType.index);
  writer.writeDouble(offsets[14], object.markupValue);
  writer.writeDouble(offsets[15], object.monthlyEMI);
  writer.writeLong(offsets[16], object.months);
  writer.writeDateTime(offsets[17], object.nextDueDate);
  writer.writeString(offsets[18], object.notes);
  writer.writeDouble(offsets[19], object.paymentProgress);
  writer.writeLong(offsets[20], object.paymentsMade);
  writer.writeLong(offsets[21], object.paymentsRemaining);
  writer.writeDouble(offsets[22], object.remainingBalance);
  writer.writeByte(offsets[23], object.status.index);
  writer.writeDouble(offsets[24], object.totalAmount);
  writer.writeDouble(offsets[25], object.totalMarkupAmount);
  writer.writeDouble(offsets[26], object.totalPaid);
}

InstallmentContract _installmentContractDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InstallmentContract();
  object.bikeId = reader.readLong(offsets[0]);
  object.cashPrice = reader.readDouble(offsets[1]);
  object.contractDate = reader.readDateTime(offsets[2]);
  object.customerId = reader.readLong(offsets[3]);
  object.dayOfMonth = reader.readLong(offsets[4]);
  object.discountAmount = reader.readDouble(offsets[5]);
  object.discountPercentage = reader.readDouble(offsets[6]);
  object.downPayment = reader.readDouble(offsets[7]);
  object.firstDueDate = reader.readDateTime(offsets[8]);
  object.id = id;
  object.lastPaymentDate = reader.readDateTimeOrNull(offsets[10]);
  object.lateFeeEnabled = reader.readBool(offsets[11]);
  object.lateFeePercentage = reader.readDouble(offsets[12]);
  object.markupType = _InstallmentContractmarkupTypeValueEnumMap[
          reader.readByteOrNull(offsets[13])] ??
      MarkupType.percentage;
  object.markupValue = reader.readDouble(offsets[14]);
  object.monthlyEMI = reader.readDouble(offsets[15]);
  object.months = reader.readLong(offsets[16]);
  object.nextDueDate = reader.readDateTimeOrNull(offsets[17]);
  object.notes = reader.readStringOrNull(offsets[18]);
  object.paymentsMade = reader.readLong(offsets[20]);
  object.status = _InstallmentContractstatusValueEnumMap[
          reader.readByteOrNull(offsets[23])] ??
      ContractStatusEnum.active;
  object.totalAmount = reader.readDouble(offsets[24]);
  object.totalMarkupAmount = reader.readDouble(offsets[25]);
  object.totalPaid = reader.readDouble(offsets[26]);
  return object;
}

P _installmentContractDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (_InstallmentContractmarkupTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MarkupType.percentage) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readDouble(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readDouble(offset)) as P;
    case 23:
      return (_InstallmentContractstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ContractStatusEnum.active) as P;
    case 24:
      return (reader.readDouble(offset)) as P;
    case 25:
      return (reader.readDouble(offset)) as P;
    case 26:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _InstallmentContractmarkupTypeEnumValueMap = {
  'percentage': 0,
  'fixed': 1,
};
const _InstallmentContractmarkupTypeValueEnumMap = {
  0: MarkupType.percentage,
  1: MarkupType.fixed,
};
const _InstallmentContractstatusEnumValueMap = {
  'active': 0,
  'partiallyPaid': 1,
  'overdue': 2,
  'completed': 3,
  'defaulted': 4,
};
const _InstallmentContractstatusValueEnumMap = {
  0: ContractStatusEnum.active,
  1: ContractStatusEnum.partiallyPaid,
  2: ContractStatusEnum.overdue,
  3: ContractStatusEnum.completed,
  4: ContractStatusEnum.defaulted,
};

Id _installmentContractGetId(InstallmentContract object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _installmentContractGetLinks(
    InstallmentContract object) {
  return [];
}

void _installmentContractAttach(
    IsarCollection<dynamic> col, Id id, InstallmentContract object) {
  object.id = id;
}

extension InstallmentContractQueryWhereSort
    on QueryBuilder<InstallmentContract, InstallmentContract, QWhere> {
  QueryBuilder<InstallmentContract, InstallmentContract, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InstallmentContractQueryWhere
    on QueryBuilder<InstallmentContract, InstallmentContract, QWhereClause> {
  QueryBuilder<InstallmentContract, InstallmentContract, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterWhereClause>
      idBetween(
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

extension InstallmentContractQueryFilter on QueryBuilder<InstallmentContract,
    InstallmentContract, QFilterCondition> {
  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      bikeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bikeId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      bikeIdGreaterThan(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      bikeIdLessThan(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      bikeIdBetween(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      cashPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      cashPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      cashPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      cashPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      contractDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contractDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      contractDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contractDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      contractDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contractDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      contractDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contractDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      customerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      customerIdGreaterThan(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      customerIdLessThan(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      customerIdBetween(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      dayOfMonthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      dayOfMonthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      dayOfMonthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      dayOfMonthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discountAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discountAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discountAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discountAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discountPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discountPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discountPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      discountPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discountPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      downPaymentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downPayment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      downPaymentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downPayment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      downPaymentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downPayment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      downPaymentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downPayment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      firstDueDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      firstDueDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      firstDueDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      firstDueDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstDueDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      isOverdueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOverdue',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lastPaymentDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastPaymentDate',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lastPaymentDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastPaymentDate',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lastPaymentDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPaymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lastPaymentDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPaymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lastPaymentDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPaymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lastPaymentDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPaymentDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lateFeeEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lateFeeEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lateFeePercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lateFeePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lateFeePercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lateFeePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lateFeePercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lateFeePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      lateFeePercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lateFeePercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupTypeEqualTo(MarkupType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markupType',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupTypeGreaterThan(
    MarkupType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'markupType',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupTypeLessThan(
    MarkupType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'markupType',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupTypeBetween(
    MarkupType lower,
    MarkupType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'markupType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupValueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markupValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupValueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'markupValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupValueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'markupValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      markupValueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'markupValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthlyEMIEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyEMI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthlyEMIGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyEMI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthlyEMILessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyEMI',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthlyEMIBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyEMI',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'months',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'months',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'months',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      monthsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'months',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      nextDueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextDueDate',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      nextDueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextDueDate',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      nextDueDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      nextDueDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      nextDueDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      nextDueDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextDueDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesEqualTo(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesGreaterThan(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesLessThan(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesBetween(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesStartsWith(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesEndsWith(
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentProgressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentProgressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentProgressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentProgress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentProgressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentProgress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsMadeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentsMade',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsMadeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentsMade',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsMadeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentsMade',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsMadeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentsMade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsRemainingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentsRemaining',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsRemainingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentsRemaining',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsRemainingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentsRemaining',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      paymentsRemainingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentsRemaining',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      remainingBalanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      remainingBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      remainingBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      remainingBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      statusEqualTo(ContractStatusEnum value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      statusGreaterThan(
    ContractStatusEnum value, {
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      statusLessThan(
    ContractStatusEnum value, {
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      statusBetween(
    ContractStatusEnum lower,
    ContractStatusEnum upper, {
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
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

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalMarkupAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalMarkupAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalMarkupAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalMarkupAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalMarkupAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalMarkupAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalMarkupAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalMarkupAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalPaidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalPaidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalPaidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterFilterCondition>
      totalPaidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPaid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension InstallmentContractQueryObject on QueryBuilder<InstallmentContract,
    InstallmentContract, QFilterCondition> {}

extension InstallmentContractQueryLinks on QueryBuilder<InstallmentContract,
    InstallmentContract, QFilterCondition> {}

extension InstallmentContractQuerySortBy
    on QueryBuilder<InstallmentContract, InstallmentContract, QSortBy> {
  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByBikeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByCashPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashPrice', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByCashPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashPrice', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByContractDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByContractDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDiscountAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDiscountAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDiscountPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPercentage', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDiscountPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPercentage', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDownPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downPayment', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByDownPaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downPayment', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByFirstDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByFirstDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByLastPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByLastPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByLateFeeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeeEnabled', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByLateFeeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeeEnabled', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByLateFeePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeePercentage', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByLateFeePercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeePercentage', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMarkupType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupType', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMarkupTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupType', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMarkupValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupValue', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMarkupValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupValue', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMonthlyEMI() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyEMI', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMonthlyEMIDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyEMI', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMonths() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'months', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByMonthsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'months', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByNextDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByNextDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByPaymentProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProgress', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByPaymentProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProgress', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByPaymentsMade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsMade', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByPaymentsMadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsMade', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByPaymentsRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsRemaining', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByPaymentsRemainingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsRemaining', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByRemainingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingBalance', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByRemainingBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingBalance', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByTotalMarkupAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMarkupAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByTotalMarkupAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMarkupAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByTotalPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      sortByTotalPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.desc);
    });
  }
}

extension InstallmentContractQuerySortThenBy
    on QueryBuilder<InstallmentContract, InstallmentContract, QSortThenBy> {
  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByBikeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeId', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByCashPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashPrice', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByCashPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashPrice', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByContractDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByContractDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDiscountAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDiscountAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDiscountPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPercentage', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDiscountPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountPercentage', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDownPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downPayment', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByDownPaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downPayment', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByFirstDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByFirstDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDueDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByLastPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByLastPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByLateFeeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeeEnabled', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByLateFeeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeeEnabled', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByLateFeePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeePercentage', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByLateFeePercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lateFeePercentage', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMarkupType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupType', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMarkupTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupType', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMarkupValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupValue', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMarkupValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markupValue', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMonthlyEMI() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyEMI', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMonthlyEMIDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyEMI', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMonths() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'months', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByMonthsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'months', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByNextDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueDate', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByNextDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextDueDate', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByPaymentProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProgress', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByPaymentProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProgress', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByPaymentsMade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsMade', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByPaymentsMadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsMade', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByPaymentsRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsRemaining', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByPaymentsRemainingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentsRemaining', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByRemainingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingBalance', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByRemainingBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingBalance', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByTotalMarkupAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMarkupAmount', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByTotalMarkupAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMarkupAmount', Sort.desc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByTotalPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.asc);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QAfterSortBy>
      thenByTotalPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.desc);
    });
  }
}

extension InstallmentContractQueryWhereDistinct
    on QueryBuilder<InstallmentContract, InstallmentContract, QDistinct> {
  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByBikeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bikeId');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByCashPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashPrice');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByContractDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contractDate');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfMonth');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByDiscountAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discountAmount');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByDiscountPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discountPercentage');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByDownPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downPayment');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByFirstDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstDueDate');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOverdue');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByLastPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPaymentDate');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByLateFeeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lateFeeEnabled');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByLateFeePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lateFeePercentage');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByMarkupType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markupType');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByMarkupValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markupValue');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByMonthlyEMI() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyEMI');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByMonths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'months');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByNextDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextDueDate');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByPaymentProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentProgress');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByPaymentsMade() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentsMade');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByPaymentsRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentsRemaining');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByRemainingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingBalance');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByTotalMarkupAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalMarkupAmount');
    });
  }

  QueryBuilder<InstallmentContract, InstallmentContract, QDistinct>
      distinctByTotalPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPaid');
    });
  }
}

extension InstallmentContractQueryProperty
    on QueryBuilder<InstallmentContract, InstallmentContract, QQueryProperty> {
  QueryBuilder<InstallmentContract, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InstallmentContract, int, QQueryOperations> bikeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bikeId');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      cashPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashPrice');
    });
  }

  QueryBuilder<InstallmentContract, DateTime, QQueryOperations>
      contractDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contractDate');
    });
  }

  QueryBuilder<InstallmentContract, int, QQueryOperations>
      customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<InstallmentContract, int, QQueryOperations>
      dayOfMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfMonth');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      discountAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discountAmount');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      discountPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discountPercentage');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      downPaymentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downPayment');
    });
  }

  QueryBuilder<InstallmentContract, DateTime, QQueryOperations>
      firstDueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstDueDate');
    });
  }

  QueryBuilder<InstallmentContract, bool, QQueryOperations>
      isOverdueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOverdue');
    });
  }

  QueryBuilder<InstallmentContract, DateTime?, QQueryOperations>
      lastPaymentDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPaymentDate');
    });
  }

  QueryBuilder<InstallmentContract, bool, QQueryOperations>
      lateFeeEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lateFeeEnabled');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      lateFeePercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lateFeePercentage');
    });
  }

  QueryBuilder<InstallmentContract, MarkupType, QQueryOperations>
      markupTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markupType');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      markupValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markupValue');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      monthlyEMIProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyEMI');
    });
  }

  QueryBuilder<InstallmentContract, int, QQueryOperations> monthsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'months');
    });
  }

  QueryBuilder<InstallmentContract, DateTime?, QQueryOperations>
      nextDueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextDueDate');
    });
  }

  QueryBuilder<InstallmentContract, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      paymentProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentProgress');
    });
  }

  QueryBuilder<InstallmentContract, int, QQueryOperations>
      paymentsMadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentsMade');
    });
  }

  QueryBuilder<InstallmentContract, int, QQueryOperations>
      paymentsRemainingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentsRemaining');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      remainingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingBalance');
    });
  }

  QueryBuilder<InstallmentContract, ContractStatusEnum, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      totalMarkupAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalMarkupAmount');
    });
  }

  QueryBuilder<InstallmentContract, double, QQueryOperations>
      totalPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPaid');
    });
  }
}
