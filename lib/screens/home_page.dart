import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/note_card.dart';
import '../widgets/custom_button.dart';
import '../providers/note_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/category.dart' as models;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde notları ve kategorileri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().loadNotes();
      context.read<NoteProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Defterim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Arama fonksiyonu - Auth ekibi giriş kontrolü ekleyecek
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filtreleme fonksiyonu
              _showFilterDialog();
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          return Column(
            children: [
              // İstatistik kartları
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Toplam Not',
                        '${noteProvider.totalNotesCount}',
                        Icons.note,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Bu Hafta',
                        '${noteProvider.thisWeekNotesCount}',
                        Icons.calendar_today,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              // Loading indicator
              if (noteProvider.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              // Not listesi veya boş durum
              if (!noteProvider.isLoading)
                Expanded(
                  child: noteProvider.notes.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: noteProvider.notes.length,
                          itemBuilder: (context, index) {
                            final note = noteProvider.notes[index];
                            final category = noteProvider.categories
                                .where((cat) => cat.id == note.categoryId)
                                .firstOrNull;

                            return NoteCard(
                              title: note.title,
                              content: note.content,
                              createdAt: note.createdAt,
                              updatedAt: note.updatedAt,
                              categoryColor: category?.color,
                              onTap: () {
                                // Not detay sayfası - CRUD ekibi implement edecek
                                _showNoteDetail(note.id!);
                              },
                              onEdit: () {
                                // Not düzenleme - CRUD ekibi implement edecek
                                _editNote(note.id!);
                              },
                              onDelete: () {
                                // Not silme - CRUD ekibi implement edecek
                                _deleteNote(note.id!);
                              },
                            );
                          },
                        ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Yeni not ekleme - CRUD ekibi implement edecek
          _addNewNote();
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Not'),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz not yok',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk notunuzu eklemek için + butonuna dokunun',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'İlk Notu Ekle',
            icon: Icons.add,
            onPressed: _addNewNote,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arama'),
        content: const Text('Arama fonksiyonu Auth ekibi tarafından implement edilecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrele'),
        content: const Text('Filtreleme seçenekleri burada olacak.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Uygula'),
          ),
        ],
      ),
    );
  }

  void _showNoteDetail(int noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Not Detayı'),
        content: Consumer<NoteProvider>(
          builder: (context, noteProvider, child) {
            final note = noteProvider.notes.firstWhere((note) => note.id == noteId);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Başlık: ${note.title}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('İçerik: ${note.content}', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text('Oluşturulma Tarihi: ${note.createdAt}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Text('Son Güncelleme: ${note.updatedAt}', style: Theme.of(context).textTheme.bodySmall),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void _editNote(int noteId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Not düzenleme CRUD ekibi tarafından implement edilecek'),
      ),
    );
  }

  void _deleteNote(int noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notu Sil'),
        content: const Text('Bu notu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<NoteProvider>().deleteNote(noteId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not silindi')),
                );
              }
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addNewNote() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yeni not ekleme CRUD ekibi tarafından implement edilecek'),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 32),
                ),
                SizedBox(height: 12),
                Text(
                  'Kullanıcı Adı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Ana Sayfa'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Tüm Notlar'),
            onTap: () {
              Navigator.pop(context);
              // Tüm notlar sayfası
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Kategoriler'),
            onTap: () {
              Navigator.pop(context);
              // Kategori sayfası
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text('Arşiv'),
            onTap: () {
              Navigator.pop(context);
              // Arşiv sayfası
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              _showSettingsDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Yardım'),
            onTap: () {
              Navigator.pop(context);
              _showHelpDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              // Auth ekibi logout fonksiyonu implement edecek
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayarlar'),
        content: const Text('Ayarlar sayfası geliştirilecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yardım'),
        content: const Text('Yardım içeriği burada olacak.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout fonksiyonu Auth ekibi tarafından implement edilecek'),
                ),
              );
            },
            child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
