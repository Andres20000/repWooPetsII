//
//  UbicacionViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces

class UbicacionViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource
{
    var model  = ModeloUsuario.sharedInstance
    var modelOferente  = ModeloOferente.sharedInstance
    
    var ubicarDireccion:Int?
    var ubicacionTableView:[UbicacionGoogleMaps]? = []
    
    @IBOutlet var barItemTitulo: UIBarButtonItem!
    @IBOutlet var tableDirecciones: UITableView!
    
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var shareLocation: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient!
    
    @IBAction func backView(_ sender: Any)
    {
        if ubicarDireccion == 0
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
            
            dismiss(animated: true, completion: nil)
        } else
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initializeTheLocationManager()
        
        if ubicarDireccion == 0
        {
            self.barItemTitulo.title = "Ubicación Dirección"
        }else
        {
            self.barItemTitulo.title = "Ubicación Dirección \(ubicarDireccion!)"
        }
        
        let nib = UINib(nibName: "UbicacionTableViewCell", bundle: nil)
        tableDirecciones.register(nib, forCellReuseIdentifier: "ubicacionTableViewCell")
        
        placesClient = GMSPlacesClient.shared()
    }
    
    func initializeTheLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.authorizedWhenInUse)
        {
            mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locationManager.location?.coordinate
        
        cameraMoveToLocation(toLocation: location)
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?)
    {
        if toLocation != nil
        {
            let camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
            mapView = GMSMapView.map(withFrame: CGRect.init(x: 0.0, y: 44.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44.0 - 250), camera: camera)
            mapView.mapType = .normal
            mapView.isMyLocationEnabled = true
            
            let marker = GMSMarker(position: toLocation!)
            
            shareLocation = toLocation
            marker.map = mapView
            
            marker.title = "Ubicación Dirección \(ubicarDireccion!)"
            locationManager.stopUpdatingLocation()
            
            self.view .addSubview(mapView)
            self.view .sendSubview(toBack: mapView)
        }
        
        tableDirecciones.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if (ubicacionTableView?.count)! > 0
        {
            Comando.init().EmptyMessage("", tableView: tableDirecciones)
            
            //tableDirecciones.separatorStyle = .singleLine
            
            return 1
        } else
        {
            Comando.init().EmptyMessage("No se puede mostrar información. Esto se debe a que no has permitido que la aplicación acceda a la información de ubicación.", tableView: tableDirecciones)
            
            //tableDirecciones.separatorStyle = .none
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (ubicacionTableView?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ubicacionTableViewCell")  as! UbicacionTableViewCell
        
        cell.lblDireccionMaps.text = ubicacionTableView?[indexPath.row].direccion
        
        if ubicarDireccion == 0
        {
            if modelOferente.ubicacionGoogle.direccion != ""
            {
                if modelOferente.ubicacionGoogle.latitud == ubicacionTableView?[indexPath.row].latitud
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionOk")
                }else
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
                }
                
            }else
            {
                cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
            }
        }
        
        if ubicarDireccion == 1
        {
            if model.direccion1.direccion != ""
            {
                if model.ubicacion1.latitud == ubicacionTableView?[indexPath.row].latitud
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionOk")
                }else
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
                }
                
            }else
            {
                cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
            }
        }
        
        if ubicarDireccion == 2
        {
            if model.direccion2.direccion != ""
            {
                if model.ubicacion2.latitud == ubicacionTableView?[indexPath.row].latitud
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionOk")
                }else
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
                }
            }else
            {
                cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
            }
        }
        
        if ubicarDireccion == 3
        {
            if model.direccion3.direccion != ""
            {
                if model.ubicacion3.latitud == ubicacionTableView?[indexPath.row].latitud
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionOk")
                }else
                {
                    cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
                }
            }else
            {
                cell.imgUbicacionSelect.image = UIImage(named: "imgUbicacionNok")
            }
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
        if ubicarDireccion! == 0
        {
            modelOferente.ubicacionGoogle.direccion = ubicacionTableView?[indexPath.row].direccion
            modelOferente.ubicacionGoogle.latitud = ubicacionTableView?[indexPath.row].latitud
            modelOferente.ubicacionGoogle.longitud = ubicacionTableView?[indexPath.row].longitud
            
        } else
        {
            if ubicarDireccion! == 1
            {
                model.direccion1.direccion = ubicacionTableView?[indexPath.row].direccion
                
                model.ubicacion1.latitud = ubicacionTableView?[indexPath.row].latitud
                model.ubicacion1.longitud = ubicacionTableView?[indexPath.row].longitud
                
                model.direccion1.ubicacion?.removeAll()
                model.direccion1.ubicacion?.append(model.ubicacion1)
                
            } else
            {
                if ubicarDireccion! == 2
                {
                    model.direccion2.direccion = ubicacionTableView?[indexPath.row].direccion
                    
                    model.ubicacion2.latitud = ubicacionTableView?[indexPath.row].latitud
                    model.ubicacion2.longitud = ubicacionTableView?[indexPath.row].longitud
                    
                    model.direccion2.ubicacion?.removeAll()
                    model.direccion2.ubicacion?.append(model.ubicacion2)
                    
                } else
                {
                    model.direccion3.direccion = ubicacionTableView?[indexPath.row].direccion
                    
                    model.ubicacion3.latitud = ubicacionTableView?[indexPath.row].latitud
                    model.ubicacion3.longitud = ubicacionTableView?[indexPath.row].longitud
                    
                    model.direccion3.ubicacion?.removeAll()
                    model.direccion3.ubicacion?.append(model.ubicacion3)
                }
            }
        }
        
        if ubicarDireccion == 0
        {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
            
            dismiss(animated: true, completion: nil)
        } else
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //Edited
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func refreshView()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    let ubicacionData = UbicacionGoogleMaps()
                    
                    /*print("Latitude: \(place.coordinate.latitude)")
                    print("Longitude: \(place.coordinate.longitude)")
                    
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(place.formattedAddress!)")
                    print("Current Place attributions \(place.attributions!)")
                    print("Current PlaceID \(place.placeID)")*/
                    
                    ubicacionData.direccion = place.formattedAddress!
                    
                    ubicacionData.latitud = place.coordinate.latitude
                    ubicacionData.longitud = place.coordinate.longitude
                    
                    self.ubicacionTableView?.append(ubicacionData)
                }
            }
            
            self.initializeTheLocationManager()
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self .refreshView()
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
