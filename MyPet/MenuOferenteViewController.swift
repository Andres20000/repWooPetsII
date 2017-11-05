//
//  MenuOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuOferenteViewController: UIViewController
{
    var model  = ModeloOferente.sharedInstance
    
    @IBOutlet var lblRazonSocial: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func cargarDatosOferente(_ notification: Notification)
    {
        lblRazonSocial.text = "   " + model.oferente[0].razonSocial!
    }
    
    @IBAction func navegarMenu(_ sender: Any)
    {
        let btnMenu:UIButton = sender as! UIButton
        
        switch btnMenu.tag
        {
        case 1:
            
            model.horarioSemana.dias = ""
            model.horarioFestivo.dias = ""
            model.oferente.removeAll()
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            
        case 2:
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 3:
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 4:
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.performSegue(withIdentifier: "editarOferente", sender: self)
            
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
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.oferente.removeAll()
        
        try! Auth.auth().signOut()
        
        performSegue(withIdentifier: "ingresoDesdeHomeOferente", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        ComandoOferente.getOferente(uid: Auth.auth().currentUser?.uid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuOferenteViewController.cargarDatosOferente(_:)), name:NSNotification.Name(rawValue:"cargoOferente"), object: nil)
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
