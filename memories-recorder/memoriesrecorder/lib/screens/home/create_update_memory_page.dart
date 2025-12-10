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
      // mode create: default tanggal hari ini
      final now = DateTime.now();
      _selectedDate = now;
      _dateController.text = _formatDate(now);
    }

    _initializedFromArgs = true;
  }

  String get _pageTitle =>
      widget.mode == CreateUpdateMode.create ? 'Create Memory' : 'Update Memory';

  String get _primaryButtonText =>
      widget.mode == CreateUpdateMode.create ? 'Save Memory' : 'Update Memory';

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

  Future<void> _onSave({required bool asDraft}) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date.')),
      );
      return;
    }

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final date = _selectedDate!;

    if (widget.mode == CreateUpdateMode.create) {
      await _memoryService.createMemory(
        title: title,
        content: content,
        date: date,
        isDraft: asDraft,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(asDraft
              ? 'Memory saved as draft.'
              : 'Memory created successfully.'),
        ),
      );
    } else {
      if (_editingMemory == null) return;
      await _memoryService.updateMemory(
        _editingMemory!.id,
        title: title,
        content: content,
        date: date,
        isDraft: asDraft,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(asDraft
              ? 'Draft updated.'
              : 'Memory updated successfully.'),
        ),
      );
    }

    // Setelah save, balik ke home list.
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/homeList',
      (route) => false,
    );
  }

  Future<void> _onDelete() async {
    if (_editingMemory == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Memory'),
        content: const Text(
          'Are you sure you want to delete this memory? This action cannot be undone.',
        ),
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

    final success = await _memoryService.deleteMemory(_editingMemory!.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memory deleted.')),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/homeList',
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete memory.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        centerTitle: true,
        actions: [
          if (widget.mode == CreateUpdateMode.update)
            IconButton(
              onPressed: _onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
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
                // Title
                Text(
                  'Title',
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Morning Walk at the Park',
                    prefixIcon: Icon(Icons.title_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Date
                Text(
                  'Date',
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Choose a date',
                    prefixIcon:
                        const Icon(Icons.calendar_today_outlined),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.event),
                      onPressed: _pickDate,
                    ),
                  ),
                  onTap: _pickDate,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Date cannot be empty';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Content
                Text(
                  'Memory',
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  maxLines: 8,
                  minLines: 5,
                  decoration: const InputDecoration(
                    hintText:
                        'Write down your thoughts, activities, or moments you want to remember...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Memory content cannot be empty';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                Text(
                  'You can later enhance this memory with AI suggestions for activities or reflections.',
                  style: textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 24),

                // Save / update
                ElevatedButton(
                  onPressed: () => _onSave(asDraft: false),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _primaryButtonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Save as draft
                OutlinedButton(
                  onPressed: () => _onSave(asDraft: true),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
