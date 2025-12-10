import 'package:flutter/material.dart';

import '../../models/memory.dart';
import '../../services/memory_service.dart';
import '../../utils/responsive.dart';

enum CreateUpdateMode { create, update }

class CreateUpdateMemoryPage extends StatefulWidget {
  final CreateUpdateMode mode;

  const CreateUpdateMemoryPage({
    super.key,
    required this.mode,
  });

  @override
  State<CreateUpdateMemoryPage> createState() =>
      _CreateUpdateMemoryPageState();
}

class _CreateUpdateMemoryPageState extends State<CreateUpdateMemoryPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _contentController = TextEditingController();

  final MemoryService _memoryService = MemoryService();

  DateTime? _selectedDate;
  Memory? _editingMemory;
  bool _initializedFromArgs = false;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initializedFromArgs) return;

    if (widget.mode == CreateUpdateMode.update) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Memory) {
        _editingMemory = args;
        _titleController.text = args.title;
        _contentController.text = args.content;
        _selectedDate = args.date;
        _dateController.text = _formatDate(args.date);
      }
    } else {
      final now = DateTime.now();
      _selectedDate = now;
      _dateController.text = _formatDate(now);
    }

    _initializedFromArgs = true;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  // ============================================================
  // 🔥 SAVE MEMORY (CREATE / UPDATE)
  // ============================================================
  Future<void> _onSave({required bool asDraft}) async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final date = _selectedDate!;

    if (widget.mode == CreateUpdateMode.create) {
      // CREATE memory baru
      await _memoryService.createMemory(
        title: title,
        content: content,
        date: date,
        isDraft: asDraft,
      );
    } else {
      // UPDATE memory lama
      if (_editingMemory == null) return;

      final updated = _editingMemory!.copyWith(
        title: title,
        content: content,
        date: date,
        isDraft: asDraft,
        updatedAt: DateTime.now(),
      );

      // 1️⃣ Hapus lokasi lama (draft → publish / publish → draft)
      await _memoryService.deleteMemory(
        _editingMemory!.id,
        isDraft: _editingMemory!.isDraft,
      );

      // 2️⃣ Simpan ulang di folder baru
      await _memoryService.createMemory(
        title: updated.title,
        content: updated.content,
        date: updated.date,
        isDraft: updated.isDraft,
        aiSuggestion: updated.aiSuggestion,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          asDraft ? 'Saved as draft.' : 'Saved successfully.',
        ),
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/homeList',
      (route) => false,
    );
  }

  // ============================================================
  // 🔥 DELETE MEMORY
  // ============================================================
  Future<void> _onDelete() async {
    if (_editingMemory == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Memory'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _memoryService.deleteMemory(
      _editingMemory!.id,
      isDraft: _editingMemory!.isDraft,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memory deleted.')),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/homeList',
      (route) => false,
    );
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == CreateUpdateMode.create
            ? 'Create Memory'
            : 'Update Memory'),
        centerTitle: true,
        actions: [
          if (widget.mode == CreateUpdateMode.update)
            IconButton(
              onPressed: _onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TITLE
                Text('Title', style: textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. A sunny morning...',
                    prefixIcon: Icon(Icons.title_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Title cannot be empty' : null,
                ),

                const SizedBox(height: 20),

                // DATE
                Text('Date', style: textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.calendar_month_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.event),
                      onPressed: _pickDate,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // CONTENT
                Text('Memory', style: textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'Write something to remember...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Content cannot be empty' : null,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () => _onSave(asDraft: false),
                  child: Text(widget.mode == CreateUpdateMode.create
                      ? 'Save Memory'
                      : 'Update Memory'),
                ),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () => _onSave(asDraft: true),
                  child: const Text('Save as Draft'),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
