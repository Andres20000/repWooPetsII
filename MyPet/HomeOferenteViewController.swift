//
//  HomeOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 9/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeOferenteViewController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.items?[0].selectedImage = UIImage(named: "btnPerfilAzul")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].image = UIImage(named: "btnPerfilBlanco")?.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items?[1].selectedImage = UIImage(named: "btnPublicarAzul")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "btnPublicarBlanco")?.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items?[2].selectedImage = UIImage(named: "btnNotificacionAzul")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "btnNotificacionBlanco")?.withRenderingMode(.alwaysOriginal)
        
        let model = Modelo.sharedInstance
        
        let version = model.myApp.version
        Comando.updateDataSystem(tipo: "oferentes", uid: (FIRAuth.auth()?.currentUser?.uid)!, version: version)
        
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
