//
//  PreguntasFrecuentes.swift
//  MyPet
//
//  Created by Andres Garcia on 9/9/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PreguntasFrecuentes: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tabla: UITableView!
    
    
    
    var filtered:[PreguntaFrecuente] = []
    
    var searchActive = false {
        willSet {
            print("pilas")
        }
    }
    
    var texto = ""
    
    
    let model = ModeloOferente.sharedInstance
    
    
    
    var selectedIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CeldaPreguntaFrecuente", bundle: nil)
        tabla.register(nib, forCellReuseIdentifier: "CeldaPreguntaFrecuente")
        
        tabla.rowHeight = UITableViewAutomaticDimension
        tabla.estimatedRowHeight = 120

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if texto != "" {
            searchActive = true
        }
        
        tabla.allowsSelection = false
        tabla.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if texto != "" {
            return filtered.count
        }
        else {
            return model.preguntasFrecuentes.count
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return armarPregunta(indexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "detalle", sender: self)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        search.resignFirstResponder()
        tabla.reloadData()
    }
    
    
    
    
    func armarPregunta(_ index:Int) -> CeldaPreguntaFrecuente {
        
        let cell = tabla.dequeueReusableCell(withIdentifier: "CeldaPreguntaFrecuente")  as! CeldaPreguntaFrecuente
        
        //let sub = model.ingredientesRevueltes[index].subcategoria
        //print(sub)
        
        var pregu:PreguntaFrecuente
        
        if texto != "" {
            filtered = model.preguntasFrecuentes.filter { $0.cadenaBusqueda.range(of: texto, options: .caseInsensitive) != nil  }
            pregu = filtered[index]
        }
        else {
            pregu = model.preguntasFrecuentes[index]
        }
        
        
        cell.pregunta.text = "P: " + pregu.pregunta
        cell.respuesta.text = "R: " + pregu.respuesta
        
        
        ///Botones
        //cell.botonDetalle.addTarget(self, action: #selector(self.callBotonDetalle(_:)), for: .touchUpInside)
        //cell.botonDetalle.tag = index
        
        return cell
        
    }
    
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        texto = searchText
        filtered = model.preguntasFrecuentes.filter { $0.cadenaBusqueda.range(of: searchText, options: .caseInsensitive) != nil  }
        
        if(filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        tabla.reloadData()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        tabla.reloadData()
    }

    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }


    
}
