//
//  ViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/04/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ViewController: UIViewController
{
    var model  = ModeloUsuario.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //try! FIRAuth.auth()!.signOut()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil
            {
                if Comando.isConnectedToNetwork()
                {
                    ComandoUsuario.getUsuario(uid: (user?.uid)!)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.validarIngreso(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
                }else
                {
                    let alert:UIAlertController = UIAlertController(title: "¡Sin conexión!", message: "No detectamos conexión a internet, por favor valida tu señal para poder ingresar a la aplicación. La app se cerrará.", preferredStyle: .alert)
                    
                    let continuarAction = UIAlertAction(title: "OK, entiendo", style: .default) { (_) -> Void in
                        
                        if Comando.validarTipoIngreso()
                        {
                            FBSDKAccessToken.setCurrent(nil)
                            print("Entra aquí al estar con FB")
                        }
                        
                        try! FIRAuth.auth()!.signOut()
                        
                        exit(0)
                    }
                    
                    // Add the actions
                    alert.addAction(continuarAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }else
            {
                /*let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFade
                self.view.window!.layer.add(transition, forKey: kCATransition)*/
                
                self.performSegue(withIdentifier: "ingreso", sender: self)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    func validarIngreso(_ notification: Notification)
    {
        if self.model.usuario.count == 0
        {
            
            precargarPublicacionesOferente()
            
            /*let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFade
            view.window!.layer.add(transition, forKey: kCATransition)*/
            
            self.performSegue(withIdentifier: "homeOferenteDesdeVistaDeCarga", sender: self)
        }else
        {
            /*let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionReveal
            transition.subtype = kCATransitionFade
            view.window!.layer.add(transition, forKey: kCATransition)*/
            
            performSegue(withIdentifier: "precargarPublicacionesDesdeVistaDeCarga", sender: self)
        }
    }
    
    
    func precargarPublicacionesOferente(){
        
        let model = ModeloOferente.sharedInstance
        let user = FIRAuth.auth()?.currentUser
        
        if user != nil && !model.yaPrecargo {
            
            model.idOferente =  (FIRAuth.auth()!.currentUser?.uid)!
            ComandoPublicacion.getPublicacionesOferente(uid: user!.uid)
            ComandoPreguntasOferente.getTodasMisPreguntas()
            ComandoCompras.getMisCompras(abiertas: true)
            ComandoCalificacion.getMisCalificaciones()
            ComandoOferente.getDatosTPaga(uid: user!.uid)
            ComandoOferente.getTarjetas(uid: user!.uid)
            ComandoParametros.getParametros()
            
            model.yaPrecargo = true
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
        
        if (segue.identifier == "precargarPublicacionesDesdeVistaDeCarga")
        {
            let detailController = segue.destination as! PreCargaDatosViewController
            detailController.omitir = false
        }
    }
}



