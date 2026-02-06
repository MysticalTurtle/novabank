import 'package:flutter/material.dart';
import 'package:novabank/data/models/beneficiary_model.dart';

class BeneficiaryTile extends StatelessWidget {
  const BeneficiaryTile({
    super.key,
    required this.beneficiary,
    required this.isSelected,
    required this.onTap,
  });

  final BeneficiaryModel beneficiary;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
              isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
          child: Icon(
            Icons.person,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
        title: Text(
          beneficiary.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(beneficiary.accountNumber),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.blue.shade700)
            : null,
      ),
    );
  }
}
