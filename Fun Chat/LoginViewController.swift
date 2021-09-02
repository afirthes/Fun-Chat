//
//  ViewController.swift
//  Fun Chat
//
//  Created by sehio on 25.08.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard let email = emailTextfield.text, let password = passwordTextfield.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          
            if let e = error {
                print(e)
                return
            }
            
            guard let strongSelf = self else { return }
            
            strongSelf.performSegue(withIdentifier: "LoginToChat", sender: self)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
