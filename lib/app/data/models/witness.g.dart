// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'witness.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWitnessCollection on Isar {
  IsarCollection<Witness> get witness => this.collection();
}

const WitnessSchema = CollectionSchema(
  name: r'Witness',
  id: 8849472431542267893,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'cnicImageFilename': PropertySchema(
      id: 1,
      name: r'cnicImageFilename',
      type: IsarType.string,
    ),
    r'cnicNumber': PropertySchema(
      id: 2,
      name: r'cnicNumber',
      type: IsarType.string,
    ),
    r'contractId': PropertySchema(
      id: 3,
      name: r'contractId',
      type: IsarType.long,
    ),
    r'fullName': PropertySchema(
      id: 4,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'phoneNumber': PropertySchema(
      id: 5,
      name: r'phoneNumber',
      type: IsarType.string,
    ),
    r'relationship': PropertySchema(
      id: 6,
      name: r'relationship',
      type: IsarType.string,
    )
  },
  estimateSize: _witnessEstimateSize,
  serialize: _witnessSerialize,
  deserialize: _witnessDeserialize,
  deserializeProp: _witnessDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _witnessGetId,
  getLinks: _witnessGetLinks,
  attach: _witnessAttach,
  version: '3.1.0+1',
);

int _witnessEstimateSize(
  Witness object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.address;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cnicImageFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.cnicNumber.length * 3;
  bytesCount += 3 + object.fullName.length * 3;
  bytesCount += 3 + object.phoneNumber.length * 3;
  {
    final value = object.relationship;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _witnessSerialize(
  Witness object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.cnicImageFilename);
  writer.writeString(offsets[2], object.cnicNumber);
  writer.writeLong(offsets[3], object.contractId);
  writer.writeString(offsets[4], object.fullName);
  writer.writeString(offsets[5], object.phoneNumber);
  writer.writeString(offsets[6], object.relationship);
}

Witness _witnessDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Witness();
  object.address = reader.readStringOrNull(offsets[0]);
  object.cnicImageFilename = reader.readStringOrNull(offsets[1]);
  object.cnicNumber = reader.readString(offsets[2]);
  object.contractId = reader.readLong(offsets[3]);
  object.fullName = reader.readString(offsets[4]);
  object.id = id;
  object.phoneNumber = reader.readString(offsets[5]);
  object.relationship = reader.readStringOrNull(offsets[6]);
  return object;
}

P _witnessDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _witnessGetId(Witness object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _witnessGetLinks(Witness object) {
  return [];
}

void _witnessAttach(IsarCollection<dynamic> col, Id id, Witness object) {
  object.id = id;
}

extension WitnessQueryWhereSort on QueryBuilder<Witness, Witness, QWhere> {
  QueryBuilder<Witness, Witness, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WitnessQueryWhere on QueryBuilder<Witness, Witness, QWhereClause> {
  QueryBuilder<Witness, Witness, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Witness, Witness, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Witness, Witness, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Witness, Witness, QAfterWhereClause> idBetween(
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

extension WitnessQueryFilter
    on QueryBuilder<Witness, Witness, QFilterCondition> {
  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cnicImageFilename',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cnicImageFilename',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnicImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cnicImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cnicImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cnicImageFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cnicImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cnicImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cnicImageFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cnicImageFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnicImageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      cnicImageFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cnicImageFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnicNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cnicNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cnicNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cnicNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cnicNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cnicNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cnicNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cnicNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnicNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> cnicNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cnicNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> contractIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contractId',
        value: value,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> contractIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contractId',
        value: value,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> contractIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contractId',
        value: value,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> contractIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contractId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Witness, Witness, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Witness, Witness, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phoneNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phoneNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> phoneNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      phoneNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relationship',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      relationshipIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relationship',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationship',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relationship',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relationship',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relationship',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relationship',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relationship',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relationship',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relationship',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition> relationshipIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationship',
        value: '',
      ));
    });
  }

  QueryBuilder<Witness, Witness, QAfterFilterCondition>
      relationshipIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relationship',
        value: '',
      ));
    });
  }
}

extension WitnessQueryObject
    on QueryBuilder<Witness, Witness, QFilterCondition> {}

extension WitnessQueryLinks
    on QueryBuilder<Witness, Witness, QFilterCondition> {}

extension WitnessQuerySortBy on QueryBuilder<Witness, Witness, QSortBy> {
  QueryBuilder<Witness, Witness, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByCnicImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicImageFilename', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByCnicImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicImageFilename', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByCnicNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicNumber', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByCnicNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicNumber', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractId', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByContractIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractId', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByRelationship() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationship', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> sortByRelationshipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationship', Sort.desc);
    });
  }
}

extension WitnessQuerySortThenBy
    on QueryBuilder<Witness, Witness, QSortThenBy> {
  QueryBuilder<Witness, Witness, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByCnicImageFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicImageFilename', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByCnicImageFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicImageFilename', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByCnicNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicNumber', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByCnicNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicNumber', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractId', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByContractIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractId', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByRelationship() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationship', Sort.asc);
    });
  }

  QueryBuilder<Witness, Witness, QAfterSortBy> thenByRelationshipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationship', Sort.desc);
    });
  }
}

extension WitnessQueryWhereDistinct
    on QueryBuilder<Witness, Witness, QDistinct> {
  QueryBuilder<Witness, Witness, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Witness, Witness, QDistinct> distinctByCnicImageFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cnicImageFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Witness, Witness, QDistinct> distinctByCnicNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cnicNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Witness, Witness, QDistinct> distinctByContractId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contractId');
    });
  }

  QueryBuilder<Witness, Witness, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Witness, Witness, QDistinct> distinctByPhoneNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phoneNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Witness, Witness, QDistinct> distinctByRelationship(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relationship', caseSensitive: caseSensitive);
    });
  }
}

extension WitnessQueryProperty
    on QueryBuilder<Witness, Witness, QQueryProperty> {
  QueryBuilder<Witness, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Witness, String?, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<Witness, String?, QQueryOperations> cnicImageFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cnicImageFilename');
    });
  }

  QueryBuilder<Witness, String, QQueryOperations> cnicNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cnicNumber');
    });
  }

  QueryBuilder<Witness, int, QQueryOperations> contractIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contractId');
    });
  }

  QueryBuilder<Witness, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<Witness, String, QQueryOperations> phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phoneNumber');
    });
  }

  QueryBuilder<Witness, String?, QQueryOperations> relationshipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relationship');
    });
  }
}
