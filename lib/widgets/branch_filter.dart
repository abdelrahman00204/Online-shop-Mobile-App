import 'package:flutter/material.dart';
import 'package:the_project/data/branch_data.dart';
import 'package:the_project/managers/auth_manage.dart';

class BranchFilter extends StatefulWidget {
  final void Function(int branchId)? onChanged;

  const BranchFilter({super.key, this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return _BranchFilter();
  }
}

class _BranchFilter extends State<BranchFilter> {
  String? selectedBranch = branches
      .firstWhere(
        (branch) => branch.id == AuthManage.instance.userFavBranch,
        orElse: () => branches.first,
      )
      .name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: selectedBranch,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
        ),
        dropdownColor: Colors.white,
        iconEnabledColor: const Color(0xFF2E7D32),
        style: const TextStyle(color: Colors.black87, fontSize: 15),
        items: [
          for (final branch in branches)
            DropdownMenuItem(
              value: branch.name,
              child: Row(
                children: [
                  const Icon(
                    Icons.store_outlined,
                    color: Color(0xFF2E7D32),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(branch.name),
                ],
              ),
            ),
        ],
        onChanged: (value) {
          setState(() {
            selectedBranch = value!;
          });
          final branch = branches.firstWhere((b) => b.name == value); 
          widget.onChanged?.call(branch.id);
        },
      ),
    );
  }
}
