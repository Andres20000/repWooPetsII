//
//  RegistroUsuarioViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 6/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

//     Continuar con Facebook

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class RegistroUsuarioViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var txtCorreo: UITextField!
    @IBOutlet var txtContrasena: UITextField!
    @IBOutlet var btnRegistro: UIButton!
    @IBOutlet weak var botonFacebook: FBSDKLoginButton!
    //@IBOutlet var btnRegistroFB: UIButton!
    @IBOutlet var btnInicioSesion: UIButton!
    
    var sizeFont : CGFloat = 0.0
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil {
                print("Registro: Con usuario listo")
                self.performSegue(withIdentifier: "ingresoExitosoDesdeRegistroUsuario", sender: self)
            }
            else {
                print("Registro: Con usuario en NILLL")
                self.botonFacebook.readPermissions = ["public_profile", "email" ]
                self.botonFacebook.delegate = self
                self.botonFacebook.isHidden = false
            }
        }
    }
    
    // #pragma mark - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func registrarUsuario(_ sender: Any)
    {
        let btnRegistro:UIButton = sender as! UIButton
        
        if btnRegistro.tag == 1
        {
            if Comando.init().isValidEmail(testStr: txtCorreo.text!)
            {
                FIRAuth.auth()?.createUser(withEmail: txtCorreo.text!, password: txtContrasena.text!, completion: { (user, error) in
                    if error != nil {
                        self.mostrarAlerta(titulo: "Registro", mensaje: "No se ha podido hacer el registro. Esa cuenta ya existe o la contraseña es muy débil")
                        print(error?.localizedDescription)
                        
                    }else
                    {
                        ComandoUsuario.registrarUsuario(uid: (user?.uid)!, correo: self.txtCorreo.text!)
                        
                        //self.performSegue(withIdentifier: "ingresoExitosoDesdeRegistroUsuario", sender: self)
                    }
                })
            }else
            {
                self.mostrarAlerta(titulo: "e-mail Inválido", mensaje: "El e-mail no es válido, escríbelo correctamente para que puedas registrarte")
            }
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
                }
            }
            
            ComandoUsuario.registrarUsuario(uid: (user?.uid)!, correo: email)
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
        
        btnRegistro.layer.cornerRadius = 10.0
        
        //btnRegistroFB.layer.cornerRadius = 10.0
        
        if DeviceType.IS_IPHONE_5
        {
            sizeFont = 14.0
            self.spaceTopLayoutConstraint?.constant = 5.0
        }else
        {
            sizeFont = 17.0
        }
        
        //create attributed string txt bold
        let textBoton: NSString = btnInicioSesion.titleLabel!.text! as NSString
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: textBoton as String)
        
        attributedText.addAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: sizeFont)!], range: NSRange(location: 0, length:36))
        attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: sizeFont)!], range: NSRange(location: 23, length: 13))
        
        //assign text first, then customize properties
        btnInicioSesion.titleLabel!.attributedText = attributedText
        
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
