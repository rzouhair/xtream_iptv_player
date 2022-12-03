import 'package:first_fp/Components/Input.dart';
import 'package:first_fp/Screens/Home.dart';
import 'package:first_fp/providers/starred_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String host = '';
  late String username = '';
  late String password = '';

  late bool loading = false;

  late bool hasBeenSet = false;

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Starred>(context);
    final entries = context.watch<Starred>().login?.get('logins');
    late bool allFilled = host.isEmpty || username.isEmpty || password.isEmpty;

    Future login() async {
      String action = 'get_live_categories';
      var url = Uri.http(
          host, 'player_api.php', {'username': username, 'password': password});
      try {
        setState(() {
          loading = true;
        });
        var response = await http.get(url);

        if (response.statusCode == 200) {
          provider.login?.put('logins', {
            'host': host,
            'username': username,
            'password': password,
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[400],
            content: const Text(
              'Invalid username or password',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            'An error occurred $e',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ));
      } finally {
        setState(() {
          loading = false;
        });
      }
      // player_api.php?username=X&password=X
    }

    setState(() {
      if (!hasBeenSet) {
        host = entries['host'];
        username = entries['username'];
        password = entries['password'];
        if (!allFilled) {
          login();
        }
        hasBeenSet = true;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.connected_tv,
                size: 65,
              ),
              const Text(
                'IPTV',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Input(
                placeholder: 'Host:port',
                value: host,
                disabled: loading,
                onChanged: (String value) {
                  setState(() {
                    host = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Input(
                placeholder: 'Username',
                value: username,
                disabled: loading,
                onChanged: (String value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Input(
                placeholder: 'Password',
                value: password,
                disabled: loading,
                obscure: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () async {
                    if (!allFilled && !loading) {
                      login();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: allFilled || loading
                          ? Colors.deepPurple.withOpacity(0.5)
                          : Colors.deepPurple,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: allFilled || loading
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
