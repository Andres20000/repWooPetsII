//
//  CarritoComprasViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class CarritoComprasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let model = Modelo.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    @IBOutlet var segCtrlCarrito: UISegmentedControl!
    
    @IBOutlet var viewMensaje: UIView!
    @IBOutlet var imgMensaje: UIImageView!
    @IBOutlet var lblMensaje: UILabel!
    
    @IBOutlet var tableProductosServicios: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Configuración UISegmentedControl
        
        let attributes = [ NSForegroundColorAttributeName : UIColor.white,
                           NSFontAttributeName : UIFont (name: "HelveticaNeue-Light", size: 15.0)];
        let attributesSelected = [ NSForegroundColorAttributeName : UIColor.white,
                                   NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 15.0)];
        
        UISegmentedControl.appearance().setTitleTextAttributes(attributes as Any as? [AnyHashable : Any], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(attributesSelected as Any as? [AnyHashable : Any], for: .selected)
        
        segCtrlCarrito.clipsToBounds = true
        segCtrlCarrito.layer.cornerRadius = 10.0
        segCtrlCarrito.layer.borderWidth = 1.0
        segCtrlCarrito.layer.borderColor = UIColor.white.cgColor
        
        let nib = UINib(nibName: "FavoritoTableViewCell", bundle: nil)
        tableProductosServicios.register(nib, forCellReuseIdentifier: "favoritoTableViewCell")
    }
    
    func refrescarVista(_ notification: Notification)
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes ningún producto y/o servicio en tu carrito."
        case 1:
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes productos y/o servicios en tus compras."
        case 2:
            if model.publicacionesFavoritas.count == 0
            {
                viewMensaje.isHidden = false
                imgMensaje.image = UIImage(named: "imgFavoritoVacio")
                lblMensaje.text = "Actualmente no tienes productos y/o servicios favoritos."
            } else
            {
                viewMensaje.isHidden = true
            }
        default:
            break
        }
        
        tableProductosServicios.reloadData()
    }
    
    @IBAction func indexChanged(_ sender: AnyObject)
    {
        Comando.getPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            tableProductosServicios.separatorStyle = .none
            return 0
        case 1:
            tableProductosServicios.separatorStyle = .none
            return 0
        case 2:
            if model.publicacionesFavoritas.count == 0
            {
                tableProductosServicios.separatorStyle = .none
                return 0
            } else
            {
                tableProductosServicios.separatorStyle = .singleLine
                return 1
            }
        default:
            break
        }
        
        tableProductosServicios.separatorStyle = .none
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return model.publicacionesFavoritas.count
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritoTableViewCell")  as! FavoritoTableViewCell
        
        if let amountString = model.publicacionesFavoritas[indexPath.row].precio?.currencyInputFormatting()
        {
            cell.lblPrecio.text = amountString
        }
        
        cell.lblNombreProducto.text = model.publicacionesFavoritas[indexPath.row].nombre
        
        if (model.publicacionesFavoritas[indexPath.row].fotos?.count)! > 0
        {
            let path = "productos/" + (model.publicacionesFavoritas[indexPath.row].idPublicacion)! + "/" + (model.publicacionesFavoritas[indexPath.row].fotos?[0].nombreFoto)!
            
            cell.imgProducto.loadImageUsingCacheWithUrlString(pathString: path)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        modelOferente.publicacion = model.publicacionesFavoritas[indexPath.row]
        
        if modelOferente.publicacion.servicio!
        {
            self.performSegue(withIdentifier: "publicacionServicioDesdeVistaCarrito", sender: self)
        } else
        {
            self.performSegue(withIdentifier: "publicacionProductoDesdeVistaCarrito", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Comando.getPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
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
