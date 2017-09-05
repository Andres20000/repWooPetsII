//
//  TuMascotaViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 11/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

import Firebase

class TuMascotaViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let model = Modelo.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    
    let  user = FIRAuth.auth()?.currentUser
    
    let pickerTipoMascota = UIPickerView()
    let pickerRazaMascota = UIPickerView()
    let pickerGenero = UIPickerView()
    var genero = ["Chica", "Chico"]
    var datePicker = UIDatePicker()
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceBottomLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var heightEqualsAceptarLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var heightEqualsCancelarLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var imgFotoMascota: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var lblNombreMascota: UILabel!
    @IBOutlet var txtNombreMascota: UITextField!
    
    @IBOutlet var lblTipoMascota: UILabel!
    @IBOutlet var txtTipoMascota: UITextField!
    
    @IBOutlet var lblRaza: UILabel!
    @IBOutlet var txtRaza: UITextField!
    
    @IBOutlet var lblGenero: UILabel!
    @IBOutlet var txtGenero: UITextField!
    
    @IBOutlet var lblFechaNacimiento: UILabel!
    @IBOutlet var txtFechaNacimiento: UITextField!
    
    @IBOutlet var lblEdad: UILabel!
    @IBOutlet var txtEdad: UITextField!
    
    @IBOutlet var btnAceptar: UIButton!
    @IBOutlet var btnCancelar: UIButton!
    
    var datosEditables:Bool = false
    var changeFoto:Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        self .abandonar()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DeviceType.IS_IPHONE_5
        {
            imgFotoMascota.layer.cornerRadius = 60
        }else
        {
            if DeviceType.IS_IPHONE_6
            {
                imgFotoMascota.layer.cornerRadius = imgFotoMascota.frame.height / 2
            }else
            {
                imgFotoMascota.layer.cornerRadius = 80
            }
        }
        
        if datosEditables
        {
            changeFoto = false
            
            if modelUsuario.tuMascota.foto == ""
            {
                imgFotoMascota.image = UIImage(named: "btnFotoMascota")
            } else
            {
                let path = "mascotas/" + (user?.uid)! + "/" + (modelUsuario.tuMascota.idMascota)! + "/" + (modelUsuario.tuMascota.foto)!
                
                imgFotoMascota.loadImageUsingCacheWithUrlString(pathString: path)
                
                imgFotoMascota.translatesAutoresizingMaskIntoConstraints = false
                imgFotoMascota.layer.masksToBounds = true
                imgFotoMascota.contentMode = .scaleAspectFill
                imgFotoMascota.leftAnchor.constraint(equalTo: imgFotoMascota.leftAnchor, constant: 8).isActive = true
                imgFotoMascota.centerYAnchor.constraint(equalTo: imgFotoMascota.centerYAnchor).isActive = true
                imgFotoMascota.widthAnchor.constraint(equalToConstant: imgFotoMascota.frame.width).isActive = true
                imgFotoMascota.heightAnchor.constraint(equalToConstant: imgFotoMascota.frame.height).isActive = true
            }
            
            txtNombreMascota.text = modelUsuario.tuMascota.nombre
            txtTipoMascota.text = modelUsuario.tuMascota.tipo
            lblRaza.textColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0)
            txtRaza.text = modelUsuario.tuMascota.raza
            txtRaza.isEnabled = true
            txtGenero.text = modelUsuario.tuMascota.genero
            txtFechaNacimiento.text = modelUsuario.tuMascota.fechaNacimiento
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yyyy"
            let birthdayDate = dateFormater.date(from: modelUsuario.tuMascota.fechaNacimiento!)
            self.datePicker.date = birthdayDate!
            
            let yearDate = Comando.calcularEdadEnAños(birthday: datePicker.date as NSDate)
            var textYear:String?
            
            if yearDate == 1
            {
                textYear = "año"
            } else
            {
                textYear = "años"
            }
            
            let monthDate = Comando.calcularEdadEnMeses(birthday: datePicker.date as NSDate) - (yearDate * 12)
            var textMonth:String?
            
            if monthDate == 1
            {
                textMonth = "mes"
            } else
            {
                textMonth = "meses"
            }
            
            txtEdad.text = "\(yearDate) \(textYear!),      \(monthDate) \(textMonth!)"
            
            btnAceptar.setTitle("Editar", for: .normal)
            
        }else
        {
            let  user = FIRAuth.auth()?.currentUser
            
            if user != nil
            {
                modelUsuario.tuMascota.idMascota = ComandoUsuario.crearIdMascotaUsuario(uid: (user?.uid)!)
            }
            
            modelUsuario.tuMascota.foto = ""
            txtRaza.isEnabled = false
        }
        
        imagePicker.delegate = self
    }
    
    @IBAction func cargarEditarFoto(_ sender: AnyObject)
    {
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
            imgFotoMascota.image = self.resizeImage(pickedImage, newWidth: 200.0)
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgFotoMascota.image = self.resizeImage(pickedImage, newWidth: 200.0)
        } else {
            imgFotoMascota.image = nil
        }
        
        imgFotoMascota.translatesAutoresizingMaskIntoConstraints = false
        imgFotoMascota.layer.masksToBounds = true
        imgFotoMascota.contentMode = .scaleAspectFill
        imgFotoMascota.leftAnchor.constraint(equalTo: imgFotoMascota.leftAnchor, constant: 8).isActive = true
        imgFotoMascota.centerYAnchor.constraint(equalTo: imgFotoMascota.centerYAnchor).isActive = true
        imgFotoMascota.widthAnchor.constraint(equalToConstant: imgFotoMascota.frame.width).isActive = true
        imgFotoMascota.heightAnchor.constraint(equalToConstant: imgFotoMascota.frame.height).isActive = true
        
        if datosEditables
        {
            changeFoto = true
            
        } else
        {
            modelUsuario.tuMascota.foto = "FotoTuMascota"
        }
        
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
    
    func cargarDatos(_ notification: Notification)
    {
        pickerTipoMascota.delegate = self
        pickerTipoMascota.dataSource = self as? UIPickerViewDataSource
        pickerTipoMascota.tag = 1
        
        txtTipoMascota.inputView = pickerTipoMascota
        
        pickerRazaMascota.delegate = self
        pickerRazaMascota.dataSource = self as? UIPickerViewDataSource
        pickerRazaMascota.tag = 2
        
        txtRaza.inputView = pickerRazaMascota
        
        pickerGenero.delegate = self
        pickerGenero.dataSource = self as? UIPickerViewDataSource
        pickerGenero.tag = 3
        
        txtGenero.inputView = pickerGenero
    }
    
    // #pragma mark - pickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 1
        {
            return model.tiposMascota.count
        }
        
        if pickerView.tag == 2
        {
            if txtTipoMascota.text == "Perro"
            {
                return model.razasPerro.count
            }
            
            if txtTipoMascota.text == "Gato"
            {
                return model.razasGato.count
            }
        }
        
        if pickerView.tag == 3
        {
            return genero.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var dato:String?
        
        if pickerView.tag == 1
        {
            dato = model.tiposMascota[row].nombreTipo
        }
        
        if pickerView.tag == 2
        {
            if txtTipoMascota.text == "Perro"
            {
                dato = model.razasPerro[row].nombreRaza
            }
            
            if txtTipoMascota.text == "Gato"
            {
                dato = model.razasGato[row].nombreRaza
            }
        }
        
        if pickerView.tag == 3
        {
            dato = genero[row]
        }
        
        return dato
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1
        {
            txtTipoMascota.text = model.tiposMascota[row].nombreTipo
            
            if txtTipoMascota.text == "Perro" || txtTipoMascota.text == "Gato"
            {
                txtRaza.isEnabled = true
                
                if txtRaza.text != ""
                {
                    txtRaza.text = ""
                }
                
                modelUsuario.tuMascota.raza = txtRaza.text
            }else
            {
                txtRaza.isEnabled = false
                txtRaza.text = "No aplica"
                
                modelUsuario.tuMascota.raza = txtRaza.text
            }
        }
        
        if pickerView.tag == 2
        {
            if txtTipoMascota.text == "Perro"
            {
                txtRaza.text = model.razasPerro[row].nombreRaza
            }
            
            if txtTipoMascota.text == "Gato"
            {
                txtRaza.text = model.razasGato[row].nombreRaza
            }
        }
        
        if pickerView.tag == 3
        {
            txtGenero.text = genero[row]
        }
    }
    
    // #pragma mark - DatePicker
    
    func pickUpDate(_ textField : UITextField)
    {
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.maximumDate = NSDate() as Date
        self.datePicker.addTarget(self, action: #selector(TuMascotaViewController.actualizarTextField), for: .valueChanged)
        textField.inputView = self.datePicker
    }
    
    func actualizarTextField()
    {
        txtFechaNacimiento.text = datePicker.date.fechaString()
        
        let yearDate = Comando.calcularEdadEnAños(birthday: datePicker.date as NSDate)
        var textYear:String?
        
        if yearDate == 1
        {
            textYear = "año"
        } else
        {
            textYear = "años"
        }
        
        let monthDate = Comando.calcularEdadEnMeses(birthday: datePicker.date as NSDate) - (yearDate * 12)
        var textMonth:String?
        
        if monthDate == 1
        {
            textMonth = "mes"
        } else
        {
            textMonth = "meses"
        }
        
        txtEdad.text = "\(yearDate) \(textYear!),      \(monthDate) \(textMonth!)"
    }
    
    // #pragma mark - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        animateViewMoving(up: true, moveValue: 150)
        
        if textField.tag == 2
        {
            lblRaza.textColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0)
            
            if textField.text == ""
            {
                textField.text = model.tiposMascota[0].nombreTipo
                txtRaza.isEnabled = false
                txtRaza.text = "No aplica"
                modelUsuario.tuMascota.raza = txtRaza.text
            }
        }
        
        if textField.tag == 3
        {
            if textField.text == ""
            {
                pickerRazaMascota.selectRow(0, inComponent: 0, animated: true)
                
                if txtTipoMascota.text == "Perro"
                {
                    textField.text = model.razasPerro[0].nombreRaza
                }
                
                if txtTipoMascota.text == "Gato"
                {
                    textField.text = model.razasGato[0].nombreRaza
                }
            }
        }
        
        if textField.tag == 4
        {
            if textField.text == ""
            {
                textField.text = genero[0]
            }
        }
        
        if textField.tag == 5
        {
            self .pickUpDate(textField)
            
            if textField.text != ""
            {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd/MM/yyyy"
                let birthdayDate = dateFormater.date(from: modelUsuario.tuMascota.fechaNacimiento!)
                self.datePicker.date = birthdayDate!
            }
            
            textField.text = datePicker.date.fechaString()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(up: false, moveValue: 150)
        
        if textField.tag == 1
        {
            modelUsuario.tuMascota.nombre = textField.text
        }
        
        if textField.tag == 2
        {
            modelUsuario.tuMascota.tipo = textField.text
        }
        
        if textField.tag == 3
        {
            modelUsuario.tuMascota.raza = textField.text
        }
        
        if textField.tag == 4
        {
            modelUsuario.tuMascota.genero = textField.text
        }
        
        if textField.tag == 5
        {
            modelUsuario.tuMascota.fechaNacimiento = textField.text
        }
    }
    
    @IBAction func aceptarEditarMascota(_ sender: Any)
    {
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.crearEditarPerfil()
            } else {
                self.mostrarAlerta(titulo: "Sin conexión", mensaje: "No detectamos conexión a internet, por favor valida tu señal para poder terminar tu registro.")
            }
        })
    }
    
    func crearEditarPerfil()
    {
        if datosEditables
        {
            if modelUsuario.tuMascota.fechaNacimiento == "" || modelUsuario.tuMascota.genero == "" || modelUsuario.tuMascota.nombre == "" || modelUsuario.tuMascota.raza == "" || modelUsuario.tuMascota.tipo == ""
            {
                self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
            } else
            {
                if changeFoto
                {
                    if modelUsuario.tuMascota.foto != ""
                    {
                        ComandoUsuario.deleteFotoMascota(uid: (user?.uid)!, idMascota: modelUsuario.tuMascota.idMascota!, nombreFoto: modelUsuario.tuMascota.foto!)
                        
                        let path = "mascotas/" + (user?.uid)! + "/" + modelUsuario.tuMascota.idMascota! + "/" + modelUsuario.tuMascota.foto!
                        imgFotoMascota.deleteImageCache(pathString: path)
                    }
                    
                    modelUsuario.tuMascota.foto = "FotoTuMascota"
                    
                    var imageData:NSData? = nil
                    imageData = UIImagePNGRepresentation(imgFotoMascota.image!) as NSData?
                    
                    DispatchQueue.main.async {
                        if imageData != nil {
                            ComandoUsuario.loadFotoMascota(uid: (self.user?.uid)!, idMascota: self.modelUsuario.tuMascota.idMascota!, nombreFoto: self.modelUsuario.tuMascota.foto!, fotoData: imageData! as Data)
                        }
                    }
                    
                }
                
                ComandoUsuario.crearEditarMascota(uid: (user?.uid)!, mascota: modelUsuario.tuMascota)
                
                ComandoUsuario.getUsuario(uid: (user?.uid)!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(TuMascotaViewController.cargarMascotas(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
            }
            
        }else
        {
            if modelUsuario.tuMascota.fechaNacimiento == "" || modelUsuario.tuMascota.genero == "" || modelUsuario.tuMascota.nombre == "" || modelUsuario.tuMascota.raza == "" || modelUsuario.tuMascota.tipo == ""
            {
                self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
            } else
            {
                if modelUsuario.usuario[0].datosComplementarios?[0].mascotas?.count == 0
                {
                    modelUsuario.tuMascota.activa = true
                }else
                {
                    modelUsuario.tuMascota.activa = false
                }
                
                if modelUsuario.tuMascota.foto != ""
                {
                    var imageData:NSData? = nil
                    imageData = UIImagePNGRepresentation(imgFotoMascota.image!) as NSData?
                    
                    DispatchQueue.main.async {
                        if imageData != nil {
                            ComandoUsuario.loadFotoMascota(uid: (self.user?.uid)!, idMascota: self.modelUsuario.tuMascota.idMascota!, nombreFoto: self.modelUsuario.tuMascota.foto!, fotoData: imageData! as Data)
                        }
                    }
                }
                
                ComandoUsuario.crearEditarMascota(uid: (user?.uid)!, mascota: modelUsuario.tuMascota)
                
                ComandoUsuario.getUsuario(uid: (user?.uid)!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(TuMascotaViewController.cargarMascotas(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
            }
        }
    }
    
    func cargarMascotas(_ notification: Notification)
    {
        self.performSegue(withIdentifier: "administrarMascotasDesdeTuMascota", sender: self)
    }
    
    @IBAction func cancelar(_ sender: Any)
    {
        let alert:UIAlertController = UIAlertController(title: "¡Confirmar!", message: "¿Está seguro de abandonar la vista?", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "Sí", style: .default)
        {
            UIAlertAction in self.abandonar()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(continuarAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func abandonar()
    {
        modelUsuario.tuMascota.foto = ""
        modelUsuario.tuMascota.nombre = ""
        modelUsuario.tuMascota.tipo = ""
        modelUsuario.tuMascota.raza = ""
        modelUsuario.tuMascota.genero = ""
        modelUsuario.tuMascota.fechaNacimiento = ""
        modelUsuario.tuMascota.idMascota = ""
        modelUsuario.tuMascota.activa = false
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        lblNombreMascota.layer.masksToBounds = true
        lblNombreMascota.layer.cornerRadius = 5.0
        
        let spacerViewTxtNombreMascota = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        txtNombreMascota.rightViewMode = UITextFieldViewMode.always
        txtNombreMascota.rightView = spacerViewTxtNombreMascota
        
        lblTipoMascota.layer.masksToBounds = true
        lblTipoMascota.layer.cornerRadius = 5.0
        
        let spacerViewTxtTipoMascota = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        txtTipoMascota.rightViewMode = UITextFieldViewMode.always
        txtTipoMascota.rightView = spacerViewTxtTipoMascota
        self .toolBarTextField(txtTipoMascota)
        
        lblRaza.layer.masksToBounds = true
        lblRaza.layer.cornerRadius = 5.0
        
        let spacerViewTxtRaza = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        txtRaza.rightViewMode = UITextFieldViewMode.always
        txtRaza.rightView = spacerViewTxtRaza
        self .toolBarTextField(txtRaza)
        
        lblGenero.layer.masksToBounds = true
        lblGenero.layer.cornerRadius = 5.0
        
        let spacerViewTxtGenero = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        txtGenero.rightViewMode = UITextFieldViewMode.always
        txtGenero.rightView = spacerViewTxtGenero
        self .toolBarTextField(txtGenero)
        
        lblFechaNacimiento.layer.masksToBounds = true
        lblFechaNacimiento.layer.cornerRadius = 5.0
        
        let spacerViewTxtFechaNacimiento = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        txtFechaNacimiento.rightViewMode = UITextFieldViewMode.always
        txtFechaNacimiento.rightView = spacerViewTxtFechaNacimiento
        self .toolBarTextField(txtFechaNacimiento)
        
        lblEdad.layer.masksToBounds = true
        lblEdad.layer.cornerRadius = 5.0
        
        let spacerViewTxtEdad = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        txtEdad.rightViewMode = UITextFieldViewMode.always
        txtEdad.rightView = spacerViewTxtEdad
        
        if DeviceType.IS_IPHONE_5
        {
            self.spaceBottomLayoutConstraint?.constant = 8.0
            self.heightEqualsAceptarLayoutConstraint?.constant = 35.0
            self.heightEqualsCancelarLayoutConstraint?.constant = 35.0
        }
        
        btnAceptar.layer.cornerRadius = 10.0
        btnCancelar.layer.cornerRadius = 10.0
        
        Comando.getTiposMascota()
        Comando.getRazasPerro()
        Comando.getRazasGato()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TuMascotaViewController.cargarDatos(_:)), name:NSNotification.Name(rawValue:"cargoTipoMascotas"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TuMascotaViewController.cargarDatos(_:)), name:NSNotification.Name(rawValue:"cargoRazasPerro"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TuMascotaViewController.cargarDatos(_:)), name:NSNotification.Name(rawValue:"cargoRazasGato"), object: nil)
        
        if user != nil
        {
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(TuMascotaViewController.cargarDatos(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Move show/hide Keypoard
    func animateViewMoving (up:Bool, moveValue :CGFloat)
    {
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
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
    
    // Toolbar in textField
    func toolBarTextField(_ textField : UITextField)
    {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 41/255, green: 184/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    // Button Cancelar Keyboard
    func cancelClick()
    {
        view.endEditing(true)
    }
}
