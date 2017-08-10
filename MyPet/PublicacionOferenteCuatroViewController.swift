//
//  PublicacionOferenteCuatroViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 14/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import Firebase

class PublicacionOferenteCuatroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var horizontalSpaceConstraint: NSLayoutConstraint?
    @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var verticalSpaceLabel_1Constraint: NSLayoutConstraint?
    @IBOutlet var verticalSpaceLabel_2Constraint: NSLayoutConstraint?
    @IBOutlet var verticalSpaceLabel_3Constraint: NSLayoutConstraint?
    @IBOutlet var verticalSpaceLabel_4Constraint: NSLayoutConstraint?
    @IBOutlet var verticalSpaceLabel_5Constraint: NSLayoutConstraint?
    @IBOutlet var verticalSpaceLabel_6Constraint: NSLayoutConstraint?
    
    let model = ModeloOferente.sharedInstance
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var barItemTitulo: UIBarButtonItem!
    @IBOutlet var lblEtapaPublicacion_1: UILabel!
    @IBOutlet var lblEtapaPublicacion_2: UILabel!
    @IBOutlet var lblEtapaPublicacion_3: UILabel!
    @IBOutlet var lblEtapaPublicacion_4: UILabel!
    
    @IBOutlet var imgFoto_1: UIImageView!
    @IBOutlet var btnFoto_1: UIButton!
    @IBOutlet var lblFoto_1: UILabel!
    
    @IBOutlet var imgFoto_2: UIImageView!
    @IBOutlet var btnFoto_2: UIButton!
    @IBOutlet var lblFoto_2: UILabel!
    
    @IBOutlet var imgFoto_3: UIImageView!
    @IBOutlet var btnFoto_3: UIButton!
    @IBOutlet var lblFoto_3: UILabel!
    
    @IBOutlet var imgFoto_4: UIImageView!
    @IBOutlet var btnFoto_4: UIButton!
    @IBOutlet var lblFoto_4: UILabel!
    
    @IBOutlet var imgFoto_5: UIImageView!
    @IBOutlet var btnFoto_5: UIButton!
    @IBOutlet var lblFoto_5: UILabel!
    
    @IBOutlet var imgFoto_6: UIImageView!
    @IBOutlet var btnFoto_6: UIButton!
    @IBOutlet var lblFoto_6: UILabel!
    
    var imgGenerica: UIImageView!
    var btnGenerico: UIButton!
    var lblGenerico: UILabel!
    
    @IBOutlet var btnFinalizar: UIButton!
    
    var datosEditables:Bool = false
    
    var imgAddInEdition_2:Bool = false
    var imgAddInEdition_3:Bool = false
    var imgAddInEdition_4:Bool = false
    var imgAddInEdition_5:Bool = false
    var imgAddInEdition_6:Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        if !datosEditables
        {
            if (model.publicacion.fotos?.count)! > 0
            {
                for foto in (model.publicacion.fotos)!
                {
                    ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: (foto.nombreFoto)!)
                }
                model.publicacion.fotos?.removeAll()
            }
        }else
        {
            if imgAddInEdition_2
            {
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: "Foto2.png")
                model.publicacion.fotos?.remove(at: 1)
            }
            
            if imgAddInEdition_3
            {
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: "Foto3.png")
                model.publicacion.fotos?.remove(at: 2)
            }
            
            if imgAddInEdition_4
            {
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: "Foto4.png")
                model.publicacion.fotos?.remove(at: 3)
            }
            
            if imgAddInEdition_5
            {
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: "Foto5.png")
                model.publicacion.fotos?.remove(at: 4)
            }
            
            if imgAddInEdition_6
            {
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: "Foto6.png")
                model.publicacion.fotos?.remove(at: 5)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        
        lblEtapaPublicacion_1.layer.masksToBounds = true
        lblEtapaPublicacion_1.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_2.layer.masksToBounds = true
        lblEtapaPublicacion_2.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_3.layer.masksToBounds = true
        lblEtapaPublicacion_3.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_4.layer.masksToBounds = true
        lblEtapaPublicacion_4.layer.cornerRadius = 22.0
        
        // Definir espacio para cada dispositivo
        if DeviceType.IS_IPHONE_5
        {
            self.horizontalSpaceConstraint?.constant = 40.0
            self.bottomLayoutConstraint?.constant = 10.0
            self.verticalSpaceLabel_1Constraint?.constant = -39.0
            self.verticalSpaceLabel_2Constraint?.constant = -39.0
            self.verticalSpaceLabel_3Constraint?.constant = -39.0
            self.verticalSpaceLabel_4Constraint?.constant = -39.0
            self.verticalSpaceLabel_5Constraint?.constant = -39.0
            self.verticalSpaceLabel_6Constraint?.constant = -39.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            self.horizontalSpaceConstraint?.constant = 85.0
            self.verticalSpaceLabel_1Constraint?.constant = -53.0
            self.verticalSpaceLabel_2Constraint?.constant = -53.0
            self.verticalSpaceLabel_3Constraint?.constant = -53.0
            self.verticalSpaceLabel_4Constraint?.constant = -53.0
            self.verticalSpaceLabel_5Constraint?.constant = -53.0
            self.verticalSpaceLabel_6Constraint?.constant = -53.0
        }
        
        imgFoto_1.layer.borderWidth = 1.0
        imgFoto_1.layer.borderColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0).cgColor
        
        imgFoto_2.layer.borderWidth = 1.0
        imgFoto_2.layer.borderColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0).cgColor
        btnFoto_2.isEnabled = false
        
        imgFoto_3.layer.borderWidth = 1.0
        imgFoto_3.layer.borderColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0).cgColor
        btnFoto_3.isEnabled = false
        
        imgFoto_4.layer.borderWidth = 1.0
        imgFoto_4.layer.borderColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0).cgColor
        btnFoto_4.isEnabled = false
        
        imgFoto_5.layer.borderWidth = 1.0
        imgFoto_5.layer.borderColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0).cgColor
        btnFoto_5.isEnabled = false
        
        imgFoto_6.layer.borderWidth = 1.0
        imgFoto_6.layer.borderColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0).cgColor
        btnFoto_6.isEnabled = false
        
        lblFoto_1.text = "Tomar foto"
        lblFoto_2.text = "Tomar foto"
        lblFoto_3.text = "Tomar foto"
        lblFoto_4.text = "Tomar foto"
        lblFoto_5.text = "Tomar foto"
        lblFoto_6.text = "Tomar foto"
        
        btnFinalizar.layer.cornerRadius = 10.0
        btnFinalizar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        btnFinalizar.isEnabled = false
        
        if datosEditables
        {
            barItemTitulo.title = "Editar publicación"
            btnFinalizar.setTitle("Editar", for: .normal)
            btnFinalizar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
            btnFinalizar.isEnabled = true
            
            if (model.publicacion.fotos?.count)! > 0
            {
                for foto in (model.publicacion.fotos)!
                {
                    if foto.idFoto == "Foto1"
                    {
                        let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (foto.nombreFoto)!
                        
                        imgFoto_1.loadImageUsingCacheWithUrlString(pathString: path)
                        
                        imgFoto_1.translatesAutoresizingMaskIntoConstraints = false
                        imgFoto_1.layer.masksToBounds = true
                        imgFoto_1.contentMode = .scaleAspectFill
                        imgFoto_1.leftAnchor.constraint(equalTo: imgFoto_1.leftAnchor, constant: 8).isActive = true
                        imgFoto_1.centerYAnchor.constraint(equalTo: imgFoto_1.centerYAnchor).isActive = true
                        imgFoto_1.widthAnchor.constraint(equalToConstant: imgFoto_1.frame.width).isActive = true
                        imgFoto_1.heightAnchor.constraint(equalToConstant: imgFoto_1.frame.height).isActive = true
                        
                        btnFoto_1 .setImage(nil, for: .normal)
                        btnFoto_1.isEnabled = true
                        
                        btnFoto_2.isEnabled = true
                        
                        lblFoto_1.text = "Cambiar foto"
                    }
                    
                    if foto.idFoto == "Foto2"
                    {
                        let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (foto.nombreFoto)!
                        imgFoto_2.loadImageUsingCacheWithUrlString(pathString: path)
                        
                        imgFoto_2.translatesAutoresizingMaskIntoConstraints = false
                        imgFoto_2.layer.masksToBounds = true
                        imgFoto_2.contentMode = .scaleAspectFill
                        imgFoto_2.leftAnchor.constraint(equalTo: imgFoto_2.leftAnchor, constant: 8).isActive = true
                        imgFoto_2.centerYAnchor.constraint(equalTo: imgFoto_2.centerYAnchor).isActive = true
                        imgFoto_2.widthAnchor.constraint(equalToConstant: imgFoto_2.frame.width).isActive = true
                        imgFoto_2.heightAnchor.constraint(equalToConstant: imgFoto_2.frame.height).isActive = true
                        
                        btnFoto_2 .setImage(nil, for: .normal)
                        btnFoto_2.isEnabled = true
                        
                        btnFoto_3.isEnabled = true
                        
                        lblFoto_2.text = "Cambiar foto"
                    }
                    
                    if foto.idFoto == "Foto3"
                    {
                        let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (foto.nombreFoto)!
                        imgFoto_3.loadImageUsingCacheWithUrlString(pathString: path)
                        
                        imgFoto_3.translatesAutoresizingMaskIntoConstraints = false
                        imgFoto_3.layer.masksToBounds = true
                        imgFoto_3.contentMode = .scaleAspectFill
                        imgFoto_3.leftAnchor.constraint(equalTo: imgFoto_3.leftAnchor, constant: 8).isActive = true
                        imgFoto_3.centerYAnchor.constraint(equalTo: imgFoto_3.centerYAnchor).isActive = true
                        imgFoto_3.widthAnchor.constraint(equalToConstant: imgFoto_3.frame.width).isActive = true
                        imgFoto_3.heightAnchor.constraint(equalToConstant: imgFoto_3.frame.height).isActive = true
                        
                        btnFoto_3 .setImage(nil, for: .normal)
                        btnFoto_3.isEnabled = true
                        
                        btnFoto_4.isEnabled = true
                        
                        lblFoto_3.text = "Cambiar foto"
                    }
                    
                    if foto.idFoto == "Foto4"
                    {
                        let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (foto.nombreFoto)!
                        imgFoto_4.loadImageUsingCacheWithUrlString(pathString: path)
                        
                        imgFoto_4.translatesAutoresizingMaskIntoConstraints = false
                        imgFoto_4.layer.masksToBounds = true
                        imgFoto_4.contentMode = .scaleAspectFill
                        imgFoto_4.leftAnchor.constraint(equalTo: imgFoto_4.leftAnchor, constant: 8).isActive = true
                        imgFoto_4.centerYAnchor.constraint(equalTo: imgFoto_4.centerYAnchor).isActive = true
                        imgFoto_4.widthAnchor.constraint(equalToConstant: imgFoto_4.frame.width).isActive = true
                        imgFoto_4.heightAnchor.constraint(equalToConstant: imgFoto_4.frame.height).isActive = true
                        
                        btnFoto_4 .setImage(nil, for: .normal)
                        btnFoto_4.isEnabled = true
                        
                        btnFoto_5.isEnabled = true
                        
                        lblFoto_4.text = "Cambiar foto"
                    }
                    
                    if foto.idFoto == "Foto5"
                    {
                        let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (foto.nombreFoto)!
                        imgFoto_5.loadImageUsingCacheWithUrlString(pathString: path)
                        
                        imgFoto_5.translatesAutoresizingMaskIntoConstraints = false
                        imgFoto_5.layer.masksToBounds = true
                        imgFoto_5.contentMode = .scaleAspectFill
                        imgFoto_5.leftAnchor.constraint(equalTo: imgFoto_5.leftAnchor, constant: 8).isActive = true
                        imgFoto_5.centerYAnchor.constraint(equalTo: imgFoto_5.centerYAnchor).isActive = true
                        imgFoto_5.widthAnchor.constraint(equalToConstant: imgFoto_5.frame.width).isActive = true
                        imgFoto_5.heightAnchor.constraint(equalToConstant: imgFoto_5.frame.height).isActive = true
                        
                        btnFoto_5 .setImage(nil, for: .normal)
                        btnFoto_5.isEnabled = true
                        
                        btnFoto_6.isEnabled = true
                        
                        lblFoto_5.text = "Cambiar foto"
                    }
                    
                    if foto.idFoto == "Foto6"
                    {
                        let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (foto.nombreFoto)!
                        imgFoto_6.loadImageUsingCacheWithUrlString(pathString: path)
                        
                        imgFoto_6.translatesAutoresizingMaskIntoConstraints = false
                        imgFoto_6.layer.masksToBounds = true
                        imgFoto_6.contentMode = .scaleAspectFill
                        imgFoto_6.leftAnchor.constraint(equalTo: imgFoto_6.leftAnchor, constant: 8).isActive = true
                        imgFoto_6.centerYAnchor.constraint(equalTo: imgFoto_6.centerYAnchor).isActive = true
                        imgFoto_6.widthAnchor.constraint(equalToConstant: imgFoto_6.frame.width).isActive = true
                        imgFoto_6.heightAnchor.constraint(equalToConstant: imgFoto_6.frame.height).isActive = true
                        
                        btnFoto_6 .setImage(nil, for: .normal)
                        btnFoto_6.isEnabled = true
                        
                        lblFoto_6.text = "Cambiar foto"
                    }
                }
            }
            
        }else
        {
            barItemTitulo.title = "Nueva publicación"
            btnFinalizar.setTitle("Finalizar", for: .normal)
            btnFinalizar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            btnFinalizar.isEnabled = false
        }
    }
    
    @IBAction func cargarEditarFoto(_ sender: AnyObject)
    {
        let btnFoto:UIButton = sender as! UIButton
        
        switch btnFoto.tag
        {
        case 1:
            imgGenerica = imgFoto_1
            btnGenerico = btnFoto_1
            lblGenerico = lblFoto_1
        case 2:
            imgGenerica = imgFoto_2
            btnGenerico = btnFoto_2
            lblGenerico = lblFoto_2
        case 3:
            imgGenerica = imgFoto_3
            btnGenerico = btnFoto_3
            lblGenerico = lblFoto_3
        case 4:
            imgGenerica = imgFoto_4
            btnGenerico = btnFoto_4
            lblGenerico = lblFoto_4
        case 5:
            imgGenerica = imgFoto_5
            btnGenerico = btnFoto_5
            lblGenerico = lblFoto_5
        case 6:
            imgGenerica = imgFoto_6
            btnGenerico = btnFoto_6
            lblGenerico = lblFoto_6
        
        default:
            print("Nothing")
        }
        
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
            imgGenerica.image = self.resizeImage(pickedImage, newWidth: 200.0)
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgGenerica.image = self.resizeImage(pickedImage, newWidth: 200.0)
        } else {
            imgGenerica.image = nil
        }
        
        imgGenerica.translatesAutoresizingMaskIntoConstraints = false
        imgGenerica.layer.masksToBounds = true
        imgGenerica.contentMode = .scaleAspectFill
        imgGenerica.leftAnchor.constraint(equalTo: imgGenerica.leftAnchor, constant: 8).isActive = true
        imgGenerica.centerYAnchor.constraint(equalTo: imgGenerica.centerYAnchor).isActive = true
        imgGenerica.widthAnchor.constraint(equalToConstant: imgGenerica.frame.width).isActive = true
        imgGenerica.heightAnchor.constraint(equalToConstant: imgGenerica.frame.height).isActive = true
        
        btnGenerico .setImage(nil, for: .normal)
        lblGenerico.text = "Cambiar foto"
        
        switch btnGenerico.tag
        {
        case 1:
            let fotoPublicacion = Foto()
            
            if (model.publicacion.fotos?.count)! == 0
            {
                fotoPublicacion.idFoto = "Foto1"
                fotoPublicacion.nombreFoto = "Foto1.png"
                model.publicacion.fotos?.append(fotoPublicacion)
            }else
            {
                fotoPublicacion.idFoto = "Foto1"
                fotoPublicacion.nombreFoto = "Foto1.png"
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!)
                
                let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (fotoPublicacion.nombreFoto)!
                imgGenerica.deleteImageCache(pathString: path)
            }
            
            var imageData:NSData? = nil
            imageData = UIImagePNGRepresentation(imgGenerica.image!) as NSData?
            
            DispatchQueue.main.async {
                if imageData != nil {
                    ComandoPublicacion.loadImagenPublicacion(idFoto: self.model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!, fotoData: imageData! as Data)
                }
            }
            
            btnFoto_2.isEnabled = true
            
        case 2:
            let fotoPublicacion = Foto()
            
            if (model.publicacion.fotos?.count)! == 1
            {
                fotoPublicacion.idFoto = "Foto2"
                fotoPublicacion.nombreFoto = "Foto2.png"
                model.publicacion.fotos?.append(fotoPublicacion)
                
                imgAddInEdition_2 = true
            }else
            {
                fotoPublicacion.idFoto = "Foto2"
                fotoPublicacion.nombreFoto = "Foto2.png"
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!)
                
                let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (fotoPublicacion.nombreFoto)!
                imgGenerica.deleteImageCache(pathString: path)
            }
            
            var imageData:NSData? = nil
            imageData = UIImagePNGRepresentation(imgGenerica.image!) as NSData?
            
            DispatchQueue.main.async {
                if imageData != nil {
                    ComandoPublicacion.loadImagenPublicacion(idFoto: self.model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!, fotoData: imageData! as Data)
                }
            }
            
            btnFoto_3.isEnabled = true
            
        case 3:
            let fotoPublicacion = Foto()
            
            if (model.publicacion.fotos?.count)! == 2
            {
                fotoPublicacion.idFoto = "Foto3"
                fotoPublicacion.nombreFoto = "Foto3.png"
                model.publicacion.fotos?.append(fotoPublicacion)
                
                imgAddInEdition_3 = true
            }else
            {
                fotoPublicacion.idFoto = "Foto3"
                fotoPublicacion.nombreFoto = "Foto3.png"
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!)
                
                let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (fotoPublicacion.nombreFoto)!
                imgGenerica.deleteImageCache(pathString: path)
            }
            
            var imageData:NSData? = nil
            imageData = UIImagePNGRepresentation(imgGenerica.image!) as NSData?
            
            DispatchQueue.main.async {
                if imageData != nil {
                    ComandoPublicacion.loadImagenPublicacion(idFoto: self.model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!, fotoData: imageData! as Data)
                }
            }
            
            btnFoto_4.isEnabled = true
            
        case 4:
            let fotoPublicacion = Foto()
            
            if (model.publicacion.fotos?.count)! == 3
            {
                fotoPublicacion.idFoto = "Foto4"
                fotoPublicacion.nombreFoto = "Foto4.png"
                model.publicacion.fotos?.append(fotoPublicacion)
                
                imgAddInEdition_4 = true
            }else
            {
                fotoPublicacion.idFoto = "Foto4"
                fotoPublicacion.nombreFoto = "Foto4.png"
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!)
                
                let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (fotoPublicacion.nombreFoto)!
                imgGenerica.deleteImageCache(pathString: path)
            }
            
            var imageData:NSData? = nil
            imageData = UIImagePNGRepresentation(imgGenerica.image!) as NSData?
            
            DispatchQueue.main.async {
                if imageData != nil {
                    ComandoPublicacion.loadImagenPublicacion(idFoto: self.model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!, fotoData: imageData! as Data)
                }
            }
            
            btnFoto_5.isEnabled = true
            
        case 5:
            let fotoPublicacion = Foto()
            
            if (model.publicacion.fotos?.count)! == 4
            {
                fotoPublicacion.idFoto = "Foto5"
                fotoPublicacion.nombreFoto = "Foto5.png"
                model.publicacion.fotos?.append(fotoPublicacion)
                
                imgAddInEdition_5 = true
            }else
            {
                fotoPublicacion.idFoto = "Foto5"
                fotoPublicacion.nombreFoto = "Foto5.png"
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!)
                
                let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (fotoPublicacion.nombreFoto)!
                imgGenerica.deleteImageCache(pathString: path)
            }
            
            var imageData:NSData? = nil
            imageData = UIImagePNGRepresentation(imgGenerica.image!) as NSData?
            
            DispatchQueue.main.async {
                if imageData != nil {
                    ComandoPublicacion.loadImagenPublicacion(idFoto: self.model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!, fotoData: imageData! as Data)
                }
            }
            
            btnFoto_6.isEnabled = true
            
        case 6:
            let fotoPublicacion = Foto()
            
            if (model.publicacion.fotos?.count)! == 5
            {
                fotoPublicacion.idFoto = "Foto6"
                fotoPublicacion.nombreFoto = "Foto6.png"
                model.publicacion.fotos?.append(fotoPublicacion)
                
                imgAddInEdition_6 = true
            }else
            {
                fotoPublicacion.idFoto = "Foto6"
                fotoPublicacion.nombreFoto = "Foto6.png"
                ComandoPublicacion.deleteImagenesPublicacion(idFoto: model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!)
                
                let path = "productos/" + (model.publicacion.idPublicacion)! + "/" + (fotoPublicacion.nombreFoto)!
                imgGenerica.deleteImageCache(pathString: path)
            }
            
            var imageData:NSData? = nil
            imageData = UIImagePNGRepresentation(imgGenerica.image!) as NSData?
            
            DispatchQueue.main.async {
                if imageData != nil {
                    ComandoPublicacion.loadImagenPublicacion(idFoto: self.model.publicacion.idPublicacion!, nombreFoto: fotoPublicacion.nombreFoto!, fotoData: imageData! as Data)
                }
            }
            
        default:
            print("Nothing")
        }
        
        btnFinalizar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
        btnFinalizar.isEnabled = true
        
        dismiss(animated: true, completion: nil)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finalizarPublicacion(_ sender: Any)
    {
        if datosEditables
        {
            ComandoPublicacion.updateFotos(idPublicacion: model.publicacion.idPublicacion!)
            dismiss(animated: true, completion: nil)
        } else
        {
            let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
            
            connectedRef.observe(.value, with: { snapshot in
                if let connected = snapshot.value as? Bool, connected {
                    self .confirmarPublicacion()
                } else {
                    self.mostrarAlerta(titulo: "Sin conexión", mensaje: "No detectamos conexión a internet, por favor valida tu señal para poder guardar tu publicación.")
                }
            })
        }
    }
    
    func confirmarPublicacion()
    {
        let  user = FIRAuth.auth()?.currentUser
        
        model.publicacion.idOferente = (user?.uid)!
        model.publicacion.activo = true
        model.publicacion.destacado = false
        
        model.publicacionOferente.removeAll()
        
        model.publicacionOferente.append(model.publicacion)
        
        ComandoPublicacion.crearPublicacionOferente(publicacion: model.publicacionOferente[0])
        
        let alert:UIAlertController = UIAlertController(title: "¡Publicación exitosa!", message: "Has finalizado tu publicación, puedes verla o volver al inicio", preferredStyle: .alert)
        
        let verAction = UIAlertAction(title: "Ver publicación", style: .default)
        {
            UIAlertAction in self .verPublicacion()
        }
        
        let volverAction = UIAlertAction(title: "Ir al inicio", style: .default)
        {
            UIAlertAction in self .volverInicio()
        }
        
        // Add the actions
        alert.addAction(verAction)
        alert.addAction(volverAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func verPublicacion()
    {
        self.performSegue(withIdentifier: "verDetallePublicacionDesdeNuevaPublicacion", sender: self)
    }
    
    func volverInicio()
    {
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.publicacionOferente.removeAll()
        
        self.performSegue(withIdentifier: "returnHomeOferenteDesdePublicacionCuatro", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "verDetallePublicacionDesdeNuevaPublicacion")
        {
            let detailController = segue.destination as! DetallePublicacionOferenteViewController
            detailController.vistoDesde = "NuevaPublicacion"
        }
    }

    func mostrarAlerta(titulo:String, mensaje:String)
    {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            return
        }
        
        alerta.addAction(OKAction)
        present(alerta, animated: true, completion: { return })
    }
}
