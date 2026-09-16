
import 'package:diaster_ngo_app/features/ngos/widgets/app_card.dart';
import 'package:diaster_ngo_app/features/profile/model/user_model.dart';
import 'package:diaster_ngo_app/features/profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override

  @override
  Widget build(BuildContext context) {
    return const _ProfileContent();
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  static const Color _bg = Color(0xFF0D0D0D);
  static const Color _blue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    if (vm.state == ProfileState.loading) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(
            child: CircularProgressIndicator(color: _blue)),
      );
    }

    if (vm.state == ProfileState.loggedOut) {
      // Navigate to login. Handle from parent navigator instead of here.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      });
      return const SizedBox.shrink();
    }

    final user = vm.user;
    if (user == null) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(
            child: Text('No user found.',
                style: TextStyle(color: Colors.white54))),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile',
            style: TextStyle(color: Colors.white, fontSize: 22,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Divider
            Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Colors.white24,
                  Colors.transparent
                ]),
              ),
            ),
            const SizedBox(height: 20),

            // ── Profile Card ─────────────────────────────────────
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: () {
                      vm.pickAndUploadProfileImage();
                    },
                    child: _Avatar(photoUrl: user.photoUrl),
                  ),
                  const SizedBox(height: 10),

                  // Name
                  Text(user.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),

                  // Email
                  Text(user.email,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 16)),
                  const SizedBox(height: 15),

                  // Role badge
                  _RoleBadge(role: user.role),

                  const SizedBox(height: 30),

                  // Edit Profile button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                    ),
                    onPressed: () => _openEditSheet(context, vm),
                    child: const Text('Edit Profile',
                        style: TextStyle(color: _blue)),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Logout ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: () => _confirmLogout(context, vm),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _openEditSheet(BuildContext context, ProfileViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: const _EditProfileSheet(),
      ),
    );
  }

  void _confirmLogout(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
            const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              vm.logout();
            },
            child: const Text('Logout',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String? photoUrl;
  const _Avatar({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white10,
      ),
      child: ClipOval(
        child: photoUrl != null
            ? Image.network(photoUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _placeholder())
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return const Icon(Icons.person, size: 52, color: Colors.white30);
  }
}

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  Color get _color {
    switch (role) {
      case UserRole.admin:
        return Colors.purple;
      case UserRole.ngo:
        return Colors.orange;
      case UserRole.volunteer:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        role.label,
        style: TextStyle(
            color: _color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Edit Profile Bottom Sheet ────────────────────────────────────────────────

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late UserRole _selectedRole;
  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileViewModel>().user;
    _nameCtrl = TextEditingController(text: user?.name);
    _emailCtrl = TextEditingController(text: user?.email);
    _selectedRole = user?.role ?? UserRole.volunteer;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final isSaving = vm.state == ProfileState.saving;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _field(_nameCtrl, 'Name'),
          const SizedBox(height: 12),
          _field(_emailCtrl, 'Email', type: TextInputType.emailAddress),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserRole>(
                dropdownColor: const Color(0xFF1A1A1A),
                value: _selectedRole,
                isExpanded: true,
                style: const TextStyle(color: Colors.white),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isSaving ? null : () => _save(context, vm),
              child: isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : const Text('SAVE CHANGES',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF0D0D0D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2196F3)),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, ProfileViewModel vm) async {
    final success = await vm.updateProfile(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      role: _selectedRole,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated ✓')),
      );
    }
  }
}