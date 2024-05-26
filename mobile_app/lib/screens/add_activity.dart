import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/models/activity.dart';
import 'package:training_app/services/firebase_database_service.dart';
import 'package:training_app/style/colors.dart';
import 'package:training_app/util/either.dart';
import 'package:training_app/widgets/bv_scaffold.dart';
import 'package:training_app/widgets/fd_app_bar.dart';
import 'package:training_app/widgets/fd_button.dart';
import 'package:training_app/widgets/fd_text_field.dart';

import '../bloc/global/global_bloc.dart';
import '../util/failures/failure.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _activityNameController = TextEditingController();
  File? _fitFile;

  @override
  Widget build(BuildContext context) {
    return BVScaffold(
      appBar: const FDAppBar(
        title: "Dodaj aktivnost",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ime aktivnosti:"),
          FDTextField(
            controller: _activityNameController,
            hintText: "Vnesite ime",
          ),
          const SizedBox(height: 10),
          if (_fitFile == null)
            const Text("Datoteka .fit ni izbrana")
          else
            Text("Izbrana datoteka: ${_fitFile!.path.split("/").last}"),
          const SizedBox(height: 10),
          FDPrimaryButton(
            color: BVColors.bronze,
            text: "Izberite .fit datoteko",
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.any,
                withData: true,
              );

              if (result == null) return;

              File file = File(result.files.single.path!);
              await file.writeAsBytes(result.files.single.bytes!);
              setState(() {
                _fitFile = file;
              });
            },
          ),
        ],
      ),
      persistentFooterButton: FDButton(
        text: "Dodaj aktivnost",
        enabled: _fitFile != null,
        onPressed: () async {
          try {
            if (_activityNameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Ime aktivnosti ne sme biti prazno"),
                ),
              );
              return;
            }

            final Activity activity = Activity(
              id: "",
              name: _activityNameController.text,
              userId: context.read<GlobalBloc>().state.user!.id,
              createdAt: DateTime.now(),
            );

            final Either<Failure, String> idOrFailure =
                await FirebaseDatabaseService.instance.addDocument(
              FirebaseDocumentPaths.activities,
              activity.toJson(),
            );

            if (!context.mounted) return;

            if (idOrFailure.isError()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Napaka pri dodajanju aktivnosti")),
              );
              return;
            }

            await FirebaseStorage.instance
                .ref("${FirebaseDocumentPaths.activities}/${idOrFailure.value}")
                .child("activity.fit")
                .putFile(
                  _fitFile!,
                  SettableMetadata(contentType: "application/fit"),
                );

            if (!context.mounted) return;
            Navigator.pop(context);
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Napaka pri dodajanju aktivnosti")),
            );
          }
          // Add activity
        },
      ),
    );
  }
}
