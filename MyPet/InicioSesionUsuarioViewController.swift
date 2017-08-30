//
//  InicioSesionUsuarioViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 6/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class InicioSesionUsuarioViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate
{
    var modelUsuario  = ModeloUsuario.sharedInstance
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var txtCorreo: UITextField!
    @IBOutlet var txtContrasena: UITextField!
    @IBOutlet var btnInicioSesion: UIButton!
    @IBOutlet weak var botonFacebook: FBSDKLoginButton!
    @IBOutlet var btnRegistro: UIButton!
    
    var sizeFont : CGFloat = 0.0
    var registroCompleto:Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let  user = FIRAuth.auth()?.currentUser
        
        if user == nil
        {
            print("Registro: Con usuario en NILLL")
            self.botonFacebook.readPermissions = ["public_profile", "email" ]
            self.botonFacebook.delegate = self
            self.botonFacebook.isHidden = false
        }
        /*FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil
            {
                print("Ingreso para Usuario con usuario \((user?.uid)!)")
                
                ComandoUsuario.getUsuario(uid: (user?.uid)!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(InicioSesionUsuarioViewController.verificarUsuario(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
            }
            else {
                print("Registro: Con usuario en NILLL")
                self.botonFacebook.readPermissions = ["public_profile", "email" ]
                self.botonFacebook.delegate = self
                self.botonFacebook.isHidden = false
            }
        }*/
        
    }
    
    func verificarUsuario(_ notification: Notification)
    {
        if modelUsuario.usuario.count == 0
        {
            if Comando.validarTipoIngreso()
            {
                let alertController = UIAlertController (title: "Ingreso fallido", message: "Para poder iniciar sesión con Facebook primero debes registrarte.", preferredStyle: .alert)
                
                let oKAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                    FBSDKAccessToken.setCurrent(nil)
                    try! FIRAuth.auth()!.signOut()
                }
                
                alertController.addAction(oKAction)
                
                present(alertController, animated: true, completion: nil)
            } else
            {
                let alertController = UIAlertController (title: "Ingreso fallido", message: "Tus datos están creados como Oferente. Registra uno nuevo o ingresa otros datos válidos.", preferredStyle: .alert)
                
                let oKAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                    try! FIRAuth.auth()!.signOut()
                }
                
                alertController.addAction(oKAction)
                
                present(alertController, animated: true, completion: nil)
            }
            
        } else
        {
            self.performSegue(withIdentifier: "precargarPublicacionesDesdeInicioSesionUsuario", sender: self)
        }
    }
    
    // #pragma mark - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func iniciarSesionUsuario(_ sender: Any)
    {
        txtCorreo.resignFirstResponder()
        txtContrasena.resignFirstResponder()
        
        let btnRegistro:UIButton = sender as! UIButton
        
        if btnRegistro.tag == 1
        {
            FIRAuth.auth()?.signIn(withEmail: txtCorreo.text!, password: txtContrasena.text!, completion: { (user, error) in
                
                if error != nil {
                    
                    self.mostrarAlerta(titulo: "Ingreso fallido", mensaje: "Tus datos no parecen estar correctos. Revisa tus datos y/o tu acceso a Internet.")
                    print(error?.localizedDescription)
                }else
                {
                    print("Ingreso para Usuario con usuario \((user?.uid)!)")
                    
                    ComandoUsuario.getUsuario(uid: (user?.uid)!)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(InicioSesionUsuarioViewController.verificarUsuario(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
                }
            })
        }
    }
    
    @IBAction func recuperarContraseña(_ sender: AnyObject)
    {
        if Comando.init().isValidEmail(testStr: txtCorreo.text!)
        {
            FIRAuth.auth()?.sendPasswordReset(withEmail: txtCorreo.text!) { error in
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
    
    // #pragma mark - FBSDKLoginButtonDelegate Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        self.botonFacebook.isHidden = true
        
        if let error = error {
            print(error.localizedDescription)
            self.botonFacebook.isHidden = false
            return
        }
        
        if  result.isCancelled {
            self.botonFacebook.isHidden = false
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        var email = ""
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                self.mostrarAlerta(titulo: "Registro", mensaje: "No se ha podido hacer el registro. La dirección de correo electrónico ya está en uso por otra cuenta.")
                print(error.localizedDescription)
                return
            }
            
            let testMail:String?
            
            if user?.email == nil {
                
                testMail = user?.providerData[0].email
                
                if testMail != nil {
                    email = testMail!
                    
                    print("Ingreso para Usuario con usuario \((user?.uid)!)")
                    
                    ComandoUsuario.getUsuario(uid: (user?.uid)!)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(InicioSesionUsuarioViewController.verificarUsuario(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
                }
            }
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("Se Deslogeo \(loginButton)")
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
        
        //btnInicioSesionFB.layer.cornerRadius = 10.0
        
        if DeviceType.IS_IPHONE_5
        {
            sizeFont = 14.0
            self.spaceTopLayoutConstraint?.constant = 25.0
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "precargarPublicacionesDesdeInicioSesionUsuario")
        {
            let detailController = segue.destination as! PreCargaDatosViewController
            detailController.omitir = false
        }
    }
    
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
