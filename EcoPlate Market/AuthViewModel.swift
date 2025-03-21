//
//  AuthViewModel.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?

    init() {
        self.userSession = Auth.auth().currentUser
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else { return }

            let userData = ["email": email, "uid": user.uid]
            Firestore.firestore().collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    DispatchQueue.main.async {
                        self.userSession = user
                    }
                    completion(.success(()))
                }
            }
        }
    }
}

