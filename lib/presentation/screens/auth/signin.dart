import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/presentation/providers/login_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';
import 'package:todoapp/helpers/app_color.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';

TextEditingController emailcont = TextEditingController();
TextEditingController passcontroller = TextEditingController();

@RoutePage()
class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Padding(
          padding: const EdgeInsets.only(top: 90),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,
              child: TextFormField(
                controller: emailcont,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),

            SizedBox(height: 16),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,

              child: TextFormField(
                controller: passcontroller,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),

            SizedBox(height: 70),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailcont.text.isEmpty || passcontroller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email ve şifre boş olamaz'),
                      ),
                    );
                    return;
                  }

                  try {
                    await Provider.of<LoginProvider>(
                      context,
                      listen: false,
                    ).signUp(emailcont.text.trim(), passcontroller.text.trim());
                    if (!mounted) return;
                    /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewLogin(),
                      ),
                    );*/
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kayıt başarısız: $e')),
                    );
                  }
                },
                child: Text('Kaydet', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  context.router.push(const LoginRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGray,
                ),
                child: Text(
                  'Hesabım var ',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
