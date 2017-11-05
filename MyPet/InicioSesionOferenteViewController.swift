//
//  InicioSesionOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/04/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class InicioSesionOferenteViewController: UIViewController, UITextFieldDelegate
{
    var model  = ModeloOferente.sharedInstance
    
    var sizeFont : CGFloat = 0.0
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var txtCorreo: UITextField!
    @IBOutlet var txtContrasena: UITextField!
    @IBOutlet var btnInicioSesion: UIButton!
    @IBOutlet var btnRegistro: UIButton!

    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Auth.auth().addStateDidChangeListener { auth, user in
            
            if user != nil {
                
                ComandoOferente.getOferente(uid: (user?.uid)!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(InicioSesionOferenteViewController.verificarOferente(_:)), name:NSNotification.Name(rawValue:"cargoOferente"), object: nil)
                
            }
        }
    }
    
    func verificarOferente(_ notification: Notification)
    {
        if model.oferente.count == 0
        {
            let alertController = UIAlertController (title: "Ingreso fallido", message: "Tus datos están creados como Usuario. Registra uno nuevo o ingresa otros datos válidos.", preferredStyle: .alert)
            
            let oKAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                try! Auth.auth().signOut()
            }
            
            alertController.addAction(oKAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else
        {
            if model.oferente[0].aprobacionMyPet == "Pendiente"
            {
                self.mostrarAlerta(titulo: "¡Aviso importante!", mensaje: "Tu usuario aún está pendiente por activar")
            } else
            {
                self.performSegue(withIdentifier: "homeOferenteDesdeInicioSesion", sender: self)
            }
        }
    }
    
    // #pragma mark - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func iniciarSesion(_ sender: Any)
    {
        txtCorreo.resignFirstResponder()
        txtContrasena.resignFirstResponder()
        
        Auth.auth().signIn(withEmail: txtCorreo.text!, password: txtContrasena.text!, completion: { (user, error) in
            
            if error != nil {
                
                self.mostrarAlerta(titulo: "Ingreso fallido", mensaje: "Tus datos no parecen estar correctos. Revisa tus datos y/o tu acceso a Internet.")
                
            }
        })
    }
    
    @IBAction func recuperarContraseña(_ sender: AnyObject)
    {
        if Comando.init().isValidEmail(testStr: txtCorreo.text!)
        {
            Auth.auth().sendPasswordReset(withEmail: txtCorreo.text!) { error in
                if error != nil
                {
                    self.mostrarAlerta(titulo: "e-mail Inválido", mensaje: "El e-mail no es válido o no existe en nuestros registros, escríbelo correctamente para que puedas actualizar tu contraseña")
                    
                } else
                {
                    self.mostrarAlerta(titulo: "e-mail Enviado", mensaje: "Te hemos enviado un correo a: " + self.txtCorreo.text! + ". Abre el link que aparece en el correo para poder actualizar la contraseña")
                    
                }
            }
        }else
        {
            self.mostrarAlerta(titulo: "e-mail Inválido", mensaje: "El e-mail no es válido o no existe en nuestros registros, escríbelo correctamente para que puedas actualizar tu contraseña")
        }
    }
    
    @IBAction func registrarOferente(_ sender: Any)
    {
        self.performSegue(withIdentifier: "avisoOferente", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let spacerViewTxtUser = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtCorreo.leftViewMode = UITextFieldViewMode.always
        txtCorreo.leftView = spacerViewTxtUser
        txtCorreo.text = ""
        txtCorreo.attributedPlaceholder = NSAttributedString(string:"Correo electrónico", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtPassword = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtContrasena.leftViewMode = UITextFieldViewMode.always
        txtContrasena.leftView = spacerViewTxtPassword
        txtContrasena.text = ""
        txtContrasena.attributedPlaceholder = NSAttributedString(string:"Contraseña", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        btnInicioSesion.layer.cornerRadius = 10.0
        
        if DeviceType.IS_IPHONE_5
        {
            sizeFont = 14.0
            self.spaceTopLayoutConstraint?.constant = 20.0
        }else
        {
            sizeFont = 17.0
        }
        
        //create attributed string txt bold
        let textBoton: NSString = btnRegistro.titleLabel!.text! as NSString
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: textBoton as String)
        
        attributedText.addAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: sizeFont)!], range: NSRange(location: 0, length:38))
        attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: sizeFont)!], range: NSRange(location: 23, length: 15))
        
        //assign text first, then customize properties
        btnRegistro.titleLabel!.attributedText = attributedText
        
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

    // Validación de datos
    
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
