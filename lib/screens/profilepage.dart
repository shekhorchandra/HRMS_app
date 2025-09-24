import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ----- Profile Data -----
  // Overview
  final String branch = "QBitTech Head Office";
  final String empType = "Official";
  final String grade = "";
  final String reportingTo = "Mr. Arif Hossen";
  final String officialPhone = "";
  final String officialWhatsapp = "";
  final String officialEmail = "";
  final String noticeStart = "";
  final String noticeEnd = "";

  // Payroll
  final String weeklyHoliday = "Friday";
  final String shift = "Regular Shift";
  final String overtime = "No";
  final String salaryBy = "Cash";
  final String tin = "";
  final String joiningDate = "05 May 2025";
  final String joiningSalary = "";
  final String probationPeriod = "";
  final String probationStart = "";
  final String probationEnd = "";
  final String salaryType = "Regular";

  // Login
  final String username = "shekhor25";
  final String password = "********";

  // Projects
  final String project1 = "GrowUp 1.0.13";
  final String project2 = "HRMS 1.0.0";

  // About
  final String empId = "EM25-17";
  final String gender = "Male";
  final String religion = "Hinduism";
  final String bloodGroup = "O+";
  final String mobile = "01736457478";
  final String email = "tonoysaha46@gmail.com";
  final String location = "18, Block-D, Road-6, Banasree, Dhaka";
  final String designationname = "Mr. Shekhor Chandra Saha";
  final String designation = "Junior App Developer, Development & Engineering";
  final String department = "Development & Engineering";
  final String birthdate = "28 Nov 1999";

  // Work Experience
  final String company = "Qbittech";
  final String jobPosition = "Junior App Developer";
  final String workDepartment = "Development & Engineering";
  final String responsibilities = "Research and Development";
  final String duration = "1 Year";

  // Professional Training
  final String organization = "Creative It";
  final String courseTitle = "Flutter";
  final String courseType = "App Development";
  final String durationTraining = "2 years";
  final String resultTraining = "First Class";
  final String yearTraining = "2022-2024";

  // Educational Qualification
  final String experience = "N/A";
  final String training = "N/A";
  final String education = "Bsc in CSE";
  final String institution = "East West University";
  final String board = "Dhaka";
  final String group = "Computer Science & Engineering (CSE)";
  final String passingYear = "2022";
  final String result = "3.16";

  // References
  final String referenceName = "Arif Hossen";
  final String referenceRelation = "Brother";
  final String referenceContact = "01601958560";
  final String referenceAddress = "Dhonia,Jatrabari";

  // Granter
  final String granterName = "Mukul Chandra Shaha";
  final String granterRelation = "Father";
  final String granterContact = "01736457478";
  final String granterAddress = "Main bazar,Mohadebpur,Naogaon";

  // ----- Helper Widgets -----
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(flex: 5, child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: children,
      ),
    );
  }

  double getProfileCompletion() {
    List<String> fields = [
      branch, empType, grade, reportingTo, officialPhone, officialWhatsapp, officialEmail, noticeStart, noticeEnd,
      weeklyHoliday, shift, overtime, salaryBy, tin, joiningDate, joiningSalary, probationPeriod, probationStart, probationEnd, salaryType,
      username, password, project1, project2, empId, gender, religion, bloodGroup, mobile, email, location, designationname, designation, department, birthdate,
      company, jobPosition, workDepartment, responsibilities, duration,
      organization, courseTitle, courseType, durationTraining, resultTraining, yearTraining,
      experience, training, education, institution, board, group, passingYear, result,
      referenceName, referenceRelation, referenceContact, referenceAddress,
      granterName, granterRelation, granterContact, granterAddress,
    ];
    int filled = fields.where((f) => f.trim().isNotEmpty && f.trim() != "N/A").length;
    return filled / fields.length;
  }

  // ----- PDF Download Function -----
  Future<void> _downloadProfilePdf(BuildContext context) async {
    final pdf = pw.Document();

    // Load profile image
    final Uint8List profileImageBytes = await rootBundle
        .load('assets/images/img.png')
        .then((data) => data.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            margin: const pw.EdgeInsets.only(bottom: 16),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Profile Header
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Container(
                        width: 100,
                        height: 100,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          image: pw.DecorationImage(
                            image: pw.MemoryImage(profileImageBytes),
                            fit: pw.BoxFit.cover,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        "Employee Profile",
                        style: pw.TextStyle(
                          fontSize: 24,
                          color: PdfColor.fromInt(0xFF0000FF),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(designationname, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text(designation),
                      pw.SizedBox(height: 8),
                      pw.Text("Phone: $mobile", style: pw.TextStyle(color: PdfColor.fromInt(0xFF808080))),
                      pw.Text("Email: $email", style: pw.TextStyle(color: PdfColor.fromInt(0xFF808080))),
                      pw.Text("Address: $location", style: pw.TextStyle(color: PdfColor.fromInt(0xFF808080))),
                    ],
                  ),
                ),
                pw.Divider(height: 24, thickness: 1, color: PdfColors.grey300),

                // Overview
                pw.Text("Overview (Official Info)", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Branch", branch),
                _pdfRow("Employee Type", empType),
                _pdfRow("Grade", grade),
                _pdfRow("Reporting To", reportingTo),
                _pdfRow("Official Phone", officialPhone),
                _pdfRow("Official Whatsapp", officialWhatsapp),
                _pdfRow("Official Email", officialEmail),
                _pdfRow("Notice Start", noticeStart),
                _pdfRow("Notice End", noticeEnd),
                pw.SizedBox(height: 12),

                // Payroll
                pw.Text("Payroll", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Weekly Holiday", weeklyHoliday),
                _pdfRow("Shift", shift),
                _pdfRow("Overtime Enable", overtime),
                _pdfRow("Salary Payment By", salaryBy),
                _pdfRow("TIN Number", tin),
                _pdfRow("Joining Date", joiningDate),
                _pdfRow("Joining Salary", joiningSalary),
                _pdfRow("Probation Period", probationPeriod),
                _pdfRow("Probation Start", probationStart),
                _pdfRow("Probation End", probationEnd),
                _pdfRow("Salary Type", salaryType),
                pw.SizedBox(height: 12),

                // Login Credentials
                pw.Text("Login Credentials", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Username", username),
                _pdfRow("Password", password),
                pw.SizedBox(height: 12),

                // Projects
                pw.Text("Assign Project", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Project 1", project1),
                _pdfRow("Project 2", project2),
                pw.SizedBox(height: 12),

                // About
                pw.Text("About", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Employee ID", empId),
                _pdfRow("Gender", gender),
                _pdfRow("Religion", religion),
                _pdfRow("Blood Group", bloodGroup),
                _pdfRow("Mobile", mobile),
                _pdfRow("Email", email),
                _pdfRow("Location", location),
                _pdfRow("Designation", designation),
                _pdfRow("Department", department),
                _pdfRow("Date of Birth", birthdate),
                pw.SizedBox(height: 12),

                // Work Experience
                pw.Text("Work Experience", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Company", company),
                _pdfRow("Job Position", jobPosition),
                _pdfRow("Department", workDepartment),
                _pdfRow("Responsibilities", responsibilities),
                _pdfRow("Duration", duration),
                pw.SizedBox(height: 12),

                // Professional Training
                pw.Text("Professional Training", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Organization", organization),
                _pdfRow("Course Title", courseTitle),
                _pdfRow("Course Type", courseType),
                _pdfRow("Duration", durationTraining),
                _pdfRow("Result", resultTraining),
                _pdfRow("Year", yearTraining),
                pw.SizedBox(height: 12),

                // Educational Qualification
                pw.Text("Educational Qualification", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Education", education),
                _pdfRow("Institution", institution),
                _pdfRow("Board", board),
                _pdfRow("Group", group),
                _pdfRow("Passing Year", passingYear),
                _pdfRow("Result", result),
                pw.SizedBox(height: 12),

                // References
                pw.Text("Reference Information", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Name", referenceName),
                _pdfRow("Relation", referenceRelation),
                _pdfRow("Contact", referenceContact),
                _pdfRow("Address", referenceAddress),
                pw.SizedBox(height: 12),

                // Granter
                pw.Text("Granter Information", style: pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xFF0000FF), fontWeight: pw.FontWeight.bold)),
                _pdfRow("Name", granterName),
                _pdfRow("Relation", granterRelation),
                _pdfRow("Contact", granterContact),
                _pdfRow("Address", granterAddress),
              ],
            ),
          ),
        ],
      ),
    );

    // Save in Documents/HRMS folder
    Directory? directory = await getExternalStorageDirectory();
    String newPath = "";
    List<String> paths = directory!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      if (paths[x] == "Android") break;
      newPath += "/" + paths[x];
    }
    newPath += "/Documents/HRMS";

    final hrmsDir = Directory(newPath);
    if (!await hrmsDir.exists()) await hrmsDir.create(recursive: true);

    final file = File("${hrmsDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile PDF saved to Documents/HRMS folder")),
    );
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double completion = getProfileCompletion();
    int completionPercent = (completion * 100).toInt(); // Convert to percentage number

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'),
          foregroundColor: Colors.white,
          centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 8.0,
              percent: completion,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/img.png'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$completionPercent%", // Display numeric percentage
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              progressColor: Colors.blue,
              // backgroundColor: Colors.grey[300]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 12),
            Text(designationname, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(designation, style: const TextStyle(color: Colors.grey)),
            Text(location, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            // All Sections
            _buildSection("Overview (Official Info)", [
              _buildRow("Branch", branch),
              _buildRow("Employee Type", empType),
              _buildRow("Grade", grade),
              _buildRow("Reporting To", reportingTo),
              _buildRow("Official Phone", officialPhone),
              _buildRow("Official Whatsapp", officialWhatsapp),
              _buildRow("Official Email", officialEmail),
              _buildRow("Notice Start", noticeStart),
              _buildRow("Notice End", noticeEnd),
            ]),

            _buildSection("Payroll", [
              _buildRow("Weekly Holiday", weeklyHoliday),
              _buildRow("Shift", shift),
              _buildRow("Overtime Enable", overtime),
              _buildRow("Salary Payment By", salaryBy),
              _buildRow("TIN Number", tin),
              _buildRow("Joining Date", joiningDate),
              _buildRow("Joining Salary", joiningSalary),
              _buildRow("Probation Period", probationPeriod),
              _buildRow("Probation Start", probationStart),
              _buildRow("Probation End", probationEnd),
              _buildRow("Salary Type", salaryType),
            ]),

            _buildSection("Login Credentials", [
              _buildRow("Username", username),
              _buildRow("Password", password),
            ]),

            _buildSection("Assign Project", [
              _buildRow("Project 1", project1),
              _buildRow("Project 2", project2),
            ]),

            _buildSection("About", [
              _buildRow("Employee ID", empId),
              _buildRow("Gender", gender),
              _buildRow("Religion", religion),
              _buildRow("Blood Group", bloodGroup),
              _buildRow("Mobile", mobile),
              _buildRow("Email", email),
              _buildRow("Location", location),
              _buildRow("Designation", designation),
              _buildRow("Department", department),
              _buildRow("Date of Birth", birthdate),
            ]),

            _buildSection("Qualifications", [
              ExpansionTile(
                title: const Text("Work Experience", style: TextStyle(fontWeight: FontWeight.w600)),
                children: [
                  _buildRow("Company", company),
                  _buildRow("Job Position", jobPosition),
                  _buildRow("Department", workDepartment),
                  _buildRow("Responsibilities", responsibilities),
                  _buildRow("Duration", duration),
                ],
              ),
              ExpansionTile(
                title: const Text("Professional Training", style: TextStyle(fontWeight: FontWeight.w600)),
                children: [
                  _buildRow("Organization", organization),
                  _buildRow("Course Title", courseTitle),
                  _buildRow("Course Type", courseType),
                  _buildRow("Duration", durationTraining),
                  _buildRow("Result", resultTraining),
                  _buildRow("Year", yearTraining),
                ],
              ),
              ExpansionTile(
                title: const Text("Educational Qualification", style: TextStyle(fontWeight: FontWeight.w600)),
                children: [
                  _buildRow("Education", education),
                  _buildRow("Institution", institution),
                  _buildRow("Board", board),
                  _buildRow("Group", group),
                  _buildRow("Passing Year", passingYear),
                  _buildRow("Result", result),
                ],
              ),
            ]),

            _buildSection("Connections", [
              ExpansionTile(
                title: const Text("Reference", style: TextStyle(fontWeight: FontWeight.w600)),
                children: [
                  _buildRow("Name", referenceName),
                  _buildRow("Relation", referenceRelation),
                  _buildRow("Contact", referenceContact),
                  _buildRow("Address", referenceAddress),
                ],
              ),
              ExpansionTile(
                title: const Text("Granter", style: TextStyle(fontWeight: FontWeight.w600)),
                children: [
                  _buildRow("Name", granterName),
                  _buildRow("Relation", granterRelation),
                  _buildRow("Contact", granterContact),
                  _buildRow("Address", granterAddress),
                ],
              ),
            ]),

            _buildSection("Documents", [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("Profile of $designationname", style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.blue),
                      onPressed: () => _downloadProfilePdf(context),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
