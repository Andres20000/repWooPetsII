//
//  DestacarPublicacionViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MobileCoreServices



class DestacarPublicacionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    
    
    @IBOutlet weak var examinar: UIButton!
    
    @IBOutlet weak var aceptar: UIButton!
    
    @IBOutlet weak var cancelar: UIButton!
    
    @IBOutlet weak var imagen: UIImageView!
    
    
    
    let imagePicker = UIImagePickerController()
    
    var subir = false;
    
    var publicacion:PublicacionOferente?
    
    
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        examinar.layer.cornerRadius = 22.0
        aceptar.layer.cornerRadius = 22.0
        cancelar.layer.cornerRadius = 22.0
        
        
        
        
        
        
        if publicacion!.destacado!  {
            imagen.image =  publicacion?.imagenDestacado?.getImagen(msnNoti: nil)
            
            examinar.setTitle("Editar", for: .normal)
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actualizoImagen), name:NSNotification.Name(rawValue: (publicacion?.imagenDestacado?.pathEnStorage)!), object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapSeleccionarImagen(_ sender: Any) {
        
        let alert:UIAlertController = UIAlertController(title: "Traer foto a partir de:", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Captura desde la cámara", style: .default)
        {
            UIAlertAction in self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Seleccionar desde la Biblioteca", style: .default)
        {
            UIAlertAction in self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    
        
    
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertController(title: "Error accessing camera", message: "Error accessing camera", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertWarning.addAction(defaultAction)
            
            present(alertWarning, animated: true, completion: nil)
        }
    }
    
    
    func openGallery()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertController(title: "Error accessing photo library", message: "Device does not support a photo library", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertWarning.addAction(defaultAction)
            
            present(alertWarning, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagen.image = self.resizeImage(pickedImage, newWidth: 300.0)
            
            subir = true
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            subir = true
            imagen.image = self.resizeImage(pickedImage, newWidth: 300.0)
        } else {
            imagen.image = nil
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }

    
    
    
    
    @IBAction func didTapAceptar(_ sender: Any) {
        
        
        
        performSegue(withIdentifier: "metodoPago", sender: nil)
        
        /*if !subir {
            dismiss(animated: true, completion: nil)
            return
        }*/
        
        activarDestacado()

    }
    
    
    
    func activarDestacado() {
        
        
        if imagen.image != nil {
            publicacion?.imagenDestacado?.imageData = UIImageJPEGRepresentation(imagen.image!, 1.0)
        }
        else {
            return
        }

        
        ComandoDestacados.destacarPublicacion(publicacion: publicacion!, newVersion: 1)
        
        
    }
    
    
    

    @IBAction func didTapAyuda(_ sender: Any) {
    }
    
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage
    {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }


    func  actualizoImagen() {
        
        DispatchQueue.main.async {
            
            if self.publicacion!.imagenDestacado?.imageData != nil {
                self.imagen.image = UIImage(data:(self.publicacion!.imagenDestacado?.imageData!)!)
                
                self.examinar.setTitle("Editar", for: .normal)
            }
            
        }
        
        
        
        
    }

    
    
  
}
