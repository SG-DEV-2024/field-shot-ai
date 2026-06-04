import 'dart:io';
import 'package:ai_camera/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_camera/pages/data_input/data_input_controller.dart';

class DataInputPage extends StatelessWidget {
  const DataInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DataInputController());

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotoPreview(ctrl),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '액정에 표시된 수치를 입력해주세요',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          _buildValueInput(ctrl),
                          const SizedBox(height: 20),
                          const Text(
                            '비고 (선택)',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          _buildNoteInput(ctrl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(ctrl),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(DataInputController ctrl) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          color: Colors.grey[200],
          child: ctrl.photoPath.isEmpty
              ? Center(
                  child: Text(
                    '[ 촬영된 2x 줌 사진 영역 ]',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                )
              : Image.file(File(ctrl.photoPath), fit: BoxFit.cover, alignment: Alignment.center),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: GestureDetector(
            onTap: ctrl.openPhotoViewer,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValueInput(DataInputController ctrl) {
    return TextField(
      controller: ctrl.valueController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: '0.00',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 24),
        suffixText: 'mm',
        suffixStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue800, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue800, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildNoteInput(DataInputController ctrl) {
    return TextField(
      controller: ctrl.noteController,
      maxLines: 4,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: '특이사항이나 메모를 입력하세요...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.blue800, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }

  Widget _buildBottomButtons(DataInputController ctrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Obx(() {
        final valid = ctrl.isValid.value;
        final saving = ctrl.isSaving.value;
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: ctrl.retake,
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: const Text('다시 촬영'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[400]!),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: (valid && !saving) ? ctrl.save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue600,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: const Color(0xFF9CA3AF),
                  elevation: 0,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('저장 후 계속 촬영', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      }),
    );
  }
}
