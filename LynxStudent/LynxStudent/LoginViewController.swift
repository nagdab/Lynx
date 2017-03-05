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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // initialize facebook login button
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        
        // should be using constraints here, but didn't figure out how to do it programmatically
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self

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
                    print("signed in to firebase through facebook")
                }
            }
        }
    }
    
}
