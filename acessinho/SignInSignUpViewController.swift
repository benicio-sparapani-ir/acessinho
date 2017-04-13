//
//  SignInSignUpViewController.swift
//  acessinho
//
//  Created by Benicio Sparapani Junior on 13/04/17.
//  Copyright © 2017 Ingresso Rapido. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "EventListViewController", sender: nil)
            }
        }
    }
    
    func login(with email: String, and password: String) {
        FIRAuth.auth()?.signIn(withEmail: email,
                               password: password,
                               completion: { (user, error) in
                                if let error = error {
                                    print(error)
                                }
        })
    }
    
    func signup(with email: String, and password: String) {
        FIRAuth.auth()?.createUser(withEmail: email,
                                   password: password) { user, error in
                                    if error == nil {
                                        self.login(with: email, and: password)
                                    }
        }
    }
    
    //MARK: Settings

    @IBAction func signUpTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Cadastro",
                                      message: "Digite os dados:",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Cadastrar",
                                       style: .default) { action in
                                        
                                        let email = alert.textFields![0].text
                                        let password = alert.textFields![1].text
                                        self.signup(with: email!, and: password!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Digite seu e-mail"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Digite sua senha"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Login",
                                      message: "Digite os dados:",
                                      preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "Entrar",
                                        style: .default) { action in
                                        
                                        let email = alert.textFields![0].text
                                        let password = alert.textFields![1].text
                                        
                                        self.login(with: email!, and: password!)
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Digite seu e-mail"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Digite sua senha"
        }
        
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
