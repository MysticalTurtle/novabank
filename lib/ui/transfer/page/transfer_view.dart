import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/ui/transfer/cubit/transfer_cubit.dart';
import 'package:novabank/ui/transfer/widgets/beneficiary_tile.dart';
import 'package:novabank/ui/widgets/toast_helper.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transferir dinero')),
      body: BlocConsumer<TransferCubit, TransferState>(
        listener: (context, state) {
          if (state.status == TransferStatus.error) {
            ToastHelper.showErrorToast(context, state.errorMessage ?? 'Error');
          } else if (state.status == TransferStatus.completed) {
            ToastHelper.showSuccessToast(context, '¡Transferencia completada!');
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.status == TransferStatus.loading &&
              state.beneficiaries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TransferStatus.success) {
            return _buildConfirmationView(context, state);
          }

          return _buildSelectionView(context, state);
        },
      ),
    );
  }

  Widget _buildSelectionView(BuildContext context, TransferState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Seleccionar beneficiario',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (state.beneficiaries.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No hay beneficiarios disponibles'),
              ),
            )
          else
            ...state.beneficiaries.map((beneficiary) {
              final isSelected =
                  state.selectedBeneficiary?.id == beneficiary.id;
              return BeneficiaryTile(
                beneficiary: beneficiary,
                isSelected: isSelected,
                onTap: () {
                  context.read<TransferCubit>().selectBeneficiary(beneficiary);
                },
              );
            }),
          const SizedBox(height: 24),
          const Text(
            'Amount',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Ingrese la cantidad',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final amount = double.tryParse(value);
              if (amount != null) {
                context.read<TransferCubit>().setAmount(amount);
              }
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed:
                state.selectedBeneficiary != null &&
                    state.amount != null &&
                    state.status != TransferStatus.loading
                ? () {
                    context.read<TransferCubit>().createTransfer();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: state.status == TransferStatus.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Transferir'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationView(BuildContext context, TransferState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Transferencia creada',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'ID de transferencia: ${state.transferId}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Para: ${state.selectedBeneficiary?.name}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Cantidad: \$${state.amount?.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: state.status == TransferStatus.confirming
                  ? null
                  : () {
                      context.read<TransferCubit>().confirmTransfer();
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                backgroundColor: Colors.green,
              ),
              child: state.status == TransferStatus.confirming
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirmar transferencia',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: state.status == TransferStatus.confirming
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
