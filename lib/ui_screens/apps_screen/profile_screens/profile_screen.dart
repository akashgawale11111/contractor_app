// import 'package:contractor_app/logic/Apis/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class UserProfileScreen extends ConsumerWidget {
//   const UserProfileScreen({super.key});

//   Widget infoRow(String title, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value ?? "N/A")),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(authProvider);

//     if (user == null || user.labour == null) {
//       return const Scaffold(
//         body: Center(child: Text("No user data")),
//       );
//     }

//     final labour = user.labour!;

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: labour.imageUrl != null
//                   ? NetworkImage(labour.imageUrl!)
//                   : null,
//               child: labour.imageUrl == null
//                   ? const Icon(Icons.person, size: 60)
//                   : null,
//             ),
//             const SizedBox(height: 16),
//             Text("${labour.firstName ?? ''} ${labour.lastName ?? ''}",
//                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             infoRow("Labour ID", labour.labourId),
//             infoRow("Email", labour.email),
//             infoRow("Phone", labour.phoneNumber),
//             infoRow("Age", labour.age?.toString()),
//             infoRow("Gender", labour.gender),
//             infoRow("DOB", labour.dateOfBirth),
//             infoRow("Address", labour.address),
//             infoRow("City", labour.city),
//             infoRow("State", labour.state),
//             infoRow("Pincode", labour.pincode),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

    if (user == null || user.labour == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      );
    }

    final labour = user.labour!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "${labour.firstName ?? ''} ${labour.lastName ?? ''}",
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
                    backgroundImage: labour.imageUrl != null
                        ? NetworkImage(labour.imageUrl!)
                        : null,
                    child: labour.imageUrl == null
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
                  infoRow(Icons.badge, "Labour ID", labour.labourId),
                  infoRow(Icons.email, "Email", labour.email),
                  infoRow(Icons.phone, "Phone", labour.phoneNumber),
                  infoRow(Icons.cake, "Age", labour.age?.toString()),
                  infoRow(Icons.male, "Gender", labour.gender),
                  infoRow(Icons.calendar_today, "DOB", labour.dateOfBirth),
                  infoRow(Icons.location_on, "Address", labour.address),
                  infoRow(Icons.location_city, "City", labour.city),
                  infoRow(Icons.map, "State", labour.state),
                  infoRow(Icons.pin, "Pincode", labour.pincode),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
