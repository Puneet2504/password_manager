import 'package:flutter/material.dart' hide Key;
import 'package:password_manager/provider/password_add.dart';
import 'package:encrypt/encrypt.dart';

class AddPage extends StatefulWidget {
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _service = TextEditingController();
  final snackBar = SnackBar(
    backgroundColor: Colors.purple.shade400,
    content: const Text(
      'Data Saved Successfully',
      textAlign: TextAlign.center,
    ),
    duration: const Duration(seconds: 1),
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
  );

  void intiState() {
    super.initState();

    _email.addListener(() => setState(() {}));
    _service.addListener(() => setState(() {}));
    _password.addListener(() => setState(() {}));
  }

  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    //Generation of Key and iv for password encryption and decryption
    final key = Key.fromSecureRandom(32);
    final iv = IV.fromSecureRandom(16);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple.shade700,
          title: const Text(
            'Add page',
          )),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 180,
              ),
              TextFormField(
                controller: _service,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field cannot be empty';
                  } else {
                    return null;
                  }
                },
                cursorColor: Colors.purple,
                decoration: InputDecoration(
                    focusColor: Colors.purple.shade700,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    hintText: 'Service',
                    labelStyle: TextStyle(color: Colors.purple.shade300),
                    hintStyle: TextStyle(color: Colors.purple.shade300),
                    errorStyle: const TextStyle(color: Colors.purple),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    labelText: 'Service',
                    suffixIcon: IconButton(
                        onPressed: () {
                          _service.clear();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.purple,
                        ))),
              ),
              const SizedBox(
                height: 36,
              ),
              TextFormField(
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field cannot be empty';
                  } else {
                    return null;
                  }
                },
                cursorColor: Colors.purple,
                decoration: InputDecoration(
                    focusColor: Colors.purple.shade700,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    hintText: 'E-Mail/Username',
                    hintStyle: TextStyle(color: Colors.purple.shade300),
                    labelText: 'E-Mail',
                    labelStyle: TextStyle(color: Colors.purple.shade300),
                    errorStyle: const TextStyle(color: Colors.purple),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        _email.clear();
                      },
                    )),
              ),
              const SizedBox(
                height: 36,
              ),
              TextFormField(
                obscureText: isPasswordVisible,
                controller: _password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field cannot be empty';
                  } else {
                    return null;
                  }
                },
                cursorColor: Colors.purple,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    hintText: 'Password',
                    labelStyle: TextStyle(color: Colors.purple.shade300),
                    hintStyle: TextStyle(color: Colors.purple.shade300),
                    errorStyle: const TextStyle(color: Colors.purple),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple.shade300)),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: !isPasswordVisible
                          ? const Icon(
                              Icons.visibility,
                              color: Colors.purple,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Colors.purple,
                            ),
                      onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible),
                    )),
              ),
              const SizedBox(
                height: 36,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FirebaseService().insertSubCollection(
                          _service.text,
                          _email.text,
                          encrypt(_password.text, key, iv),
                          key.base16,
                          iv.base16);
                      _email.clear();
                      _service.clear();
                      _password.clear();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.purple.shade700,
                      minimumSize: const Size(50, 50))),
            ]),
          ),
        ),
      ),
    );
  }

  String encrypt(String password, Key key, IV iv) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(_password.text, iv: iv);
    return encrypted.base16;
  }
}
