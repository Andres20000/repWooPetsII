//
//  RegistroUsuarioDosViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 8/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistroUsuarioDosViewController: UIViewController, UITextFieldDelegate
{
    var modelUsuario  = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var heightViewLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var imgFondo: UIImageView!
    
    @IBOutlet var scrollContent: UIScrollView!
    
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
    var idDireccion2 = ""
    
    var tieneDireccionTres:Bool = false
    var idDireccion3 = ""
    
    var direccionParaUbicar:Int?
    
    var datosEditables:Bool = false
    
    @IBAction func closeView(_ sender: Any)
    {
        self.goBack()
    }
    
    func goBack()
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
        
        scrollContent.bounces = true
        scrollContent.isScrollEnabled = true
        
        scrollContent.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
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
        
        modelUsuario.direccion1.posicion = 1
        modelUsuario.direccion2.posicion = 2
        modelUsuario.direccion3.posicion = 3
        
        if datosEditables
        {
            if modelUsuario.usuario[0].datosComplementarios?[0].direcciones?.count == 1
            {
                modelUsuario.ubicacion2.latitud = 0
                modelUsuario.ubicacion2.longitud = 0
                
                modelUsuario.direccion2.ubicacion?.removeAll()
                modelUsuario.direccion2.ubicacion?.append(modelUsuario.ubicacion2)
                
                modelUsuario.ubicacion3.latitud = 0
                modelUsuario.ubicacion3.longitud = 0
                
                modelUsuario.direccion3.ubicacion?.removeAll()
                modelUsuario.direccion3.ubicacion?.append(modelUsuario.ubicacion3)
                
                tieneDireccionDos = false
                tieneDireccionTres = false
                
                self.heightViewLayoutConstraint?.constant = UIScreen.main.bounds.height
                
                self.spaceTopLayoutConstraint?.constant = 344 - 140 - 140 + 10
                
                viewDireccion2.isHidden = true
                viewDireccion3.isHidden = true
                
                btnAgregar.isHidden = true
                btnAgregar2.isHidden = false
                btnAgregar3.isHidden = true
            }
            
            if modelUsuario.usuario[0].datosComplementarios?[0].direcciones?.count == 2
            {
                modelUsuario.ubicacion3.latitud = 0
                modelUsuario.ubicacion3.longitud = 0
                
                modelUsuario.direccion3.ubicacion?.removeAll()
                modelUsuario.direccion3.ubicacion?.append(modelUsuario.ubicacion3)
                
                tieneDireccionDos = true
                tieneDireccionTres = false
                
                if DeviceType.IS_IPHONE_6P
                {
                    self.heightViewLayoutConstraint?.constant = 845.0 - 140.0 + 31
                }else
                {
                    self.heightViewLayoutConstraint?.constant = 845.0 - 140.0
                }
                
                self.spaceTopLayoutConstraint?.constant = 344 - 140
                
                viewDireccion2.isHidden = false
                viewDireccion3.isHidden = true
                
                btnAgregar.isHidden = true
                btnAgregar2.isHidden = true
                btnAgregar3.isHidden = false
            }
            
            if modelUsuario.usuario[0].datosComplementarios?[0].direcciones?.count == 3
            {
                tieneDireccionDos = true
                tieneDireccionTres = true
                
                self.heightViewLayoutConstraint?.constant = 845.0
                
                self.spaceTopLayoutConstraint?.constant = 344
                
                viewDireccion2.isHidden = false
                viewDireccion3.isHidden = false
                
                btnAgregar.isHidden = false
                btnAgregar2.isHidden = true
                btnAgregar3.isHidden = true
            }
            
            btnContinuar.setTitle("Editar", for: .normal)
            
        } else
        {
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
            if datosEditables
            {
                idDireccion2 = ""
            }
            
            tieneDireccionDos = true
            
            if DeviceType.IS_IPHONE_6P
            {
                self.heightViewLayoutConstraint?.constant = 845.0 - 140.0 + 31
            }else
            {
                self.heightViewLayoutConstraint?.constant = 845.0 - 140.0
            }
            
            self.spaceTopLayoutConstraint?.constant = 344 - 140
            
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
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "No puedes borrar la dirección 2 porque tienes diligenciado la dirección 3")
        } else
        {
            let alert:UIAlertController = UIAlertController(title: "Confirmar", message: "¿Estás seguro de eliminar ésta dirección?", preferredStyle: .alert)
            
            let continuarAction = UIAlertAction(title: "Sí, continuar", style: .default) { (_) -> Void in
                
                if self.datosEditables
                {
                    self.idDireccion2 = self.modelUsuario.direccion2.idDireccion!
                }
                
                self.txtDireccion2.text = ""
                self.txtNombreDireccion2.text = ""
                
                self.modelUsuario.direccion2.direccion = ""
                self.modelUsuario.direccion2.nombre = ""
                
                self.modelUsuario.ubicacion2.latitud = 0.0
                self.modelUsuario.ubicacion2.longitud = 0.0
                
                self.tieneDireccionDos = false
                
                self.heightViewLayoutConstraint?.constant = UIScreen.main.bounds.height
                
                self.spaceTopLayoutConstraint?.constant = 344 - 140 - 140 + 10
                
                self.viewDireccion2.isHidden = true
                self.viewDireccion3.isHidden = true
                
                self.btnAgregar.isHidden = true
                self.btnAgregar2.isHidden = false
                self.btnAgregar3.isHidden = true
                
                self .refreshView()
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            {
                UIAlertAction in
            }
            
            // Add the actions
            alert.addAction(continuarAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
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
            if datosEditables
            {
                idDireccion3 = ""
            }
            
            tieneDireccionTres = true
            
            self.heightViewLayoutConstraint?.constant = 845.0
            
            self.spaceTopLayoutConstraint?.constant = 344
            
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
        
        let alert:UIAlertController = UIAlertController(title: "Confirmar", message: "¿Estás seguro de eliminar ésta dirección?", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "Sí, continuar", style: .default) { (_) -> Void in
            
            if self.datosEditables
            {
                self.idDireccion3 = self.modelUsuario.direccion3.idDireccion!
            }
            
            self.txtDireccion3.text = ""
            self.txtNombreDireccion3.text = ""
            
            self.modelUsuario.direccion3.direccion = ""
            self.modelUsuario.direccion3.nombre = ""
            
            self.modelUsuario.ubicacion3.latitud = 0.0
            self.modelUsuario.ubicacion3.longitud = 0.0
            
            self.tieneDireccionTres = false
            
            self.heightViewLayoutConstraint?.constant = 845.0 - 140.0
            
            self.spaceTopLayoutConstraint?.constant = 344 - 140
            
            self.viewDireccion2.isHidden = false
            self.viewDireccion3.isHidden = true
            
            self.btnAgregar.isHidden = true
            self.btnAgregar2.isHidden = true
            self.btnAgregar3.isHidden = false
            
            self .refreshView()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(continuarAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
        
        if modelUsuario.registroComplementario.apellido == "" || modelUsuario.registroComplementario.celular == "" || modelUsuario.registroComplementario.documento == "" || modelUsuario.registroComplementario.nombre == "" || modelUsuario.direccion1.direccion == "" || modelUsuario.direccion1.nombre == ""
        {
            self.mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Debes completar todos los campos para poder continuar")
            
            return
        }
        
        if tieneDireccionDos
        {
            if modelUsuario.direccion2.direccion == "" || modelUsuario.direccion2.nombre == ""
            {
                self.mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Debes completar todos los campos para poder continuar")
                
                return
            }
        }
        
        if tieneDireccionTres
        {
            if modelUsuario.direccion3.direccion == "" || modelUsuario.direccion3.nombre == ""
            {
                self.mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Debes completar todos los campos para poder continuar")
                
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
        
        if datosEditables
        {
            if idDireccion2 != ""
            {
                ComandoUsuario.eliminarDireccion(uid: (user?.uid)!, idDireccion: idDireccion2)
            }
            
            if idDireccion3 != ""
            {
                ComandoUsuario.eliminarDireccion(uid: (user?.uid)!, idDireccion: idDireccion3)
            }
            
            ComandoUsuario.editarDatosPerfil(uid: (user?.uid)!, datos: modelUsuario.registroComplementario)
            
            self.goBack()
            
        } else
        {
            self.performSegue(withIdentifier: "completarRegistroTresDesdecompletarRegistroDos", sender: self)
        }
    }
    
    func refreshView()
    {
        txtApellido.text = modelUsuario.registroComplementario.apellido
        txtTelefono.text = modelUsuario.registroComplementario.celular
        txtCedula.text = modelUsuario.registroComplementario.documento
        txtNombre.text = modelUsuario.registroComplementario.nombre
        
        if modelUsuario.direccion1.direccion != ""
        {
            txtDireccion1.text = modelUsuario.direccion1.direccion
            txtNombreDireccion1.text = modelUsuario.direccion1.nombre
        }
        
        if modelUsuario.direccion1.ubicacion?[0].latitud == 0
        {
            btnUbicacion1.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            btnUbicacion1.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
        }
        
        if modelUsuario.direccion2.direccion != ""
        {
            txtDireccion2.text = modelUsuario.direccion2.direccion
            txtNombreDireccion2.text = modelUsuario.direccion2.nombre
        }
        
        if modelUsuario.direccion2.ubicacion?[0].latitud == 0
        {
            btnUbicacion2.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
        } else
        {
            btnUbicacion2.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
        }
        
        if modelUsuario.direccion3.direccion != ""
        {
            txtDireccion3.text = modelUsuario.direccion3.direccion
            txtNombreDireccion3.text = modelUsuario.direccion3.nombre
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
            self.heightViewLayoutConstraint?.constant = UIScreen.main.bounds.height
            
            self.spaceTopLayoutConstraint?.constant = 344 - 140 - 140 + 10
            
            viewDireccion2.isHidden = true
            viewDireccion3.isHidden = true
            
            btnAgregar.isHidden = true
            btnAgregar2.isHidden = false
            btnAgregar3.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        scrollContent.contentSize = CGSize.init(width: scrollContent.frame.width, height: (self.heightViewLayoutConstraint?.constant)!)
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
