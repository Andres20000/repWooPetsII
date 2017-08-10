//
//  FotoViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 29/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class FotoViewController: UIViewController
{
    let model = Modelo.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    var pathImage:String!
    var pageIndex:Int!
    
    @IBOutlet var contentImageView: UIImageView!
    
    @IBOutlet var imgDegradado: UIImageView!
    @IBOutlet var lblTitulo: UILabel!
    @IBOutlet var lblPrecio: UILabel!
    
    @IBOutlet var btnActionView: UIButton!
    var elementosOcultos:Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.layer.masksToBounds = true
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.leftAnchor.constraint(equalTo: contentImageView.leftAnchor, constant: 8).isActive = true
        contentImageView.centerYAnchor.constraint(equalTo: contentImageView.centerYAnchor).isActive = true
        contentImageView.widthAnchor.constraint(equalToConstant: contentImageView.frame.width).isActive = true
        contentImageView.heightAnchor.constraint(equalToConstant: contentImageView.frame.height).isActive = true
        
        contentImageView.loadImageUsingCacheWithUrlString(pathString: pathImage)
        
        btnActionView.tag = pageIndex
        
        imgDegradado.isHidden = elementosOcultos
        lblTitulo.isHidden = elementosOcultos
        lblPrecio.isHidden = elementosOcultos
        
        if !elementosOcultos
        {
            lblTitulo.text = (model.publicacionesDestacadas[pageIndex].nombre)!
            lblPrecio.text = (model.publicacionesDestacadas[pageIndex].precio)!.currencyInputFormatting()
        }
        
        btnActionView.isHidden = elementosOcultos
    }

    @IBAction func verPublicacion(_ sender: Any)
    {
        let btnPublicacion:UIButton = sender as! UIButton
        
        modelOferente.publicacion = model.publicacionesDestacadas[btnPublicacion.tag]
        
        if modelOferente.publicacion.servicio!
        {
            self.performSegue(withIdentifier: "publicacionServicioDesdeDestacados", sender: self)
        } else
        {
            self.performSegue(withIdentifier: "publicacionProductoDesdeDestacados", sender: self)
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
