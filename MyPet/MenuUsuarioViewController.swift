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
    var model  = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceBottomLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var imgCerrarSesion: UIImageView!
    @IBOutlet var lblCerrarSesion: UILabel!
    @IBOutlet var btnCerrarSesion: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
            
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
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
    
    func cerrarSesion()
    {
        print("Tipo: \(Comando.validarTipoIngreso())")
        if Comando.validarTipoIngreso()
        {
            FBSDKAccessToken.setCurrent(nil)
            print("Entra aquí al estar con FB")
        }
        
        model.usuario.removeAll()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
