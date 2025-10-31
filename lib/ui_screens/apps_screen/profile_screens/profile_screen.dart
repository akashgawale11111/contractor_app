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
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 180,
                            child: Center(
                              child: Icon(Icons.broken_image, color: Colors.white, size: 56),
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
    Map<String, String?> personalDetails = {};
    Map<String, String?> workDetails = {};

    // 🧩 Labour Section
    if (isLabour && user.labour != null) {
      final labour = user.labour!;
      avatarUrl = labour.imageUrl;
      displayName = labour.fullName ?? "${labour.firstName ?? ''} ${labour.lastName ?? ''}";

      personalDetails = {
        "Name": labour.fullName,
        "Labour ID": labour.labourId,
        "Contact": labour.phoneNumber,
        "Email": labour.email,
      };

      workDetails = {
        "Daily Wage": labour.dailyWage,
        "Skill Level": labour.skillLevel,
        "Specialization": labour.specialization,
        "Project ID": labour.projectId?.toString(),
        "Supervisor ID": labour.supervisorId?.toString(),
        "Status": labour.status,
      };
    }
    // 🧩 Supervisor Section
    else if (isSupervisor && user.supervisor != null) {
      final supervisor = user.supervisor!;
      avatarUrl = supervisor.imageUrl;
      displayName = supervisor.supervisorName ?? supervisor.name ?? 'Supervisor';

      personalDetails = {
        "Name": supervisor.name,
        "Login ID": supervisor.loginId,
        "Contact": supervisor.phone,
        "Email": supervisor.email,
        "Address": supervisor.address,
      };

      workDetails = {
        "Role": supervisor.role,
        "Supervisor Type": supervisor.supervisorType,
        "Status": supervisor.status,
      };
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    TextStyle labelStyle = const TextStyle(fontFamily: 'Roboto', fontSize: 18);
    TextStyle valueStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Edit Button
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.all(width * 0.02),
                //       child: GestureDetector(
                //         onTap: () {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             const SnackBar(content: Text("Edit Profile Coming Soon")),
                //           );
                //         },
                //         child: const Text(
                //           "Edit Profile",
                //           style: TextStyle(
                //             fontFamily: 'Roboto',
                //             color: Colors.blue,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 15,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // Profile Image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: width * 0.35,
                      height: width * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.yellow.shade200,
                          width: 6,
                        ),
                      ),
                      child: avatarUrl != null
                          ? GestureDetector(
                              onTap: () => _showImageDialog(context, avatarUrl!),
                              child: ClipOval(
                                child: Image.network(
                                  avatarUrl!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(color: Colors.blueAccent),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, size: 60, color: Colors.blueAccent),
                                ),
                              ),
                            )
                          : const Icon(Icons.person, size: 80, color: Colors.blueAccent),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.04),

                // Personal Details
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Details",
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                ...personalDetails.entries.map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.005),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${e.key} :", style: labelStyle),
                          Flexible(child: Text(e.value ?? "N/A", style: valueStyle, textAlign: TextAlign.right)),
                        ],
                      ),
                    )),

                SizedBox(height: height * 0.04),

                // Work Details
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Work Details",
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                ...workDetails.entries.map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.005),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${e.key} :", style: labelStyle),
                          Flexible(child: Text(e.value ?? "N/A", style: valueStyle, textAlign: TextAlign.right)),
                        ],
                      ),
                    )),

                SizedBox(height: height * 0.05),

                // Role Info
                Text(
                  "Role: ${user.userType ?? (isLabour ? 'Labour' : 'Supervisor')}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
