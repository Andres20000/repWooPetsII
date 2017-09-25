//
//  HomeUsuarioViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeUsuarioViewController: UITabBarController
{
    let model = Modelo.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.items?[0].selectedImage = UIImage(named: "btnInicioAzul")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].image = UIImage(named: "btnInicio")?.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items?[1].selectedImage = UIImage(named: "btnCarritoAzul")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "btnCarrito")?.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items?[2].selectedImage = UIImage(named: "btnMenuAzul")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "btnMenu")?.withRenderingMode(.alwaysOriginal)
        
        if modelUsuario.usuario.count > 0
        {
            let model = Modelo.sharedInstance
            
            let version = model.myApp.version
            Comando.updateDataSystem(tipo: "clientes", uid: (user?.uid)!, version: version)
        }
    }
    
    @objc func refrescarVista(_ notification: Notification)
    {
        if model.publicacionesEnCarrito.count != 0
        {
            self.tabBar.items?[1].badgeValue = "\((model.publicacionesEnCarrito.count))"
        } else
        {
            self.tabBar.items?[1].badgeValue = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if user != nil
        {
            ComandoUsuario.getMisComprasUsuario(uid: (user?.uid)!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(HomeUsuarioViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoMisComprasUsuario"), object: nil)
        }
        
        Comando.getPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeUsuarioViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
        
        ComandoUsuario.getCalificacionesPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeUsuarioViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoCalificacionesPublicaciones"), object: nil)
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
