//
//  PublicacionServicioViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 24/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class PublicacionServicioViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    let model = Modelo.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    let  user = FIRAuth.auth()?.currentUser
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceLeadingLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var spaceLeadingBtnPreguntarLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var scrollContent: UIScrollView!
    
    @IBOutlet var barItemFavorito: UIBarButtonItem!
    
    var pageViewController:UIPageViewController!
    
    @IBOutlet var lblNombre: UILabel!
    @IBOutlet var lblPrecio: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var txtDescripcion: UITextView!
    @IBOutlet var lblPreguntas: UILabel!
    
    @IBOutlet var btnComprar: UIButton!
    @IBOutlet var btnCarrito: UIButton!
    
    @IBOutlet var btnPreguntar: UIButton!
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Configurar scrollview
        
        scrollContent.bounces = false
        scrollContent.isScrollEnabled = true
        
        scrollContent.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: 755.0)
        
        lblNombre.text = modelOferente.publicacion.nombre
        
        if let amountString = modelOferente.publicacion.precio?.currencyInputFormatting()
        {
            lblPrecio.text = amountString
        }
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "imgEstrellaVacia")
        self.floatRatingView.fullImage = UIImage(named: "imgEstrellaCompleta")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.minRating = 0
        self.floatRatingView.maxRating = 5
        self.floatRatingView.rating = 0.0
        self.floatRatingView.editable = false
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        
        txtDescripcion.text = modelOferente.publicacion.descripcion
        
        btnComprar.layer.cornerRadius = 10.0
        
        btnPreguntar.layer.cornerRadius = 10.0
    }

    func refrescarVista(_ notification: Notification)
    {
        if modelUsuario.usuario.count != 0
        {
            if modelUsuario.usuario[0].datosComplementarios?.count != 0
            {
                if modelUsuario.usuario[0].datosComplementarios?[0].favoritos?.count != 0
                {
                    var activo:Bool = false
                    
                    for favorito in (modelUsuario.usuario[0].datosComplementarios?[0].favoritos)!
                    {
                        if favorito.idPublicacion == modelOferente.publicacion.idPublicacion!
                        {
                            activo = true
                        }
                    }
                    
                    if activo
                    {
                        barItemFavorito.image = UIImage(named: "btnFavorito")?.withRenderingMode(.alwaysOriginal)
                    } else
                    {
                        barItemFavorito.image = UIImage(named: "btnNoFavorito")?.withRenderingMode(.alwaysOriginal)
                    }
                    
                }else
                {
                    barItemFavorito.image = UIImage(named: "btnNoFavorito")?.withRenderingMode(.alwaysOriginal)
                }
            } else
            {
                barItemFavorito.image = UIImage(named: "btnNoFavorito")?.withRenderingMode(.alwaysOriginal)
            }
        }else
        {
            barItemFavorito.image = UIImage(named: "btnNoFavorito")?.withRenderingMode(.alwaysOriginal)
        }
        
        if model.preguntasPublicacion.count == 0
        {
            lblPreguntas.text = "Aún no hay preguntas"
        } else
        {
            if model.preguntasPublicacion.count == 1
            {
                lblPreguntas.text = "Ver la pregunta realizada"
            } else
            {
                lblPreguntas.text = "Ver las \(model.preguntasPublicacion.count) preguntas realizadas"
            }
        }
    }
    
    @IBAction func marcarComoFavorito(_ sender: Any)
    {
        if modelUsuario.usuario.count == 0
        {
            self.mostrarAlerta(titulo: "Lo sentimos", mensaje: "Para poder marcarlo como Favorito debes estar registrado")
        }else
        {
            if modelUsuario.usuario[0].datosComplementarios?.count == 0
            {
                self.mostrarAlerta(titulo: "Lo sentimos", mensaje: "Para poder marcarlo como Favorito debes estar completamente registrado")
            } else
            {
                if modelUsuario.usuario[0].datosComplementarios?[0].favoritos?.count == 0
                {
                    ComandoUsuario.activarDesactivarFavorito(uid: (user?.uid)!, idPublicacion: modelOferente.publicacion.idPublicacion!, activo: true)
                }else
                {
                    var activo:Bool = true
                    
                    for favorito in (modelUsuario.usuario[0].datosComplementarios?[0].favoritos)!
                    {
                        if favorito.idPublicacion == modelOferente.publicacion.idPublicacion!
                        {
                            if favorito.activo!
                            {
                                activo = false
                            } else
                            {
                                activo = true
                            }
                        }
                    }
                    
                    if activo
                    {
                        ComandoUsuario.activarDesactivarFavorito(uid: (user?.uid)!, idPublicacion: modelOferente.publicacion.idPublicacion!, activo: true)
                    } else
                    {
                        ComandoUsuario.activarDesactivarFavorito(uid: (user?.uid)!, idPublicacion: modelOferente.publicacion.idPublicacion!, activo: false)
                    }
                }
            }
        }
        
        if user?.uid != nil
        {
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublicacionProductoViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
    }
    
    @IBAction func verResena(_ sender: Any)
    {
        self.performSegue(withIdentifier: "resenaCompradoresDesdePublicacionServicio", sender: self)
    }
    
    @IBAction func agendarServicio(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.performSegue(withIdentifier: "agendarDesdePublicacionServicio", sender: self)
    }
    
    @IBAction func verPreguntas(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.performSegue(withIdentifier: "vistaPreguntasDesdePublicacionServicio", sender: self)
    }
    
    @IBAction func preguntar(_ sender: Any)
    {
        if modelUsuario.usuario.count == 0
        {
            self.mostrarAlerta(titulo: "Lo sentimos", mensaje: "Para formular tu pregunta debes estar registrado y así poder enviarte una notificación cuando haya una respuesta")
        }else
        {
            if modelUsuario.usuario[0].datosComplementarios?.count == 0
            {
                self.mostrarAlerta(titulo: "Lo sentimos", mensaje: "Para formular tu pregunta debes estar completamente registrado y así poder enviarte una notificación cuando haya una respuesta")
            } else
            {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                
                self.performSegue(withIdentifier: "preguntarDesdePublicacionServicio", sender: self)
            }
        }
    }
    
    @IBAction func verInfoVendedor(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.performSegue(withIdentifier: "infoVendedorDesdePublicacionServicio", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.init(red: 0.698039215686275, green: 0.698039215686275, blue: 0.698039215686275, alpha: 1.0)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.init(red: 0.0, green: 0.756862745098039, blue: 0.835294117647059, alpha: 1.0)
        
        ComandoOferente.getOferente(uid: modelOferente.publicacion.idOferente)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublicacionServicioViewController.hacerMontaje(_:)), name:NSNotification.Name(rawValue:"cargoOferente"), object: nil)
        
        if user?.uid != nil
        {
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublicacionServicioViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
        
        ComandoPublicacion.getPreguntasRespuestasPublicacionOferente(idPublicacion: modelOferente.publicacion.idPublicacion!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublicacionServicioViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPreguntasRespuestasPublicacion"), object: nil)
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
        
        if (segue.identifier == "vistaPreguntasDesdePublicacionServicio")
        {
            let detailController = segue.destination as! VistaPreguntasViewController
            detailController.tituloVista = "Preguntas sobre el servicio"
        }
    }
    
    // PageViewController
    
    func hacerMontaje(_ notification: Notification)
    {
        print("count Servicio: \(modelOferente.oferente.count) - \(modelOferente.publicacion.idOferente)")
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
            pageViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
            
            spaceLeadingLayoutConstraint?.constant = 95.0
            spaceLeadingBtnPreguntarLayoutConstraint?.constant = 95.0
        } else
        {
            if DeviceType.IS_IPHONE_6
            {
                pageViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.37)
                
                spaceLeadingLayoutConstraint?.constant = 114.0
                spaceLeadingBtnPreguntarLayoutConstraint?.constant = 114.0
            } else
            {
                pageViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
                
                spaceLeadingLayoutConstraint?.constant = 140.0
                spaceLeadingBtnPreguntarLayoutConstraint?.constant = 140.0
            }
        }
        
        pageController.view.backgroundColor = UIColor.clear
        pageViewController?.view.backgroundColor = UIColor.clear
        
        addChildViewController(pageViewController!)
        self.scrollContent.addSubview(pageViewController!.view)
        self.scrollContent.sendSubview(toBack: pageViewController!.view)
        
        pageViewController!.didMove(toParentViewController: self)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    fileprivate func pageFotoAtIndex(_ index: Int) -> FotoViewController
    {
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "fotoViewController") as! FotoViewController
        
        pageContentViewController.pathImage = "productos/" + (modelOferente.publicacion.idPublicacion)! + "/" + (modelOferente.publicacion.fotos?[index].nombreFoto)!
        
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
        
        if itemController.pageIndex + 1 < (modelOferente.publicacion.fotos?.count)!
        {
            return pageFotoAtIndex(itemController.pageIndex + 1)
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return (modelOferente.publicacion.fotos?.count)!
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    // Validación de datos
    
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
