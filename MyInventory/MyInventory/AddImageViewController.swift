//
//  AddImageViewController.swift
//  MyInventory
//
//  Created by Jack Pettit on 4/16/19.
//  Copyright © 2019 jpettit. All rights reserved.
//

import UIKit

protocol AddImageDelegate: class {
    func add(image: UIImage?)
}
class AddImageViewController: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    weak var delegate: AddImageDelegate? = nil
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButtonPressed(_ sender: Any) {
        print("Adding image.")
        delegate?.add(image: itemImageView.image)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onChooseImagePressed(_ sender: Any) {
        presentImageController(didSelectCamera: false)
    }
    @IBAction func onTakeImagePressed(_ sender: Any) {
        presentImageController(didSelectCamera: true)
    }
    
    private func presentImageController(didSelectCamera: Bool) {
        if didSelectCamera {
            print("Choose Image Pressed.")
            imagePicker.sourceType = .camera
            
        } else {
            print("Choose Image Pressed.")
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddImageViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            itemImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
