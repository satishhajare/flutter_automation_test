import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/technology_model.dart';

class TechnologyScreen extends StatefulWidget {
  const TechnologyScreen({Key? key}) : super(key: key);

  @override
  _TechnologyScreenState createState() => _TechnologyScreenState();
}

class _TechnologyScreenState extends State<TechnologyScreen> {
  final TextEditingController _ideaNameController = TextEditingController();
  final TextEditingController _ideaInspirationController =
      TextEditingController();
  final _newIdeaFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 52),
            child: Column(
              children: [
                Text(
                  'Add new Technology',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _newIdeaFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            key: const ValueKey('technologyField'),
                            controller: _ideaNameController,
                            cursorColor: Colors.green.shade900,
                            style: TextStyle(color: Colors.grey.shade400),
                            decoration: InputDecoration(
                              labelText: 'Technology Title',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.green.shade900,
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            key: const ValueKey('descriptionField'),
                            controller: _ideaInspirationController,
                            cursorColor: Colors.green.shade900,
                            style: TextStyle(color: Colors.grey.shade400),
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.green.shade900,
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.green.shade800,
                        ),
                      ),
                      onPressed: () {
                        if (_newIdeaFormKey.currentState!.validate()) {
                          Provider.of<TechnologyModel>(context, listen: false)
                              .addTechnology(
                            Technology(
                              title: _ideaNameController.value.text.trim(),
                              description:
                                  _ideaInspirationController.value.text.trim(),
                              date: DateTime.now().toIso8601String(),
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'Add',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
