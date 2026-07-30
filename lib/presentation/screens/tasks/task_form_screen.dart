import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/task_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});
  final TaskModel? task;
  bool get isEdit => task != null;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(text: widget.task?.title);
  late final _courseController = TextEditingController(text: widget.task?.course);
  late final _descController = TextEditingController(text: widget.task?.description);
  late DateTime _deadline = widget.task?.deadline ?? _defaultDeadline();
  late String _priority = widget.task?.priority ?? 'medium';
  bool _isSubmitting = false;

  static DateTime _defaultDeadline() {
    final besok = DateTime.now().add(const Duration(days: 1));
    return DateTime(besok.year, besok.month, besok.day, 23, 59);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_deadline));
    if (pickedTime == null) return;

    setState(() {
      _deadline = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final uid = context.read<AuthProvider>().uid!;
    final taskProvider = context.read<TaskProvider>();
    final task = TaskModel(
      taskId: widget.task?.taskId ?? '',
      userId: uid,
      title: _titleController.text,
      course: _courseController.text,
      description: _descController.text,
      priority: _priority,
      deadline: _deadline,
      status: widget.task?.status ?? 'pending',
    );

    try {
      widget.isEdit ? await taskProvider.updateTask(task) : await taskProvider.addTask(task);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEdit ? 'Tugas diperbarui.' : 'Tugas ditambahkan.')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan tugas. Periksa koneksimu lalu coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Ubah Tugas' : 'Tambah Tugas')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Tugas'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul tugas tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(labelText: 'Mata Kuliah'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Mata kuliah tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Deskripsi (opsional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Deadline'),
              subtitle: Text('${_deadline.day}/${_deadline.month}/${_deadline.year}  ${_deadline.hour}:${_deadline.minute.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.calendar_today_rounded),
              onTap: _pickDeadline,
            ),
            const SizedBox(height: 8),
            const Text('Prioritas'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(label: const Text('Rendah'), selected: _priority == 'low', onSelected: (_) => setState(() => _priority = 'low')),
                ChoiceChip(label: const Text('Sedang'), selected: _priority == 'medium', onSelected: (_) => setState(() => _priority = 'medium')),
                ChoiceChip(label: const Text('Tinggi'), selected: _priority == 'high', onSelected: (_) => setState(() => _priority = 'high')),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(label: 'Simpan Tugas', isLoading: _isSubmitting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}