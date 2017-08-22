//
//  HomePublicacionesViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

import FirebaseAuth

class HomePublicacionesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    let model = ModeloUsuario.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    let modelPublicacion = Modelo.sharedInstance
    var publicaciones = [PublicacionOferente]()
    
    let  user = FIRAuth.auth()?.currentUser
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var imgFotoMascota: UIImageView!
    @IBOutlet var lblNombreMascota: UILabel!
    @IBOutlet var btnAdministrarMascotas: UIButton!
    
    @IBOutlet var scrollContent: UIScrollView!
    var contentSizeScroll:CGFloat = 0.0
    
    var pageViewController:UIPageViewController!
    
    @IBOutlet var collectionCategorias: UICollectionView!
    var categoria = ""
    var iconoCategoria = ""
    var widthFixedSpace:CGFloat = 0.0
    var textoPublicacionesCategoria = ""
    
    @IBOutlet var lblAvisoHome: UILabel!
    var sizeFont : CGFloat = 0.0
    @IBOutlet var btnAviso: UIButton!
    
    @IBOutlet var lblProductos: UILabel!
    @IBOutlet var imgNoRegistro: UIImageView!
    @IBOutlet var imgNoDireccion: UIImageView!
    @IBOutlet var imgNoTarjeta: UIImageView!
    
    @IBOutlet var collectionPublicaciones: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        publicaciones = modelPublicacion.publicacionesPopulares
        
        contentSizeScroll = 702
        
        imgFotoMascota.isHidden = true
        lblNombreMascota.isHidden = true
        btnAdministrarMascotas.isHidden = true
        
        self.spaceTopLayoutConstraint?.constant = 195
        
        lblProductos.text = "   Productos populares"
        imgNoRegistro.isHidden = false
        imgNoDireccion.isHidden = false
        imgNoTarjeta.isHidden = false
        
        textoPublicacionesCategoria = ""
        
        if user == nil
        {
            if DeviceType.IS_IPHONE_5
            {
                sizeFont = 13.0
            }else
            {
                if DeviceType.IS_IPHONE_6P
                {
                    sizeFont = 17.0
                }else
                {
                    sizeFont = 15.0
                }
            }
            
            //create attributed string txt bold
            lblAvisoHome.text = "Para ver los productos sugeridos,\ningresa, completa tu registro y crea el perfil de tu mascota aquí"
            let textAviso: NSString = lblAvisoHome.text! as NSString
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: textAviso as String)
            
            attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: sizeFont)!], range: NSRange(location: 0, length:33))
            attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: sizeFont)!], range: NSRange(location: 34, length: 65))
            
            //assign text first, then customize properties
            lblAvisoHome.attributedText = attributedText
            
            btnAviso.tag = 0
            btnAviso.addTarget(self, action: #selector(actionAviso), for: .touchUpInside)
            
        }else
        {
            if (model.usuario[0].datosComplementarios?.count)! == 0
            {
                if DeviceType.IS_IPHONE_5
                {
                    sizeFont = 15.0
                }else
                {
                    if DeviceType.IS_IPHONE_6P
                    {
                        sizeFont = 18.2
                    }else
                    {
                        sizeFont = 17.0
                    }
                }
                
                //create attributed string txt bold
                lblAvisoHome.text = "Para ver los productos sugeridos,\ncompleta tu registro y crea el perfil de tu mascota aquí"
                let textAviso: NSString = lblAvisoHome.text! as NSString
                let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: textAviso as String)
                
                attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: sizeFont)!], range: NSRange(location: 0, length:33))
                attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: sizeFont)!], range: NSRange(location: 34, length: 56))
                
                //assign text first, then customize properties
                lblAvisoHome.attributedText = attributedText
                
                btnAviso.tag = 1
                btnAviso.addTarget(self, action: #selector(actionAviso), for: .touchUpInside)
            }else
            {
                if (model.usuario[0].datosComplementarios?[0].mascotas?.count)! == 0
                {
                    if DeviceType.IS_IPHONE_5
                    {
                        sizeFont = 15.0
                    }else
                    {
                        if DeviceType.IS_IPHONE_6P
                        {
                            sizeFont = 18.2
                        }else
                        {
                            sizeFont = 17.0
                        }
                    }
                    
                    //create attributed string txt bold
                    lblAvisoHome.text = "Para ver los productos sugeridos,\ncrea un perfil para tu(s) mascota(s) aquí"
                    let textAviso: NSString = lblAvisoHome.text! as NSString
                    let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: textAviso as String)
                    
                    attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: sizeFont)!], range: NSRange(location: 0, length:33))
                    attributedText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: sizeFont)!], range: NSRange(location: 34, length: 41))
                    
                    //assign text first, then customize properties
                    lblAvisoHome.attributedText = attributedText
                    
                    btnAviso.tag = 2
                    btnAviso.addTarget(self, action: #selector(actionAviso), for: .touchUpInside)
                    
                    imgNoRegistro.isHidden = true
                    imgNoDireccion.isHidden = true
                    imgNoTarjeta.isHidden = true
                }else
                {
                    imgFotoMascota.isHidden = false
                    lblNombreMascota.isHidden = false
                    btnAdministrarMascotas.isHidden = false
                    
                    self.spaceTopLayoutConstraint?.constant = 130
                    
                    lblAvisoHome.isHidden = true
                    btnAviso.isHidden = true
                    contentSizeScroll = 702 - 65
                    
                    if model.mascotaSeleccionada.foto == ""
                    {
                        imgFotoMascota.image = UIImage(named: "btnFotoMascota")
                    } else
                    {
                        let path = "mascotas/" + (user?.uid)! + "/" + (model.mascotaSeleccionada.idMascota)! + "/" + (model.mascotaSeleccionada.foto)!
                        
                        imgFotoMascota.loadImageUsingCacheWithUrlString(pathString: path)
                        
                        imgFotoMascota.translatesAutoresizingMaskIntoConstraints = false
                        imgFotoMascota.layer.masksToBounds = true
                        imgFotoMascota.contentMode = .scaleAspectFill
                        imgFotoMascota.leftAnchor.constraint(equalTo: imgFotoMascota.leftAnchor, constant: 8).isActive = true
                        imgFotoMascota.centerYAnchor.constraint(equalTo: imgFotoMascota.centerYAnchor).isActive = true
                        imgFotoMascota.widthAnchor.constraint(equalToConstant: imgFotoMascota.frame.width).isActive = true
                        imgFotoMascota.heightAnchor.constraint(equalToConstant: imgFotoMascota.frame.height).isActive = true
                        imgFotoMascota.layer.cornerRadius = imgFotoMascota.frame.height / 2
                    }
                    
                    lblNombreMascota.text = model.mascotaSeleccionada.nombre
                    
                    lblProductos.text = "   Productos sugeridos para tu mascota"
                    imgNoRegistro.isHidden = true
                    imgNoDireccion.isHidden = true
                    imgNoTarjeta.isHidden = true
                    
                    textoPublicacionesCategoria = model.mascotaSeleccionada.nombre!
                    
                    if model.mascotaSeleccionada.tipo == "Ave"
                    {
                        publicaciones = modelPublicacion.publicacionesParaAve
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Exótico"
                        {
                            publicaciones = modelPublicacion.publicacionesParaExotico
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Gato"
                            {
                                publicaciones = modelPublicacion.publicacionesParaGato
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Perro"
                                {
                                    publicaciones = modelPublicacion.publicacionesParaPerro
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Pez"
                                    {
                                        publicaciones = modelPublicacion.publicacionesParaPez
                                    } else
                                    {
                                        if model.mascotaSeleccionada.tipo == "Roedor"
                                        {
                                            publicaciones = modelPublicacion.publicacionesParaRoedor
                                        } else
                                        {
                                            lblProductos.text = "   No hay productos sugeridos para tu mascota"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        // Configurar scrollview
        
        scrollContent.bounces = false
        scrollContent.isScrollEnabled = true
        
        scrollContent.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: contentSizeScroll)
        
        // Configurar CollectionView
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize (width: 100, height: 120)
        flowLayout.scrollDirection = .horizontal
        
        // register the nib
        collectionCategorias!.register(UINib(nibName: "CategoriaCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "categoriaCollectionViewCell")
        
        collectionCategorias.collectionViewLayout = flowLayout
        
        collectionCategorias.tag = 1
        
        collectionCategorias .reloadData()
        
        let flowLayout2:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout2.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout2.scrollDirection = .vertical
        
        // register the nib
        collectionPublicaciones!.register(UINib(nibName: "PublicacionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "publicacionCollectionViewCell")
        
        collectionPublicaciones.collectionViewLayout = flowLayout2
        
        collectionPublicaciones.tag = 2
        
        collectionPublicaciones .reloadData()
        
        // Apariencia PageControl Destacados
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.init(red: 0.0, green: 0.756862745098039, blue: 0.835294117647059, alpha: 1.0)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.init(red: 0.03921568627451, green: 0.294117647058824, blue: 0.313725490196078, alpha: 1.0)
        
        hacerMontaje()
    }
    
    func actionAviso(sender: UIButton!)
    {
        if sender.tag == 0
        {
            self.performSegue(withIdentifier: "registroUsuarioDesdeHomePublicaciones", sender: self)
        }
        
        if sender.tag == 1
        {
            self.performSegue(withIdentifier: "completarRegistroDesdeHomePublicaciones", sender: self)
        }
        
        if sender.tag == 2
        {
            self.performSegue(withIdentifier: "tuMascotaDesdeHomePublicaciones", sender: self)
        }
    }
    
    @IBAction func administrarMascotas(_ sender: Any)
    {
        self.performSegue(withIdentifier: "administrarMascotasDesdeHomePublicaciones", sender: self)
    }
    
    // #pragma mark - Collection View
    
    // 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 1
        {
            return modelOferente.categorias.count
        }
        
        return publicaciones.count
    }
    
    // 2
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriaCollectionViewCell", for: indexPath as IndexPath) as! CategoriaCollectionViewCell
            
            let categoria = modelOferente.categorias[indexPath.row]
            
            // Configure the cell
            
            cell.lblNombreCategoria.text = categoria.nombre
            cell.imgCategoria.image = UIImage(named: categoria.imagen!)!
            cell.imgSelectCategoria.isHidden = true
            
            return cell
        } else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "publicacionCollectionViewCell", for: indexPath as IndexPath) as! PublicacionCollectionViewCell
            
            cell.imgFotoPublicacion.layer.borderWidth = 1.0
            cell.imgFotoPublicacion.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            
            if (publicaciones[indexPath.row].fotos?.count)! > 0
            {
                let path = "productos/" + (publicaciones[indexPath.row].idPublicacion)! + "/" + (publicaciones[indexPath.row].fotos?[0].nombreFoto)!
                
                cell.imgFotoPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
            }
            
            cell.viewContent.layer.borderWidth = 1.0
            cell.viewContent.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            
            if let amountString = publicaciones[indexPath.row].precio?.currencyInputFormatting()
            {
                cell.lblPrecio.text = amountString
            }
            
            cell.lblNombre.text = publicaciones[indexPath.row].nombre
            
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
        
        return CGSize(width: 100, height: 120)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 1
        {
            categoria = modelOferente.categorias[indexPath.row].nombre!
            
            if categoria == "Accesorios"
            {
                iconoCategoria = "imgAccesorios"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 100.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 150.0
                    }else
                    {
                        widthFixedSpace = 190.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesAccesorios
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesAccesoriosParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesAccesoriosParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesAccesoriosParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesAccesoriosParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesAccesoriosParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesAccesoriosParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if categoria == "Lind@ y Limpi@"
            {
                iconoCategoria = "imgHigiene"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 65.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 115.0
                    }else
                    {
                        widthFixedSpace = 150.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesEsteticaHigiene
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesEsteticaHigieneParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesEsteticaHigieneParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesEsteticaHigieneParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesEsteticaHigieneParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesEsteticaHigieneParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesEsteticaHigieneParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if categoria == "Amiguitos en el cielo"
            {
                iconoCategoria = "imgFuneraria"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 30.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 80.0
                    }else
                    {
                        widthFixedSpace = 120.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesFuneraria
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesFunerariaParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesFunerariaParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesFunerariaParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesFunerariaParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesFunerariaParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesFunerariaParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if categoria == "Guardería 5 patas"
            {
                iconoCategoria = "imgGuarderia"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 50.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 105.0
                    }else
                    {
                        widthFixedSpace = 135.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesGuarderia
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesGuarderiaParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesGuarderiaParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesGuarderiaParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesGuarderiaParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesGuarderiaParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesGuarderiaParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if categoria == "Medicamentos"
            {
                iconoCategoria = "imgMedicamentos"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 75.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 120.0
                    }else
                    {
                        widthFixedSpace = 165.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesMedicamentos
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesMedicamentosParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesMedicamentosParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesMedicamentosParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesMedicamentosParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesMedicamentosParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesMedicamentosParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if categoria == "Nutrición"
            {
                iconoCategoria = "imgNutricion"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 115.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 170.0
                    }else
                    {
                        widthFixedSpace = 200.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesNutricion
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesNutricionParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesNutricionParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesNutricionParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesNutricionParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesNutricionParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesNutricionParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if categoria == "Paseador"
            {
                iconoCategoria = "imgPaseador"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 110.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 160.0
                    }else
                    {
                        widthFixedSpace = 190.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesPaseador
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesPaseadorParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesPaseadorParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesPaseadorParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesPaseadorParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesPaseadorParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesPaseadorParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if categoria == "Vamos al médico"
            {
                iconoCategoria = "imgSalud"
                
                if DeviceType.IS_IPHONE_5
                {
                    widthFixedSpace = 50.0
                }else
                {
                    if DeviceType.IS_IPHONE_6
                    {
                        widthFixedSpace = 100.0
                    }else
                    {
                        widthFixedSpace = 130.0
                    }
                }
                
                modelPublicacion.publicacionesPorCategoria = modelPublicacion.publicacionesSalud
                
                if model.mascotaSeleccionada.tipo == "Ave"
                {
                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesSaludParaAve
                } else
                {
                    if model.mascotaSeleccionada.tipo == "Exótico"
                    {
                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesSaludParaExotico
                    } else
                    {
                        if model.mascotaSeleccionada.tipo == "Gato"
                        {
                            modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesSaludParaGato
                        } else
                        {
                            if model.mascotaSeleccionada.tipo == "Perro"
                            {
                                modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesSaludParaPerro
                            } else
                            {
                                if model.mascotaSeleccionada.tipo == "Pez"
                                {
                                    modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesSaludParaPez
                                } else
                                {
                                    if model.mascotaSeleccionada.tipo == "Roedor"
                                    {
                                        modelPublicacion.publicacionesPorCategoriaPorMascota = modelPublicacion.publicacionesSaludParaRoedor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            self.performSegue(withIdentifier: "publicacionesPorCategoriaDesdeHomePublicaciones", sender: self)
            
        } else
        {
            modelOferente.publicacion = publicaciones[indexPath.row]
            
            if modelOferente.publicacion.servicio!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdeHomePublicaciones", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdeHomePublicaciones", sender: self)
            }
        }
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
        
        if (segue.identifier == "completarRegistroDesdeHomePublicaciones")
        {
            let detailController = segue.destination as! RegistroUsuarioDosViewController
            detailController.datosEditables = false
        }
        
        if (segue.identifier == "tuMascotaDesdeHomePublicaciones")
        {
            let detailController = segue.destination as! TuMascotaViewController
            detailController.datosEditables = false
        }
        
        if (segue.identifier == "publicacionesPorCategoriaDesdeHomePublicaciones")
        {
            let detailController = segue.destination as! PublicacionesPorCategoriaViewController
            detailController.nombreCategoria = categoria
            detailController.nombreIconoCategoria = iconoCategoria
            detailController.fixedSpaceWidth = widthFixedSpace
            detailController.tituloPublicacionesCategoria = textoPublicacionesCategoria
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
            pageViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width + 55, height: UIScreen.main.bounds.height * 0.7)
        } else
        {
            if DeviceType.IS_IPHONE_6
            {
                pageViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
            } else
            {
                pageViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 39, height: UIScreen.main.bounds.height * 0.32)
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
        
        pageContentViewController.pathImage = "productos/" + (modelPublicacion.publicacionesDestacadas[index].idPublicacion)! + "/" + (modelPublicacion.publicacionesDestacadas[index].fotos?[0].nombreFoto)!
        
        pageContentViewController.pageIndex = index
        
        pageContentViewController.elementosOcultos = false
        
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
        
        if itemController.pageIndex + 1 < (modelPublicacion.publicacionesDestacadas.count)
        {
            return pageFotoAtIndex(itemController.pageIndex + 1)
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return (modelPublicacion.publicacionesDestacadas.count)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
