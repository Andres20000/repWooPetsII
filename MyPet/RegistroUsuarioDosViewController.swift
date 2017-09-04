//
//  RegistroUsuarioDosViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 8/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class RegistroUsuarioDosViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate
{
    var modelUsuario  = ModeloUsuario.sharedInstance
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var scrollContent: UIScrollView!
    var contentSizeScroll:CGFloat = 0.0
    
    @IBOutlet var imgFondo: UIImageView!
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var imgMailFB: UIImageView!
    
    @IBOutlet var txtNombre: UITextField!
    @IBOutlet var txtApellido: UITextField!
    @IBOutlet var txtCedula: UITextField!
    @IBOutlet var txtTelefono: UITextField!
    
    @IBOutlet var viewDireccion1: UIView!
    @IBOutlet var txtDireccion1: UITextField!
    @IBOutlet var txtNombreDireccion1: UITextField!
    @IBOutlet var btnUbicacion1: UIButton!
    @IBOutlet var btnAgregar: UIButton!
    @IBOutlet var btnAgregar2: UIButton!
    @IBOutlet var btnAgregar3: UIButton!
    
    @IBOutlet var viewDireccion2: UIView!
    @IBOutlet var txtDireccion2: UITextField!
    @IBOutlet var txtNombreDireccion2: UITextField!
    @IBOutlet var btnUbicacion2: UIButton!
    @IBOutlet var btnEliminar2: UIButton!
    
    @IBOutlet var viewDireccion3: UIView!
    @IBOutlet var txtDireccion3: UITextField!
    @IBOutlet var txtNombreDireccion3: UITextField!
    @IBOutlet var btnUbicacion3: UIButton!
    @IBOutlet var btnEliminar3: UIButton!
    
    @IBOutlet var btnContinuar: UIButton!
    
    var tieneDireccionDos:Bool = false
    var tieneDireccionTres:Bool = false
    var direccionParaUbicar:Int?
    
    var datosEditables:Bool = false
    
    @IBAction func closeView(_ sender: Any)
    {
        modelUsuario.registroComplementario.apellido = ""
        modelUsuario.registroComplementario.celular = ""
        modelUsuario.registroComplementario.documento = ""
        modelUsuario.registroComplementario.nombre = ""
        modelUsuario.registroComplementario.direcciones?.removeAll()
        
        modelUsuario.direccion1.direccion = ""
        modelUsuario.direccion1.nombre = ""
        modelUsuario.direccion1.ubicacion?.removeAll()
        
        modelUsuario.direccion2.direccion = ""
        modelUsuario.direccion2.nombre = ""
        modelUsuario.direccion2.ubicacion?.removeAll()
        
        modelUsuario.direccion3.direccion = ""
        modelUsuario.direccion3.nombre = ""
        modelUsuario.direccion3.ubicacion?.removeAll()
        
        if datosEditables
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if Comando.validarTipoIngreso()
        {
            imgMailFB.image = UIImage(named: "imgFbOk")
        }else
        {
            imgMailFB.image = UIImage(named: "imgMailOk")
        }
        
        let spacerViewTxtNombre = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtNombre.leftViewMode = UITextFieldViewMode.always
        txtNombre.leftView = spacerViewTxtNombre
        txtNombre.text = ""
        txtNombre.attributedPlaceholder = NSAttributedString(string:"Nombre", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtApellido = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtApellido.leftViewMode = UITextFieldViewMode.always
        txtApellido.leftView = spacerViewTxtApellido
        txtApellido.text = ""
        txtApellido.attributedPlaceholder = NSAttributedString(string:"Apellido", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtCedula = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtCedula.leftViewMode = UITextFieldViewMode.always
        txtCedula.leftView = spacerViewTxtCedula
        txtCedula.text = ""
        txtCedula.attributedPlaceholder = NSAttributedString(string:"No. cédula", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        self.toolBarTextField(txtCedula)
        
        let spacerViewTxtTelefono = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtTelefono.leftViewMode = UITextFieldViewMode.always
        txtTelefono.leftView = spacerViewTxtTelefono
        txtTelefono.text = ""
        txtTelefono.attributedPlaceholder = NSAttributedString(string:"Teléfono celular", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        self.toolBarTextField(txtTelefono)
        
        let spacerViewTxtDireccion1 = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtDireccion1.leftViewMode = UITextFieldViewMode.always
        txtDireccion1.leftView = spacerViewTxtDireccion1
        txtDireccion1.text = ""
        txtDireccion1.attributedPlaceholder = NSAttributedString(string:"Elige tu dirección", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtNombreDireccion1 = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtNombreDireccion1.leftViewMode = UITextFieldViewMode.always
        txtNombreDireccion1.leftView = spacerViewTxtNombreDireccion1
        txtNombreDireccion1.text = ""
        txtNombreDireccion1.attributedPlaceholder = NSAttributedString(string:"Asígnale un nombre al lugar", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtDireccion2 = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtDireccion2.leftViewMode = UITextFieldViewMode.always
        txtDireccion2.leftView = spacerViewTxtDireccion2
        txtDireccion2.text = ""
        txtDireccion2.attributedPlaceholder = NSAttributedString(string:"Elige tu dirección", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtNombreDireccion2 = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtNombreDireccion2.leftViewMode = UITextFieldViewMode.always
        txtNombreDireccion2.leftView = spacerViewTxtNombreDireccion2
        txtNombreDireccion2.text = ""
        txtNombreDireccion2.attributedPlaceholder = NSAttributedString(string:"Asígnale un nombre al lugar", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtDireccion3 = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtDireccion3.leftViewMode = UITextFieldViewMode.always
        txtDireccion3.leftView = spacerViewTxtDireccion3
        txtDireccion3.text = ""
        txtDireccion3.attributedPlaceholder = NSAttributedString(string:"Elige tu dirección", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtNombreDireccion3 = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtNombreDireccion3.leftViewMode = UITextFieldViewMode.always
        txtNombreDireccion3.leftView = spacerViewTxtNombreDireccion3
        txtNombreDireccion3.text = ""
        txtNombreDireccion3.attributedPlaceholder = NSAttributedString(string:"Asígnale un nombre al lugar", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        btnContinuar.layer.cornerRadius = 10.0
        
        modelUsuario.ubicacion1.latitud = 0
        modelUsuario.ubicacion1.longitud = 0
        
        modelUsuario.direccion1.ubicacion?.removeAll()
        modelUsuario.direccion1.ubicacion?.append(modelUsuario.ubicacion1)
        
        modelUsuario.ubicacion2.latitud = 0
        modelUsuario.ubicacion2.longitud = 0
        
        modelUsuario.direccion2.ubicacion?.removeAll()
        modelUsuario.direccion2.ubicacion?.append(modelUsuario.ubicacion2)
        
        modelUsuario.ubicacion3.latitud = 0
        modelUsuario.ubicacion3.longitud = 0
        
        modelUsuario.direccion3.ubicacion?.removeAll()
        modelUsuario.direccion3.ubicacion?.append(modelUsuario.ubicacion3)
        
        if datosEditables
        {
            btnContinuar.setTitle("Editar", for: .normal)
        } else
        {
            btnContinuar.setTitle("Ok, continuar", for: .normal)
        }
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
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(up: false, moveValue: 150)
        
        if textField.tag == 1
        {
            modelUsuario.registroComplementario.nombre = textField.text
        }
        
        if textField.tag == 2
        {
            modelUsuario.registroComplementario.apellido = textField.text
        }
        
        if textField.tag == 3
        {
            modelUsuario.registroComplementario.documento = textField.text
        }
        
        if textField.tag == 4
        {
            modelUsuario.registroComplementario.celular = textField.text
        }
        
        if textField.tag == 5
        {
            modelUsuario.direccion1.direccion = textField.text
        }
        
        if textField.tag == 6
        {
            modelUsuario.direccion1.nombre = textField.text
        }
        
        if textField.tag == 7
        {
            modelUsuario.direccion2.direccion = textField.text
        }
        
        if textField.tag == 8
        {
            modelUsuario.direccion2.nombre = textField.text
        }
        
        if textField.tag == 9
        {
            modelUsuario.direccion3.direccion = textField.text
        }
        
        if textField.tag == 10
        {
            modelUsuario.direccion3.nombre = textField.text
        }
    }
    
    @IBAction func cargarDireccionDos(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if txtDireccion1.text == "" || txtNombreDireccion1.text == ""
        {
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "Si deseas agregar una nueva dirección debes diligenciar los campos de la primera")
        } else
        {
            tieneDireccionDos = true
            
            contentSizeScroll = 845.0 - 140.0
            
            self.spaceTopLayoutConstraint?.constant = 440 - 140
            
            viewDireccion2.isHidden = false
            viewDireccion3.isHidden = true
            
            btnAgregar.isHidden = true
            btnAgregar2.isHidden = true
            btnAgregar3.isHidden = false
            
            self.refreshView()
        }
    }
    
    @IBAction func eliminarDireccionDos(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if tieneDireccionTres
        {
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "No puedes borrar la dirección 2 porque tienes activado la dirección 3")
        } else
        {
            tieneDireccionDos = false
            
            txtDireccion2.text = ""
            txtNombreDireccion2.text = ""
            
            modelUsuario.direccion2.direccion = ""
            modelUsuario.direccion2.nombre = ""
            
            modelUsuario.ubicacion2.latitud = 0.0
            modelUsuario.ubicacion2.longitud = 0.0

            contentSizeScroll = UIScreen.main.bounds.height
            
            if DeviceType.IS_IPHONE_5
            {
                self.spaceTopLayoutConstraint?.constant = 150
            }else
            {
                self.spaceTopLayoutConstraint?.constant = 200
            }
            
            viewDireccion2.isHidden = true
            viewDireccion3.isHidden = true
            
            btnAgregar.isHidden = true
            btnAgregar2.isHidden = false
            btnAgregar3.isHidden = true
            
            self .refreshView()
        }
    }
    
    @IBAction func cargarDireccionTres(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if txtDireccion2.text == "" || txtNombreDireccion2.text == ""
        {
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "Si deseas agregar una nueva dirección debes diligenciar los campos de la segunda")
        } else
        {
            tieneDireccionTres = true
            
            contentSizeScroll = 845.0
            
            self.spaceTopLayoutConstraint?.constant = 440
            
            viewDireccion2.isHidden = false
            viewDireccion3.isHidden = false
            
            btnAgregar.isHidden = false
            btnAgregar2.isHidden = true
            btnAgregar3.isHidden = true
            
            self.refreshView()
        }
    }
    
    @IBAction func eliminarDireccionTres(_ sender: Any)
    {
        self.view.endEditing(true)
        
        tieneDireccionTres = false
        
        txtDireccion3.text = ""
        txtNombreDireccion3.text = ""
        
        modelUsuario.direccion3.direccion = ""
        modelUsuario.direccion3.nombre = ""
        
        modelUsuario.ubicacion3.latitud = 0.0
        modelUsuario.ubicacion3.longitud = 0.0
        
        contentSizeScroll = 845.0 - 140.0
        
        self.spaceTopLayoutConstraint?.constant = 440 - 140
        
        viewDireccion2.isHidden = false
        viewDireccion3.isHidden = true
        
        btnAgregar.isHidden = true
        btnAgregar2.isHidden = true
        btnAgregar3.isHidden = false
        
        self .refreshView()
    }
    
    @IBAction func cargarDireccion(_ sender: Any)
    {
        self.mostrarAlerta(titulo: "Advertencia", mensaje: "Sólo puedes agregar máximo tres direcciones")
    }
    
    @IBAction func registrarUbicacion(_ sender: Any)
    {
        let btnUbicacion:UIButton = sender as! UIButton
        
        direccionParaUbicar = btnUbicacion.tag
        
        self.performSegue(withIdentifier: "ubicacionDesdeRegistroUsuario", sender: self)
    }
    
    @IBAction func continuarCompletarDatos(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if datosEditables
        {
            print("Editar")
        } else
        {
            if modelUsuario.registroComplementario.apellido == "" || modelUsuario.registroComplementario.celular == "" || modelUsuario.registroComplementario.documento == "" || modelUsuario.registroComplementario.nombre == "" || modelUsuario.direccion1.direccion == "" || modelUsuario.direccion1.nombre == ""
            {
                self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
                
                return
            }
            
            if tieneDireccionDos
            {
                if modelUsuario.direccion2.direccion == "" || modelUsuario.direccion2.nombre == ""
                {
                    self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
                    
                    return
                }
            }
            
            if tieneDireccionTres
            {
                if modelUsuario.direccion3.direccion == "" || modelUsuario.direccion3.nombre == ""
                {
                    self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
                    
                    return
                }
            }
            
            modelUsuario.registroComplementario.direcciones?.removeAll()
            
            modelUsuario.direccion1.porDefecto = true
            modelUsuario.registroComplementario.direcciones?.append(modelUsuario.direccion1)
            
            if tieneDireccionDos
            {
                modelUsuario.direccion2.porDefecto = false
                modelUsuario.registroComplementario.direcciones?.append(modelUsuario.direccion2)
            }
            
            if tieneDireccionTres
            {
                modelUsuario.direccion3.porDefecto = false
                modelUsuario.registroComplementario.direcciones?.append(modelUsuario.direccion3)
            }
            
            self.performSegue(withIdentifier: "completarRegistroTresDesdecompletarRegistroDos", sender: self)
        }
    }
    
    func refreshView()
    {
        txtApellido.text = modelUsuario.registroComplementario.apellido
        txtTelefono.text = modelUsuario.registroComplementario.celular
        txtCedula.text = modelUsuario.registroComplementario.documento
        txtNombre.text = modelUsuario.registroComplementario.nombre
        
        txtDireccion1.text = modelUsuario.direccion1.direccion
        txtNombreDireccion1.text = modelUsuario.direccion1.nombre
        
        txtDireccion2.text = modelUsuario.direccion2.direccion
        txtNombreDireccion2.text = modelUsuario.direccion2.nombre
        
        txtDireccion3.text = modelUsuario.direccion3.direccion
        txtNombreDireccion3.text = modelUsuario.direccion3.nombre
        
        if modelUsuario.direccion1.ubicacion?[0].latitud == 0
        {
            btnUbicacion1.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            btnUbicacion1.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
        }
        
        if modelUsuario.direccion2.ubicacion?[0].latitud == 0
        {
            btnUbicacion2.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            btnUbicacion2.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
        }
        
        if modelUsuario.direccion3.ubicacion?[0].latitud == 0
        {
            btnUbicacion3.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            btnUbicacion3.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
        }
        
        if txtDireccion1.text == "" || txtNombreDireccion1.text == ""
        {
            contentSizeScroll = UIScreen.main.bounds.height
            
            if DeviceType.IS_IPHONE_5
            {
                self.spaceTopLayoutConstraint?.constant = 150
            }else
            {
                self.spaceTopLayoutConstraint?.constant = 200
            }
            
            viewDireccion2.isHidden = true
            viewDireccion3.isHidden = true
            
            btnAgregar.isHidden = true
            btnAgregar2.isHidden = false
            btnAgregar3.isHidden = true
        }
        
        scrollContent.bounces = false
        scrollContent.isScrollEnabled = true
        
        scrollContent.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollContent.contentSize = CGSize.init(width: scrollContent.frame.width, height: contentSizeScroll)
        
        imgFondo.frame = CGRect.init(x: 0.0, y: 0.0, width: scrollContent.contentSize.width, height: scrollContent.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self .refreshView()
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
        
        if (segue.identifier == "ubicacionDesdeRegistroUsuario")
        {
            let detailController = segue.destination as! UbicacionViewController
            detailController.ubicarDireccion = direccionParaUbicar
        }
    }
    
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
        let cancelButton = UIBarButtonItem(title: "Ocultar", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
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
