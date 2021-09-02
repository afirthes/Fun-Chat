//
//  ViewController.swift
//  Fun Chat
//
//  Created by sehio on 25.08.2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let email = emailTextfield.text, let passwrod = passwordTextfield.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: passwrod) { result, err in
            
            if let error = err {
                //print(Locale.current.languageCode)
                print(error.localizedDescription)
                return
            }
            
            // Navigate to chat view controller
            self.performSegue(withIdentifier: "RegisterToChat", sender: self)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
