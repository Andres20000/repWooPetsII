//
//  ComandoDestacados.swift
//  MyPet
//
//  Created by Andres Garcia on 8/15/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import Foundation
import Firebase



class ComandoDestacados {
    
    
    
    class func  destacarPublicacion(publicacion:PublicacionOferente, newVersion:Int){
    
    
        
        let imagen = publicacion.imagenDestacado
        
        // 1. Marcamos el prouducto como destacado
        var ref  = FIRDatabase.database().reference().child("productos/" +  publicacion.idPublicacion! + "/destacado")
        ref.setValue(true)
        
        // 2. Aumentamos la version de la imagen
        ref  = FIRDatabase.database().reference().child("imagenes/" + publicacion.idPublicacion! +  "/" + imagen!.idImagen)
        ref.setValue(newVersion)
        
        //3. Le ponemos la nueva version al modelo.
        // TODO
        
        //4. Guardamos la imagen en el storage
        
        let storage = FIRStorage.storage()
        
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        let path = imagen!.folderStorage + "/" + imagen!.nombreImagen
        let refS = storage.reference(withPath: path)
        
        refS.put(imagen!.imageData!, metadata: metadata)
        
        let uploadTask = refS.put(imagen!.imageData!, metadata:  metadata) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
                print("Error load image desde Firebase: \(error.debugDescription)")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("status: \(snapshot.status)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "subioDestacado"), object: nil)
        }

        
        
    
    }
    
    
    
    
    
}
