//Mock the hymn & hymnal service
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/repositories/hymn_repository.dart';
import 'package:nah/data/repositories/hymnal_repository.dart';
import 'package:nah/data/services/hymn_service.dart';
import 'package:nah/data/services/hymnal_service.dart';
import 'package:nah/ui/hymn/view_model/hymn_provider.dart';
import 'package:nah/ui/hymnal/view_model/hymnal_provider.dart';

class MockHymnalService with Mock implements HymnalService {}

class MockHymnService with Mock implements HymnService {}

class MockDatabaseHelper with Mock implements DatabaseHelper {}

class MockHymnalRepository with Mock implements HymnalRepository {}

class MockHymnRepository with Mock implements HymnRepository {}

class MockHymnProvider with Mock implements HymnProvider {}

//mock the hymnal provider
class MockHymnalProvider with Mock implements HymnalProvider {}
