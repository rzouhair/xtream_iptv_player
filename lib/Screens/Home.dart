import 'dart:convert';

import 'package:first_fp/Screens/login.dart';
import 'package:first_fp/providers/starred_provider.dart';
import 'package:flutter/material.dart';
import 'package:first_fp/Entites/Categories.dart';
import 'package:first_fp/Screens/Channels.dart';
import 'package:provider/provider.dart';
import '../Components/card.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Starred starred;

  late bool hasBeenSet = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      starred = context.watch<Starred>();
    });

    void appendEntries(Category category) async {
      Navigator.of(context).push(
          // MaterialPageRoute(builder: (context) => ChannelsScreen(category_id: int.parse(entries[index].categorie_id), category_name: entries[index].categorie_name,))
          MaterialPageRoute(
              builder: (context) => ChannelsScreen(
                    category_id: int.parse(category.categorie_id),
                    category_name: category.categorie_name,
                  )));
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Loading...'),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              var starredEntries = starred.box?.get('entries');
              List<Category> categories = snapshot.data;
              var entries = starredEntries != null
                  ? [
                      ...categories.where((v) => starredEntries
                          .contains('Category_${v.categorie_id}')),
                      ...categories.where((v) => !starredEntries
                          .contains('Category_${v.categorie_id}'))
                    ]
                  : [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                var logins = starred.login?.get('logins');
                                var url = Uri.http(
                                    logins['host'], 'player_api.php', {
                                  'username': logins['username'],
                                  'password': logins['password']
                                });
                                try {
                                  var response = await http.get(url);
                                  var body = json.decode(response.body);

                                  if (response.statusCode == 200) {
                                    starred.login?.put('logins', {
                                      'host': logins['host'],
                                      'username': logins['username'],
                                      'password': logins['password'],
                                    });
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Server Information"),
                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Status: ',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: [
                                                  TextSpan(
                                                    text: body['user_info']
                                                        ['status'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ])),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Max connections: ',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: [
                                                  TextSpan(
                                                    text: body['user_info']
                                                        ['max_connections'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ])),
                                            RichText(
                                                text: TextSpan(
                                                    text:
                                                        'Active connections: ',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: [
                                                  TextSpan(
                                                    text: body['user_info']
                                                        ['active_cons'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ])),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Starting date: ',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: [
                                                  TextSpan(
                                                    text: DateTime.fromMillisecondsSinceEpoch(
                                                            int.parse(body[
                                                                        'user_info']
                                                                    [
                                                                    'created_at']) *
                                                                1000)
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ])),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Expiration date: ',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: [
                                                  TextSpan(
                                                    text: DateTime.fromMillisecondsSinceEpoch(
                                                            int.parse(body[
                                                                        'user_info']
                                                                    [
                                                                    'exp_date']) *
                                                                1000)
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ])),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                  color: Colors.deepPurple[400],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4))),
                                              child: const Text('Close',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red[400],
                                      content: const Text(
                                        'Invalid username or password',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.red[400],
                                    content: Text(
                                      'An error occurred $e',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple[400],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                child: const Icon(Icons.info),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                context.read<Starred>().login?.put('logins', {
                                  'host': '',
                                  'username': '',
                                  'password': '',
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                    (route) => false);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                child: const Icon(Icons.logout_outlined),
                              )),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ListView.separated(
                            itemCount: entries.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InnerCard(
                                onPressed: () {
                                  appendEntries(entries[index]);
                                },
                                onStar: () async {
                                  dynamic entr = starred.box?.get('entries');
                                  await starred.box?.put(
                                      'entries',
                                      (() {
                                        if (!entr.contains(
                                            'Category_${entries[index].categorie_id}')) {
                                          return [
                                            ...entr,
                                            'Category_${entries[index].categorie_id}'
                                          ];
                                        } else {
                                          return entr
                                              .where((value) =>
                                                  value !=
                                                  'Category_${entries[index].categorie_id}')
                                              .toList();
                                        }
                                      }()));
                                  setState(() {
                                    starredEntries =
                                        starred.box?.get('entries');
                                    entries = starredEntries != null
                                        ? [
                                            ...entries.where((v) =>
                                                starredEntries.contains(
                                                    'Category_${v.categorie_id}')),
                                            ...entries.where((v) =>
                                                !starredEntries.contains(
                                                    'Category_${v.categorie_id}'))
                                          ]
                                        : [];
                                  });
                                },
                                showStar: true,
                                isStarred: starredEntries != null &&
                                    starredEntries.contains(
                                        'Category_${entries[index].categorie_id}'),
                                content: Text(
                                  entries[index].categorie_name.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Container(
                              height: 10,
                            ),
                          )))
                ],
              );
            } else {
              return const Text('No data!');
            }
          },
          future: Category.getAll('live', starred.login?.get('logins')),
        ),
      ),
    );
  }
}
