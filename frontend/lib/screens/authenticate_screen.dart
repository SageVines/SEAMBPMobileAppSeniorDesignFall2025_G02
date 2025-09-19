// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthenticateScreen extends StatefulWidget {
//   const AuthenticateScreen({super.key});

//   @override
//   State<AuthenticateScreen> createState() => _AuthenticateScreenState();
// }

// class _AuthenticateScreenState extends State<AuthenticateScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String status = "Not signed in";

//   // -------------------------
//   // Email + Password Register
//   // -------------------------
//   Future<void> _registerWithEmail() async {
//     try {
//       final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Save user profile in Firestore
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(cred.user!.uid)
//           .set({
//         "email": cred.user!.email,
//         "created_at": DateTime.now().toIso8601String(),
//       });

//       setState(() => status = "✅ Registered with ${cred.user!.email}");
//     } catch (e) {
//       setState(() => status = "❌ Error: $e");
//     }
//   }

//   // -------------------------
//   // Email + Password Login
//   // -------------------------
//   Future<void> _loginWithEmail() async {
//     try {
//       final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       setState(() => status = "✅ Logged in as ${cred.user!.email}");
//     } catch (e) {
//       setState(() => status = "❌ Error: $e");
//     }
//   }

//   // -------------------------
//   // Google Sign-In
//   // -------------------------
//   Future<void> _signInWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       if (googleUser == null) {
//         setState(() => status = "⚠️ Google sign-in aborted");
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final cred = await FirebaseAuth.instance.signInWithCredential(credential);

//       // Ensure Firestore profile exists
//       final userDoc =
//           FirebaseFirestore.instance.collection("users").doc(cred.user!.uid);
//       if (!(await userDoc.get()).exists) {
//         await userDoc.set({
//           "email": cred.user!.email,
//           "created_at": DateTime.now().toIso8601String(),
//         });
//       }

//       setState(() => status = "✅ Signed in as ${cred.user!.email}");
//     } catch (e) {
//       setState(() => status = "❌ Google sign-in error: $e");
//     }
//   }

//   // -------------------------
//   // Sign Out
//   // -------------------------
//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//     setState(() => status = "Signed out");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Authentication Test")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Email + Password inputs
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),

//             // Buttons for email/password
//             ElevatedButton(
//               onPressed: _registerWithEmail,
//               child: const Text("Register with Email"),
//             ),
//             ElevatedButton(
//               onPressed: _loginWithEmail,
//               child: const Text("Login with Email"),
//             ),

//             const Divider(height: 40),

//             // Google Sign-In button
//             ElevatedButton.icon(
//               onPressed: _signInWithGoogle,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//               ),
//               icon: const Icon(Icons.login, color: Colors.red),
//               label: const Text("Sign in with Google"),
//             ),

//             const SizedBox(height: 20),

//             // Sign Out button
//             ElevatedButton(
//               onPressed: _signOut,
//               child: const Text("Sign Out"),
//             ),

//             const SizedBox(height: 30),

//             // Status display
//             Text(
//               status,
//               style: const TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import 'onboarding_screen.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String status = "Not signed in";

  /// 🔹 Helper: Navigate user to correct screen
  Future<void> _routeAfterLogin(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => OnboardingScreen(uid: user.uid)),
      );
    }
  }

  /// 🔹 Register with Email
  Future<void> _registerWithEmail() async {
    try {
      final userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCred.user;
      if (user != null) {
        await _routeAfterLogin(user);
      }
    } catch (e) {
      setState(() => status = "❌ Registration error: $e");
    }
  }

  /// 🔹 Login with Email
  Future<void> _loginWithEmail() async {
    try {
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCred.user;
      if (user != null) {
        await _routeAfterLogin(user);
      }
    } catch (e) {
      setState(() => status = "❌ Login error: $e");
    }
  }

  /// 🔹 Google Sign-In (Web + Mobile)
  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCred;

      if (Theme.of(context).platform == TargetPlatform.android ||
          Theme.of(context).platform == TargetPlatform.iOS) {
        // ---- MOBILE FLOW ----
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          setState(() => status = "⚠️ Google sign-in aborted");
          return;
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCred = await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        // ---- WEB FLOW ----
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        userCred = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      }

      final user = userCred.user;
      if (user != null) {
        await _routeAfterLogin(user);
      }
    } catch (e) {
      setState(() => status = "❌ Google sign-in error: $e");
    }
  }

  /// 🔹 Sign out
  // Future<void> _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   setState(() => status = "Signed out");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authentication Test")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            // Buttons
            ElevatedButton(
              onPressed: _registerWithEmail,
              child: const Text("Register with Email"),
            ),
            ElevatedButton(
              onPressed: _loginWithEmail,
              child: const Text("Login with Email"),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: const Icon(Icons.login),
              label: const Text("Sign in with Google"),
            ),
            const SizedBox(height: 20),

            // ElevatedButton(
            //   onPressed: _signOut,
            //   child: const Text("Sign Out"),
            // ),

            const SizedBox(height: 20),
            Text(status, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
