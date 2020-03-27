//
//  ViewController.swift
//  MediaCapture
//
//  Created by Plam Stefanova on 3/27/20.
//  Copyright © 2020 Plam Stefanova. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    
    @IBOutlet weak var tf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
    }
    
    @IBAction func photosBtnPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }
    
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageView.image = image
        selectedImage = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func showAlert(msg:String) {
        let alertController = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnClicked(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            showAlert(msg: "Device has no camera")
            
        }
        else{
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = true
            imagePicker.allowsEditing = true
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    
    @IBAction func addClicked(_ sender: Any) {
        if imageView.image == nil {
            showAlert(msg: "Please select a photo")
        }
        else{
            let s = tf.text!
            let s2 = NSAttributedString(string: s, attributes:
                [.font:UIFont(name: "Georgia", size: 100)!,
                 .foregroundColor: UIColor.yellow])
            let sz = imageView.image!.size
            let r = UIGraphicsImageRenderer(size:sz)
            imageView.image = r.image {
                _ in
                imageView.image!.draw(at:.zero)
                s2.draw(at: CGPoint(x:30, y:sz.height-150))
            }
        }
    }
    
    @IBAction func revertBtn(_ sender: Any) {
imageView.image = selectedImage    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        let image = resizeImage(image: imageView.image!, newWidth: 250)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        showAlert(msg: "Image saved")
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
