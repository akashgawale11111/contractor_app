import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  Widget infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "N/A")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    if (user == null || user.labour == null) {
      return const Scaffold(
        body: Center(child: Text("No user data")),
      );
    }

    final labour = user.labour!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: labour.imageUrl != null
                  ? NetworkImage(labour.imageUrl!)
                  : null,
              child: labour.imageUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 16),
            Text("${labour.firstName ?? ''} ${labour.lastName ?? ''}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            infoRow("Labour ID", labour.labourId),
            infoRow("Email", labour.email),
            infoRow("Phone", labour.phoneNumber),
            infoRow("Age", labour.age?.toString()),
            infoRow("Gender", labour.gender),
            infoRow("DOB", labour.dateOfBirth),
            infoRow("Address", labour.address),
            infoRow("City", labour.city),
            infoRow("State", labour.state),
            infoRow("Pincode", labour.pincode),
          ],
        ),
      ),
    );
  }
}
