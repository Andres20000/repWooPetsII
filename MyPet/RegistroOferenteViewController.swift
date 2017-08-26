//
//  RegistroOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 25/04/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import Firebase

class RegistroOferenteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate
{
    var model  = ModeloOferente.sharedInstance
    var oferenteRegistro = Oferente()
    var contactoRegistro = ContactoPrincipal()
    
    var datosEditables:Bool = false
    
    @IBOutlet var barItemTitulo: UIBarButtonItem!
    @IBOutlet var tableRegistroOferente: UITableView!
    @IBOutlet var btnAceptar: UIButton!
    @IBOutlet var btnCancelar: UIButton!
    @IBOutlet var viewTableViewBottom: UIView!
    
    var tituloNegocio = ["Razón Social","NIT","Dirección", "Teléfono fijo", "Celular", "Correo electrónico", "Página web (opcional)", "Horario de atención a domicilio"]
    
    var datosNegocio:NSMutableArray = NSMutableArray(array: ["","","", "", "", "", "", ""])
    
    var tituloContacto = ["Nombre completo","Tipo de documento","Número de documento", "Teléfono fijo", "Celular", "Correo electrónico (Usuario)", "Contraseña (Usuario)"]
    
    var datosContacto:NSMutableArray = NSMutableArray(array: ["","","", "", "", "", ""])
    
    let pickerView = UIPickerView()
    var pickOption = ["Cédula de ciudadanía", "Cédula de extranjería", "NIT para personas jurídicas"]
    
    @IBAction func backView(_ sender: Any)
    {
        model.ubicacionGoogle.direccion = ""
        model.ubicacionGoogle.latitud = 0
        model.ubicacionGoogle.longitud = 0
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.oferente.removeAll()
        
        if datosEditables
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "EstandarRegistroTableViewCell", bundle: nil)
        tableRegistroOferente.register(nib, forCellReuseIdentifier: "estandarRegistroTableViewCell")
        
        let nib2 = UINib(nibName: "DireccionRegistroTableViewCell", bundle: nil)
        tableRegistroOferente.register(nib2, forCellReuseIdentifier: "direccionRegistroTableViewCell")
        
        let nib3 = UINib(nibName: "HorarioTableViewCell", bundle: nil)
        tableRegistroOferente.register(nib3, forCellReuseIdentifier: "horarioTableViewCell")
        
        if model.oferente.count != 0
        {
            barItemTitulo.title = "Editar Perfil"
            oferenteRegistro = model.oferente[0]
            contactoRegistro = (model.oferente[0].contactoPrincipal?[0])!
            
            datosEditables = true
            
            btnAceptar.setTitle("Editar", for: .normal)
            
            tituloNegocio = ["Razón Social","NIT","Dirección", "Teléfono fijo", "Celular", "Correo electrónico", "Página web (opcional)", "Horario de atención a domicilio"]
            
            datosNegocio.removeObject(at: 0)
            datosNegocio.insert(model.oferente[0].razonSocial as Any, at: 0)
            
            datosNegocio.removeObject(at: 1)
            datosNegocio.insert(model.oferente[0].nit as Any, at: 1)
            
            if model.ubicacionGoogle.direccion == ""
            {
                model.ubicacionGoogle.direccion = model.oferente[0].direccion
                model.ubicacionGoogle.latitud = model.oferente[0].ubicacion?[0].latitud
                model.ubicacionGoogle.longitud = model.oferente[0].ubicacion?[0].longitud
            }
            
            datosNegocio.removeObject(at: 2)
            datosNegocio.insert(model.oferente[0].direccion as Any, at: 2)
            
            datosNegocio.removeObject(at: 3)
            datosNegocio.insert(model.oferente[0].telefono as Any, at: 3)
            
            datosNegocio.removeObject(at: 4)
            datosNegocio.insert(model.oferente[0].celular as Any, at: 4)
            
            datosNegocio.removeObject(at: 5)
            datosNegocio.insert(model.oferente[0].correo as Any, at: 5)
            
            datosNegocio.removeObject(at: 6)
            datosNegocio.insert(model.oferente[0].paginaWeb as Any, at: 6)
            
            tituloContacto = ["Nombre completo","Tipo de documento","Número de documento", "Teléfono fijo", "Celular"]
            
            datosContacto.removeObject(at: 0)
            datosContacto.insert(model.oferente[0].contactoPrincipal?[0].nombre as Any, at: 0)
            
            datosContacto.removeObject(at: 1)
            datosContacto.insert(model.oferente[0].contactoPrincipal?[0].tipoDocumento as Any, at: 1)
            
            datosContacto.removeObject(at: 2)
            datosContacto.insert(model.oferente[0].contactoPrincipal?[0].documento as Any, at: 2)
            
            datosContacto.removeObject(at: 3)
            datosContacto.insert(model.oferente[0].contactoPrincipal?[0].telefono as Any, at: 3)
            
            datosContacto.removeObject(at: 4)
            datosContacto.insert(model.oferente[0].contactoPrincipal?[0].celular as Any, at: 4)
            
            datosContacto.removeObject(at: 5)
            datosContacto.insert("No aplica" as Any, at: 5)
            
            datosContacto.removeObject(at: 6)
            datosContacto.insert("No aplica" as Any, at: 6)
        }else
        {
            model.ubicacionGoogle.direccion = ""
            model.ubicacionGoogle.latitud = 0
            model.ubicacionGoogle.longitud = 0
            
            barItemTitulo.title = "Registro"
            
            oferenteRegistro.aprobacionMyPet = "Pendiente"
            datosEditables = false
            
            tituloNegocio = ["Razón Social","NIT","Dirección", "Teléfono fijo", "Celular", "Correo electrónico", "Página web (opcional)", "Horario de atención a domicilio"]
            
            tituloContacto = ["Nombre completo","Tipo de documento","Número de documento", "Teléfono fijo", "Celular", "Correo electrónico (este será tu Usuario)", "Contraseña (para tu Usuario)"]
            
            FIRAuth.auth()?.addStateDidChangeListener { auth, user in
                
                if user != nil
                {
                    print("uid Registrado antes de la alerta: \((user?.uid)!)")
                    ComandoOferente.getOferente(uid: (user?.uid)!)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(RegistroOferenteViewController.continuarRegistro(_:)), name:NSNotification.Name(rawValue:"cargoOferente"), object: nil)
                    
                }
            }
        }
        
    }
    
    func continuarRegistro(_ notification: Notification)
    {
        let alert:UIAlertController = UIAlertController(title: "¡Hemos recibido tu solicitud!", message: "Tus datos serán confirmados. Mientras tanto, puedes continuar creando publicaciones y estas serán mostradas a todos los usuarios de WooPets cuando seas aprobado", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "OK, entendido", style: .default){ (_) -> Void in
            
            self.performSegue(withIdentifier: "homeOferenteDesdeRegistro", sender: self)
        }
        
        // Add the actions
        alert.addAction(continuarAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let vw = UIView()
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 35))
        lbl.font = UIFont (name: "HelveticaNeue-Light", size: 17.0)
        lbl.textColor = UIColor.white
        
        if section == 0
        {
            lbl.text = "   Datos del establecimiento"
            
        } else
        {
            lbl.text = "   Datos del contacto principal"
            
        }
        
        vw .addSubview(lbl)
        vw.backgroundColor = UIColor.init(red: 0.980392156862745, green: 0.407843137254902, blue: 0.380392156862745, alpha: 1.0)
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return tituloNegocio.count
        } else
        {
            return tituloContacto.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "estandarRegistroTableViewCell")  as! EstandarRegistroTableViewCell
            
            cell.imgFlecha.isHidden = true
            cell.txtCampo.inputView = nil
            
            cell.txtCampo.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)) , for: .editingDidBegin)
            cell.txtCampo.addTarget(self, action: #selector(textFieldDidEndEditing(_:)) , for: .editingDidEnd)
            cell.txtCampo.addTarget(self, action: #selector(textFieldShouldReturn(_:)) , for: .editingDidEndOnExit)
            cell.txtCampo.textAlignment = .left
            cell.txtCampo.autocorrectionType = .no
            cell.txtCampo.tag = indexPath.row
            cell.txtCampo.isSecureTextEntry = false
            cell.txtCampo.keyboardType = .default
            self .toolBarTextField(cell.txtCampo)
            
            if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "direccionRegistroTableViewCell")  as! DireccionRegistroTableViewCell
                
                cell.txtCampo.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)) , for: .editingDidBegin)
                cell.txtCampo.addTarget(self, action: #selector(textFieldDidEndEditing(_:)) , for: .editingDidEnd)
                cell.txtCampo.addTarget(self, action: #selector(textFieldShouldReturn(_:)) , for: .editingDidEndOnExit)
                cell.txtCampo.inputView = nil
                cell.txtCampo.textAlignment = .left
                cell.txtCampo.autocorrectionType = .no
                cell.txtCampo.tag = indexPath.row
                self .toolBarTextField(cell.txtCampo)
                
                if (datosNegocio[indexPath.row] as? String) == ""
                {
                    cell.txtCampo.placeholder = "Escríbelo o tráelo desde tu ubicación"
                }
                
                if model.ubicacionGoogle.latitud == 0
                {
                    cell.btnGeolocalizar.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
                } else
                {
                    cell.btnGeolocalizar.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
                }
                
                /*if (datosNegocio[indexPath.row] as? String) == ""
                {
                    cell.txtCampo.placeholder = "Escríbelo o tráelo desde tu ubicación"
                    cell.txtCampo.isEnabled = false
                    cell.btnGeolocalizar.setImage(UIImage(named: "btnGeolocalizar"), for: UIControlState.normal)
                } else
                {
                    cell.txtCampo.isEnabled = true
                    cell.btnGeolocalizar.setImage(UIImage(named: "btnGeolocalizarOk"), for: UIControlState.normal)
                }*/
                
                cell.lblNombreCampo.text = tituloNegocio[indexPath.row]
                cell.txtCampo.text = datosNegocio[indexPath.row] as? String
                
                cell.btnGeolocalizar.tag = indexPath.row
                cell.btnGeolocalizar.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                return cell
            }
            
            if indexPath.row == 3 || indexPath.row == 4
            {
                cell.txtCampo.keyboardType = .phonePad
            }
            
            if indexPath.row == 5
            {
                cell.txtCampo.keyboardType = .emailAddress
            }
            
            if indexPath.row == 7
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "horarioTableViewCell")  as! HorarioTableViewCell
                
                if DeviceType.IS_IPHONE_5
                {
                    cell.lblDiasSemana.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                    cell.lblHorarioDiasSemana.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                    
                    cell.lblDiasFestivos.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                    cell.lblHorarioDiasFestivos.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
                }
                
                cell.btnHorario.layer.cornerRadius = 5.0
                cell.btnHorario.tag = indexPath.row
                cell.btnHorario.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                
                if (oferenteRegistro.horario?.count)! > 0
                {
                    for horario in (oferenteRegistro.horario)!
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
                }
                
                return cell
            }
            
            cell.lblNombreCampo.text = tituloNegocio[indexPath.row]
            cell.txtCampo.text = datosNegocio[indexPath.row] as? String
            
            return cell
            
        } else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "estandarRegistroTableViewCell")  as! EstandarRegistroTableViewCell
            
            cell.imgFlecha.isHidden = true
            
            cell.txtCampo.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)) , for: .editingDidBegin)
            cell.txtCampo.addTarget(self, action: #selector(textFieldDidEndEditing(_:)) , for: .editingDidEnd)
            cell.txtCampo.addTarget(self, action: #selector(textFieldShouldReturn(_:)) , for: .editingDidEndOnExit)
            cell.txtCampo.tag = indexPath.row + 20
            cell.txtCampo.textAlignment = .left
            cell.txtCampo.autocorrectionType = .no
            cell.txtCampo.keyboardType = .default
            cell.txtCampo.inputView = nil
            
            self .toolBarTextField(cell.txtCampo)
            
            if indexPath.row == 1
            {
                cell.imgFlecha.isHidden = false
                
                pickerView.delegate = self
                pickerView.dataSource = self as? UIPickerViewDataSource
                
                cell.txtCampo.inputView = pickerView
                
            }
            
            if indexPath.row == 2
            {
                cell.txtCampo.keyboardType = .decimalPad
            }
            
            if indexPath.row == 3 || indexPath.row == 4
            {
                cell.txtCampo.keyboardType = .phonePad
            }
            
            if indexPath.row == 5
            {
                cell.txtCampo.keyboardType = .emailAddress
            }
            
            if indexPath.row == 6
            {
                cell.txtCampo.isSecureTextEntry = true
            } else
            {
                if indexPath.row != 1
                {
                    cell.txtCampo.isSecureTextEntry = false
                    cell.txtCampo.text = datosContacto[indexPath.row] as? String
                }
            }
            
            cell.lblNombreCampo.text = tituloContacto[indexPath.row]
            cell.txtCampo.text = datosContacto[indexPath.row] as? String
            
            return cell
        }
        
    }
    
    // Celda con botón
    func buttonAction(sender: UIButton!)
    {
        let btnCelda:UIButton = sender!
        
        if btnCelda.tag == 2
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.performSegue(withIdentifier: "ubicacionDesdeRegistroOferente", sender: self)
        } else
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.performSegue(withIdentifier: "horarioDesdeRegistroOferente", sender: self)
        }
    }
    
    // #pragma mark - pickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        contactoRegistro.tipoDocumento = pickOption[row]
        datosContacto.removeObject(at: 1)
        datosContacto.insert(contactoRegistro.tipoDocumento as Any, at: 1)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // No selectionable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //No Edited
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if indexPath.row == 7
            {
                if model.oferente.count == 0
                {
                    return 45
                } else
                {
                    if model.oferente[0].horario?.count == 0
                    {
                        return 45
                    } else
                    {
                        if model.oferente[0].horario?.count == 1
                        {
                            return 60
                        } else
                        {
                            return 90
                        }
                    }
                }
            }
        }
        
        return 70
        
    }
    
    // #pragma mark - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if datosEditables
        {
            if textField.tag == 23 || textField.tag == 24
            {
                animateViewMoving(up: true, moveValue: 145)
            }
        }
        
        if textField.tag == 25 || textField.tag == 26
        {
            animateViewMoving(up: true, moveValue: 145)
        }
        
        if textField.tag == 21
        {
            textField.text = pickOption[0]
            contactoRegistro.tipoDocumento = pickOption[0]
            datosContacto.removeObject(at: 1)
            datosContacto.insert(contactoRegistro.tipoDocumento as Any, at: 1)
        }
        
        if textField.tag == 26
        {
            textField.isSecureTextEntry = true
        }else
        {
            textField.isSecureTextEntry = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 0
        {
            oferenteRegistro.razonSocial = textField.text
        }
        
        if textField.tag == 1
        {
            oferenteRegistro.nit = textField.text
        }
        
        if textField.tag == 2
        {
            model.ubicacionGoogle.direccion = textField.text
            
            oferenteRegistro.direccion = model.ubicacionGoogle.direccion
            
            oferenteRegistro.ubicacion?.removeAll()
            
            let ubicacionRegistrado = Ubicacion()
            ubicacionRegistrado.latitud = model.ubicacionGoogle.latitud
            ubicacionRegistrado.longitud = model.ubicacionGoogle.longitud
            
            oferenteRegistro.ubicacion?.append(ubicacionRegistrado)
        }
        
        if textField.tag == 3
        {
            oferenteRegistro.telefono = textField.text
        }
        
        if textField.tag == 4
        {
            oferenteRegistro.celular = textField.text
        }
        
        if textField.tag == 5
        {
            if Comando.init().isValidEmail(testStr: textField.text!)
            {
                oferenteRegistro.correo = textField.text
            } else
            {
                self.mostrarAlerta(titulo: "e-mail Inválido", mensaje: "El e-mail no es válido, escríbelo correctamente para que puedas registrar tu negocio")
                textField.text = ""
            }
        }
        
        if textField.tag == 6
        {
            oferenteRegistro.paginaWeb = textField.text
        }
        
        if textField.tag == 20
        {
            contactoRegistro.nombre = textField.text
        }
        
        if textField.tag == 21
        {
            textField.text = datosContacto[1] as? String
        }
        
        if textField.tag == 22
        {
            contactoRegistro.documento = textField.text
        }
        
        if textField.tag == 23
        {
            contactoRegistro.telefono = textField.text
        }
        
        if textField.tag == 24
        {
            contactoRegistro.celular = textField.text
        }
        
        if textField.tag == 25
        {
            if Comando.init().isValidEmail(testStr: textField.text!)
            {
                contactoRegistro.correo = textField.text
            } else
            {
                self.mostrarAlerta(titulo: "e-mail Inválido", mensaje: "El e-mail no es válido, escríbelo correctamente para que puedas registrarte")
                textField.text = ""
            }
        }
        
        if textField.tag == 26
        {
            contactoRegistro.contraseña = textField.text
        }
        
        if datosEditables
        {
            if textField.tag == 23 || textField.tag == 24
            {
                animateViewMoving(up: false, moveValue: 145)
            }
        }
        
        if textField.tag == 25 || textField.tag == 26
        {
            animateViewMoving(up: false, moveValue: 145)
        }
        
        if textField.tag >= 20
        {
            datosContacto.removeObject(at: textField.tag - 20)
            datosContacto.insert(textField.text as Any, at: textField.tag - 20)
        } else
        {
            datosNegocio.removeObject(at: textField.tag)
            datosNegocio.insert(textField.text as Any, at: textField.tag)
        }
    }
    
    func validarDatos() -> Bool
    {
        var i = 0
        var datosVacios:Bool = false
        
        for _ in datosNegocio
        {
            
            if i == 6 || i == 7
            {
                print("No Aplica")
            }else
            {
                if (datosNegocio[i] as? String) == ""
                {
                    datosVacios = true
                }
            }
            
            i += 1
        }
        
        if !datosVacios
        {
            var j = 0
            
            for _ in datosContacto
            {
                if (datosContacto[j] as? String) == ""
                {
                    datosVacios = true
                }
                
                j += 1
            }
        }
        
        return datosVacios
    }
    
    // Enviar Datos
    @IBAction func aceptarEditarRegistro(_ sender: Any)
    {
        model.oferente.removeAll()
        
        model.oferente.append(oferenteRegistro)
        
        if !datosEditables
        {
            if validarDatos() ||  model.oferente[0].ubicacion?.count == 0 || model.oferente[0].horario?.count == 0
            {
                self.mostrarAlerta(titulo: "¡Información Incompleta!", mensaje: "Por favor, revisa que todos los campos estén correctamente diligenciados")
            } else
            {
                FIRAuth.auth()?.createUser(withEmail: (model.oferente[0].contactoPrincipal?[0].correo)!, password: (model.oferente[0].contactoPrincipal?[0].contraseña)!, completion: { (user, error) in
                    if error != nil {
                        self.mostrarAlerta(titulo: "Registro", mensaje: "No se ha podido hacer el registro. Esa cuenta ya existe o la contraseña es muy débil")
                        print(error?.localizedDescription)
                        
                    }
                        
                    else
                    {
                        ComandoOferente.crearOferente(uid: (user?.uid)!, registro: self.oferenteRegistro)
                    }
                })
            }
            
        } else
        {
            let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
            
            connectedRef.observe(.value, with: { snapshot in
                if let connected = snapshot.value as? Bool, connected {
                    self.editarDatosOferente()
                } else {
                    self.mostrarAlerta(titulo: "Sin conexión", mensaje: "No detectamos conexión a internet, por favor valida tu señal para poder editar tus datos.")
                }
            })
        }
    }
    
    func editarDatosOferente()
    {
        let  user = FIRAuth.auth()?.currentUser
        
        ComandoOferente.actualizarOferente(uid: (user?.uid)!, registro: self.model.oferente[0])
        
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.oferente.removeAll()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelar(_ sender: Any)
    {
        let alert:UIAlertController = UIAlertController(title: "¡Confirmar!", message: "¿Está seguro de abandonar la vista?", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "Sí", style: .default)
        {
            UIAlertAction in self.abandonar()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(continuarAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func abandonar()
    {
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.oferente.removeAll()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        btnAceptar.layer.cornerRadius = 10.0
        btnCancelar.layer.cornerRadius = 10.0
        
        if model.oferente.count != 0
        {
            model.oferente.removeAll()
        }
        
        oferenteRegistro.direccion = model.ubicacionGoogle.direccion
        
        datosNegocio.removeObject(at: 2)
        datosNegocio.insert(model.ubicacionGoogle.direccion as Any, at: 2)
        
        if model.ubicacionGoogle.latitud != 0
        {
            oferenteRegistro.ubicacion?.removeAll()
            
            let ubicacionRegistrado = Ubicacion()
            ubicacionRegistrado.latitud = model.ubicacionGoogle.latitud
            ubicacionRegistrado.longitud = model.ubicacionGoogle.longitud
            
            oferenteRegistro.ubicacion?.append(ubicacionRegistrado)
        }
        
        oferenteRegistro.contactoPrincipal?.removeAll()
        oferenteRegistro.contactoPrincipal?.append(contactoRegistro)
        
        if model.horarioSemana.dias != ""
        {
            if oferenteRegistro.horario?.count == 0
            {
                oferenteRegistro.horario?.append(model.horarioSemana)
            } else
            {
                oferenteRegistro.horario?[0].dias = model.horarioSemana.dias
                oferenteRegistro.horario?[0].horaInicio = model.horarioSemana.horaInicio
                oferenteRegistro.horario?[0].horaCierre = model.horarioSemana.horaCierre
                oferenteRegistro.horario?[0].nombreArbol = "Semana"
            }
        }else
        {
            oferenteRegistro.horario?.removeAll()
        }
        
        if model.horarioFestivo.dias != ""
        {
            if oferenteRegistro.horario?.count == 1
            {
                oferenteRegistro.horario?.append(model.horarioFestivo)
            } else
            {
                oferenteRegistro.horario?[1].dias = model.horarioFestivo.dias
                oferenteRegistro.horario?[1].horaInicio = model.horarioFestivo.horaInicio
                oferenteRegistro.horario?[1].horaCierre = model.horarioFestivo.horaCierre
                oferenteRegistro.horario?[1].nombreArbol = "FinDeSemana"
            }
        }else
        {
            if oferenteRegistro.horario?.count == 2
            {
                oferenteRegistro.horario?.remove(at: 1)
            }
        }
        
        model.oferente.append(oferenteRegistro)
        
        tableRegistroOferente .reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
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
        
        if (segue.identifier == "horarioDesdeRegistroOferente")
        {
            let detailController = segue.destination as! HorarioViewController
            detailController.horarioPara = "NegocioOferente"
        }
        
        if (segue.identifier == "ubicacionDesdeRegistroOferente")
        {
            let detailController = segue.destination as! UbicacionViewController
            detailController.ubicarDireccion = 0
        }
    }
    
    // Move show/hide Keypoard
    func animateViewMoving (up:Bool, moveValue :CGFloat)
    {
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
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
        let cancelButton = UIBarButtonItem(title: "Ocultar", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    // Button Cancelar Keyboard
    func cancelClick()
    {
        view.endEditing(true)
    }
    
}
