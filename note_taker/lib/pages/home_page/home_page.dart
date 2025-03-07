import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_taker/global_components/note_container.dart';
import 'package:note_taker/pages/edit_note_page/edit_note_page.dart';
import 'package:provider/provider.dart';
import 'package:note_taker/models/models.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../pages/home_page/components/app_bart_buttons/app_bar_buttons.dart';

//I have used a stateful widget to manage whether to show a progressive indicator or data.
//I will not manage it in provider because it's something that is not need to be accessed
//globally.
//I have not used Future builder because it is used when the UI is directly tied to the result
//of a single Asynchronous function, but this UI is connected to many Async functions in
//provider and allows the user to interact with the screen once the results are loaded

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  //method to asynchronously load notes from disk
  Future<void> _loadNotes() async {
    final notesProvider = context.read<NoteProvider>();
    await notesProvider.loadNotesFromDisk();
    setState(() {
      _isLoading = false;
    });
  }

  void noteContainerTapped(Note? note) async {
    final notesProvider = context.read<NoteProvider>();
    final updatedNote = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => EditNotePage(note: note)));
    if (updatedNote != null) {
      notesProvider.updateNote(updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NoteProvider>();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const SortButton(),
          SearchButton(noteContainerTapped: noteContainerTapped),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : notesProvider.notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/emptynote.png'),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        style: GoogleFonts.alexBrush(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        const TextSpan(
                          text: 'You don\'t have any\n',
                          children: [TextSpan(text: 'notes')],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : notesProvider.errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      notesProvider.errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadNotes,
                      child: Text(
                        'Retry',
                        style: GoogleFonts.alexBrush(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : SafeArea(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: notesProvider.notes.length,
                  itemBuilder: (context, index) {
                    final note = notesProvider.notes[index];
                    return NoteContainer(
                      note: note,
                      onTap: () => noteContainerTapped(note),
                    );
                  },
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New note',
        onPressed: () async {
          //a variable that return a response which may either be a note or is null
          //if a note is retained, then create a new note
          final newNote = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const EditNotePage()));

          if (newNote != null) {
            notesProvider.addNote(newNote);
          }
        },
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        child: const Icon(Icons.add),
      ),
    );
  }
}
