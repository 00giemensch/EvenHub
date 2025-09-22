import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthService {
    static let shared = AuthService()
    
    private init() {
        self.currentUser = Auth.auth().currentUser
        self.isAuthenticated = self.currentUser != nil
        setupAuthStateListener()
    }
    
    // currentUser
    private(set) var currentUser: User?
    
    // isAuthenticated
    private(set) var isAuthenticated: Bool = false
    
    // setupAuthStateListener
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.currentUser = user
            self?.isAuthenticated = user != nil
        }
    }
    
    
    
    func setRememberMe(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "app.isRememberMeEnabled")
    }
    
    func getRememberMe() -> Bool {
        return UserDefaults.standard.bool(forKey: "app.isRememberMeEnabled")
    }
    
    func signInWithEmail(email: String, password: String, rememberMe: Bool, completion: @escaping (Result<User, Error>) -> Void) {
        
        // Save RememberMe state
        setRememberMe(rememberMe)
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    // shouldSkipLoginInScreen
    func shouldSkipLogin() -> Bool {
        // Skip SignInScreen if rememberMe is true and current user exist
        return getRememberMe() && Auth.auth().currentUser != nil
    }
    
    // MARK: - Sign in / Sign up with Google
    func signInWithGoogle(
        presentingViewController: UIViewController,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Missing Google client ID"]
            )))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(
                    domain: "AuthService",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to get Google user or token"]
                )))
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = result?.user {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(
                        domain: "AuthService",
                        code: -3,
                        userInfo: [NSLocalizedDescriptionKey: "Unknown Firebase sign-in error"]
                    )))
                }
            }
        }
    }
    
    // MARK: - Sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Sing out error: %@", signOutError)
        }
        self.setRememberMe(false)
    }
}
