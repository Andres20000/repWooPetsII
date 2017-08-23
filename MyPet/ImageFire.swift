//
//  ImageFire.swift
//  MyPet
//
//  Created by Andres Garcia on 8/15/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class ImageFire {
    
    
    var nombre = ""
    var prefijo = ""
    var versionFirebase = 0
    var versionLocal = 0
    var extenci = ""
    var folderStorage = ""        //En el storage se va a formar el path imagenes/foldername/
    var idImagen:String {
        return prefijo + nombre.quitarEspaciosYTildes()
    }
    var nombreImagen:String {
        return prefijo + nombre.quitarEspaciosYTildes() + extenci
    }
    
    var imageData: Data? {
        willSet {
            if newValue != nil {
                print("guardando: " + "\(nombreImagen + ".dat")")
                let filename = getDocumentsDirectory().appendingPathComponent(nombreImagen + ".dat" )
                try? newValue!.write(to: filename)
                
            }
            
        }
    }
    
    
    
    var pathEnStorage:String {
        return  folderStorage + "/" + nombreImagen
    }
    
    
    
    func getImagen(msnNoti:String?) -> UIImage? {
        
        let model = Modelo.sharedInstance
        versionFirebase = model.getVersionFirebase(de: self)
        versionLocal = cargarVersionLocal()
        
        
        var yallamado = false
        
        if versionFirebase > versionLocal {
            getImagenFromFirebase(msnNoti: msnNoti)
            yallamado = true
        }
        
        if imageData != nil {
            
            return UIImage(data: imageData! as Data)
            
        }
        
        var imagen = loadImageFromPath(path: nombreImagen + ".dat")
        
        if imagen != nil {
            
            return imagen
        }
        
        
        
        imagen = UIImage(named: idImagen)
        print(idImagen)
        
        if imagen != nil {
            return imagen
        }
        
        
        
        
        if !yallamado {
            getImagenFromFirebase(msnNoti: msnNoti)
        }
        
        return nil
        
        
    }
    
    
    
    private func getImagenFromFirebase(msnNoti:String?) {
        
        let storage = FIRStorage.storage()
        
        let pathV = pathEnStorage
        print(pathV)
        
        let cache = Modelo.sharedInstance.cache
        
        
        
        if cache.object(forKey: pathV as NSString) != nil   {    //Revisar el cache
            imageData = cache.object(forKey: pathV as NSString) as Data!
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: pathV), object: nil)
            
        } else {
            let ref = storage.reference(withPath: pathV)
            
            
            ref.data(withMaxSize: 1024 * 1024, completion: { (data, error ) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                self.imageData = data
                print(pathV)
                cache.setObject(data! as NSData, forKey: pathV as NSString)
                self.versionLocal = self.versionFirebase
                
                if msnNoti == nil {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: pathV), object: nil)
                }
                else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: msnNoti!), object: nil)
                }
                
                self.guardarVersionLocal()
                
                
                
            })
            
        }
        
    }
    
    
    func guardarVersionLocal() {
        
        escribirEnArchivo(nombreArchivo: nombreImagen , version: String(versionLocal))
        
    }
    
    
    
    private func escribirEnArchivo(nombreArchivo:String, version:String ) {
        
        
        var filePath = ""
        
        // Find documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + nombreArchivo + ".ver")
            
            print("Local path = \(filePath)")
        } else {
            print("ERROR LOCAL: Could not find local directory to store file")
            return
        }
        
        
        
        do {
            // Write contents to file
            try version.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("ERROR LOCAL: \(error)")
        }
        
        
    }
    
    
    
    func cargarVersionLocal()  -> Int {
        
        
        var filePath = ""
        
        // Find documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + nombreImagen + ".ver")
            
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return -1
        }
        
        
        // Read file content. Example in Swift
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            print(contentFromFile)
            return Int(contentFromFile as String)!
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        return -1
        
    }
    
    
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        
        print("cargando \(path)")
        let laData = NSData(contentsOf: getDocumentsDirectory().appendingPathComponent(path))
        
        if laData == nil {
            return nil
        }
        
        let image = UIImage(data: laData! as Data)
        
        if image == nil {
            
            //print("missing image at: \(path)")
        }
        //print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    
    
    
    
    private  func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
    
    
    func duplicar() -> ImageFire {
        
        let newImage = ImageFire()
        newImage.nombre  = nombre
        newImage.prefijo = prefijo
        newImage.versionFirebase = versionFirebase
        newImage.versionLocal = versionLocal
        newImage.extenci = extenci
        newImage.folderStorage = folderStorage
        newImage.imageData = imageData
        
        return newImage
    }
    
    
    
    class func getVersiones() {
        
        let model = Modelo.sharedInstance
        
        let ref  = FIRDatabase.database().reference().child("imagenes")
        
        /*ref.observeSingleEvent(of: .value, with: {snap in
            
            model.imagenes.removeAll()
            
            let children = snap.children
            while let child = children.nextObject() as? FIRDataSnapshot {
                
                let ima = ImageFire()
                let dicc = child.value as! NSDictionary
                
                
                ima.nombre = child.key
                ima.versionFirebase = dicc["version"] as! Int
                model.imagenes.append(ima)
                
                
            }
            
            
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "cargoEnsaladasCasa"), object: nil)
            
        });*/
        
        
    }
    
    
    
    
    
    
    
}
