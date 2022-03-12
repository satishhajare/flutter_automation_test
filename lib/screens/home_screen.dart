import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screens/login_screen.dart';
import 'technology_screen.dart';
import '../model/technology_model.dart';
import '../services/authentication_service.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  final AuthenticationService? authenticationService;
  const HomeScreen({Key? key, @required this.authenticationService})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int i = 0;

  List<Technology> jsonToTechnologyList(Map<String, dynamic> data) {
    final technology = <Technology>[];
    if (data['technologyList'] != null) {
      data['technologyList']!.forEach((Object? e) {
        technology.add(Technology.fromJson(e as Map<String, dynamic>));
      });
    }
    if (i == 0) {
      Provider.of<TechnologyModel>(context, listen: false)
          .initialize(technology);
      i = 1;
    }
    return technology;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('addButton'),
        onPressed: () {
          Navigator.push<TechnologyScreen>(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                  value: Provider.of<TechnologyModel>(context),
                  child: const TechnologyScreen()),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green.shade800,
      ),
      appBar: AppBar(
        title: const Text('Technology'),
        backgroundColor: Colors.green.shade900,
        actions: [
          IconButton(
            key: const ValueKey('LogoutKey'),
            onPressed: () {
              widget.authenticationService!.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<LoginScreen>(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: Provider.of<TechnologyModel>(context),
                    child: LoginScreen(
                      authenticationService: widget.authenticationService,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: DatabaseService().readData(AuthenticationService().getUserID),
          builder: (ctx, data) {
            if (!data.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            jsonToTechnologyList(data.data!);
            return Consumer<TechnologyModel>(
                builder: (context, ideasModel, child) {
              final ideasList = ideasModel.getAllIdeas;
              return ideasList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Add New Technology by clicking add icon below',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: ideasList.length,
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 8,
                          color: Colors.grey.shade200,
                          child: Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${ideasList[index].title!} dismissed'),
                                ),
                              );
                              Provider.of<TechnologyModel>(context,
                                      listen: false)
                                  .deleteTechnology(ideasList[index]);
                            },
                            background: Container(color: Colors.redAccent),
                            child: ListTile(
                              title: Text(
                                ideasList[index].title!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                ideasList[index].description!,
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        );
                      },
                    );
            });
          }),
    );
  }
}
