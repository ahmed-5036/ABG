import 'package:flutter/material.dart';

import '../../resources/constants/app_constants.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/string_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.aboutUs),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: kDefaultPagePadding,
          child: Column(children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            const Text(StringConstants.drAglanTitleDesc),
            const SizedBox(
              height: 16,
            ),
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return constraints.maxWidth > 750
                  ? const WideAboutDetails()
                  : const NarrowAboutDetails();
            })
          ]),
        ),
      ),
    );
  }
}

class NarrowAboutDetails extends StatelessWidget {
  const NarrowAboutDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      children: <Widget>[
        Image.asset(
          AppImages.profile,
          width: size.width * 0.50,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Professor Emeritus & Author",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.deepPurple[900], fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "Author of multiple books, of mechnical ventilation, and critical care.",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
            width: size.width * 0.5,
            child: const Text("Website: www.AhmedAglan.com")),
        const SizedBox(
          height: 8,
        ),
        SizedBox(width: size.width * 0.5, child: const Text("Degree: MD")),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            width: size.width * 0.5,
            child: const Text("Phone: +(20)127385959")),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            width: size.width * 0.5,
            child: const Text("Email: dr.a.aglan@gmail.com")),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            width: size.width * 0.5,
            child: const Text("City: Alexandria, Egypt")),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            width: size.width * 0.5,
            child: const Text("Department: Critical Care")),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            width: size.width * 0.9,
            child: const Text(
                "This is official website of Dr. Ahmed Aglan, where it's one stop destination for all books, videos, apps and protocols that support GPs and critical care doctors for getting their hands on."))
      ],
    );
  }
}

class WideAboutDetails extends StatelessWidget {
  const WideAboutDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          AppImages.profile,
          width: size.width * 0.30,
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Professor Emeritus & Author",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.deepPurple[900], fontWeight: FontWeight.bold),
            ),
            Text(
              "Author of multiple books, of mechnical ventilation, and critical care.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 50,
              width: size.width * 0.61,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      width: size.width * 0.3,
                      child: const Text("Website: www.AhmedAglan.com")),
                  SizedBox(
                      width: size.width * 0.3, child: const Text("Degree: MD"))
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: size.width * 0.61,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      width: size.width * 0.3,
                      child: const Text("Phone: +(20)127385959")),
                  SizedBox(
                      width: size.width * 0.3,
                      child: const Text("Email: dr.a.aglan@gmail.com"))
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: size.width * 0.61,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      width: size.width * 0.3,
                      child: const Text("City: Alexandria, Egypt")),
                  SizedBox(
                      width: size.width * 0.3,
                      child: const Text("Department: Critical Care"))
                ],
              ),
            ),
            SizedBox(
                width: size.width * 0.6,
                child: const Text(
                    "This is official website of Dr. Ahmed Aglan, where it's one stop destination for all books, videos, apps and protocols that support GPs and critical care doctors for getting their hands on."))
          ],
        )
      ],
    );
  }
}
