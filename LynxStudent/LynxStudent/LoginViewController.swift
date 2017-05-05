//
//  LoginViewController.swift
//  LynxStudent
//
//  Created by Yifan Xu on 2/23/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // initialize facebook login button
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        
        // should be using constraints here, but didn't figure out how to do it programmatically
        loginButton.frame = CGRect(x: 16, y: view.frame.height/2 - 25, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
        // this block of code can be used to update the model when needed
        /*
        let ref = FIRDatabase.database().reference(withPath: "business")
        
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children
            {
                let snap = item as! FIRDataSnapshot
                snap.ref.updateChildValues([
                    "rating" : ["default" : 5.0]
                    ])
            }
        })
        */
 
        if FIRAuth.auth()?.currentUser != nil
        {
            print("logged in")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "Login", sender: nil)
            })
        }
        else
        {
            print("not logged in")
        }
 
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("logged out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error != nil
        {
            print(error)
            return
        }
        else
        {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                if let error = error
                {
                    print(error)
                    return
                }
                else
                {
                    self.performSegue(withIdentifier: "Login", sender: nil)
                    print("login through fb")
                }
            }
        }
    }
    
}
