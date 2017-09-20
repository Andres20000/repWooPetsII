//
//  PublicacionesPorCategoriaViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PublicacionesPorCategoriaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    let model = Modelo.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var barItemTitulo: UIBarButtonItem!
    @IBOutlet var barItemIcono: UIBarButtonItem!
    @IBOutlet var barItemBuscar: UIBarButtonItem!
    @IBOutlet var barFixedSpace1: UIBarButtonItem!
    @IBOutlet var barFixedSpace: UIBarButtonItem!
    
    @IBOutlet var lblTituloPublicacionesCategoria: UILabel!
    @IBOutlet var collectionPublicacionesMascota: UICollectionView!
    @IBOutlet var lblAvisoPublicacionesMascota: UILabel!
    
    @IBOutlet var lblTituloPublicacionesGeneral: UILabel!
    @IBOutlet var collectionPublicacionesCategoria: UICollectionView!
    @IBOutlet var lblAvisoPublicacionesCategoria: UILabel!
    
    var nombreCategoria = ""
    var nombreIconoCategoria = ""
    var fixedSpaceWidth1:CGFloat = 0.0
    var fixedSpaceWidth:CGFloat = 0.0
    var tituloPublicacionesCategoria = ""
    
    @IBAction func backView(_ sender: Any)
    {
        model.publicacionesPorCategoriaPorMascota.removeAll()
        model.publicacionesPorCategoria.removeAll()
    
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        barItemTitulo.title = nombreCategoria
        barItemIcono.image = UIImage(named: nombreIconoCategoria)?.withRenderingMode(.alwaysOriginal)
        barFixedSpace1.width = fixedSpaceWidth1
        barFixedSpace.width = fixedSpaceWidth
        barItemBuscar.image = UIImage(named: "btnBuscarBlanco")?.withRenderingMode(.alwaysOriginal)
        
        self.spaceTopLayoutConstraint?.constant = 270
        
        if tituloPublicacionesCategoria == ""
        {
            lblTituloPublicacionesCategoria.text = "   Productos populares en esta categoría"
            self.spaceTopLayoutConstraint?.constant = 30
            
        } else
        {
            lblTituloPublicacionesCategoria.text = "   Productos sugeridos para \(tituloPublicacionesCategoria)"
        }
        
        // Configurar CollectionView
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout.scrollDirection = .horizontal
        
        // register the nib
        collectionPublicacionesMascota!.register(UINib(nibName: "PublicacionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "publicacionCollectionViewCell")
        
        collectionPublicacionesMascota.collectionViewLayout = flowLayout
        
        collectionPublicacionesMascota.tag = 1
        
        collectionPublicacionesMascota .reloadData()
        
        if model.publicacionesPorCategoriaPorMascota.count == 0
        {
            lblAvisoPublicacionesMascota.isHidden = false
            lblTituloPublicacionesGeneral.text = "   Productos en esta categoría"
            
        } else
        {
            lblAvisoPublicacionesMascota.isHidden = true
            lblTituloPublicacionesGeneral.text = "   Más en esta categoría"
        }
        
        let flowLayout2:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout2.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout2.scrollDirection = .vertical
        
        // register the nib
        collectionPublicacionesCategoria!.register(UINib(nibName: "PublicacionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "publicacionCollectionViewCell")
        
        collectionPublicacionesCategoria.collectionViewLayout = flowLayout2
        
        collectionPublicacionesCategoria.tag = 2
        
        collectionPublicacionesCategoria .reloadData()
        
        if model.publicacionesPorCategoria.count == 0
        {
            lblAvisoPublicacionesCategoria.isHidden = false
        }
    }
    
    @IBAction func buscarPublicaciones(_ sender: Any)
    {
        self.performSegue(withIdentifier: "buscarDesdePublicacionesPorCategoria", sender: self)
    }
    
    // #pragma mark - Collection View
    
    // 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 1
        {
            return model.publicacionesPorCategoriaPorMascota.count
        }
        
        return model.publicacionesPorCategoria.count
    }
    
    // 2
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "publicacionCollectionViewCell", for: indexPath as IndexPath) as! PublicacionCollectionViewCell
            
            cell.imgFotoPublicacion.layer.borderWidth = 1.0
            cell.imgFotoPublicacion.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            
            if (model.publicacionesPorCategoriaPorMascota[indexPath.row].fotos?.count)! > 0
            {
                let path = "productos/" + (model.publicacionesPorCategoriaPorMascota[indexPath.row].idPublicacion)! + "/" + (model.publicacionesPorCategoriaPorMascota[indexPath.row].fotos?[0].nombreFoto)!
                
                cell.imgFotoPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
            }
            
            cell.viewContent.layer.borderWidth = 1.0
            cell.viewContent.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            
            if let amountString = model.publicacionesPorCategoriaPorMascota[indexPath.row].precio?.currencyInputFormatting()
            {
                cell.lblPrecio.text = amountString
            }
            
            cell.lblNombre.text = model.publicacionesPorCategoriaPorMascota[indexPath.row].nombre
            
            return cell
        } else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "publicacionCollectionViewCell", for: indexPath as IndexPath) as! PublicacionCollectionViewCell
            
            cell.imgFotoPublicacion.layer.borderWidth = 1.0
            cell.imgFotoPublicacion.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            
            if (model.publicacionesPorCategoria[indexPath.row].fotos?.count)! > 0
            {
                let path = "productos/" + (model.publicacionesPorCategoria[indexPath.row].idPublicacion)! + "/" + (model.publicacionesPorCategoria[indexPath.row].fotos?[0].nombreFoto)!
                
                cell.imgFotoPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
            }
            
            cell.viewContent.layer.borderWidth = 1.0
            cell.viewContent.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            
            if let amountString = model.publicacionesPorCategoria[indexPath.row].precio?.currencyInputFormatting()
            {
                cell.lblPrecio.text = amountString
            }
            
            cell.lblNombre.text = model.publicacionesPorCategoria[indexPath.row].nombre
            
            return cell
        }
    }
    
    // 3
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if collectionView.tag == 2
        {
            //device screen size
            let width = UIScreen.main.bounds.size.width
            //calculation of cell size
            return CGSize(width: ((width / 2) - 8)   , height: 197)
        }
        
        return CGSize(width: 150, height: 197)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 1
        {
            modelOferente.publicacion = model.publicacionesPorCategoriaPorMascota[indexPath.row]
            
            if modelOferente.publicacion.servicio!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdePublicacionesPorCategoria", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdePublicacionesPorCategoria", sender: self)
            }
        } else
        {
            modelOferente.publicacion = model.publicacionesPorCategoria[indexPath.row]
            
            if modelOferente.publicacion.servicio!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdePublicacionesPorCategoria", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdePublicacionesPorCategoria", sender: self)
            }
        }
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
        
        if (segue.identifier == "buscarDesdePublicacionesPorCategoria")
        {
            let detailController = segue.destination as! BuscarViewController
            detailController.publicaciones = model.publicacionesPorCategoria
        }
    }

}
