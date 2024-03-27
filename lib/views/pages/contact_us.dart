import 'package:flutter/material.dart';

import '../../resources/constants/app_constants.dart';
import '../../services/utils.dart';
import '../atoms/primary_button.dart';
import '../molecules/default_text_field.dart';

class ContactusPage extends StatefulWidget {
  const ContactusPage({super.key});

  @override
  State<ContactusPage> createState() => _ContactusPageState();
}

class _ContactusPageState extends State<ContactusPage> {
  final TextEditingController _emailTxtCont = TextEditingController();
  final TextEditingController _nameTxtCont = TextEditingController();
  final TextEditingController _subjectTxtCont = TextEditingController();
  final TextEditingController _messageTxtCont = TextEditingController();
  final GlobalKey<FormState> _contactKey =
      GlobalKey<FormState>(debugLabel: "contact_us_key");

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailTxtCont.clear();
    _nameTxtCont.clear();
    _subjectTxtCont.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: kDefaultPagePadding,
          child: Form(
            key: _contactKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: <Widget>[
              const Row(
                children: <Widget>[
                  Flexible(
                      child: Text(
                          "Please feel free to contact me whenever needed.")),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              DefaultTextField(
                controller: _nameTxtCont,
                bottomPadding: 16,
                label: "Your Name",
              ),
              DefaultTextField(
                controller: _emailTxtCont,
                bottomPadding: 16,
                label: "Your Email",
              ),
              DefaultTextField(
                controller: _subjectTxtCont,
                bottomPadding: 16,
                label: "Subject",
              ),
              DefaultTextField(
                controller: _messageTxtCont,
                bottomPadding: 16,
                label: "Message",
                maxLines: 10,
              ),
              const SizedBox(
                height: 16,
              ),
              BorderedButton(
                label: "Send Message",
                action: () async {
                  // String username = 'username@gmail.com';
                  // String password = 'password';

                  // final smtpServer = SmtpServer(username, password);
                  Utils.sendEmail("dr.a.aglan@gmail.com",
                      message:
                          "Name: ${_nameTxtCont.text}\n\n ${_messageTxtCont.text}",
                      subject: _subjectTxtCont.text);
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
