//
//  ExtensionImage.swift
//  MyPet
//
//  Created by Jose Aguilar on 24/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import Firebase

extension UIImageView
{
    class ImageCacheHelper:NSObject{
        
        static var cache = NSCache<AnyObject, AnyObject>()
        static var isNotRunningDispatch:Bool = true
        
        class func setObjectForKey(imageData:NSData,imageKey:String){
            
            ImageCacheHelper.cache.setObject(imageData, forKey: imageKey as AnyObject)
            
        }
        
        class func getObjectForKey(imageKey:String)->NSData?{
            
            return ImageCacheHelper.cache.object(forKey: imageKey as AnyObject) as? NSData
            
        }
        
        class func removeObjectForKey(imageKey:String){
            
            ImageCacheHelper.cache.removeObject(forKey: imageKey as AnyObject)
            
        }
    }
    
    func loadImageUsingCacheWithUrlString(pathString: String)
    {
        // Check cache for image first
        if ImageCacheHelper.getObjectForKey(imageKey: pathString) != nil
        {
            DispatchQueue.main.async(execute:{
                
                self.image = UIImage(data: ImageCacheHelper.getObjectForKey(imageKey: pathString)! as Data)
                
            })
            return
        }
        
        let storage = Storage.storage()
        
        let ref = storage.reference(withPath: pathString)
        
        ref.getData(maxSize: 1024 * 1024, completion: { (data, error ) in
            if error != nil {
                print("Error Caché: \(error.debugDescription)")
                
                return
            }
            
            DispatchQueue.main.async(execute:{
                if data != nil {
                    
                    ImageCacheHelper.setObjectForKey(imageData: data! as NSData, imageKey: pathString)
                    self.image = UIImage(data: ImageCacheHelper.getObjectForKey(imageKey: pathString)! as Data)
                }
            })
        }).resume()
    }
    
    func deleteImageCache(pathString: String)
    {
        ImageCacheHelper.removeObjectForKey(imageKey: pathString)
    }
}
