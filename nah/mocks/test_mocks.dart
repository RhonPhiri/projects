//Mock the hymn & hymnal service
import 'package:mocktail/mocktail.dart';
import 'package:nah/data/db/database_helper.dart';
import 'package:nah/data/services/hymn_service.dart';
import 'package:nah/data/services/hymnal_service.dart';

class MockHymnalService with Mock implements HymnalService {}

class MockHymnService with Mock implements HymnService {}

class MockDatabaseHelper with Mock implements DatabaseHelper {}
