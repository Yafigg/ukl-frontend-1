import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/matkul.dart';
import '../services/services.dart';

class MatkulPage extends StatefulWidget {
  const MatkulPage({super.key});

  @override
  State<MatkulPage> createState() => _MatkulPageState();
}

class _MatkulPageState extends State<MatkulPage> {
  final ApiService _apiService = ApiService();
  List<Matkul> _matkuls = [];
  final List<Matkul> _selectedMatkuls = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  int _totalSks = 0;

  @override
  void initState() {
    super.initState();
    _loadMatkuls();
  }

  Future<void> _loadMatkuls() async {
    setState(() => _isLoading = true);

    try {
      final matkuls = await _apiService.getMatkul();
      setState(() {
        _matkuls = matkuls;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load courses: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleMatkulSelection(Matkul matkul, bool isSelected) {
    setState(() {
      matkul.isSelected = isSelected;

      if (isSelected) {
        _selectedMatkuls.add(matkul);
      } else {
        _selectedMatkuls.removeWhere((item) => item.id == matkul.id);
      }

      _totalSks = _selectedMatkuls.fold(0, (sum, item) => sum + item.sks);
    });
  }

  Future<void> _submitSelectedMatkuls() async {
    if (_selectedMatkuls.isEmpty) {
      // Ganti SnackBar dengan dialog warning yang lebih jelas
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'No Courses Selected',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'Please select at least one course before submitting.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF032670),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actionsAlignment: MainAxisAlignment.center,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final matkulIds = _selectedMatkuls.map((matkul) => matkul.id).toList();
      final response = await _apiService.selectMatkul(matkulIds);

      if (!mounted) return;

      if (response['status'] == true) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success icon with green background
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF032670), // Green color
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),

                    // Success message
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            'Course Selection Successful',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You have selected ${_selectedMatkuls.length} courses with a total of $_totalSks SKS',
                            style: GoogleFonts.poppins(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF032670),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pop(context); // Return to profile
                              },
                              child: Text(
                                'Back to Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to select courses'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Select Courses',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF032670),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Header with instruction
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF032670),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Courses',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select the courses you want to take this semester',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Selected: ${_selectedMatkuls.length} courses',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Total SKS: $_totalSks',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // List of courses
                  Expanded(
                    child:
                        _matkuls.isEmpty
                            ? Center(
                              child: Text(
                                'No courses available',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: _matkuls.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final matkul = _matkuls[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CheckboxListTile(
                                      title: Text(
                                        matkul.namaMatkul,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${matkul.sks} SKS',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF032670),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      value: matkul.isSelected,
                                      onChanged: (bool? value) {
                                        _toggleMatkulSelection(
                                          matkul,
                                          value ?? false,
                                        );
                                      },
                                      activeColor: const Color(0xFF032670),
                                      checkColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      secondary: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          145,
                                          180,
                                          253,
                                        ).withOpacity(0.2),
                                        child: Text(
                                          '${index + 1}', // Nomor urut, dimulai dari 1
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF032670),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),

                  // Submit button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitSelectedMatkuls,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF032670),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 56),
                        disabledBackgroundColor: const Color(
                          0xFF032670,
                        ).withOpacity(0.6),
                      ),
                      child:
                          _isSubmitting
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                'SUBMIT SELECTION',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
    );
  }
}
