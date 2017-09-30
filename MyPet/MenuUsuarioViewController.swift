//
//  MenuUsuarioViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class MenuUsuarioViewController: UIViewController
{
    var model  = Modelo.sharedInstance
    var modelUsuario  = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceBottomLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var imgCerrarSesion: UIImageView!
    @IBOutlet var lblCerrarSesion: UILabel!
    @IBOutlet var btnCerrarSesion: UIButton!
    
    var editarDatosPersonales:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ComandoUsuario.getUsuario(uid: (user?.uid)!)
        
        if DeviceType.IS_IPHONE_5
        {
            self.spaceBottomLayoutConstraint?.constant = 15.0
        }
    }
    
    @IBAction func navegarMenu(_ sender: Any)
    {
        let btnMenu:UIButton = sender as! UIButton
        
        switch btnMenu.tag
        {
        case 1:
            
            if modelUsuario.usuario.count == 0
            {
                self.mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Aún no te has registrado")
            } else
            {
                if modelUsuario.usuario[0].datosComplementarios?.count == 0
                {
                    self.mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Aún no te has completado tu registro")
                } else
                {
                    editarDatosPersonales = true
                    
                    ComandoUsuario.getUsuario(uid: (user?.uid)!)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(MenuUsuarioViewController.cargarDatosPerfil(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
                }
            }
            
        case 2:
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 3:
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 4:
            
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 5:
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 6:
            
            let alert:UIAlertController = UIAlertController(title: "¡Atención!", message: "¿Seguro deseas cerrar sesión?", preferredStyle: .alert)
            
            let cerrarAction = UIAlertAction(title: "Sí, cerrar", style: .default)
            {
                UIAlertAction in self.cerrarSesion()
            }
            
            let cancelAction = UIAlertAction(title: "No, cancelar", style: .cancel)
            {
                UIAlertAction in
            }
            
            // Add the actions
            alert.addAction(cerrarAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        default:
            print("Nothing")
        }
    }
    
    func cargarDatosPerfil(_ notification: Notification)
    {
        if modelUsuario.usuario[0].datosComplementarios?.count != 0
        {
            modelUsuario.registroComplementario = (modelUsuario.usuario[0].datosComplementarios?[0])!
            
            for direccion in (modelUsuario.usuario[0].datosComplementarios?[0].direcciones)!
            {
                if direccion.posicion == 1
                {
                    modelUsuario.direccion1 = direccion
                    modelUsuario.ubicacion1 = (direccion.ubicacion?[0])!
                }
                
                if direccion.posicion == 2
                {
                    modelUsuario.direccion2 = direccion
                    modelUsuario.ubicacion2 = (direccion.ubicacion?[0])!
                }
                
                if direccion.posicion == 3
                {
                    modelUsuario.direccion3 = direccion
                    modelUsuario.ubicacion3 = (direccion.ubicacion?[0])!
                }
            }
            
            if editarDatosPersonales
            {
                editarDatosPersonales = false
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                
                self.performSegue(withIdentifier: "editarPerfilUsuario", sender: self)
            }
        }
    }
    
    func cerrarSesion()
    {
        if Comando.validarTipoIngreso()
        {
            FBSDKAccessToken.setCurrent(nil)
            print("Entra aquí al estar con FB")
        }
        
        modelUsuario.usuario.removeAll()
        
        try! FIRAuth.auth()!.signOut()
        
        performSegue(withIdentifier: "ingresoDesdeHomeUsuario", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if user == nil
        {
            imgCerrarSesion.isHidden = true
            lblCerrarSesion.isHidden = true
            btnCerrarSesion.isHidden = true
        }else
        {
            imgCerrarSesion.isHidden = false
            lblCerrarSesion.isHidden = false
            btnCerrarSesion.isHidden = false
        }
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
        
        if (segue.identifier == "editarPerfilUsuario")
        {
            let detailController = segue.destination as! RegistroUsuarioDosViewController
            detailController.datosEditables = true
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
