import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yutaa_partner_app/theme/app_theme.dart';
import 'package:yutaa_partner_app/core/api/api_client.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Personal Details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  // Professional Info
  String? _selectedCategory;
  double _experienceLevel = 1.0; // 1 to 10 years
  final TextEditingController _bioController = TextEditingController();

  // KYC
  String? _selectedIdType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yutaa Partner',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Service Provider Registration',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Progress
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8A2BE2), // Lighter purple / distinct shade
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registration Progress',
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              '0/3 Sections',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          child: Text(
                            '0%',
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.05,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section 1: Personal Details
            _buildSectionCard(
              index: 1,
              title: "Personal Details",
              subtitle: "Your basic information",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Profile Photo *"),
                  const SizedBox(height: 8),
                  _buildPhotoUploadArea("Tap to upload", "Professional headshot recommended"),
                  const SizedBox(height: 20),
                  _buildLabel("Full Name *"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: "Enter your full name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("Phone Number *"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade100),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green.shade50.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                         Icon(Icons.phone_outlined, color: Colors.grey.shade600, size: 20),
                         const SizedBox(width: 12),
                         Text(
                           "+91 1234567890", // Mock
                           style: GoogleFonts.poppins(fontSize: 16),
                         ),
                         const Spacer(),
                         const Icon(Icons.check_circle_outline, color: Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                   Row(
                     children: [
                       const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                       const SizedBox(width: 4),
                       Text("Phone verified", style: GoogleFonts.poppins(color: Colors.green, fontSize: 13)),
                     ],
                   ),
                   const SizedBox(height: 20),

                   _buildLabel("Email Address"),
                   const SizedBox(height: 8),
                   _buildTextField(
                     controller: _emailController,
                     hint: "your.email@example.com",
                     icon: Icons.email_outlined,
                   ),
                   const SizedBox(height: 6),
                   Text(
                     "Optional - for account recovery",
                     style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                   ),
                ],
              ),
            ),

            // Section 2: Professional Info
             _buildSectionCard(
              index: 2,
              title: "Professional Info",
              subtitle: "Tell us about your expertise",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Service Category *"),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Select your primary service"),
                    value: _selectedCategory,
                    items: ["Plumbing", "Cleaning", "Electrical", "Beauty"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), 
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("Experience Level *"),
                  const SizedBox(height: 12),
                  // Slider UI mock
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.primaryPurple,
                      thumbColor: AppTheme.primaryPurple,
                      inactiveTrackColor: Colors.grey.shade200,
                    ),
                    child: Slider(
                      value: _experienceLevel, 
                      min: 1, max: 10,
                      divisions: 9,
                      label: "${_experienceLevel.toInt()} Year(s)",
                      onChanged: (val) => setState(() => _experienceLevel = val),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("1 Year", style: GoogleFonts.poppins(color: Colors.grey)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(color: AppTheme.primaryPurple, borderRadius: BorderRadius.circular(20)),
                        child: Text("${_experienceLevel.toInt()} Year", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Text("10+ Years", style: GoogleFonts.poppins(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("Short Bio *"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: _inputDecoration("Tell customers about your expertise...").copyWith(
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),

            // Section 3: KYC
            _buildSectionCard(
              index: 3,
              title: "Identity Verification (KYC)",
              subtitle: "Help us verify your identity",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildLabel("Government ID Type *"),
                   const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Select ID type"),
                    value: _selectedIdType,
                    items: ["Aadhaar Card", "PAN Card", "Driving License"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), 
                    onChanged: (v) => setState(() => _selectedIdType = v),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildLabel("Upload Front of ID *"),
                  const SizedBox(height: 8),
                  _buildPhotoUploadArea("Tap to upload", "Clear photo of ID front", icon: Icons.description_outlined),
                  const SizedBox(height: 20),
                  
                  _buildLabel("Upload Back of ID *"),
                  const SizedBox(height: 8),
                  _buildPhotoUploadArea("Tap to upload", "Clear photo of ID back", icon: Icons.description_outlined),
                ],
              ),
            ),


            
            // Footer Warning & Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 20),
                        const SizedBox(width: 8),
                        Text("Complete all required fields to submit", style: GoogleFonts.poppins(color: Colors.amber.shade900, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                         // Submit registration data to backend
                         if (_nameController.text.trim().isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name')));
                           return;
                         }
                         try {
                           final apiClient = ApiClient();
                           await apiClient.updateProfile(
                             name: _nameController.text.trim(),
                             email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
                             serviceCategory: _selectedCategory,
                             experienceYears: _experienceLevel.toInt(),
                             bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
                           );
                           if (context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Successful!')));
                             context.go('/dashboard');
                           }
                         } catch (e) {
                           if (context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                           }
                         }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300, // Disabled look initially
                        foregroundColor: Colors.grey.shade600,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline),
                          const SizedBox(width: 8),
                          Text("Submit Registration", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required int index, required String title, required String subtitle, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.person_outline, color: Colors.white), // Dynamic icon based on index?
                      Positioned(
                        right: -8, top: -8,
                        child: Container(
                           padding: const EdgeInsets.all(4),
                           decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                           child: Text('$index', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text.replaceAll('*', ''),
        style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
        children: [
          if (text.contains('*'))
            const TextSpan(text: ' *', style: TextStyle(color: AppTheme.primaryPurple)),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, IconData? icon}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint, icon: icon),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // await picker.pickImage(source: ImageSource.gallery);
    // Logic to verify permission and pick image
  }

  Widget _buildPhotoUploadArea(String mainText, String subText, {IconData icon = Icons.image_outlined}) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid), // Dashed border needs custom painter or package, simple border for now
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primaryPurple, size: 32),
              ),
              const SizedBox(height: 12),
              Text(mainText, style: GoogleFonts.poppins(color: AppTheme.primaryPurple, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subText, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              const Icon(Icons.upload_rounded, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppTheme.primaryPurple)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
