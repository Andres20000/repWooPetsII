//
//  RegistroExitosoViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 11/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistroExitosoViewController: UIViewController
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceBottomLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var heightEqualsLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var lblAviso: UILabel!
    @IBOutlet var imgMailFB: UIImageView!
    @IBOutlet var btnContinuar: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if Comando.validarTipoIngreso()
        {
            imgMailFB.image = UIImage(named: "imgFbOk")
        }else
        {
            imgMailFB.image = UIImage(named: "imgMailOk")
        }
    }
    
    @IBAction func continuarView(_ sender: Any)
    {
        let  user = FIRAuth.auth()?.currentUser
        
        ComandoUsuario.getUsuario(uid: (user?.uid)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegistroExitosoViewController.goAvisoApp(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
    }
    
    func goAvisoApp(_ notification: Notification)
    {
        self.performSegue(withIdentifier: "avisoAppDesdeRegistroExitoso", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if DeviceType.IS_IPHONE_5
        {
            self.spaceBottomLayoutConstraint?.constant = 25.0
            lblAviso.font = UIFont (name: "HelveticaNeue-Light", size: 16.0)
            self.heightEqualsLayoutConstraint?.constant = 85.0
            
        } else
        {
            if DeviceType.IS_IPHONE_6P
            {
                lblAviso.font = UIFont (name: "HelveticaNeue-Light", size: 21.0)
                self.heightEqualsLayoutConstraint?.constant = 120.0
            }
        }
        
        btnContinuar.layer.cornerRadius = 10.0
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
