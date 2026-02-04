import 'package:isar/isar.dart';
import 'package:tahir_showroom/app/data/models/purchase_batch.dart';

part 'supplier.g.dart';

@collection
class Supplier {
  Id id = Isar.autoIncrement;

  late String name;
  
  @Index(unique: true, replace: true)
  late String cnic;
  
  late String phone;
  
  String? profilePicFilename; // Stored in Media/Suppliers/{Name}/Profile/
  String? cnicPicFilename;    // Stored in Media/Suppliers/{Name}/CNIC/

  @Backlink(to: 'supplier')
  final batches = IsarLinks<PurchaseBatch>();
}
