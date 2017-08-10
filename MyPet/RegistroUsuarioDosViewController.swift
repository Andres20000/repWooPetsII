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
    var model  = ModeloUsuario.sharedInstance
    
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
        model.registroComplementario.apellido = ""
        model.registroComplementario.celular = ""
        model.registroComplementario.documento = ""
        model.registroComplementario.nombre = ""
        model.registroComplementario.direcciones?.removeAll()
        
        model.direccion1.direccion = ""
        model.direccion1.nombre = ""
        
        model.direccion2.direccion = ""
        model.direccion2.nombre = ""
        
        model.direccion3.direccion = ""
        model.direccion3.nombre = ""
        
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
        
        tieneDireccionTres = false
        
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
            model.registroComplementario.nombre = textField.text
        }
        
        if textField.tag == 2
        {
            model.registroComplementario.apellido = textField.text
        }
        
        if textField.tag == 3
        {
            model.registroComplementario.documento = textField.text
        }
        
        if textField.tag == 4
        {
            model.registroComplementario.celular = textField.text
        }
        
        if textField.tag == 5
        {
            model.direccion1.direccion = textField.text
        }
        
        if textField.tag == 6
        {
            model.direccion1.nombre = textField.text
        }
        
        if textField.tag == 7
        {
            model.direccion2.direccion = textField.text
        }
        
        if textField.tag == 8
        {
            model.direccion2.nombre = textField.text
        }
        
        if textField.tag == 9
        {
            model.direccion3.direccion = textField.text
        }
        
        if textField.tag == 10
        {
            model.direccion3.nombre = textField.text
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
            
            model.direccion2.direccion = ""
            model.direccion2.nombre = ""
            
            model.ubicacion2.latitud = 0.0
            model.ubicacion2.longitud = 0.0

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
        
        model.direccion3.direccion = ""
        model.direccion3.nombre = ""
        
        model.ubicacion3.latitud = 0.0
        model.ubicacion3.longitud = 0.0
        
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
        
        if model.registroComplementario.apellido == "" || model.registroComplementario.celular == "" || model.registroComplementario.documento == "" || model.registroComplementario.nombre == "" || model.direccion1.direccion == "" || model.direccion1.nombre == ""
        {
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
            
            return
        }
        
        if tieneDireccionDos
        {
            if model.direccion2.direccion == "" || model.direccion2.nombre == ""
            {
                self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
                
                return
            }
        }
        
        if tieneDireccionTres
        {
            if model.direccion3.direccion == "" || model.direccion3.nombre == ""
            {
                self.mostrarAlerta(titulo: "Advertencia", mensaje: "Debes completar todos los campos para poder continuar")
                
                return
            }
        }
        
        model.registroComplementario.direcciones?.removeAll()
        
        model.direccion1.porDefecto = true
        model.registroComplementario.direcciones?.append(model.direccion1)
        
        if tieneDireccionDos
        {
            model.direccion2.porDefecto = false
            model.registroComplementario.direcciones?.append(model.direccion2)
        }
        
        if tieneDireccionTres
        {
            model.direccion3.porDefecto = false
            model.registroComplementario.direcciones?.append(model.direccion3)
        }
        
        self.performSegue(withIdentifier: "completarRegistroTresDesdecompletarRegistroDos", sender: self)
    }
    
    func refreshView()
    {
        txtDireccion1.text = model.direccion1.direccion
        
        if txtDireccion1.text == ""
        {
            txtDireccion1.isEnabled = false
            btnUbicacion1.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            txtDireccion1.isEnabled = true
            btnUbicacion1.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
        }
        
        txtDireccion2.text = model.direccion2.direccion
        
        if txtDireccion2.text == ""
        {
            txtDireccion2.isEnabled = false
            btnUbicacion2.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            txtDireccion2.isEnabled = true
            btnUbicacion2.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
        }
        
        txtDireccion3.text = model.direccion3.direccion
        
        if txtDireccion3.text == ""
        {
            txtDireccion3.isEnabled = false
            btnUbicacion3.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            txtDireccion3.isEnabled = true
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
