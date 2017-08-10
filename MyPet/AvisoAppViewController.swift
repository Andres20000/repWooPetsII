//
//  AvisoAppViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 7/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AvisoAppViewController: UIViewController
{
    var model  = ModeloUsuario.sharedInstance
    
    @IBOutlet var lblTituloAviso: UILabel!
    @IBOutlet var btnCrearPerfilMascota: UIButton!
    @IBOutlet var lblTextoAviso: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func omitirCrearPerfilMascota(_ sender: Any)
    {
        self.performSegue(withIdentifier: "precargarPublicacionesDesdeAvisoApp", sender: self)
    }
    
    @IBAction func crearPerfilMascota(_ sender: Any)
    {
        if (model.usuario[0].datosComplementarios?.count)! > 0
        {
            self.performSegue(withIdentifier: "tuMascotaDesdeAvisoApp", sender: self)
        } else
        {
            let alert:UIAlertController = UIAlertController(title: "No has completado tu registro", message: "Para crear un perfil de tu mascota debes completar tu registro.\n¿Deseas hacerlo en éste momento?", preferredStyle: .alert)
            
            let continuarAction = UIAlertAction(title: "Sí, continuar", style: .default)
            {
                UIAlertAction in self.completarRegistro()
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
    
    func completarRegistro()
    {
        self.performSegue(withIdentifier: "completarRegistroDesdeAvisoApp", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if DeviceType.IS_IPHONE_5
        {
            btnCrearPerfilMascota.titleLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 16.0)
            
        } else
        {
            if DeviceType.IS_IPHONE_6P
            {
                lblTituloAviso.font = UIFont (name: "HelveticaNeue-Medium", size: 30.0)
                btnCrearPerfilMascota.titleLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 21.0)
                lblTextoAviso.font = UIFont (name: "HelveticaNeue-Light", size: 31.0)
            }
        }
        
        btnCrearPerfilMascota.layer.cornerRadius = 10.0
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
        
        if (segue.identifier == "completarRegistroDesdeAvisoApp")
        {
            let detailController = segue.destination as! RegistroUsuarioDosViewController
            detailController.datosEditables = false
        }
        
        if (segue.identifier == "tuMascotaDesdeAvisoApp")
        {
            let detailController = segue.destination as! TuMascotaViewController
            detailController.datosEditables = false
        }
        
        if (segue.identifier == "precargarPublicacionesDesdeAvisoApp")
        {
            let detailController = segue.destination as! PreCargaDatosViewController
            detailController.omitir = true
        }
    }

}
