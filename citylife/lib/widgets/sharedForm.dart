import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SharedForm extends StatefulWidget {
  @override
  _SharedFormState createState() => _SharedFormState();
}

class _SharedFormState extends State<SharedForm> {
  @override
  Widget build(BuildContext context) {
    final structuralImpression = context.watch<CLImpression>();
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              width: constraints.maxWidth * 0.8,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: T.structuralColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add here your photos"),
                          Icon(Icons.add_a_photo)
                        ],
                      )),
                  TextFormField(
                      maxLines: 11,
                      initialValue: "Notes",
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 190.0),
                        child: Icon(Icons.rate_review_outlined),
                      )))
                ],
              ),
            ));
  }
}
