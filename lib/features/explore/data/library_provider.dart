import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book_model.dart';
import 'library_repository.dart';

final libraryRepositoryProvider =
    Provider<LibraryRepository>((ref) => LibraryRepository());

final libraryProvider =
    AsyncNotifierProvider<LibraryNotifier, LibraryState>(LibraryNotifier.new);

class LibraryState {
  final List<Book> books;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const LibraryState({
    this.books = const [],
    this.categories = const [],
    this.selectedCategory = 'الكل',
    this.searchQuery = '',
    this.isLoading = true,
    this.error,
  });

  LibraryState copyWith({
    List<Book>? books,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return LibraryState(
      books: books ?? this.books,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LibraryNotifier extends AsyncNotifier<LibraryState> {
  @override
  Future<LibraryState> build() async {
    final repo = ref.read(libraryRepositoryProvider);
    await repo.loadBooks();
    return LibraryState(
      books: repo.search(''),
      categories: ['الكل', ...repo.categories],
      isLoading: false,
    );
  }

  void setCategory(String category) {
    final repo = ref.read(libraryRepositoryProvider);
    final query = state.requireValue.searchQuery;
    state = AsyncData(
      state.requireValue.copyWith(
        selectedCategory: category,
        books: category == 'الكل'
            ? repo.search(query)
            : repo.getBooksByCategory(category).where((b) {
                return query.isEmpty ||
                    _matchesSearch(b, query);
              }).toList(),
      ),
    );
  }

  void search(String query) {
    final repo = ref.read(libraryRepositoryProvider);
    final category = state.requireValue.selectedCategory;
    state = AsyncData(
      state.requireValue.copyWith(
        searchQuery: query,
        books: category == 'الكل'
            ? repo.search(query)
            : repo.getBooksByCategory(category).where((b) {
                return query.isEmpty || _matchesSearch(b, query);
              }).toList(),
      ),
    );
  }

  bool _matchesSearch(Book book, String query) {
    final q = query.trim().toLowerCase();
    return book.title.toLowerCase().contains(q) ||
        book.author.toLowerCase().contains(q) ||
        book.description.toLowerCase().contains(q) ||
        book.category.toLowerCase().contains(q) ||
        book.tags.any((t) => t.toLowerCase().contains(q));
  }

  void retry() async {
    final repo = ref.read(libraryRepositoryProvider);
    await repo.loadBooks();
    state = AsyncData(
      LibraryState(
        books: repo.search(''),
        categories: ['الكل', ...repo.categories],
        isLoading: false,
      ),
    );
  }
}
