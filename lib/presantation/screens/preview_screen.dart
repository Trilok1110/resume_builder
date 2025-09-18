import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../providers/resume_provider.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  pw.Widget _pdfSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfCard(pw.Widget child) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 6),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Future<File> _exportPdf(BuildContext context) async {
    final provider = Provider.of<ResumeProvider>(context, listen: false);
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Personal Info
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(provider.personalInfo?.name ?? "",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(provider.personalInfo?.email ?? ""),
                  if ((provider.personalInfo?.email ?? "").isNotEmpty) pw.Text("  |  "),
                  pw.Text(provider.personalInfo?.phone ?? ""),
                ],
              ),
              if ((provider.personalInfo?.address ?? "").isNotEmpty)
                pw.Text(provider.personalInfo!.address),
            ],
          ),
          pw.Divider(),

          // Education
          if (provider.educationList.isNotEmpty) ...[
            _pdfSectionTitle("Education"),
            ...provider.educationList.map(
                  (edu) => _pdfCard(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(edu.degree,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(edu.school),
                    pw.Text("Year: ${edu.year}"),
                  ],
                ),
              ),
            ),
          ],

          // Experience
          if (provider.experienceList.isNotEmpty) ...[
            _pdfSectionTitle("Experience"),
            ...provider.experienceList.map(
                  (exp) => _pdfCard(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(exp.job,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(exp.company),
                    pw.Text(exp.duration),
                    if (exp.description.isNotEmpty) pw.Text(exp.description),
                  ],
                ),
              ),
            ),
          ],

          // Projects
          if (provider.projectsList.isNotEmpty) ...[
            _pdfSectionTitle("Projects"),
            ...provider.projectsList.map(
                  (proj) => _pdfCard(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(proj.title,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Tech: ${proj.techStack}"),
                    if (proj.description.isNotEmpty) pw.Text(proj.description),
                  ],
                ),
              ),
            ),
          ],

          // Skills
          if (provider.skillsList.isNotEmpty) ...[
            _pdfSectionTitle("Skills"),
            pw.Wrap(
              spacing: 8,
              runSpacing: 6,
              children: provider.skillsList
                  .map(
                    (s) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Text("${s.name} (${s.level})"),
                ),
              )
                  .toList(),
            ),
          ],
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/resume.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, size: 28),
            onPressed: () async {
              final file = await _exportPdf(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PDF saved at: ${file.path}')),
              );
            },
          ),
        ],
      ),
      body: Consumer<ResumeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Info
                if (provider.personalInfo != null) ...[
                  Center(
                    child: Column(
                      children: [
                        Text(
                          provider.personalInfo!.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.email, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(provider.personalInfo!.email),
                            const SizedBox(width: 12),
                            const Icon(Icons.phone, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(provider.personalInfo!.phone),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(provider.personalInfo!.address,
                            style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1.2),
                ],

                // Education
                if (provider.educationList.isNotEmpty) ...[
                  _buildSectionTitle("Education"),
                  ...provider.educationList.map(
                        (edu) => _buildCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(edu.degree,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(edu.school),
                          Text("Year: ${edu.year}"),
                        ],
                      ),
                    ),
                  ),
                ],

                // Experience
                if (provider.experienceList.isNotEmpty) ...[
                  _buildSectionTitle("Experience"),
                  ...provider.experienceList.map(
                        (exp) => _buildCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.job,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(exp.company),
                          Text(exp.duration),
                          if (exp.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(exp.description),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Projects
                if (provider.projectsList.isNotEmpty) ...[
                  _buildSectionTitle("Projects"),
                  ...provider.projectsList.map(
                        (proj) => _buildCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(proj.title,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text("Tech: ${proj.techStack}"),
                          if (proj.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(proj.description),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Skills
                if (provider.skillsList.isNotEmpty) ...[
                  _buildSectionTitle("Skills"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.skillsList
                        .map(
                          (skill) => Chip(
                        label: Text("${skill.name} (${skill.level})"),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    )
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
