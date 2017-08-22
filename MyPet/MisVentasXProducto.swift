//
//  MisVentasXProducto.swift
//  MyPet
//
//  Created by Andres Garcia on 8/16/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class MisVentasXProducto: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    @IBOutlet var tabla: UITableView!
    
    let model = ModeloOferente.sharedInstance
    
    var ventas:[ItemCompra] = []
    
    var selectedPublicacion = ""
    
    var publicacion:PublicacionOferente?
    var abiertas = true
    
    var selectedIndex = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CeldaVentaProducto", bundle: nil)
        tabla.register(nib, forCellReuseIdentifier: "CeldaVentaProducto")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintarXUsuario), name:NSNotification.Name(rawValue:"cargoMiniUsuario"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        
        ventas = model.getMisVentasDeUnaPublicacion(abiertas: abiertas, idPublicacion: publicacion!.idPublicacion!)
        return ventas.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        selectedIndex = indexPath.row
        
        let item = model.getMisVentasDeUnaPublicacion(abiertas: abiertas, idPublicacion: publicacion!.idPublicacion!)[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaVentaProducto")  as! CeldaVentaProducto
        
        
        let cliente = model.misUsuarios[item.compra!.idCliente]
        
        if cliente != nil {
            cell.nombre.text = (cliente?.datosComplementarios![0].nombre)! + " " +  (cliente?.datosComplementarios![0].apellido)!
        }
        else {
            ComandoPreguntasOferente.getMiniUsuario(uid: item.compra!.idCliente)
        }

       
        cell.cantidad.text = String(item.cantidad)
        cell.fecha.text = item.fechaServicio!
        
        return cell;
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        
       // let oferta = model.getPublicacion(idPublicacion: publicaciones[indexPath.row])
        //selectedPublicacion = oferta!.idPublicacion!
        
        
        self.performSegue(withIdentifier: "detalleVenta", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //Edited
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "detalleVenta"){
            
            let item = model.getMisVentasDeUnaPublicacion(abiertas: abiertas, idPublicacion: publicacion!.idPublicacion!)[selectedIndex]
            let detailController = segue.destination as! DetalleMiVenta
            
            detailController.item = item
            
        }
    }
    
    func repintarXUsuario(){
        tabla.reloadData()
        
    }
    
    
}
