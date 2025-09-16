import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthService {
    static let shared = AuthService()
    
    private init() {
        setupAuthStateListener()
    }
    
    // Текущий пользователь
    private(set) var currentUser: User?
    
    // Флаг авторизации
    private(set) var isAuthenticated: Bool = false
    
    // Слушатель состояния
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.currentUser = user
            self?.isAuthenticated = user != nil
        }
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
            GIDSignIn.sharedInstance.signOut()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
