import '../../../core/constants/appimageasset.dart';
import '../../models/onboarding/onboardingmodel.dart';

List<OnBoradingModel> onBoardingList = [
  OnBoradingModel(
    "Complaints",
    AppImageAsset.onBoardingImageOne,
    "Submit complaints, attach files, and track status easily.",
  ),
  OnBoradingModel(
    "Government Entities",
    AppImageAsset.onBoardingImageTwo,
    "Choose the right authority for faster resolution.",
  ),
  OnBoradingModel(
    "Track Complaint",
    AppImageAsset.onBoardingImageThree,
    "Follow updates with a reference number and notifications.",
  ),
  OnBoradingModel(
    "Privacy & Security",
    AppImageAsset.onBoardingImageFour,
    "Your data is protected with secure access and encryption.",
  ),
];



// إضافة إلى الملف الحالي
class StaticComplaintData {
  static List<String> complaintTypes = [
    'Infrastructure',
    'Sanitation',
    'Security',
    'Administrative',
    'Technical',
    'Other'
  ];

  static List<String> responsibleEntities = [
    'Municipality',
    'Public Works',
    'Health Department',
    'Police Department',
    'Technical Support',
    'Other'
  ];
}