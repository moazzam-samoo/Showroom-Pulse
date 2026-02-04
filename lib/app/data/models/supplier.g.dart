// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSupplierCollection on Isar {
  IsarCollection<Supplier> get suppliers => this.collection();
}

const SupplierSchema = CollectionSchema(
  name: r'Supplier',
  id: -3022359166140243741,
  properties: {
    r'cnic': PropertySchema(
      id: 0,
      name: r'cnic',
      type: IsarType.string,
    ),
    r'cnicPicFilename': PropertySchema(
      id: 1,
      name: r'cnicPicFilename',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 3,
      name: r'phone',
      type: IsarType.string,
    ),
    r'profilePicFilename': PropertySchema(
      id: 4,
      name: r'profilePicFilename',
      type: IsarType.string,
    )
  },
  estimateSize: _supplierEstimateSize,
  serialize: _supplierSerialize,
  deserialize: _supplierDeserialize,
  deserializeProp: _supplierDeserializeProp,
  idName: r'id',
  indexes: {
    r'cnic': IndexSchema(
      id: 2156336864798544313,
      name: r'cnic',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'cnic',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'batches': LinkSchema(
      id: -1735294909261585686,
      name: r'batches',
      target: r'PurchaseBatch',
      single: false,
      linkName: r'supplier',
    )
  },
  embeddedSchemas: {},
  getId: _supplierGetId,
  getLinks: _supplierGetLinks,
  attach: _supplierAttach,
  version: '3.1.0+1',
);

int _supplierEstimateSize(
  Supplier object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cnic.length * 3;
  {
    final value = object.cnicPicFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  {
    final value = object.profilePicFilename;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _supplierSerialize(
  Supplier object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cnic);
  writer.writeString(offsets[1], object.cnicPicFilename);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.phone);
  writer.writeString(offsets[4], object.profilePicFilename);
}

Supplier _supplierDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Supplier();
  object.cnic = reader.readString(offsets[0]);
  object.cnicPicFilename = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.phone = reader.readString(offsets[3]);
  object.profilePicFilename = reader.readStringOrNull(offsets[4]);
  return object;
}

P _supplierDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _supplierGetId(Supplier object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _supplierGetLinks(Supplier object) {
  return [object.batches];
}

void _supplierAttach(IsarCollection<dynamic> col, Id id, Supplier object) {
  object.id = id;
  object.batches
      .attach(col, col.isar.collection<PurchaseBatch>(), r'batches', id);
}

extension SupplierByIndex on IsarCollection<Supplier> {
  Future<Supplier?> getByCnic(String cnic) {
    return getByIndex(r'cnic', [cnic]);
  }

  Supplier? getByCnicSync(String cnic) {
    return getByIndexSync(r'cnic', [cnic]);
  }

  Future<bool> deleteByCnic(String cnic) {
    return deleteByIndex(r'cnic', [cnic]);
  }

  bool deleteByCnicSync(String cnic) {
    return deleteByIndexSync(r'cnic', [cnic]);
  }

  Future<List<Supplier?>> getAllByCnic(List<String> cnicValues) {
    final values = cnicValues.map((e) => [e]).toList();
    return getAllByIndex(r'cnic', values);
  }

  List<Supplier?> getAllByCnicSync(List<String> cnicValues) {
    final values = cnicValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cnic', values);
  }

  Future<int> deleteAllByCnic(List<String> cnicValues) {
    final values = cnicValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cnic', values);
  }

  int deleteAllByCnicSync(List<String> cnicValues) {
    final values = cnicValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cnic', values);
  }

  Future<Id> putByCnic(Supplier object) {
    return putByIndex(r'cnic', object);
  }

  Id putByCnicSync(Supplier object, {bool saveLinks = true}) {
    return putByIndexSync(r'cnic', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCnic(List<Supplier> objects) {
    return putAllByIndex(r'cnic', objects);
  }

  List<Id> putAllByCnicSync(List<Supplier> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'cnic', objects, saveLinks: saveLinks);
  }
}

extension SupplierQueryWhereSort on QueryBuilder<Supplier, Supplier, QWhere> {
  QueryBuilder<Supplier, Supplier, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SupplierQueryWhere on QueryBuilder<Supplier, Supplier, QWhereClause> {
  QueryBuilder<Supplier, Supplier, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Supplier, Supplier, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterWhereClause> idBetween(
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

  QueryBuilder<Supplier, Supplier, QAfterWhereClause> cnicEqualTo(String cnic) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cnic',
        value: [cnic],
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterWhereClause> cnicNotEqualTo(
      String cnic) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cnic',
              lower: [],
              upper: [cnic],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cnic',
              lower: [cnic],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cnic',
              lower: [cnic],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cnic',
              lower: [],
              upper: [cnic],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SupplierQueryFilter
    on QueryBuilder<Supplier, Supplier, QFilterCondition> {
  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cnic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cnic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cnic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnic',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> cnicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cnic',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cnicPicFilename',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cnicPicFilename',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnicPicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cnicPicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cnicPicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cnicPicFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cnicPicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cnicPicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cnicPicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cnicPicFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnicPicFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      cnicPicFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cnicPicFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profilePicFilename',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profilePicFilename',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profilePicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profilePicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profilePicFilename',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profilePicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profilePicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profilePicFilename',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profilePicFilename',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicFilename',
        value: '',
      ));
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      profilePicFilenameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePicFilename',
        value: '',
      ));
    });
  }
}

extension SupplierQueryObject
    on QueryBuilder<Supplier, Supplier, QFilterCondition> {}

extension SupplierQueryLinks
    on QueryBuilder<Supplier, Supplier, QFilterCondition> {
  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> batches(
      FilterQuery<PurchaseBatch> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'batches');
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> batchesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'batches', length, true, length, true);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> batchesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'batches', 0, true, 0, true);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> batchesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'batches', 0, false, 999999, true);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> batchesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'batches', 0, true, length, include);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition>
      batchesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'batches', length, include, 999999, true);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterFilterCondition> batchesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'batches', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SupplierQuerySortBy on QueryBuilder<Supplier, Supplier, QSortBy> {
  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByCnic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnic', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByCnicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnic', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByCnicPicFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicPicFilename', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByCnicPicFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicPicFilename', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> sortByProfilePicFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicFilename', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy>
      sortByProfilePicFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicFilename', Sort.desc);
    });
  }
}

extension SupplierQuerySortThenBy
    on QueryBuilder<Supplier, Supplier, QSortThenBy> {
  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByCnic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnic', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByCnicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnic', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByCnicPicFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicPicFilename', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByCnicPicFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnicPicFilename', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy> thenByProfilePicFilename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicFilename', Sort.asc);
    });
  }

  QueryBuilder<Supplier, Supplier, QAfterSortBy>
      thenByProfilePicFilenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicFilename', Sort.desc);
    });
  }
}

extension SupplierQueryWhereDistinct
    on QueryBuilder<Supplier, Supplier, QDistinct> {
  QueryBuilder<Supplier, Supplier, QDistinct> distinctByCnic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cnic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Supplier, Supplier, QDistinct> distinctByCnicPicFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cnicPicFilename',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Supplier, Supplier, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Supplier, Supplier, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Supplier, Supplier, QDistinct> distinctByProfilePicFilename(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePicFilename',
          caseSensitive: caseSensitive);
    });
  }
}

extension SupplierQueryProperty
    on QueryBuilder<Supplier, Supplier, QQueryProperty> {
  QueryBuilder<Supplier, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Supplier, String, QQueryOperations> cnicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cnic');
    });
  }

  QueryBuilder<Supplier, String?, QQueryOperations> cnicPicFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cnicPicFilename');
    });
  }

  QueryBuilder<Supplier, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Supplier, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<Supplier, String?, QQueryOperations>
      profilePicFilenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePicFilename');
    });
  }
}
