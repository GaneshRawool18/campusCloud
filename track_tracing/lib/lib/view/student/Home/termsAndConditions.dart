import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsPage extends StatefulWidget {
  const TermsConditionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainTermsConditionsPage();
}

class _MainTermsConditionsPage extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,

        // arrow back icon
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text(
          "Terms & Conditions",
          style: GoogleFonts.jost(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Condition & Attending",
                style: GoogleFonts.jost(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "1] Acceptable Use and Compliance: By using Online, you consent to the collection, processing, and limited sharing of your information with third parties necessary for service improvement and maintenance. Personal information will not be used for marketing purposes unless you provide explicit consent. For more details, please review our complete Privacy Policy.\n\n2]Privacy and Data Usage: We value your privacy and handle your data in accordance with our Privacy Policy. By using [Your VoIP Software Name], you consent to the collection, processing, and limited sharing of your information with third parties necessary for service improvement and maintenance. Personal information will not be used for marketing purposes unless you provide explicit consent. For more details, please review our complete Privacy Policy.",
                style: GoogleFonts.mulish(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Terms & Use",
                style: GoogleFonts.jost(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Ut proverbia non nulla veriora sint quam vestra dogmata. Tamen aberramus a proposito, et, ne longius, prorsus, inquam, Piso, si ista mala sunt, placet. Omnes enim iucundum motum, quo sensus hilaretur. Cum id fugiunt, re eadem defendunt, quae Peripatetici, verba. Quibusnam praeteritis? Portenta haec esse dicit, quidem hactenus; Si id dicis, vicimus. Qui ita affectus, beatum esse numquam probabis; Igitur neque stultorum quisquam beatus neque sapientium non beatus.\n\n"
                "Dicam, inquam, et quidem discendi causa magis, quam quo te aut Epicurum reprehensum velim. Dolor ergo, id est summum malum, metuetur semper, etiamsi non ader.",
                style: GoogleFonts.mulish(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
