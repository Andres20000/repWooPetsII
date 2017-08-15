//
//  ConfirmacionUnoViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfirmacionUnoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var tableCompras: UITableView!
    
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var btnSiguiente: UIButton!
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CompraTableViewCell", bundle: nil)
        tableCompras.register(nib, forCellReuseIdentifier: "compraTableViewCell")
        
        let costo:Int = Int(modelUsuario.publicacionCarrito.publicacionCompra.precio!)!
        let Total:Int = modelUsuario.publicacionCarrito.cantidadCompra! * costo
        let TotalString:String = String(Total)
        lblTotal.text = TotalString
        
        if let amountString = lblTotal.text?.currencyInputFormatting()
        {
            lblTotal.text = amountString
        }
        
        btnSiguiente.layer.cornerRadius = 10.0
    }
    
    func refrescarVista(_ notification: Notification)
    {
        tableCompras.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "compraTableViewCell")  as! CompraTableViewCell
        
        let path = "productos/" + (modelUsuario.publicacionCarrito.idPublicacion)! + "/" + (modelUsuario.publicacionCarrito.publicacionCompra.fotos?[0].nombreFoto)!
        
        cell.imgPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
        
        cell.lblCantidad.text = "\(modelUsuario.publicacionCarrito.cantidadCompra!)"
        
        if let amountString = modelUsuario.publicacionCarrito.publicacionCompra.precio?.currencyInputFormatting()
        {
            cell.lblCostoPublicacion.text = "\(amountString) c/u"
        }
        
        cell.lblNombrePublicacion.text = modelUsuario.publicacionCarrito.publicacionCompra.nombre
        
        let costo:Int = Int(modelUsuario.publicacionCarrito.publicacionCompra.precio!)!
        let Total:Int = modelUsuario.publicacionCarrito.cantidadCompra! * costo
        let TotalString:String = String(Total)
        cell.lblTotal.text = TotalString
        
        if let amountStringDos = cell.lblTotal.text?.currencyInputFormatting()
        {
            cell.lblTotal.text = amountStringDos
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Seleccionado")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    @IBAction func continuarConfirmacion(_ sender: Any)
    {
        self.performSegue(withIdentifier: "confirmacionDosDesdeConfirmacionUno", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tableCompras.reloadData()
        
        /*if user?.uid != nil
        {
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmacionUnoViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)*/
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
