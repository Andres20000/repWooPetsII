//
//  ViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/04/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController
{
    var model  = ModeloUsuario.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool)
    {
        //try! FIRAuth.auth()!.signOut()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil
            {
                ComandoUsuario.getUsuario(uid: (user?.uid)!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(ViewController.validarIngreso(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
                
            }else
            {
                self.performSegue(withIdentifier: "ingreso", sender: self)
            }
        }
    }
    
    func validarIngreso(_ notification: Notification)
    {
        if self.model.usuario.count == 0
        {
            self.performSegue(withIdentifier: "homeOferenteDesdeVistaDeCarga", sender: self)
        }else
        {
            self.performSegue(withIdentifier: "precargarPublicacionesDesdeVistaDeCarga", sender: self)
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

