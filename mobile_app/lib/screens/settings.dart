import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/bloc/global/global_bloc.dart';
import 'package:training_app/models/user.dart';
import 'package:training_app/services/firebase_database_service.dart';
import 'package:training_app/widgets/bv_scaffold.dart';
import 'package:training_app/widgets/fd_app_bar.dart';
import 'package:training_app/widgets/fd_button.dart';
import 'package:training_app/widgets/fd_double_column.dart';
import 'package:training_app/widgets/fd_text_field.dart';

import '../util/either.dart';
import '../util/failures/failure.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _maxHrController = TextEditingController();

  final TextEditingController _zone1MinController = TextEditingController();
  final TextEditingController _zone1MaxController = TextEditingController();
  final TextEditingController _zone2MinController = TextEditingController();
  final TextEditingController _zone2MaxController = TextEditingController();
  final TextEditingController _zone3MinController = TextEditingController();
  final TextEditingController _zone3MaxController = TextEditingController();
  final TextEditingController _zone4MinController = TextEditingController();
  final TextEditingController _zone4MaxController = TextEditingController();
  final TextEditingController _zone5MinController = TextEditingController();
  final TextEditingController _zone5MaxController = TextEditingController();

  @override
  void initState() {
    final BVUser? user = context.read<GlobalBloc>().state.user;
    if (user != null) {
      _weightController.text = user.weight?.toString() ?? "";
      _heightController.text = user.height?.toString() ?? "";
      _ageController.text = user.age?.toString() ?? "";
      _maxHrController.text = user.maxHr?.toString() ?? "";
      _zone1MinController.text = user.zone1MinPower?.toString() ?? "";
      _zone1MaxController.text = user.zone1MaxPower?.toString() ?? "";
      _zone2MinController.text = user.zone2MinPower?.toString() ?? "";
      _zone2MaxController.text = user.zone2MaxPower?.toString() ?? "";
      _zone3MinController.text = user.zone3MinPower?.toString() ?? "";
      _zone3MaxController.text = user.zone3MaxPower?.toString() ?? "";
      _zone4MinController.text = user.zone4MinPower?.toString() ?? "";
      _zone4MaxController.text = user.zone4MaxPower?.toString() ?? "";
      _zone5MinController.text = user.zone5MinPower?.toString() ?? "";
      _zone5MaxController.text = user.zone5MaxPower?.toString() ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BVScaffold(
      appBar: const FDAppBar(
        title: "Nastavitve",
      ),
      persistentFooterButton: Column(
        children: [
          FDPrimaryButton(
            text: "Shrani",
            color: Colors.green,
            onPressed: () async {
              BVUser user = context.read<GlobalBloc>().state.user!;
              user = user.copyWith(
                weight: num.tryParse(_weightController.text),
                height: num.tryParse(_heightController.text),
                age: int.tryParse(_ageController.text),
                maxHr: num.tryParse(_maxHrController.text),
                zone1MinPower: num.tryParse(_zone1MinController.text),
                zone1MaxPower: num.tryParse(_zone1MaxController.text),
                zone2MinPower: num.tryParse(_zone2MinController.text),
                zone2MaxPower: num.tryParse(_zone2MaxController.text),
                zone3MinPower: num.tryParse(_zone3MinController.text),
                zone3MaxPower: num.tryParse(_zone3MaxController.text),
                zone4MinPower: num.tryParse(_zone4MinController.text),
                zone4MaxPower: num.tryParse(_zone4MaxController.text),
                zone5MinPower: num.tryParse(_zone5MinController.text),
                zone5MaxPower: num.tryParse(_zone5MaxController.text),
              );

              final Either<Failure, void> voidOrFailure =
                  await FirebaseDatabaseService.instance.updateDocument(
                FirebaseDocumentPaths.users,
                user.id,
                user.toJson(),
              );
              if (!context.mounted) return;
              if (voidOrFailure.isError()) {
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
                    content: Text(
                  "Prišlo je do napake pri posodabljanju podatkov",
                )));
              } else {
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(const SnackBar(
                    content: Text(
                  "Podatki so bili uspešno posodobljeni",
                )));
                context.read<GlobalBloc>().updateUser(user);
              }
            },
          ),
          const SizedBox(height: 10),
          FDPrimaryButton(
            text: "Sign out",
            onPressed: () async {
              context.read<GlobalBloc>().signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FDDoubleColumn(
            children: [
              FDTextField(
                controller: _weightController,
                hintText: "Teža",
                suffixText: "Teža [kg]",
              ),
              FDTextField(
                controller: _heightController,
                hintText: "Višina",
                suffixText: "Višina [cm]",
              ),
              FDTextField(
                controller: _ageController,
                hintText: "Starost",
                suffixText: "Starost",
              ),
              FDTextField(
                controller: _maxHrController,
                hintText: "Max HR",
                suffixText: "Max HR",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Text("Zone 1:")),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone1MinController,
                  hintText: "Min",
                  suffixText: "W",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone1MaxController,
                  hintText: "Max",
                  suffixText: "W",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Zone 2:")),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone2MinController,
                  hintText: "Min",
                  suffixText: "W",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone2MaxController,
                  hintText: "Max",
                  suffixText: "W",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Zone 3:")),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone3MinController,
                  hintText: "Min",
                  suffixText: "W",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone3MaxController,
                  hintText: "Max",
                  suffixText: "W",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Zone 4:")),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone4MinController,
                  hintText: "Min",
                  suffixText: "W",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone4MaxController,
                  hintText: "Max",
                  suffixText: "W",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: Text("Zone 5:")),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone5MinController,
                  hintText: "Min",
                  suffixText: "W",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FDTextField(
                  controller: _zone5MaxController,
                  hintText: "Max",
                  suffixText: "W",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
