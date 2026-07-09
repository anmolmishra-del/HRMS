import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class AtsLocalizations {
  /// Translates dynamic Odoo recruitment stages to localized names
  static String getStage(BuildContext context, String stageName) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return stageName;
    
    final lower = stageName.toLowerCase().trim();
    switch (lower) {
      case 'all':
        return l10n.tab_all;
      case 'new':
        return l10n.tab_new;
      case 'screening':
        return l10n.tab_screening;
      case 'first interview':
        return l10n.tab_first_interview;
      case 'second interview':
        return l10n.tab_second_interview;
      case 'offered':
        return l10n.tab_offered;
      case 'hired':
        return l10n.tab_hired;
      case 'refused':
        return l10n.tab_refused;
      case 'ij':
        return l10n.tab_ij;
      case 'hr stage':
        return l10n.tab_hr_stage;
      case 'contract proposal':
        return l10n.tab_contract_proposal;
      case 'contract signed':
        return l10n.tab_contract_signed;
      case 'published':
        return l10n.tab_published;
      case 'unpublished':
        return l10n.tab_unpublished;
      case 'ongoing':
        return l10n.tab_ongoing;
      default:
        return stageName;
    }
  }

  /// Translates general ATS detail pages UI text
  static String translate(BuildContext context, String text) {
    try {
      final locale = Localizations.localeOf(context).languageCode;
      if (locale == 'hi') {
        return _hi[text] ?? text;
      } else if (locale == 'te') {
        return _te[text] ?? text;
      }
    } catch (_) {}
    return text;
  }

  static const Map<String, String> _hi = {
    "Application Profile": "आवेदन प्रोफ़ाइल",
    "No Linked Position": "कोई लिंक नहीं",
    "Status": "स्थिति",
    "Stage": "चरण",
    "Availability": "उपलब्धता",
    "Not specified": "निर्दिष्ट नहीं",
    "Info": "जानकारी",
    "Details": "विवरण",
    "Additional Info": "अतिरिक्त जानकारी",
    "Notes & Comments": "टिप्पणियाँ",
    "Candidate Identity": "उम्मीदवार की पहचान",
    "Candidate Name": "उम्मीदवार का नाम",
    "Email Address": "ईमेल पता",
    "Phone Number": "फ़ोन नंबर",
    "LinkedIn Profile": "लिंक्डइन प्रोफाइल",
    "Not linked": "लिंक नहीं किया गया",
    "Salary details": "वेतन विवरण",
    "Current CTC": "वर्तमान सीटीसी",
    "Expected Salary": "अपेक्षित वेतन",
    "Proposed Salary": "प्रस्तावित वेतन",
    "Salary Negotiable": "वेतन पर बातचीत योग्य",
    "Yes": "हाँ",
    "No": "नहीं",
    "Experience details": "अनुभव विवरण",
    "Total Experience": "कुल अनुभव",
    "Relevant Experience": "प्रासंगिक अनुभव",
    "Notice Period": "नोटिस अवधि",
    "NP Negotiable": "नोटिस अवधि पर बातचीत योग्य",
    "Holding Offer": "होल्डिंग ऑफर",
    "Recruitment Assignments": "भर्ती असाइनमेंट",
    "Recruiter / Handler": "भर्तीकर्ता / हैंडलर",
    "Job Position": "नौकरी की स्थिति",
    "Experience Type": "अनुभव का प्रकार",
    "Company": "कंपनी",
    "Bio details": "बायो विवरण",
    "Gender": "लिंग",
    "Birthday": "जन्मदिन",
    "Blood Group": "रक्त समूह",
    "Marital Status": "वैवाहिक स्थिति",
    "Contact Addresses": "संपर्क पते",
    "Current Address": "वर्तमान पता",
    "Permanent Address": "स्थायी पता",
    "Applicant Comments": "आवेदक की टिप्पणियाँ",
    "Recruiter Comments": "भर्तीकर्ता की टिप्पणियाँ",
    "General Notes": "सामान्य नोट्स",
    "No records provided.": "कोई रिकॉर्ड प्रदान नहीं किया गया।",
    "Application Details": "आवेदन विवरण",
    "Applied On": "लागू किया गया",
    "Documents": "दस्तावेज़",
    "Applicants": "आवेदक",
    "Job Documents": "नौकरी के दस्तावेज़",
    "No documents found for this job position.": "इस नौकरी की स्थिति के लिए कोई दस्तावेज नहीं मिला।",
    "Primary Skills Required": "आवश्यक प्राथमिक कौशल",
    "Secondary Skills Required": "आवश्यक माध्यमिक कौशल",
    "Job Description": "नौकरी का विवरण",
    "Key Responsibilities": "मुख्य जिम्मेदारियां",
    "Job Requirements": "नौकरी की आवश्यकताएं",
    "Key Details": "मुख्य विवरण",
    "Published": "प्रकाशित",
    "Draft": "ड्राफ्ट",
    "Priority": "प्राथमिकता",
    "Not Spec": "निर्दिष्ट नहीं",
    "Minimum Requirements": "न्यूनतम आवश्यकताएं",
    "Job Directory Summary": "नौकरी निर्देशिका सारांश",
    "Department": "विभाग",
    "Experience Required": "आवश्यक अनुभव",
    "Budget / Salary": "बजट / वेतन",
    "Employment Type": "रोजगार का प्रकार",
    "Full-time": "पूर्णकालिक",
    "Candidate Profile": "उम्मीदवार प्रोफ़ाइल",
    "Contact & Bio": "संपर्क और बायो",
    "Skills & Meta": "कौशल और मेटा",
    "Primary Contact": "प्राथमिक संपर्क",
    "Mobile Phone": "मोबाइल फ़ोन",
    "Alternate Phone": "वैकल्पिक फ़ोन",
    "Not provided": "प्रदान नहीं किया गया",
    "Recruitment Information": "भर्ती की जानकारी",
    "Contact Partner Name": "संपर्क भागीدار का नाम",
    "Candidate Manager": "उम्मीदवार प्रबंधक",
    "Odoo Company": "ओडू कंपनी",
    "Candidate Status Info": "उम्मीदवार की स्थिति की जानकारी",
    "Availability Date": "उपलब्धता तिथि",
    "Recruitment Stage": "भर्ती चरण",
    "Odoo Skills List": "ओडू कौशल सूची",
    "No skills mapped for this candidate yet.": "इस उम्मीदवार के लिए अभी तक कोई कौशल मैप नहीं किया गया है।",
    "Download Resume": "बायोडाटा डाउनलोड करें",
    "Type": "प्रकार",
  };

  static const Map<String, String> _te = {
    "Application Profile": "దరఖాస్తు ప్రొఫైల్",
    "No Linked Position": "లింక్ చేయబడిన స్థానం లేదు",
    "Status": "స్థితి",
    "Stage": "దశ",
    "Availability": "అందుబాటు",
    "Not specified": "పేర్కొనబడలేదు",
    "Info": "సమాచారం",
    "Details": "వివరాలు",
    "Additional Info": "అదనపు సమాచారం",
    "Notes & Comments": "గమనికలు & వ్యాఖ్యలు",
    "Candidate Identity": "అభ్యర్థి గుర్తింపు",
    "Candidate Name": "అభ్యర్థి పేరు",
    "Email Address": "ఈమెయిల్ చిరునామా",
    "Phone Number": "ఫోన్ నంబర్",
    "LinkedIn Profile": "లింక్డ్ఇన్ ప్రొఫైల్",
    "Not linked": "లింక్ చేయబడలేదు",
    "Salary details": "జీతం వివరాలు",
    "Current CTC": "ప్రస్తుత CTC",
    "Expected Salary": "ఆశించిన జీతం",
    "Proposed Salary": "ప్రతిపాదిత జీతం",
    "Salary Negotiable": "జీతం చర్చించదగినది",
    "Yes": "అవును",
    "No": "కాదు",
    "Experience details": "అనుభవం వివరాలు",
    "Total Experience": "మొత్తం అనుభవం",
    "Relevant Experience": "సంబంధిత అనుభవం",
    "Notice Period": "నోటీసు వ్యవధి",
    "NP Negotiable": "NP చర్చించదగినది",
    "Holding Offer": "హోల్డింగ్ ఆఫర్",
    "Recruitment Assignments": "నియామక కేటాయింపులు",
    "Recruiter / Handler": "రిక్రూటర్ / హ్యాండ్లర్",
    "Job Position": "ఉద్యోగ హోదా",
    "Experience Type": "అనుభవం రకం",
    "Company": "కంపెనీ",
    "Bio details": "బయో వివరాలు",
    "Gender": "లింగం",
    "Birthday": "పుట్టినరోజు",
    "Blood Group": "రక్త గ్రూపు",
    "Marital Status": "వైవాహిక స్థితి",
    "Contact Addresses": "సంప్రదింపు చిరునామాలు",
    "Current Address": "ప్రస్తుత చిరునామా",
    "Permanent Address": "శాశ్వత చిరునామా",
    "Applicant Comments": "దరఖాస్తుదారు వ్యాఖ్యలు",
    "Recruiter Comments": "రిక్రూటర్ వ్యాఖ్యలు",
    "General Notes": "సాధారణ గమనికలు",
    "No records provided.": "ఎటువంటి రికార్డులు అందించబడలేదు.",
    "Application Details": "దరఖాస్తు వివరాలు",
    "Applied On": "దరఖాస్తు చేసిన తేదీ",
    "Documents": "పత్రాలు",
    "Applicants": "దరఖాస్తుదారులు",
    "Job Documents": "ఉద్యోగ పత్రాలు",
    "No documents found for this job position.": "ఈ ఉద్యోగ హోదా కోసం ఎటువంటి పత్రాలు కనుగొనబడలేదు.",
    "Primary Skills Required": "అవసరమైన ప్రాథమిక నైపుణ్యాలు",
    "Secondary Skills Required": "అవసరమైన ద్వితీయ నైపుణ్యాలు",
    "Job Description": "ఉద్యోగ వివరణ",
    "Key Responsibilities": "కీలక బాధ్యతలు",
    "Job Requirements": "ఉద్యోగ అవసరాలు",
    "Key Details": "కీలక వివరాలు",
    "Published": "ప్రచురించబడింది",
    "Draft": "డ్రాఫ్ట్",
    "Priority": "ప్రాధాన్యత",
    "Not Spec": "పేర్కొనబడలేదు",
    "Minimum Requirements": "కనిష్ట అవసరాలు",
    "Job Directory Summary": "ఉద్యోగ డైరెక్టరీ సారాంశం",
    "Department": "విభాగం",
    "Experience Required": "అవసరమైన అనుభవం",
    "Budget / Salary": "బడ్జెట్ / జీతం",
    "Employment Type": "ఉద్యోగ రకం",
    "Full-time": "పూర్తి సమయం",
    "Candidate Profile": "అభ్యర్థి ప్రొఫైల్",
    "Contact & Bio": "సంప్రదింపు & బయో",
    "Skills & Meta": "నైపుణ్యాలు & మెటా",
    "Primary Contact": "ప్రాథమిక సంప్రదింపు",
    "Mobile Phone": "మొబైల్ ఫోన్",
    "Alternate Phone": "ప్రత్యామ్నాయ ఫోన్",
    "Not provided": "అందించబడలేదు",
    "Recruitment Information": "నియామక సమాచారం",
    "Contact Partner Name": "సంప్రదింపు భాగస్వామి పేరు",
    "Candidate Manager": "అభ్యర్థి మేనేజర్",
    "Odoo Company": "Odoo కంపెనీ",
    "Candidate Status Info": "అభ్యర్థి స్థితి సమాచారం",
    "Availability Date": "అందుబాటులో ఉండే తేదీ",
    "Recruitment Stage": "నియామక దశ",
    "Odoo Skills List": "Odoo నైపుణ్యాల జాబితా",
    "No skills mapped for this candidate yet.": "ఈ అభ్యర్థికి ఇంకా నైపుణ్యాలు మ్యాప్ చేయబడలేదు.",
    "Download Resume": "రెజ్యూమ్ డౌన్‌లోడ్ చేయండి",
    "Type": "రకం",
  };
}
