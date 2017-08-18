//
//  CompraExitosaViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 17/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class CompraExitosaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let modelUsuario = ModeloUsuario.sharedInstance
    
    @IBOutlet var tableCompras: UITableView!
    @IBOutlet var btnContinuar: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnContinuar.layer.cornerRadius = 10.0
        
        let nib = UINib(nibName: "ProductoCompradoTableViewCell", bundle: nil)
        tableCompras.register(nib, forCellReuseIdentifier: "productoCompradoTableViewCell")
        
        let nib2 = UINib(nibName: "ServicioCompradoTableViewCell", bundle: nil)
        tableCompras.register(nib2, forCellReuseIdentifier: "servicioCompradoTableViewCell")
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if modelUsuario.publicacionCarrito.publicacionCompra.servicio!
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "servicioCompradoTableViewCell")  as! ServicioCompradoTableViewCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoCompradoTableViewCell")  as! ProductoCompradoTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Seleccionado")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if modelUsuario.publicacionCarrito.publicacionCompra.servicio!
        {
            return 130
        }
        
        return 110
    }
    
    @IBAction func continuar(_ sender: Any)
    {
        self.performSegue(withIdentifier: "precargarPublicacionesDesdeCompraExitosa", sender: self)
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
        
        if (segue.identifier == "precargarPublicacionesDesdeCompraExitosa")
        {
            let detailController = segue.destination as! PreCargaDatosViewController
            detailController.omitir = false
        }
    }

}
