import 'package:deloitte/widgets/authentification/sign_in/sign_in.dart';
import 'package:deloitte/widgets/authentification/sign_up/sign_up.dart';
import 'package:deloitte/widgets/dashboards/dash.dart';
import 'package:deloitte/widgets/files/file_pg.dart';
import 'package:deloitte/widgets/table_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _logout() async {
    if (isUserLoggedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      setState(() {
        isUserLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/DELBlack.jpg',
                                  width: 300,
                                  height: 120,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => const Home(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Home",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      InkWell(
                                        onTap: () {},
                                        child: const Text(
                                          "About Us",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      InkWell(
                                        onTap: () async {
                                          if (isUserLoggedIn) {
                                            await _logout();
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => const SignIn(),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          isUserLoggedIn ? "Logout" : "Login",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 100),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 50,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 50),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Cabinet de",
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Services professionnels",
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      const Text(
                                        "Deloitte favorise une approche focalisée sur la maîtrise des risques spécifiques \n à l'activité tout en intégrant une évaluation des systèmes et des procédures",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => const SignUp(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Register today!",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  bool isUserLoggedIn =
                                      prefs.getBool('isLoggedIn') ?? false;

                                  if (isUserLoggedIn) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const FilePg(),
                                      ),
                                    );
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Not Logged In'),
                                          content: const Text(
                                            'You need to be logged in to access this feature.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "assets/upload.png",
                                    color: Colors.white,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                "Uploading File",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  bool isUserLoggedIn =
                                      prefs.getBool('isLoggedIn') ?? false;

                                  if (isUserLoggedIn) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TableData(),
                                      ),
                                    );
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Not Logged In'),
                                          content: const Text(
                                            'You need to be logged in to access this feature.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/view.svg",
                                      color: Colors.white,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                "Consulting Data",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  bool isUserLoggedIn =
                                      prefs.getBool('isLoggedIn') ?? false;

                                  if (isUserLoggedIn) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboarding(),
                                      ),
                                    );
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Not Logged In'),
                                          content: const Text(
                                            'You need to be logged in to access this feature.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/statistics.svg",
                                      color: Colors.white,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                "Dashboards",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/contact.svg",
                                  color: Colors.white,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                "Contact Us",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
