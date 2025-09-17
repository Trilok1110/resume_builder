import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/personal_info.dart';
import '../providers/resume_provider.dart';
import '../widgets/custom_text_field.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ResumeProvider>(context, listen: false);
      if (provider.personalInfo != null) {
        _nameController.text = provider.personalInfo!.name;
        _phoneController.text = provider.personalInfo!.phone;
        _emailController.text = provider.personalInfo!.email;
        _addressController.text = provider.personalInfo!.address;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Name',
                controller: _nameController,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              CustomTextField(label: 'Email', controller: _emailController),
              CustomTextField(label: 'Phone', controller: _phoneController),
              CustomTextField(label: 'Address', controller: _addressController),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ResumeProvider>(context, listen: false);
      final info = PersonalInfo(
        id: provider.personalInfo?.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      );
      provider.savePersonalInfo(info);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
_addressController.dispose() ;
_emailController.dispose();
_phoneController.dispose();
super.dispose();
  }
}