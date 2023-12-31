import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_rider_app/features/uber_auth_feature/domain/use_cases/uber_add_profile_image_usecase.dart';
import 'package:uber_rider_app/features/uber_auth_feature/domain/use_cases/uber_auth_check_user_status_usecase.dart';
import 'package:uber_rider_app/features/uber_auth_feature/domain/use_cases/uber_auth_get_user_uid_usecase.dart';
import 'package:uber_rider_app/features/uber_auth_feature/domain/use_cases/uber_auth_is_sign_in_usecase.dart';
import 'package:uber_rider_app/features/uber_auth_feature/domain/use_cases/uber_auth_otp_verification_usecase.dart';
import 'package:uber_rider_app/features/uber_auth_feature/domain/use_cases/uber_auth_phone_verification_usecase.dart';
import 'package:uber_rider_app/features/uber_auth_feature/presentation/pages/uber_auth_register_page.dart';
import 'package:uber_rider_app/features/uber_home_page_feature/presentation/pages/uber_home_page.dart';
import 'package:uber_rider_app/features/uber_profile_feature/domain/entities/uber_profile_rider_entity.dart';
import 'package:uber_rider_app/features/uber_profile_feature/domain/use_cases/uber_profile_update_rider_usecase.dart';

class UberAuthController extends GetxController {
  final UberAuthIsSignInUseCase uberAuthIsSignInUseCase;
  final UberAuthPhoneVerificationUseCase uberAuthPhoneVerificationUseCase;
  final UberAuthOtpVerificationUseCase uberAuthOtpVerificationUseCase;
  final UberAuthCheckUserStatusUseCase uberAuthCheckUserStatusUseCase;
  final UberAuthGetUserUidUseCase uberAuthGetUserUidUseCase;
  final UberProfileUpdateRiderUsecase uberProfileUpdateRiderUsecase;
  final UberAddProfileImgUseCase uberAddProfileImgUseCase;
  var isSignIn = false.obs;
  var profileImgUrl =
      "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png"
          .obs;

  UberAuthController(
      {required this.uberAuthIsSignInUseCase,
      required this.uberAuthPhoneVerificationUseCase,
      required this.uberAuthOtpVerificationUseCase,
      required this.uberAuthCheckUserStatusUseCase,
      required this.uberAuthGetUserUidUseCase,
      required this.uberProfileUpdateRiderUsecase,
      required this.uberAddProfileImgUseCase});

  checkIsSignIn() async {
    bool uberAuthIsSignIn = await uberAuthIsSignInUseCase.call();
    isSignIn.value = uberAuthIsSignIn;
  }

  verifyPhoneNumber(String phoneNumber) async {
    await uberAuthPhoneVerificationUseCase.call(phoneNumber);

    Get.showSnackbar(
      const GetSnackBar(backgroundColor: Colors.grey,
        title: "Wait",
        message: '"Verifying Number", "Please wait !"',
        icon:  Icon(Icons.timelapse_rounded),
        duration: Duration(seconds: 10),snackStyle: SnackStyle.FLOATING,
      ),
    );
  }

  verifyOtp(String otp) async {
    Get.snackbar("Validating Otp", "Please wait !",
        showProgressIndicator: true, duration: const Duration(seconds: 10));
    await uberAuthOtpVerificationUseCase.call(otp).whenComplete(() async {
      String riderId = await uberAuthGetUserUidUseCase.call();
      if (riderId.isNotEmpty) {
        Get.closeAllSnackbars();
        final userStatus = await checkUserStatus();
        if (userStatus) {
          Get.offAll(() => const UberHomePage());
        } else {
          Get.offAll(() => const UberAuthRegistrationPage());
        }
      }
    });
  }

  Future<bool> checkUserStatus() async {
    String riderId = await uberAuthGetUserUidUseCase.call();
    return uberAuthCheckUserStatusUseCase.call(riderId);
  }

  pickProfileImg() async {
    String riderId = await uberAuthGetUserUidUseCase.call();
    String profileUrl = await uberAddProfileImgUseCase.call(riderId);
    Get.showSnackbar(
        const GetSnackBar(backgroundColor: Colors.grey,
          title: "Wait",
          message: 'Please wait , while your image is uploading',
          icon:  Icon(Icons.timelapse_outlined),
          snackPosition: SnackPosition.BOTTOM,
        ),);
    profileImgUrl.value = profileUrl;
  }

  addRiderprofile(String name, String email, String city, String homeAddress,
      String workAddress) async {
    final riderEntity = RiderEntity(
        name,
        email,
        FirebaseAuth.instance.currentUser!.phoneNumber,
        city,
        profileImgUrl.value,
        homeAddress,
        workAddress,
        0);
    await uberAuthGetUserUidUseCase.call().then((riderId) async {
      await uberProfileUpdateRiderUsecase.call(riderEntity, riderId);
      Get.showSnackbar(
        const GetSnackBar(backgroundColor: Colors.grey,
          title: "Wait",
          message: "uploading details! ,Please wait !",
          icon:  Icon(Icons.timer_outlined),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
        ),);
    });


    final userStatus = await checkUserStatus();
    if (userStatus) {
      Get.closeAllSnackbars();
      Get.snackbar("done", "registration successful!");
      Get.showSnackbar(
        const GetSnackBar(backgroundColor: Colors.teal,
          title: "Done",
          message: "registration successful!",
          icon:  Icon(Icons.check_circle),


        ),);
      Get.offAll(() => const UberHomePage());
    }
  }
}
