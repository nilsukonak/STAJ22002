import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/presentation/providers/login_provider.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';
import 'package:todoapp/presentation/screens/auth/signin.dart';

import 'package:todoapp/helpers/app_color.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _SigninState();
}

class _SigninState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    final appbarlength = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: appbarlength,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            SizedBox(height: 70),
            Center(
              child: Text(
                'Welcome back!',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,

              child: TextFormField(
                controller: emailcont,
                decoration: InputDecoration(
                  labelText: 'Email',

                  // contentPadding: EdgeInsets.only(left: 12),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.92,
            height: MediaQuery.of(context).size.height * 0.06,

            child: TextFormField(
              controller: passcontroller,
              decoration: InputDecoration(
                labelText: 'Password',

                contentPadding: EdgeInsets.only(left: 12),
              ),
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
                    const SnackBar(content: Text('Email ve şifre boş olamaz')),
                  );
                  return;
                }

                try {
                  await Provider.of<LoginProvider>(
                    context,
                    listen: false,
                  ).signIn(emailcont.text.trim(), passcontroller.text.trim());

                  if (!mounted) return;
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Giriş başarısız: $e')),
                  );
                }
              },

              child: const Text('Login', style: TextStyle(fontSize: 20)),
            ),
          ),

          SizedBox(height: 12),

          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: MediaQuery.of(context).size.height * 0.06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // zorunlu hale getiriyoruz
                backgroundColor: AppColors.lightGray,
              ),
              onPressed: () {
                context.router.push(const SigninRoute());
              },

              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 12),

          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: MediaQuery.of(context).size.height * 0.06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.white,
              ),
              onPressed: () => print('tıklandı'),
              child: Text(
                'Forget Password',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
