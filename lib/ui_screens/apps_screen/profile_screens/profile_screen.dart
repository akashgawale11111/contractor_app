import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  Widget infoRow(IconData icon, String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(value ?? "N/A",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      );
    }

    // Determine if the user is Labour or Supervisor
    final isLabour = user.isLabour;
    final isSupervisor = user.isSupervisor;

    String? avatarUrl;
    String displayName = 'User';
    List<Widget> infoRows = [];

    if (isLabour && user.labour != null) {
      final labour = user.labour!;
      avatarUrl = labour.imageUrl;
      displayName = "${labour.firstName ?? ''} ${labour.lastName ?? ''}";
      infoRows = [
        infoRow(Icons.badge, "Labour ID", labour.labourId),
        infoRow(Icons.email, "Email", labour.email),
      ];
    } else if (isSupervisor && user.supervisor != null) {
      final supervisor = user.supervisor!;
      avatarUrl = supervisor.photo;
      displayName = supervisor.supervisorName ?? 'Supervisor';
      infoRows = [
        infoRow(Icons.badge, "Login ID", supervisor.loginId),
        infoRow(Icons.email, "Email", null), // Add email if available
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                displayName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person,
                            size: 60, color: Colors.blueAccent)
                        : null,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ...infoRows,
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Show role info
                  Text(
                    "Role: ${user.userType ?? (isLabour ? 'Labour' : 'Supervisor')}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
