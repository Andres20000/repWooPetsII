//
//  PublicacionOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PublicacionOferenteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var horizontalSpaceConstraint: NSLayoutConstraint?
    
    let model = ModeloOferente.sharedInstance
    
    @IBOutlet var lblEtapaPublicacion_1: UILabel!
    @IBOutlet var lblEtapaPublicacion_2: UILabel!
    @IBOutlet var lblEtapaPublicacion_3: UILabel!
    @IBOutlet var lblEtapaPublicacion_4: UILabel!
    
    var imgCoachMark: UIImageView!
    var scrollCoachMark: UIScrollView!
    
    @IBOutlet var collectionCategorias: UICollectionView!
    
    @IBOutlet var viewSubcategoriaFooter: UIView!
    @IBOutlet var lblSubcategoria: UILabel!
    @IBOutlet var txtSubcategoria: UITextField!
    @IBOutlet var imgFlecha: UIImageView!
    @IBOutlet var viewSubcategoriaBottom: UIView!
    
    @IBOutlet var btnContinuar: UIButton!
    
    var estadoCategorias:NSMutableArray = NSMutableArray(array: [false,false,false, false, false, false, false, false])
    var categoriasSelected:Int! = 0
    
    let pickerView = UIPickerView()
    var subcategoriaPublicacion:[SubCategoria]? = []
    
    @IBAction func backView(_ sender: Any)
    {
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.publicacionOferente.removeAll()
        
        self.performSegue(withIdentifier: "returnHomeOferenteDesdePublicacion", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblEtapaPublicacion_1.layer.masksToBounds = true
        lblEtapaPublicacion_1.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_2.layer.masksToBounds = true
        lblEtapaPublicacion_2.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_3.layer.masksToBounds = true
        lblEtapaPublicacion_3.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_4.layer.masksToBounds = true
        lblEtapaPublicacion_4.layer.cornerRadius = 22.0
        
        // Configurar CollectionView
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize (width: 100, height: 120)
        flowLayout.scrollDirection = .horizontal
        
        // register the nib
        collectionCategorias!.register(UINib(nibName: "CategoriaCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "categoriaCollectionViewCell")
        
        collectionCategorias.collectionViewLayout = flowLayout
        
        btnContinuar.layer.cornerRadius = 10.0
        btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        btnContinuar.isEnabled = false
        
        // Definir espacio para cada dispositivo
        if DeviceType.IS_IPHONE_5
        {
            self.horizontalSpaceConstraint?.constant = 40.0
            
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            self.horizontalSpaceConstraint?.constant = 85.0
        }
        
        categoriasSelected = 0
        
        pickerView.delegate = self
        pickerView.dataSource = self as? UIPickerViewDataSource
        
        txtSubcategoria.inputView = pickerView
        self .toolBarTextField(txtSubcategoria)
    }
    
    // Show CoachMark
    
    @IBAction func showCoachMark(_ sender: AnyObject)
    {
        scrollCoachMark = UIScrollView(frame: view.bounds)
        scrollCoachMark.contentSize = view.frame.size
        scrollCoachMark.isScrollEnabled = false
        
        imgCoachMark = UIImageView(image: UIImage(named: "coachMarkCategorias"))
        imgCoachMark.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height)
        
        scrollCoachMark.addSubview(imgCoachMark)
        
        let btnClose = UIButton(frame: CGRect(x: view.bounds.size.width - 61.0, y: 30.0, width: 25.0, height: 25.0))
        btnClose.setImage(UIImage(named: "btnSalir"), for: UIControlState())
        btnClose.addTarget(self, action: #selector(closeCoachMark), for: .touchUpInside)
        
        scrollCoachMark.addSubview(btnClose)
        
        view.addSubview(scrollCoachMark)
    }
    
    @objc func closeCoachMark(_ sender: UIButton!)
    {
        scrollCoachMark.removeFromSuperview()
    }
    
    // Categorias y SubCategorias
    
    @objc func cargarCategorias(_ notification: Notification)
    {
        collectionCategorias .reloadData()
    }
    
    // #pragma mark - Collection View
    
    // 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return model.categorias.count
    }
    
    // 2
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriaCollectionViewCell", for: indexPath as IndexPath) as! CategoriaCollectionViewCell
        
        let categoria = model.categorias[(indexPath as NSIndexPath).row]
        
        // Configure the cell
        
        cell.lblNombreCategoria.text = categoria.nombre
        cell.imgCategoria.image = UIImage(named: categoria.imagen!)!
        
        if (estadoCategorias[indexPath.row] as? Bool)!
        {
            cell.imgSelectCategoria.prender()
        } else
        {
            cell.imgSelectCategoria.apagar()
        }
        
        return cell
    }
    
    // 3
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        view.endEditing(true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! CategoriaCollectionViewCell
        
        if (estadoCategorias[indexPath.row] as? Bool)!
        {
            estadoCategorias.removeObject(at: indexPath.row)
            estadoCategorias.insert(false as Any, at: indexPath.row)
            categoriasSelected = categoriasSelected - 1
            
        } else
        {
            estadoCategorias.removeObject(at: indexPath.row)
            estadoCategorias.insert(true as Any, at: indexPath.row)
            categoriasSelected = categoriasSelected + 1
        }
        
        if categoriasSelected > 1
        {
            categoriasSelected = categoriasSelected - 1
            estadoCategorias.removeObject(at: indexPath.row)
            estadoCategorias.insert(false as Any, at: indexPath.row)
            
            let alerta = UIAlertController(title: "¡Advertencia!", message: "Sólo puedes seleccionar una categoría", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                return
            }
            
            alerta.addAction(OKAction)
            present(alerta, animated: true, completion: { return })
            
        }else
        {
            if categoriasSelected == 0
            {
                cell.imgSelectCategoria.cambiar()
                txtSubcategoria.text = ""
                model.publicacion.subcategoria = txtSubcategoria.text
                
                btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
                btnContinuar.isEnabled = false
                
                viewSubcategoriaFooter.isHidden = true
                lblSubcategoria.isHidden = true
                txtSubcategoria.isHidden = true
                imgFlecha.isHidden = true
                viewSubcategoriaBottom.isHidden = true
            }else
            {
                cell.imgSelectCategoria.cambiar()
                
                if model.categorias[indexPath.row].subcategoria?.count != 0
                {
                    model.publicacion.categoria = model.categorias[indexPath.row].nombre
                    model.publicacion.servicio = model.categorias[indexPath.row].servicio
                    
                    subcategoriaPublicacion = model.categorias[indexPath.row].subcategoria
                    pickerView .selectRow(0, inComponent: 0, animated: false)
                    
                    viewSubcategoriaFooter.isHidden = false
                    lblSubcategoria.isHidden = false
                    txtSubcategoria.isHidden = false
                    imgFlecha.isHidden = false
                    viewSubcategoriaBottom.isHidden = false
                    
                }else
                {
                    model.publicacion.categoria = model.categorias[indexPath.row].nombre
                    model.publicacion.servicio = model.categorias[indexPath.row].servicio
                    
                    btnContinuar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
                    btnContinuar.isEnabled = true
                }
            }
        }
    }
    
    // Toolbar in textField
    
    func toolBarTextField(_ textField : UITextField)
    {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 41/255, green: 184/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    // Texto con PickerView
    
    func cancelClick()
    {
        view.endEditing(true)
    }
    
    // #pragma mark - pickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return subcategoriaPublicacion!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return subcategoriaPublicacion?[row].nombre
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        txtSubcategoria.text = subcategoriaPublicacion?[row].nombre
    }
    
    // #pragma mark - textField
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        txtSubcategoria.text = subcategoriaPublicacion?[0].nombre
        
        btnContinuar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
        btnContinuar.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        model.publicacion.subcategoria = textField.text
    }
    
    @IBAction func continuarPublicacion(_ sender: Any)
    {
        if model.publicacion.idPublicacion == ""
        {
            model.publicacion.idPublicacion = ComandoPublicacion.crearIdPublicacionOferente()
        }
        
        self.performSegue(withIdentifier: "publicacionOferenteDosDesdeAnterior", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Comando.getCategorias()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublicacionOferenteViewController.cargarCategorias(_:)), name:NSNotification.Name(rawValue:"cargoCategorias"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
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

extension UIImageView
{
    func apagar() {
        self.alpha = 0
    }
    
    func prender() {
        self.alpha = 1
    }
    
    func cambiar() {
        if self.alpha == 0 {
            self.alpha = 1
        }else {
            self.alpha = 0
        }
    }
    
    func isOn() -> Bool {
        
        if self.alpha == 0 {
            return false
        }
        return true
    }
}
