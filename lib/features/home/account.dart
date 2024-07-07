import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/auth/view_model/auth_view_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/info_card.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  Account({super.key});
  final AuthViewModel vm = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.accountSettingsScreenTitle,
          style: TextStyle(color: Palette.primaryText),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'Signed in as ${vm.user?.email}',
              //   style: TextStyles.bodyLarge,
              // ),
              const Icon(
                Icons.account_circle,
                size: 200,
                color: Palette.primaryText,
              ),
              InfoCard(
                  title: AppStrings.username,
                  subtitle: "${vm.userData?.studentName}"),
              InfoCard(
                  title: AppStrings.emailAddress,
                  subtitle: "${vm.userData?.emailAddress}"),
              InfoCard(
                  title: AppStrings.phoneNumber,
                  subtitle: "${vm.userData?.parentPhoneNumber}"),
              // Padding(
              //   padding: EdgeInsets.all(Constants.padding12),
              //   child: Card(
              //     elevation: 0,
              //     child: Padding(
              //       padding: EdgeInsets.all(Constants.padding12),
              //       child: SizedBox(
              //         width: double.infinity,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.stretch,
              //           children: [
              //             Text(
              //               'User ID',
              //               style: TextStyles.bodyLarge,
              //             ),
              //             Text(
              //               " ${vm.user?.uid}",
              //               style: TextStyles.bodyMedium,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              Button(
                text: 'Sign out',
                onPressed: () async {
                  await vm.signOut(context);
                },
              ),
              // SizedBox(
              //   height: Constants.padding8,
              // ),
              // Button(
              //   text: 'Go to Components',
              //   onPressed: () {
              //     context.push('/components');
              //   },
              // ),
              // SizedBox(
              //   height: Constants.padding8,
              // ),
              // Button(
              //   text: 'Go to Settings',
              //   onPressed: () {
              //     context.push('/settings');
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget InfoCard(String title, String subtitle) {
//   return Padding(
//     padding: EdgeInsets.all(Constants.padding12),
//     child: Card(
//       elevation: 0,
//       child: Padding(
//         padding: EdgeInsets.all(Constants.padding12),
//         child: SizedBox(
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 title,
//                 style: TextStyles.bodyLarge,
//               ),
//               Text(
//                 subtitle,
//                 style: TextStyles.bodyMedium,
//               )
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
