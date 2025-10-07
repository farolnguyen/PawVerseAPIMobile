import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  // Login with Google
  Future<LoginResponse> loginWithGoogle() async {
    try {
      // 1. Trigger Google Sign In
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account == null) {
        // User cancelled the sign-in
        throw Exception('Đăng nhập Google bị hủy');
      }

      // 2. Get Google authentication
      final GoogleSignInAuthentication auth = await account.authentication;
      
      // 3. Get ID Token
      final String? idToken = auth.idToken;
      
      if (idToken == null) {
        throw Exception('Không thể lấy Google ID Token');
      }

      // 4. Send ID Token to backend
      final response = await _authRepository.loginWithGoogle(idToken);
      
      return response;
    } catch (e) {
      // Sign out on error
      await _googleSignIn.signOut();
      rethrow;
    }
  }

  // Sign out from Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Ignore errors on sign out
    }
  }

  // Check if user is signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    return await _googleSignIn.isSignedIn();
  }

  // Get current Google account
  GoogleSignInAccount? get currentGoogleAccount => _googleSignIn.currentUser;
}
