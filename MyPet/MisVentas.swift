//
//  MisVentas.swift
//  MyPet
//
//  Created by Andres Garcia on 8/16/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth



class MisVentas: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var btnActivas: UIButton!
    @IBOutlet var btnInactivas: UIButton!
    
    let model = ModeloOferente.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    var publicaciones = [PublicacionOferente]()
    
    var estadoPublicacion = ""
    
    var selectedIndex = -1
    
    @IBOutlet var tableMisPublicaciones: UITableView!
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "PublicacionTableViewCell", bundle: nil)
        tableMisPublicaciones.register(nib, forCellReuseIdentifier: "publicacionTableViewCell")
        
        estadoPublicacion = "abiertas"
        
        cargarPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintarXPregunta), name:NSNotification.Name(rawValue:"cargoPregunta"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintarXPregunta), name:NSNotification.Name(rawValue:"cargoVenta"), object: nil)
        
        
        
    }
    
    func cargarPublicaciones()
    {
        if estadoPublicacion == "abiertas"
        {
            publicaciones = model.getPublicacionesDeMisVentas(abiertas: true)
        }else
        {
            publicaciones = model.getPublicacionesDeMisVentas(abiertas: false)
        }
        
        tableMisPublicaciones.reloadData()
    }
    
    
    func repintarXPregunta(){
        if estadoPublicacion == "abiertas"
        {
            publicaciones = model.getPublicacionesDeMisVentas(abiertas: true)
        }else
        {
            publicaciones = model.getPublicacionesDeMisVentas(abiertas: false)
        }
        
        tableMisPublicaciones.reloadData()
        
    }
    
    
    @IBAction func mostrarPublicaciones(_ sender: Any)
    {
        let btnEstado:UIButton = sender as! UIButton
        
        if btnEstado.tag == 1
        {
            btnActivas.setImage(UIImage(named: "btnActivoAzul"), for: UIControlState.normal)
            btnInactivas.setImage(UIImage(named: "btnInactivoGris"), for: UIControlState.normal)
            
            estadoPublicacion = "abiertas"
            
        } else
        {
            ComandoCompras.getMisCompras(abiertas: false)
            btnActivas.setImage(UIImage(named: "btnActivoGris"), for: UIControlState.normal)
            btnInactivas.setImage(UIImage(named: "btnInactivoAzul"), for: UIControlState.normal)
            
            estadoPublicacion = "cerradas"
        }
        
        cargarPublicaciones()
    }
    
    
    
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if publicaciones.count > 0
        {
            Comando.init().EmptyMessage("", tableView: tableMisPublicaciones)
            
            tableMisPublicaciones.separatorStyle = .singleLine
            
            return 1
        } else
        {
            Comando.init().EmptyMessage("No tienes publicaciones con Ventas \(estadoPublicacion)", tableView: tableMisPublicaciones)
            
            tableMisPublicaciones.separatorStyle = .none
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return publicaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let publi = publicaciones[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicacionTableViewCell")  as! PublicacionTableViewCell
        
        if let amountString = publi.precio?.currencyInputFormatting()
        {
            cell.lblPrecio.text = amountString
        }
        
        cell.lblNombreProducto.text = publi.nombre
        
        
        
        var ventas = 0
        
        //Pintamos si numero de preguntas sin contestar
        if estadoPublicacion == "abiertas" {
        
            ventas = model.getMisVentasDeUnaPublicacion(abiertas: true, idPublicacion: publi.idPublicacion!).count
        }
        else {
            ventas = model.getMisVentasDeUnaPublicacion(abiertas: false, idPublicacion: publi.idPublicacion!).count
        }
        
        if  ventas == 0 {
            cell.imgCirculo.isHidden = true
        }
        else {
            cell.imgCirculo.isHidden = false
            cell.numeroPreguntas.text = String(ventas)  // en realidad  es numero de ventas
        }
        
        
        
        if publi.destacado!
        {
            cell.imgDestacado.isHidden = false
        } else
        {
            cell.imgDestacado.isHidden = true
        }
        
        if (publi.fotos?.count)! > 0
        {
            let path = "productos/" + (publi.idPublicacion)! + "/" + (publi.fotos?[0].nombreFoto)!
            
            cell.imgProducto.loadImageUsingCacheWithUrlString(pathString: path)
        }
        
        return cell;
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedIndex = indexPath.row
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.performSegue(withIdentifier: "verListaMismoProducto", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //Edited
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "verListaMismoProducto")
        {
            let publi = publicaciones[selectedIndex]
            
            let detailController = segue.destination as! MisVentasXProducto
            detailController.publicacion = publi
            
            if estadoPublicacion == "abiertas" {
                detailController.abiertas = true
            } else {
                detailController.abiertas = false
            }
        }
    }
    
}
