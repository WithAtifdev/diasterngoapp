
import 'package:diaster_ngo_app/features/ngos/model/ngo_model.dart';
import 'package:diaster_ngo_app/features/ngos/view_model/ngo_register_view_model.dart';
import 'package:diaster_ngo_app/features/ngos/widgets/category_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NGORegisterScreen extends StatefulWidget {
  const NGORegisterScreen({super.key});

  @override
  State<NGORegisterScreen> createState() => _NGORegisterScreenState();
}

class _NGORegisterScreenState extends State<NGORegisterScreen> {
  static const Color _bg = Color(0xFF0D0D0D);
  static const Color _blue = Color(0xFF2196F3);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _easypaisaNumberCtrl = TextEditingController();
  final _jazzCashNumberCtrl = TextEditingController();
  final _bankNumberCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    _easypaisaNumberCtrl.dispose();
    _jazzCashNumberCtrl.dispose();
    _bankNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NGORegisterViewModel>();
    final isLoading = vm.state == RegisterState.loading;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Register NGO',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // divider
              Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white24,
                      Colors.transparent
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Organization Details',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildField(_nameCtrl, 'NGO Name'),
              const SizedBox(height: 12),
              const SizedBox(height: 12),

              _buildField(
                _imageCtrl,
                'Asset Path',
              ),
              SizedBox(height: 12,),

              const Text('Category',
                  style: TextStyle(color: Colors.white60, fontSize: 13)),
              const SizedBox(height: 8),
              CategoryFilterBar<NGOCategory>(
                categories: NGOCategory.values
                    .where((c) => c != NGOCategory.all)
                    .toList(),
                selected: vm.selectedCategory,
                labelOf: (c) => c.label,
                onSelected: context.read<NGORegisterViewModel>().selectCategory,
                activeColor: _blue,
              ),

              const SizedBox(height: 12),
              _buildField(_locationCtrl, 'Location'),
              const SizedBox(height: 12),
              _buildField(_phoneCtrl, 'Contact Number',
                  inputType: TextInputType.phone),
              const SizedBox(height: 12),
              _buildField(_emailCtrl, 'Email',
                  inputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildField(_descCtrl, 'Description', maxLines: 3),
              const SizedBox(height: 24),


              const Text(
                'Payment Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildField(
                _easypaisaNumberCtrl,
                'Easypaisa Number',
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 12),

              _buildField(
                _jazzCashNumberCtrl,
                'JazzCash Number',
                inputType: TextInputType.phone,
              ),

              const SizedBox(height: 12),

              _buildField(
                _bankNumberCtrl,
                'Bank Number',
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : () => _submit(context),
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                      : const Text(
                    'SUBMIT FOR APPROVAL',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      TextEditingController ctrl,
      String hint, {
        int maxLines = 1,
        TextInputType inputType = TextInputType.text,
      }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2196F3)),
        ),
      ),
    );
  }
  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<NGORegisterViewModel>();
    final success = await vm.submit(
      name: _nameCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim(),
     easypaisa:_easypaisaNumberCtrl.text.trim(),
      jazzcash:_jazzCashNumberCtrl.text.trim(),
      bankTransfer:_bankNumberCtrl.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted for approval ✓')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${vm.errorMessage}')),
      );
    }
  }
}