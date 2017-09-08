//
//  PreCargaDatosViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

import FirebaseAuth

class PreCargaDatosViewController: UIViewController
{
    let  user = FIRAuth.auth()?.currentUser
    let model = ModeloUsuario.sharedInstance
    
    var omitir:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validarIngreso(_ notification: Notification)
    {
        if model.usuario.count != 0
        {
            if omitir
            {
                self.performSegue(withIdentifier: "HomeUsuario", sender: self)
            }else
            {
                if model.usuario[0].datosComplementarios?.count == 0
                {
                    self.performSegue(withIdentifier: "avisoAppDesdePreCargaDatos", sender: self)
                } else
                {
                    if model.usuario[0].datosComplementarios?[0].mascotas?.count == 0
                    {
                        self.performSegue(withIdentifier: "avisoAppDesdePreCargaDatos", sender: self)
                    } else
                    {
                        self.performSegue(withIdentifier: "HomeUsuario", sender: self)
                    }
                }
            }
            
        }else
        {
            print("entra aquí")
            
            NotificationCenter.default.addObserver(self, selector: #selector(PreCargaDatosViewController.cargarDirecto(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
        }
    }
    
    func cargarDirecto(_ notification: Notification)
    {
        self.performSegue(withIdentifier: "HomeUsuario", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Comando.getCategorias()
        Comando.getPublicaciones()
        //ComandoUsuario.getCalificacionesPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PreCargaDatosViewController.validarIngreso(_:)), name:NSNotification.Name(rawValue:"cargoCategorias"), object: nil)
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

}
