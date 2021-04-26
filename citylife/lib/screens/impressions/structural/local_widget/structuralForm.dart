import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StructuralForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  StructuralForm({Key key, this.formKey}) : super(key: key);

  @override
  _StructuralFormState createState() => _StructuralFormState();
}

class _StructuralFormState extends State<StructuralForm> {
  String _selectedTypology;
  List<String> _typologies = [
    'Add new',
    'Replace',
    'Repair',
    'Restore',
    'Upgrade'
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth * 0.9,
        child: Consumer<CLImpression>(
          builder: (context, structuralImpression, _) => Form(
            key: widget.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.domain,
                          color: T.primaryColor,
                        ),
                        hintText: "Component",
                      ),
                      initialValue:
                          (structuralImpression as CLStructural).component ??
                              "",
                      onChanged: (value) {
                        setState(() {
                          (structuralImpression as CLStructural).component =
                              value;
                        });
                      },
                      validator: (value) {
                        if (value == "") return "Please choose a component";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.help_outline,
                          color: T.primaryColor,
                        ),
                        hintText: "Pathology",
                      ),
                      initialValue:
                          (structuralImpression as CLStructural).pathology ??
                              "",
                      onChanged: (value) {
                        setState(() {
                          (structuralImpression as CLStructural).pathology =
                              value;
                        });
                      },
                      validator: (value) {
                        if (value == "") return "Please choose a pathology";
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<dynamic>(
                      value: _selectedTypology,
                      items: _typologies.map((typology) {
                        return DropdownMenuItem<dynamic>(
                          child: Text(typology),
                          value: typology,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          (structuralImpression as CLStructural).typology =
                              value;
                          _selectedTypology = value;
                        });
                      },
                      hint: Text(
                        'Type of Intervention',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      validator: (value) {
                        if (value == null)
                          return "Please choose a type of intervention";
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
