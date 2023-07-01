import 'package:database/database/user_db_controller.dart';
import 'package:database/extensions/context_extensions.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/process_response.dart';
import 'package:database/widgets/appTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController ;
  late TextEditingController _passwordController;
   late String _language  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _language = SharedPrefController().getValueFor<String>(Prefkeys.language.name)?? 'en';
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.login),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.login_title, style: GoogleFonts.cairo(
              fontSize: 28.sp ,
              fontWeight: FontWeight.w500
            ),),
            Text(AppLocalizations.of(context)!.login_subtitle, style: GoogleFonts.cairo(
                fontSize: 22.sp ,
                fontWeight: FontWeight.w300)),
            SizedBox(height: 20.h,),
            AppTextField( title: AppLocalizations.of(context)!.email, icon: Icons.email, textInputType: TextInputType.emailAddress, controller: _emailController,),
            SizedBox(height: 10.h,),
            AppTextField(title: AppLocalizations.of(context)!.password, icon: Icons.lock, obscure: true, textInputType: TextInputType.visiblePassword,controller:_passwordController,),
            SizedBox(height: 20.h,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity , 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),

              ),
                onPressed: (){_performLogin();},
                child:  Text(AppLocalizations.of(context)!.login))  ,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.localizations.do_not_have_an_account),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/register');
                }, child: Text(context.localizations.create))
              ],
            )

          ],
        ),
      ),
    );
  }
  void _performLogin(){
    if(_checkData())
      _login();
  }
  bool _checkData(){
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      return true;
    }
    return false;
  }
  void _login()async{
     ProcessResponse processResponse= await UserDbController().login(email: _emailController.text, password: _passwordController.text);
     if(processResponse.success){
       Navigator.pushReplacementNamed(context, '/home');
     context.showSnackBar(message: context.localizations.login_success);
     }
     if(!processResponse.success){
       context.showSnackBar(message: context.localizations.login_failed , error: true);
     }
  }

}

