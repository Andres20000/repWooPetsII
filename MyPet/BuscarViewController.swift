//
//  BuscarViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 11/09/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class BuscarViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate
{
    var model  = Modelo.sharedInstance
    var modelOferente  = ModeloOferente.sharedInstance
    
    var publicaciones = [PublicacionOferente]()
    var filteredPublicaciones:[PublicacionOferente] = []
    
    @IBOutlet weak var searchPublicaciones: UISearchBar!
    @IBOutlet weak var tableBuscar: UITableView!
    
    var searchActive : Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //publicaciones = model.publicacionesPopulares
        
        let nib = UINib(nibName: "BusquedaTableViewCell", bundle: nil)
        tableBuscar.register(nib, forCellReuseIdentifier: "busquedaTableViewCell")
        tableBuscar.keyboardDismissMode = .onDrag
        
        UISearchBar.appearance().setImage(UIImage(named: "emptyImg"), for: UISearchBarIcon.clear, state: .normal)
        UISearchBar.appearance().setImage(UIImage(named: "emptyImg"), for: UISearchBarIcon.clear, state: UIControlState.highlighted)
    }
    
    // #pragma mark - SearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        print("Borra")
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.characters.count == 0
        {
            searchActive = false
        } else
        {
            searchActive = true
            
            filteredPublicaciones = publicaciones.filter { $0.cadenaBusquedaPublicacion.range(of: searchText, options: .caseInsensitive) != nil  }
        }
        
        tableBuscar.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if searchActive
        {
            if filteredPublicaciones.count > 0
            {
                Comando.init().EmptyMessage("", tableView: tableBuscar)
                
                tableBuscar.separatorStyle = .singleLine
                
                return 1
            } else
            {
                Comando.init().EmptyMessage("No se encuentran coincidencias", tableView: tableBuscar)
                
                tableBuscar.separatorStyle = .none
                
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchActive
        {
            return filteredPublicaciones.count
        }
        return publicaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "busquedaTableViewCell")  as! BusquedaTableViewCell
        
        if(searchPublicaciones.text != "")
        {
            if let amountString = filteredPublicaciones[indexPath.row].precio?.currencyInputFormatting()
            {
                cell.lblPrecio.text = amountString
            }
            
            cell.lblNombreProducto.text = filteredPublicaciones[indexPath.row].nombre
            
            if (filteredPublicaciones[indexPath.row].fotos?.count)! > 0
            {
                let path = "productos/" + (filteredPublicaciones[indexPath.row].idPublicacion)! + "/" + (filteredPublicaciones[indexPath.row].fotos?[0].nombreFoto)!
                
                cell.imgProducto.loadImageUsingCacheWithUrlString(pathString: path)
            }
        } else
        {
            if let amountString = publicaciones[indexPath.row].precio?.currencyInputFormatting()
            {
                cell.lblPrecio.text = amountString
            }
            
            cell.lblNombreProducto.text = publicaciones[indexPath.row].nombre
            
            if (publicaciones[indexPath.row].fotos?.count)! > 0
            {
                let path = "productos/" + (publicaciones[indexPath.row].idPublicacion)! + "/" + (publicaciones[indexPath.row].fotos?[0].nombreFoto)!
                
                cell.imgProducto.loadImageUsingCacheWithUrlString(pathString: path)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if searchPublicaciones.text != ""
        {
            modelOferente.publicacion = filteredPublicaciones[indexPath.row]
            
            if modelOferente.publicacion.servicio!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdeBuscar", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdeBuscar", sender: self)
            }
        } else
        {
            modelOferente.publicacion = publicaciones[indexPath.row]
            
            if modelOferente.publicacion.servicio!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdeBuscar", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdeBuscar", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tableBuscar.reloadData()
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
