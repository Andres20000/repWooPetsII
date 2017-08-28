//
//  DetallePublicacionOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 20/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DetallePublicacionOferenteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    let model = ModeloOferente.sharedInstance
    
    var vistoDesde:String?
    
    @IBOutlet var imgEstadoDestacado: UIImageView!
    @IBOutlet var lblEstadoDestacado: UILabel!
    @IBOutlet var lblCategoria: UILabel!
    @IBOutlet var lblSubcategoria: UILabel!
    @IBOutlet var lblTipoAnimal: UILabel!
    @IBOutlet var tableDatosPublicacion: UITableView!
    @IBOutlet var viewFooterTableView: UIView!
    
    @IBOutlet var btnEstado: UIButton!
    @IBOutlet var lblEstado: UILabel!
    
    var pageViewController:UIPageViewController!
    
    var tituloDatoPublicacion = ["Título","Descripción","Precio", "Horario", "Cantidad"]
    
    var DatoPublicacion:NSMutableArray = NSMutableArray(array: ["","","", ""])
    
    @IBAction func backView(_ sender: Any)
    {
        if vistoDesde == "NuevaPublicacion"
        {
            self.performSegue(withIdentifier: "returnHomeOferenteDesdeDetallePublicacion", sender: self)
        }else
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "DetalleEstandarTableViewCell", bundle: nil)
        tableDatosPublicacion.register(nib, forCellReuseIdentifier: "detalleEstandarTableViewCell")
        
        let nib2 = UINib(nibName: "DetalleHorarioTableViewCell", bundle: nil)
        tableDatosPublicacion.register(nib2, forCellReuseIdentifier: "detalleHorarioTableViewCell")
        
        let nib3 = UINib(nibName: "DetalleDescripcionTableViewCell", bundle: nil)
        tableDatosPublicacion.register(nib3, forCellReuseIdentifier: "detalleDescripcionTableViewCell")
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tituloDatoPublicacion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detalleEstandarTableViewCell")  as! DetalleEstandarTableViewCell
        cell.viewDetalleEstandarBottom.isHidden = true
        
        if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detalleDescripcionTableViewCell")  as! DetalleDescripcionTableViewCell
            
            cell.lblTitulo.text = tituloDatoPublicacion[indexPath.row]
            cell.textDescripcion.text = DatoPublicacion[indexPath.row] as? String
            
            return cell
        }
        
        if (model.publicacion.horario?.count)! > 0
        {
            if indexPath.row == 3
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "detalleHorarioTableViewCell")  as! DetalleHorarioTableViewCell
                
                if DeviceType.IS_IPHONE_5
                {
                    cell.lblDiasSemana.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                    cell.lblHorarioDiasSemana.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                    
                    cell.lblDiasFestivos.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                    cell.lblHorarioDiasFestivos.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                }
                
                cell.lblTitulo.text = tituloDatoPublicacion[indexPath.row]
                
                for horario in (model.publicacion.horario)!
                {
                    if horario.nombreArbol == "Semana"
                    {
                        cell.lblDiasSemana.text = horario.dias
                        cell.lblHorarioDiasSemana.text = (horario.horaInicio)! + " - " + (horario.horaCierre)!
                    } else
                    {
                        cell.lblDiasFestivos.text = horario.dias
                        cell.lblHorarioDiasFestivos.text = (horario.horaInicio)! + " - " + (horario.horaCierre)!
                    }
                }
                
                return cell
            }
        }
        
        cell.lblTitulo.text = tituloDatoPublicacion[indexPath.row]
        
        if indexPath.row == 3
        {
            cell.viewDetalleEstandarBottom.isHidden = false
            cell.lblDescripcion.text = "\((DatoPublicacion[indexPath.row] as? Int)!)"
            
        }else
        {
            cell.lblDescripcion.text = DatoPublicacion[indexPath.row] as? String
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
        // No aplica
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //Edited
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 1
        {
            return 95
        }
        
        if indexPath.row == 3
        {
            if (model.publicacion.horario?.count)! == 1
            {
                return 50
            } else
            {
                if (model.publicacion.horario?.count)! == 2
                {
                    return 70
                }
            }
        }
        
        return 59
    }
    
    @IBAction func editarPublicacion(_ sender: Any)
    {
        let alert:UIAlertController = UIAlertController(title: "¡Editar Publicación!", message: "¿Qué información de tu publicación deseas editar?", preferredStyle: .actionSheet)
        
        let irATipoAction = UIAlertAction(title: "Tipo", style: .default)
        {
            UIAlertAction in self .editarTipo()
        }
        
        let irAlArticuloAction = UIAlertAction(title: "Artículo", style: .default)
        {
            UIAlertAction in self .editarArticulo()
        }
        
        let irAFoto = UIAlertAction(title: "Fotos", style: .default)
        {
            UIAlertAction in self .editarFotos()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(irATipoAction)
        alert.addAction(irAlArticuloAction)
        alert.addAction(irAFoto)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editarTipo()
    {
        self.performSegue(withIdentifier: "EditarTipoDesdeDetallePublicacion", sender: self)
    }
    
    func editarArticulo()
    {
        self.performSegue(withIdentifier: "EditarArticuloDesdeDetallePublicacion", sender: self)
    }
    
    func editarFotos()
    {
        self.performSegue(withIdentifier: "EditarFotoDesdeDetallePublicacion", sender: self)
    }
    
    @IBAction func estadoPublicacion(_ sender: Any)
    {
        if model.publicacion.activo!
        {
            btnEstado.setImage(UIImage(named: "btnInactivoGris"), for: UIControlState.normal)
            lblEstado.text = "Inactivo"
            model.publicacion.activo = false
            
            ComandoPublicacion.updateEstadoPublicacion(idPublicacion: model.publicacion.idPublicacion!, activo: false)
        } else
        {
            btnEstado.setImage(UIImage(named: "btnActivoAzul"), for: UIControlState.normal)
            lblEstado.text = "Activo"
            model.publicacion.activo = true
            
            ComandoPublicacion.updateEstadoPublicacion(idPublicacion: model.publicacion.idPublicacion!, activo: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (model.publicacion.horario?.count)! > 0
        {
            for horario in (model.publicacion.horario)!
            {
                if horario.nombreArbol == "Semana"
                {
                    model.horarioSemana.dias = horario.dias
                    model.horarioSemana.horaInicio = horario.horaInicio
                    model.horarioSemana.horaCierre = horario.horaCierre
                    model.horarioSemana.nombreArbol = horario.nombreArbol
                } else
                {
                    model.horarioFestivo.dias = horario.dias
                    model.horarioFestivo.horaInicio = horario.horaInicio
                    model.horarioFestivo.horaCierre = horario.horaCierre
                    model.horarioFestivo.nombreArbol = horario.nombreArbol
                }
            }
        }
        
        if model.publicacion.destacado!
        {
            imgEstadoDestacado.image = UIImage(named: "imgDestacadoBlanco")
            lblEstadoDestacado.textColor = UIColor.white
            lblEstadoDestacado.text = "Destacada"
        } else
        {
            imgEstadoDestacado.image = UIImage(named: "btnDestacar")
            lblEstadoDestacado.text = "Destacar"
        }
        
        lblCategoria.text = model.publicacion.categoria
        
        if model.publicacion.subcategoria == ""
        {
            lblSubcategoria.text = "No aplica"
        }else
        {
            lblSubcategoria.text = model.publicacion.subcategoria
        }
        
        lblTipoAnimal.text = model.publicacion.target
        
        DatoPublicacion.removeObject(at: 0)
        DatoPublicacion.insert(model.publicacion.nombre as Any, at: 0)
        
        DatoPublicacion.removeObject(at: 1)
        DatoPublicacion.insert(model.publicacion.descripcion as Any, at: 1)
        
        DatoPublicacion.removeObject(at: 2)
        DatoPublicacion.insert(model.publicacion.precio?.currencyInputFormatting() as Any, at: 2)
        
        if model.publicacion.servicio!
        {
            tituloDatoPublicacion = ["Título","Descripción","Precio", "Horario"]
            
        } else
        {
            tituloDatoPublicacion = ["Título","Descripción","Precio", "Cantidad"]
            
            print("stock: \(model.publicacion.stock)")
            DatoPublicacion.removeObject(at: 3)
            DatoPublicacion.insert(model.publicacion.stock as Any, at: 3)
            print("stock después: \(DatoPublicacion[3])")
        }
        
        tableDatosPublicacion.reloadData()
        
        if model.publicacion.activo!
        {
            btnEstado.setImage(UIImage(named: "btnActivoAzul"), for: UIControlState.normal)
            lblEstado.text = "Activo"
        } else
        {
            btnEstado.setImage(UIImage(named: "btnInactivoGris"), for: UIControlState.normal)
            lblEstado.text = "Inactivo"
        }
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.init(red: 0.698039215686275, green: 0.698039215686275, blue: 0.698039215686275, alpha: 1.0)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.init(red: 0.0, green: 0.756862745098039, blue: 0.835294117647059, alpha: 1.0)
        
        hacerMontaje()
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
        
        if (segue.identifier == "EditarTipoDesdeDetallePublicacion")
        {
            let detailController = segue.destination as! PublicacionOferenteDosViewController
            detailController.datosEditables = true
        }
        
        if (segue.identifier == "EditarArticuloDesdeDetallePublicacion")
        {
            let detailController = segue.destination as! PublicacionOferenteTresViewController
            detailController.datosEditables = true
        }
        
        if (segue.identifier == "EditarFotoDesdeDetallePublicacion")
        {
            let detailController = segue.destination as! PublicacionOferenteCuatroViewController
            detailController.datosEditables = true
        }
        
        if (segue.identifier == "destacar")
        {
            let detailController = segue.destination as! DestacarPublicacionViewController
            detailController.publicacion = model.publicacion
        }
        
        
    }

    // PageViewController
    
    func hacerMontaje()
    {
        createPageViewController()
    }
    
    fileprivate func createPageViewController()
    {
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "FotosPageController") as! UIPageViewControllerWithOverlayIndicator
        
        pageController.dataSource = self
        pageController.delegate = self
        
        
        let firstController = pageFotoAtIndex(0)
        
        let startingViewControllers: NSArray = [firstController]
        
        pageController.setViewControllers(startingViewControllers as? [UIViewController] , direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        pageViewController = pageController
        
        if DeviceType.IS_IPHONE_5
        {
            pageViewController?.view.frame = CGRect(x: 0, y: 92, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.39)
        } else
        {
            if DeviceType.IS_IPHONE_6
            {
                pageViewController?.view.frame = CGRect(x: 0, y: 92, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.41)
            } else
            {
                pageViewController?.view.frame = CGRect(x: 0, y: 92, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.44)
            }
        }
        
        self.viewFooterTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:pageController.view.frame.size.width)
        
        pageController.view.backgroundColor = UIColor.clear
        pageViewController?.view.backgroundColor = UIColor.clear
        
        addChildViewController(pageViewController!)
        self.viewFooterTableView.addSubview(pageViewController!.view)
        self.viewFooterTableView.sendSubview(toBack: pageViewController!.view)
        
        pageViewController!.didMove(toParentViewController: self)
        
        
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    fileprivate func pageFotoAtIndex(_ index: Int) -> FotoViewController
    {
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "fotoViewController") as! FotoViewController
        
        pageContentViewController.pathImage = "productos/" + (model.publicacion.idPublicacion)! + "/" + (model.publicacion.fotos?[index].nombreFoto)!
        
        pageContentViewController.pageIndex = index
        
        pageContentViewController.elementosOcultos = true
        
        return pageContentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let itemController = viewController as! FotoViewController
        
        if itemController.pageIndex > 0
        {
            return pageFotoAtIndex(itemController.pageIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let itemController = viewController as! FotoViewController
        
        if itemController.pageIndex + 1 < (model.publicacion.fotos?.count)!
        {
            return pageFotoAtIndex(itemController.pageIndex + 1)
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return (model.publicacion.fotos?.count)!
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}

class UIPageViewControllerWithOverlayIndicator: UIPageViewController
{
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubview(toFront: subView)
            }
        }
        
        super.viewDidLayoutSubviews()
    }
}
