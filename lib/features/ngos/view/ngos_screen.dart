
import 'package:diaster_ngo_app/features/ngos/model/ngo_model.dart';
import 'package:diaster_ngo_app/features/ngos/view/ngos_register_screen.dart';
import 'package:diaster_ngo_app/features/ngos/view_model/ngo_register_view_model.dart';
import 'package:diaster_ngo_app/features/ngos/view_model/ngo_view_model.dart';
import 'package:diaster_ngo_app/features/ngos/widgets/app_search_field.dart';
import 'package:diaster_ngo_app/features/ngos/widgets/category_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ngo_list_card.dart';


class NGOScreen extends StatelessWidget {
  const NGOScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // NGOViewModel is registered globally in main.dart
    return const _NGOScreenContent();
  }
}

class _NGOScreenContent extends StatelessWidget {
  const _NGOScreenContent();

  static const Color _bg = Color(0xFF0D0D0D);
  static const Color _blue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Relief Organizations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _blue,
        tooltip: 'Register NGO',
        onPressed: () => _openRegister(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // ── Divider ─────────────────────────────────────────────
          Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white24, Colors.transparent],
              ),
            ),
          ),

          // ── Search + Filter ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                AppSearchField(
                  hintText: 'Search organizations...',
                  onChanged: (q) =>
                      context.read<NGOViewModel>().updateSearch(q),
                ),
                const SizedBox(height: 12),
                CategoryFilterBar<NGOCategory>(
                  categories: NGOCategory.values,
                  selected: context.watch<NGOViewModel>().selectedCategory,
                  labelOf: (c) => c.label,
                  onSelected: (c) =>
                      context.read<NGOViewModel>().selectCategory(c),
                  activeColor: _blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── List ────────────────────────────────────────────────
          Expanded(child: _NGOList()),
        ],
      ),
    );
  }

  void _openRegister(BuildContext context) {
    // Reuse the global NGORegisterViewModel; reset its state first.
    final registerVm = context.read<NGORegisterViewModel>()..reset();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: registerVm,
          child: const NGORegisterScreen(),
        ),
      ),
    );
  }
}

class _NGOList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NGOViewModel>();

    if (vm.state == ViewState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2196F3)),
      );
    }

    if (vm.state == ViewState.error) {
      return Center(
        child: Text(
          'Error: ${vm.errorMessage}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final ngos = vm.filteredNGOs;

    if (ngos.isEmpty) {
      return const Center(
        child: Text(
          'No organizations found.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: ngos.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => NGOListCard(ngo: ngos[i]),
    );
  }
}