import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    this.value,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        items:
            items
                .map(
                  (items) => DropdownMenuItem(value: items, child: Text(items)),
                )
                .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
