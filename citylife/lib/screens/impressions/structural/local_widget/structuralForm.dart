import 'package:citylife/models/cl_structural.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StructuralForm extends StatefulWidget {
  @override
  _StructuralFormState createState() => _StructuralFormState();
}

class _StructuralFormState extends State<StructuralForm> {
  String _value;

  @override
  Widget build(BuildContext context) {
    final structuralImpression = context.watch<CLStructural>();
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              width: constraints.maxWidth * 0.9,
              height: constraints.maxHeight * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    decoration: InputDecoration(prefixIcon: Icon(Icons.domain)),
                    initialValue: "Component",
                    onFieldSubmitted: (value) {
                      setState(() {
                        structuralImpression.component = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(prefixIcon: Icon(Icons.help_outline)),
                    initialValue: "Pathology",
                    onFieldSubmitted: (value) {
                      setState(() {
                        structuralImpression.component = value;
                      });
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey[300], width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        items: [
                          DropdownMenuItem<String>(
                            child: Text('Fixing'),
                            value: 'Fixing',
                          ),
                          DropdownMenuItem<String>(
                            child: Text('Add new'),
                            value: 'Add new',
                          ),
                          DropdownMenuItem<String>(
                            child: Text('Replace'),
                            value: 'Replace',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            structuralImpression.typology = value;
                            _value = value;
                          });
                        },
                        hint: Text('Type of Intervention'),
                        value: _value,
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
