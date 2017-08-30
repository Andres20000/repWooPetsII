//
//  IngresoViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/04/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

class IngresoViewController: UIViewController
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var horizontalSpaceConstraint: NSLayoutConstraint?
    
    @IBOutlet var btnRegistrate: UIButton!
    @IBOutlet var btnInicioSesion: UIButton!
    @IBOutlet var lblCondiciones: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func omitirIngresoRegistro(_ sender: Any)
    {
        if Comando.isConnectedToNetwork()
        {
            self.performSegue(withIdentifier: "precargarPublicacionesDesdeHome", sender: self)
        }else
        {
            self.mostrarAlerta(titulo: "¡Sin conexión!", mensaje: "No detectamos conexión a internet, por favor valida tu señal para poder ver las publicaciones.")
        }
    }
    
    @IBAction func registrarOferente(_ sender: Any)
    {
        self.performSegue(withIdentifier: "inicioSesionOferente", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        btnRegistrate.layer.cornerRadius = 10.0
        btnInicioSesion.layer.cornerRadius = 10.0
        
        if DeviceType.IS_IPHONE_5
        {
            lblCondiciones.font = UIFont (name: "HelveticaNeue-Light", size: 10.0)
            self.spaceTopLayoutConstraint?.constant = 65.0
            self.horizontalSpaceConstraint?.constant = 35.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            self.horizontalSpaceConstraint?.constant = 72.0
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

    func mostrarAlerta(titulo:String, mensaje:String)
    {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            return
        }
        
        alerta.addAction(OKAction)
        present(alerta, animated: true, completion: { return })
    }
}
