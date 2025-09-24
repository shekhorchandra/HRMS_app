import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadDocumentsPage extends StatefulWidget {
  const UploadDocumentsPage({super.key});

  @override
  State<UploadDocumentsPage> createState() => _UploadDocumentsPageState();
}

class _UploadDocumentsPageState extends State<UploadDocumentsPage> {
  String? profilePicture;
  String? signature;
  String? nidFront;
  String? nidBack;
  String? cv;
  String? tradeLicence;
  String? vat;
  String? tax;
  String? gongPicture;
  List<Map<String, String>> otherDocuments = [];

  Future<void> _pickSingleDocument(Function(String) onSelected) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty && result.files.first.path != null) {
      onSelected(result.files.first.path!);
    }
  }

  Future<void> _pickMultipleDocuments() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        for (var file in result.files) {
          if (file.path != null) {
            otherDocuments.add({"name": file.name, "path": file.path!});
          }
        }
      });
    }
  }

  void _downloadDocument(String path) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Downloading file from $path")),
    );
  }

  void _downloadAllDocuments() {
    final allDocs = [
      profilePicture,
      signature,
      nidFront,
      nidBack,
      cv,
      tradeLicence,
      vat,
      tax,
      gongPicture,
      ...otherDocuments.map((e) => e["path"])
    ].whereType<String>().toList();

    if (allDocs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No documents to download.")),
      );
      return;
    }

    for (var path in allDocs) {
      _downloadDocument(path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Downloading all documents...")),
    );
  }

  Widget _buildUploadTile(String title, String? path, VoidCallback onUpload) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.upload_file, size: 30, color: Colors.blue),
        title: Text(title),
        subtitle: path != null ? Text(path.split('/').last) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (path != null)
              IconButton(
                icon: const Icon(Icons.download, color: Colors.green),
                onPressed: () => _downloadDocument(path),
              ),
            IconButton(
              icon: Icon(path != null ? Icons.edit : Icons.add, color: Colors.blue),
              onPressed: onUpload,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherDocs() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ExpansionTile(
        leading: const Icon(Icons.folder, color: Colors.orange),
        title: const Text("Other Documents"),
        children: [
          ...otherDocuments.map((doc) => ListTile(
            title: Text(doc["name"] ?? "Unknown"),
            trailing: IconButton(
              icon: const Icon(Icons.download, color: Colors.green),
              onPressed: () => _downloadDocument(doc["path"]!),
            ),
          )),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.blue),
            title: const Text("Add More"),
            onTap: _pickMultipleDocuments,
          )
        ],
      ),
    );
  }

  void _submitDocuments() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Documents submitted successfully!")),
    );
  }

  void _cancelUpload() {
    setState(() {
      profilePicture = null;
      signature = null;
      nidFront = null;
      nidBack = null;
      cv = null;
      tradeLicence = null;
      vat = null;
      tax = null;
      gongPicture = null;
      otherDocuments.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Uploads canceled.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Documents"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline, size: 30),
            tooltip: "Download All",
            onPressed: _downloadAllDocuments,
          )
        ],
      ),
      body: ListView(
        children: [
          _buildUploadTile("Profile Picture", profilePicture, () {
            _pickSingleDocument((path) => setState(() => profilePicture = path));
          }),
          _buildUploadTile("Signature", signature, () {
            _pickSingleDocument((path) => setState(() => signature = path));
          }),
          _buildUploadTile("NID Card Front", nidFront, () {
            _pickSingleDocument((path) => setState(() => nidFront = path));
          }),
          _buildUploadTile("NID Card Back", nidBack, () {
            _pickSingleDocument((path) => setState(() => nidBack = path));
          }),
          _buildUploadTile("CV", cv, () {
            _pickSingleDocument((path) => setState(() => cv = path));
          }),
          _buildUploadTile("Trade Licence", tradeLicence, () {
            _pickSingleDocument((path) => setState(() => tradeLicence = path));
          }),
          _buildUploadTile("VAT", vat, () {
            _pickSingleDocument((path) => setState(() => vat = path));
          }),
          _buildUploadTile("TAX", tax, () {
            _pickSingleDocument((path) => setState(() => tax = path));
          }),
          _buildUploadTile("Gong Picture", gongPicture, () {
            _pickSingleDocument((path) => setState(() => gongPicture = path));
          }),
          _buildOtherDocs(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _cancelUpload,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _submitDocuments,
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
