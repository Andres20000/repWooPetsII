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
        
        let  user = FIRAuth.auth()?.currentUser
        
        if user != nil
        {
            let model = Modelo.sharedInstance
            
            let version = model.myApp.version
            Comando.updateDataSystem(tipo: "clientes", uid: (user?.uid)!, version: version)
        }
    }
    
    func refrescarVista(_ notification: Notification)
    {
        if modelUsuario.usuario.count != 0
        {
            if modelUsuario.usuario[0].datosComplementarios?.count != 0
            {
                if modelUsuario.usuario[0].datosComplementarios?[0].carrito?.count != 0
                {
                    print("nombre: \((modelUsuario.usuario[0].datosComplementarios?[0].carrito?[0].publicacionCompra.nombre)!)")
                    self.tabBar.items?[1].badgeValue = "\((modelUsuario.usuario[0].datosComplementarios?[0].carrito?.count)!)"
                }else
                {
                    self.tabBar.items?[1].badgeValue = nil
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if self.user?.uid != nil
        {
            ComandoUsuario.getUsuario(uid: (self.user?.uid)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeUsuarioViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
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
