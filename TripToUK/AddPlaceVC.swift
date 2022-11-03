//
//  AddPlaceVC.swift
//  TripToUK
//
//  Created by Berk on 1.11.2022.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var placeNameText: UITextField!
    @IBOutlet var placeTypeText: UITextField!
    @IBOutlet var famousForText: UITextField!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPicture))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if placeNameText.text != "" && placeTypeText.text != "" && famousForText.text != "" {
            if let selectedImage = imageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.highlights = famousForText.text!
                placeModel.placeImage = selectedImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            showAlert(titleInput: "Error", messageInput: "Place couldn't added")
        }
    }
    
    func showAlert(titleInput: String, messageInput: String) {
        let ac = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        ac.addAction(okButton)
        self.present(ac, animated: true)
    }
}
