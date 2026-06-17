import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/khatmah_repository.dart';
import '../../data/models/khatmah_models.dart';

final khatmahRepositoryProvider = Provider<KhatmahRepository>(
  (ref) => KhatmahRepository(),
);

final khatmahEntriesProvider = FutureProvider<List<KhatmahEntry>>((ref) async {
  final repo = ref.watch(khatmahRepositoryProvider);
  return repo.loadKhatmahEntries();
});

final khatmahProgressProvider = FutureProvider<KhatmahProgress>((ref) async {
  final repo = ref.watch(khatmahRepositoryProvider);
  return repo.loadKhatmahProgress();
});

final khatmahStatusProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'isLoading': false,
    'error': null,
  };
});

final khatmahActionProvider = Provider<KhatmahActions>((ref) => KhatmahActions(ref));

class KhatmahActions {
  final Ref ref;

  KhatmahActions(this.ref);

  Future<void> addKhatmahEntry(KhatmahEntry entry) async {
    final repo = ref.read(khatmahRepositoryProvider);
    await repo.addKhatmahEntry(entry);
  }

  Future<void> updateKhatmahEntry(KhatmahEntry entry) async {
    final repo = ref.read(khatmahRepositoryProvider);
    await repo.updateKhatmahEntry(entry);
  }

  Future<void> deleteKhatmahEntry(String id) async {
    final repo = ref.read(khatmahRepositoryProvider);
    await repo.deleteKhatmahEntry(id);
  }

  Future<void> completeKhatmahEntry(String id) async {
    final repo = ref.read(khatmahRepositoryProvider);
    await repo.completeKhatmahEntry(id);
  }

  Future<void> clearAllKhatmah() async {
    final repo = ref.read(khatmahRepositoryProvider);
    await repo.clearAllKhatmah();
  }

  Future<String> generateKhatmahId() async {
    final repo = ref.read(khatmahRepositoryProvider);
    return repo.generateKhatmahId();
  }
}
