import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_app_test/core/gradients/gradient_colors.dart';
import 'package:you_app_test/models/profile/profile_response.dart';
import 'package:you_app_test/presentation/bloc/profile/profile_bloc.dart';
import 'package:you_app_test/presentation/pages/interest_page.dart';
import 'package:you_app_test/routes/routes_names.dart';
import 'package:you_app_test/widgets/text_gradient.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> _getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('gender');
  }

  Future<String?> _getHoroscope() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('horoscope');
  }

  Future<String?> _getZodiac() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('zodiac');
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _showImagePicker() async {
    _showLoading();

    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color.fromRGBO(14, 25, 31, 1.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(pickedFile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(pickedFile);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }

    _hideLoading();
  }

  void _showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('image');
    if (imagePath != null) {
      setState(() {
        _selectedImage = File(imagePath);
      });
    }
  }

  Future<void> _setGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', gender);
  }

  Future<void> _setHoroscope(String horoscope) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('horoscope', horoscope);
  }

  Future<void> _setZodiac(String zodiac) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zodiac', zodiac);
  }

  String username = '';
  bool isEditAbout = false;
  bool isEditImage = false;
  bool isEditInterest = false;
  bool isLoading = false;
  bool isCreated = false;
  bool isHoroscope = false;
  bool isZodiac = false;
  bool isUpdating = true;
  String gender = '';
  String horoscope = '';
  String zodiac = '';
  String formattedDate = '';
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  TextEditingController _name = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _weight = TextEditingController();

  String _calculateHoroscope(String date) {
    if (date.isEmpty) {
      return 'Unknown';
    } else {
      final dateSplit = date.split(' ');
      final day = int.parse(dateSplit[0]);
      final month = int.parse(dateSplit[1]);

      if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
        return 'Aries';
      } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
        return 'Taurus';
      } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
        return 'Gemini';
      } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
        return 'Cancer';
      } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
        return 'Leo';
      } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
        return 'Virgo';
      } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
        return 'Libra';
      } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
        return 'Scorpio';
      } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
        return 'Sagittarius';
      } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
        return 'Capricorn';
      } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
        return 'Aquarius';
      } else {
        return 'Pisces';
      }
    }
  }

  String _calculateZodiac(String date) {
    if (date.isEmpty) {
      return 'Unknown';
    } else {
      final dateSplit = date.split(' ');
      final day = int.parse(dateSplit[0]);
      final month = int.parse(dateSplit[1]);
      final year = int.parse(dateSplit[2]);

      final zodiacData = [
        {
          'start': DateTime(2023, 1, 22),
          'end': DateTime(2024, 2, 9),
          'zodiac': 'Rabbit'
        },
        {
          'start': DateTime(2022, 2, 1),
          'end': DateTime(2023, 1, 21),
          'zodiac': 'Tiger'
        },
        {
          'start': DateTime(2021, 2, 12),
          'end': DateTime(2022, 1, 31),
          'zodiac': 'Ox'
        },
        {
          'start': DateTime(2020, 1, 25),
          'end': DateTime(2021, 2, 11),
          'zodiac': 'Rat'
        },
        {
          'start': DateTime(2019, 2, 5),
          'end': DateTime(2020, 1, 24),
          'zodiac': 'Pig'
        },
        {
          'start': DateTime(2018, 2, 16),
          'end': DateTime(2019, 2, 4),
          'zodiac': 'Dog'
        },
        {
          'start': DateTime(2017, 1, 28),
          'end': DateTime(2018, 2, 15),
          'zodiac': 'Rooster'
        },
        {
          'start': DateTime(2016, 2, 8),
          'end': DateTime(2017, 1, 27),
          'zodiac': 'Monkey'
        },
        {
          'start': DateTime(2015, 2, 19),
          'end': DateTime(2016, 2, 7),
          'zodiac': 'Goat'
        },
        {
          'start': DateTime(2014, 1, 31),
          'end': DateTime(2015, 2, 18),
          'zodiac': 'Horse'
        },
        {
          'start': DateTime(2013, 2, 10),
          'end': DateTime(2014, 1, 30),
          'zodiac': 'Snake'
        },
        {
          'start': DateTime(2012, 1, 23),
          'end': DateTime(2013, 2, 9),
          'zodiac': 'Dragon'
        },
        {
          'start': DateTime(2011, 2, 3),
          'end': DateTime(2012, 1, 22),
          'zodiac': 'Rabbit'
        },
        {
          'start': DateTime(2010, 2, 14),
          'end': DateTime(2011, 2, 2),
          'zodiac': 'Tiger'
        },
        {
          'start': DateTime(2009, 1, 26),
          'end': DateTime(2010, 2, 13),
          'zodiac': 'Ox'
        },
        {
          'start': DateTime(2008, 2, 7),
          'end': DateTime(2009, 1, 25),
          'zodiac': 'Rat'
        },
        {
          'start': DateTime(2007, 2, 18),
          'end': DateTime(2008, 2, 6),
          'zodiac': 'Boar'
        },
        {
          'start': DateTime(2006, 1, 29),
          'end': DateTime(2007, 2, 17),
          'zodiac': 'Dog'
        },
        {
          'start': DateTime(2005, 2, 9),
          'end': DateTime(2006, 1, 28),
          'zodiac': 'Rooster'
        },
        {
          'start': DateTime(2004, 1, 22),
          'end': DateTime(2005, 2, 8),
          'zodiac': 'Monkey'
        },
        {
          'start': DateTime(2003, 2, 1),
          'end': DateTime(2004, 1, 21),
          'zodiac': 'Goat'
        },
        {
          'start': DateTime(2002, 2, 12),
          'end': DateTime(2003, 1, 31),
          'zodiac': 'Horse'
        },
        {
          'start': DateTime(2001, 1, 24),
          'end': DateTime(2002, 2, 11),
          'zodiac': 'Snake'
        },
        {
          'start': DateTime(2000, 2, 5),
          'end': DateTime(2001, 1, 23),
          'zodiac': 'Dragon'
        },
        {
          'start': DateTime(1999, 2, 16),
          'end': DateTime(2000, 2, 4),
          'zodiac': 'Rabbit'
        },
        {
          'start': DateTime(1998, 1, 28),
          'end': DateTime(1999, 2, 15),
          'zodiac': 'Tiger'
        },
        {
          'start': DateTime(1997, 2, 7),
          'end': DateTime(1998, 1, 27),
          'zodiac': 'Ox'
        },
        {
          'start': DateTime(1996, 2, 19),
          'end': DateTime(1997, 2, 6),
          'zodiac': 'Rat'
        },
        {
          'start': DateTime(1995, 1, 31),
          'end': DateTime(1996, 2, 18),
          'zodiac': 'Boar'
        },
        {
          'start': DateTime(1994, 2, 10),
          'end': DateTime(1995, 1, 30),
          'zodiac': 'Dog'
        },
        {
          'start': DateTime(1993, 1, 23),
          'end': DateTime(1994, 2, 9),
          'zodiac': 'Rooster'
        },
        {
          'start': DateTime(1992, 2, 4),
          'end': DateTime(1993, 1, 22),
          'zodiac': 'Monkey'
        },
        {
          'start': DateTime(1991, 2, 15),
          'end': DateTime(1992, 2, 3),
          'zodiac': 'Goat'
        },
        {
          'start': DateTime(1990, 1, 27),
          'end': DateTime(1991, 2, 14),
          'zodiac': 'Horse'
        },
        {
          'start': DateTime(1989, 2, 6),
          'end': DateTime(1990, 1, 26),
          'zodiac': 'Snake'
        },
        {
          'start': DateTime(1988, 2, 17),
          'end': DateTime(1989, 2, 5),
          'zodiac': 'Dragon'
        },
        {
          'start': DateTime(1987, 1, 29),
          'end': DateTime(1988, 2, 16),
          'zodiac': 'Rabbit'
        },
        {
          'start': DateTime(1986, 2, 9),
          'end': DateTime(1987, 1, 28),
          'zodiac': 'Tiger'
        },
        {
          'start': DateTime(1985, 2, 20),
          'end': DateTime(1986, 2, 8),
          'zodiac': 'Ox'
        },
        {
          'start': DateTime(1984, 2, 2),
          'end': DateTime(1985, 2, 19),
          'zodiac': 'Rat'
        },
      ];

      final inputDate = DateTime(year, month, day);

      for (final zodiac in zodiacData) {
        if (inputDate.isAfter(zodiac['start'] as DateTime) &&
            inputDate.isBefore(zodiac['end'] as DateTime)) {
          return zodiac['zodiac'] as String;
        }
      }

      return 'Unknown';
    }
  }

  String _calculateAge(String date) {
    if (date.isEmpty) return '';

    final dateSplit = date.split(' ');

    if (dateSplit.length != 3) return '';

    try {
      final day = int.parse(dateSplit[0]);
      final month = int.parse(dateSplit[1]);
      final year = int.parse(dateSplit[2]);

      final now = DateTime.now();
      final inputDate = DateTime(year, month, day);

      final age = now.year - inputDate.year;

      if (now.month < inputDate.month ||
          (now.month == inputDate.month && now.day < inputDate.day)) {
        return (age - 1).toString();
      }

      return age.toString();
    } catch (e) {
      return ''; // Jika parsing gagal
    }
  }

  String _birthdayFormat(String date) {
    if (date.isEmpty) return '';

    final dateSplit = date.split(' ');

    if (dateSplit.length != 3) return '';

    try {
      final day = int.parse(dateSplit[0]);
      final month = int.parse(dateSplit[1]);
      final year = int.parse(dateSplit[2]);

      final now = DateTime.now();
      final inputDate = DateTime(year, month, day);

      final age = now.year - inputDate.year;

      if (now.month < inputDate.month ||
          (now.month == inputDate.month && now.day < inputDate.day)) {
        return '$day / $month / $year (${age - 1})';
      }

      return '$day / $month / $year (Age $age)';
    } catch (e) {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchProfile());

    _getUsername().then((value) {
      setState(() {
        username = value ?? '';
      });
    });

    _getGender().then((value) {
      setState(() {
        gender = value ?? '';
      });
    });

    _getHoroscope().then((value) {
      setState(() {
        horoscope = value ?? '';
      });
    });

    _getZodiac().then((value) {
      setState(() {
        zodiac = value ?? '';
      });
    });

    _loadSavedImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09141A),
      body: BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
        if (state is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      }, builder: (context, state) {
        if (state is ProfileSuccess) {
          // check success
          final user = state.users;
          if (state.isProfileCreated == true) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 120, left: 10, right: 10),
                        child: Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Color(0xFF162329),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: _selectedImage != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '@$username, ${_calculateAge(user.birthday ?? '')}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                gender,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  // background blur 50%
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    horoscope,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    zodiac,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '@$username,',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _about(
                          state.users.name ?? '',
                          state.users.birthday ?? '',
                          state.users.height.toString(),
                          state.users.weight.toString()),
                      const SizedBox(
                        height: 30,
                      ),
                      _interest(user.interests!),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 50),
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFF09141A),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, RoutesNames.login, (route) => false);
                            _logout();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '@$username',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ))
                      ],
                    )),
              ],
            );
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 120, left: 10, right: 10),
                        child: Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Color(0xFF162329),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: _selectedImage != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '@$username, ${_calculateAge(user.birthday ?? '')}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                gender,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  // background blur 50%
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    horoscope,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    zodiac,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '@$username,',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _about2(
                          state.users.name ?? '',
                          state.users.birthday ?? '',
                          state.users.height.toString(),
                          state.users.weight.toString()),
                      const SizedBox(
                        height: 30,
                      ),
                      _interest(user.interests!),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 50),
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFF09141A),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, RoutesNames.login, (route) => false);
                            _logout();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '@$username',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ))
                      ],
                    )),
              ],
            );
          }
        } else if (state is ProfileFailure) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
      }),
    );
  }

  Widget _about(String name, String birthday, String height, String weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: isEditAbout
          ? Container(
              height: 700,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(14, 25, 31, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        isEditAbout
                            ? Container(
                                child: isUpdating
                                    ? TextGradient(
                                        text: 'Save & Update',
                                        onPressed: () async {
                                          setState(() {
                                            isUpdating = false;
                                          });
                                          context
                                              .read<ProfileBloc>()
                                              .add(AddProfile(ProfileResponse(
                                                name: _name.text,
                                                birthday: formattedDate,
                                                height: int.parse(_height.text),
                                                weight: int.parse(_weight.text),
                                              )));

                                          _setGender(gender);
                                          _setHoroscope(_calculateHoroscope(
                                              formattedDate));
                                          _setZodiac(
                                              _calculateZodiac(formattedDate));
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              'image', _selectedImage!.path);

                                          await Future.delayed(
                                              const Duration(seconds: 1));

                                          // ignore: use_build_context_synchronously
                                          context
                                              .read<ProfileBloc>()
                                              .add(FetchProfile());

                                          _getUsername().then((value) {
                                            setState(() {
                                              username = value ?? '';
                                            });
                                          });

                                          _getGender().then((value) {
                                            setState(() {
                                              gender = value ?? '';
                                            });
                                          });

                                          _getHoroscope().then((value) {
                                            setState(() {
                                              horoscope = value ?? '';
                                            });
                                          });

                                          _getZodiac().then((value) {
                                            setState(() {
                                              zodiac = value ?? '';
                                            });
                                          });

                                          await Future.delayed(
                                              const Duration(seconds: 2));

                                          setState(() {
                                            isUpdating = true;
                                            isEditAbout = false;
                                          });
                                        },
                                        size: 16,
                                        decoration: TextDecoration.none,
                                      )
                                    : const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors
                                                .white), // Ukuran lebih kecil agar pas di tombol
                                      ))
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEditAbout = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                color: Colors.white12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                                  colors: GradientColors
                                                      .goldGradient)
                                              .createShader(bounds);
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextButton(
                                  onPressed: () async {
                                    await _showImagePicker();
                                  },
                                  child: const Text(
                                    'Add Image',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Display name:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  controller: _name,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: InputBorder.none,
                                    hintText: 'Enter name',
                                    focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.33),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gender:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      gender.isEmpty ? 'Select Gender' : gender,
                                      style: TextStyle(
                                        color: gender.isEmpty
                                            ? Colors.white.withOpacity(0.33)
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      color:
                                          const Color.fromRGBO(14, 25, 31, 1),
                                      shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'Male',
                                          child: Text(
                                            'Male',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Female',
                                          child: Text(
                                            'Female',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Birthday:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                          ).then((pickedDate) {
                                            if (pickedDate != null) {
                                              setState(() {
                                                formattedDate =
                                                    '${pickedDate.day} ${pickedDate.month} ${pickedDate.year}';
                                                isHoroscope = true;
                                              });
                                            }
                                          });
                                        },
                                        child: Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Horoscope:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      _calculateHoroscope(formattedDate),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.33),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Zodiac:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      _calculateZodiac(formattedDate),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.33),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Height:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: TextField(
                                  controller: _height,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: InputBorder.none,
                                    hintText: 'Add height',
                                    focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.33),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Weight:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: TextField(
                                  controller: _weight,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: InputBorder.none,
                                    hintText: 'Add weight',
                                    focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.33),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 230,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(14, 25, 31, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        isEditAbout
                            ? TextGradient(
                                text: 'Save & Update',
                                onPressed: () {
                                  setState(() {
                                    isEditAbout = true;
                                  });
                                },
                                size: 16,
                                decoration: TextDecoration.none,
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEditAbout = true;
                                    formattedDate = birthday;
                                    _name = TextEditingController(text: name);
                                    _height =
                                        TextEditingController(text: height);
                                    _weight =
                                        TextEditingController(text: weight);
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Birthday: ',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _birthdayFormat(birthday),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Horoscope: ',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _calculateHoroscope(birthday),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Zodiac: ',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _calculateZodiac(birthday),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Height: ',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '$height cm',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Weight: ',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '$weight kg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
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
    );
  }

  Widget _about2(String name, String birthday, String height, String weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: isEditAbout
          ? Container(
              height: 700,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(14, 25, 31, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        isEditAbout
                            ? Container(
                                child: isUpdating
                                    ? TextGradient(
                                        text: 'Save & Update',
                                        onPressed: () async {
                                          setState(() {
                                            isUpdating = false;
                                          });
                                          context
                                              .read<ProfileBloc>()
                                              .add(AddProfile(ProfileResponse(
                                                name: _name.text,
                                                birthday: formattedDate,
                                                height: int.parse(_height.text),
                                                weight: int.parse(_weight.text),
                                              )));

                                          _setGender(gender);
                                          _setHoroscope(_calculateHoroscope(
                                              formattedDate));
                                          _setZodiac(
                                              _calculateZodiac(formattedDate));
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              'image', _selectedImage!.path);

                                          await Future.delayed(
                                              const Duration(seconds: 1));

                                          // ignore: use_build_context_synchronously
                                          context
                                              .read<ProfileBloc>()
                                              .add(FetchProfile());

                                          _getUsername().then((value) {
                                            setState(() {
                                              username = value ?? '';
                                            });
                                          });

                                          _getGender().then((value) {
                                            setState(() {
                                              gender = value ?? '';
                                            });
                                          });

                                          _getHoroscope().then((value) {
                                            setState(() {
                                              horoscope = value ?? '';
                                            });
                                          });

                                          _getZodiac().then((value) {
                                            setState(() {
                                              zodiac = value ?? '';
                                            });
                                          });

                                          await Future.delayed(
                                              const Duration(seconds: 2));

                                          setState(() {
                                            isUpdating = true;
                                            isEditAbout = false;
                                          });
                                        },
                                        size: 16,
                                        decoration: TextDecoration.none,
                                      )
                                    : const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors
                                                .white), // Ukuran lebih kecil agar pas di tombol
                                      ))
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEditAbout = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                color: Colors.white12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                                  colors: GradientColors
                                                      .goldGradient)
                                              .createShader(bounds);
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextButton(
                                  onPressed: () async {
                                    await _showImagePicker();
                                  },
                                  child: const Text(
                                    'Add Image',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Display name:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  controller: _name,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: InputBorder.none,
                                    hintText: 'Enter name',
                                    focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.33),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gender:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      gender.isEmpty ? 'Select Gender' : gender,
                                      style: TextStyle(
                                        color: gender.isEmpty
                                            ? Colors.white.withOpacity(0.33)
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                      color:
                                          const Color.fromRGBO(14, 25, 31, 1),
                                      shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'Male',
                                          child: Text(
                                            'Male',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Female',
                                          child: Text(
                                            'Female',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Birthday:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                          ).then((pickedDate) {
                                            if (pickedDate != null) {
                                              setState(() {
                                                formattedDate =
                                                    '${pickedDate.day} ${pickedDate.month} ${pickedDate.year}';
                                                isHoroscope = true;
                                              });
                                            }
                                          });
                                        },
                                        child: Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Horoscope:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      _calculateHoroscope(formattedDate),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.33),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Zodiac:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      _calculateZodiac(formattedDate),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.33),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Height:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: TextField(
                                  controller: _height,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: InputBorder.none,
                                    hintText: 'Add height',
                                    focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.33),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Weight:',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.33),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.33)),
                                ),
                                child: TextField(
                                  controller: _weight,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: InputBorder.none,
                                    hintText: 'Add weight',
                                    focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.33),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(14, 25, 31, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        isEditAbout
                            ? TextGradient(
                                text: 'Save & Update',
                                onPressed: () {
                                  setState(() {
                                    isEditAbout = true;
                                  });
                                },
                                size: 16,
                                decoration: TextDecoration.none,
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEditAbout = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: SizedBox(
                      height: 50,
                      child: Text(
                        'Add in your your to help others know you better',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _interest(List<String> interests) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0E191F),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.white24,
              offset: Offset(0, 4),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Interest',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      // push to RoutesNames.interest with initialInterests
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InterestPage(
                            initialInterests: interests,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit_note,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: interests.isNotEmpty
                  ? Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: interests.map((interest) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        'Add in your interest to find a better match',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
