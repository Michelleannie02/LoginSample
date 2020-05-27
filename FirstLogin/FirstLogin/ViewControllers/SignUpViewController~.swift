//
//  SignUpViewController.swift
//  FirstLogin
//
//  Created by Mina Ramses on 4/19/20.
//  Copyright © 2020 Mina Ramses. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var FirstNameTextField: UITextField!
    
    @IBOutlet weak var LastNameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var SignUpButtom: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        self.HideKeyboard()

        
    }
    func setUpElements() {
        
        ErrorLabel.alpha = 0
        
        
        Utilities.styleTextField(FirstNameTextField)
        Utilities.styleTextField(LastNameTextField)
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        Utilities.styleFilledButton(SignUpButtom)
        
        
    }
    
    func validateFields() -> String? {
        
        //Check that all fielda are filled!
        if FirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        //Check if the password is secures
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //password isn't secured
            return "Please make sure that your password is a least 8 characters, contains a special character and a number!"
        }
        
        return nil
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        //Validate the fields
        let error = validateFields()
        if error != nil {
            //There is sth error with the fields, show error message
            showErrorMessage(error!)
        }
        else {
            
            //Create clean version of the data
            let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if error != nil{ //There is an error while creating the user
                    self.showErrorMessage("Error Creating User!")
                }
                
                else{ //User was crated Successfully, now store to FIREBASE --> FireStore
                  
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName" : firstName, "lastName" : lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //There is sth error with the fields, show error message
                            self.showErrorMessage("Error, user data couldn't be saved to the Database")
                        }
                                
                    }
                     //Make transition to home screen
                    self.transitionTOHome()
                    
                }
            }
        }
        
    }
    func showErrorMessage (_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    
    func transitionTOHome(){
        
        let homeViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
