import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = MediaQuery.of(context).size.height * 0.9;
            final maxWidth = MediaQuery.of(context).size.width * 0.95;
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            height: 120,
                            width: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 180,
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 56,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: ClipOval(
                      child: Material(
                        color: Colors.black45,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 🟢 Change this to your correct image folder on the server.
  static const String baseImageUrl = "http://admin.mmprecise.com/uploads/";

  Widget infoRow(IconData icon, String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 144, 221, 106)),
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
                          fontSize: 15, fontWeight: FontWeight.w500)),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
      );
    }

    final isLabour = user.isLabour;
    final isSupervisor = user.isSupervisor;

    String? avatarUrl;
    String displayName = 'User';
    List<Widget> infoRows = [];

    // 🧩 Labour Section
    if (isLabour && user.labour != null) {
      final labour = user.labour!;
      avatarUrl = labour.imageUrl;
      if (avatarUrl != null && !avatarUrl.startsWith("http")) {
        avatarUrl = baseImageUrl + avatarUrl;
      }
      displayName = "${labour.firstName ?? ''} ${labour.lastName ?? ''}";
      infoRows = [
        infoRow(Icons.badge, "Labour ID", labour.labourId),
        infoRow(Icons.email, "Email", labour.email),
      ];
    }
    // 🧩 Supervisor Section
    else if (isSupervisor && user.supervisor != null) {
      final supervisor = user.supervisor!;
      avatarUrl = supervisor.imageUrl ?? supervisor.imageUrl;
      if (avatarUrl != null && !avatarUrl.startsWith("http")) {
        avatarUrl = baseImageUrl + avatarUrl;
      }
      displayName = supervisor.supervisorName ?? 'Supervisor';
      infoRows = [
        infoRow(Icons.badge, "Login ID", supervisor.loginId),
        infoRow(Icons.email, "Email", null),
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
                    color: Colors.white, fontWeight: FontWeight.w500,fontSize: 16),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 221, 56, 233), Color.fromARGB(255, 156, 113, 255)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: avatarUrl != null
                        ? GestureDetector(
                            onTap: () => _showImageDialog(context, avatarUrl!),
                            child: ClipOval(
                              child: Image.network(
                                avatarUrl,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    debugPrint(
                                        "✅ Image loaded successfully: $avatarUrl");
                                    return child;
                                  }
                                  return const CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  );
                                },
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  debugPrint("❌ Image load failed: $error");
                                  debugPrint("📂 Image URL: $avatarUrl");
                                  return const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.blueAccent,
                                  );
                                },
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blueAccent,
                          ),
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
                  // ElevatedButton.icon(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.edit),
                  //   label: const Text("Edit Profile"),
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 40, vertical: 14),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30)),
                  //     backgroundColor: Colors.blueAccent,
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  Text(
                    "Role: ${user.userType ?? (isLabour ? 'Labour' : 'Supervisor')}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
