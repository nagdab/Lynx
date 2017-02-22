//
//  UsernameVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/28/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class UsernameVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var imageSelected = false
	var imagePicker: UIImagePickerController!
	var user: User!
	
	@IBOutlet weak var userNameLbl: UITextField!
	@IBOutlet weak var profileImage: UIImageView!
	
	@IBOutlet weak var buttonLabel: UIButton!
	@IBAction func createUser(_ Sender: AnyObject){
		
		if userNameLbl.text != "" && imageSelected == true {
		let usernametext = userNameLbl.text!.lowercased()
		DataService.ds.REF_USER_CURRENT.childByAppendingPath("username").setValue(usernametext)
		let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
		DataService.ds.REF_USERNAMES.childByAppendingPath(usernametext).setValue(uid)
		pictureUpload()
		
		UserDefaults.standard.set(usernametext, forKey: USERNAME)
		performSegue(withIdentifier: "loggedInWithUsername", sender: nil)
		} else {
			showErrorAlert("Missing Username/Profile Image", msg: "Select a profile image, and username to continue")
		}
	}
	
	@IBAction func ImagePicker(_ sender: AnyObject) {
		present(imagePicker, animated: true, completion: nil)
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		dismiss(animated: true, completion: nil)
		profileImage.image = image
		imageSelected = true
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
    }
	
	func postProfileImageToFireB(_ url: String) {
		UserDefaults.standard.set(url, forKey: "profileImageUrl")
		DataService.ds.REF_USER_CURRENT.childByAppendingPath("profileImageUrl").setValue(url)
	}
	
	func pictureUpload() {
		
		if let img = profileImage.image, imageSelected == true {
			
			let urlStr = "https://api.imageshack.com/v2/images"
			let url = URL(string: urlStr)!
			let imgData = UIImageJPEGRepresentation(img, 0.2)!
			let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".data(using: String.Encoding.utf8)!
			let keyJSON = "json".data(using: String.Encoding.utf8)!
			
			Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
				
				multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jgp")
				multipartFormData.appendBodyPart(data: keyData, name: "key")
				multipartFormData.appendBodyPart(data: keyJSON, name: "formart")
				
				}, encodingCompletion: { encodingResult in
					
					switch encodingResult {
						
					case .Success(let upload, _, _):
						
						upload.responseJSON { response in
							if let info = response.result.value as? Dictionary<String, AnyObject> {
								if let dict = info["result"] as? Dictionary<String,AnyObject> {
									if let images = dict["images"]?[0] as? Dictionary<String,AnyObject> {
										if let imgLink = images["direct_link"] as? String {
											let finalLink = "http://\(imgLink)"
											self.postProfileImageToFireB(finalLink)
										}
									}
								}
							}
						}
					case .Failure(let error):
						print(error)
					}
			})
		}
	}
	
	func showErrorAlert(_ title: String, msg: String) {
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	
	
	
}
