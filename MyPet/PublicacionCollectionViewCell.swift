//
//  PublicacionCollectionViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 12/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PublicacionCollectionViewCell: UICollectionViewCell
{
    var publicacionSeleccionada = PublicacionOferente()
    
    @IBOutlet var imgFotoPublicacion: UIImageView!
    
    @IBOutlet var viewContent: UIView!
    @IBOutlet var lblPrecio: UILabel!
    @IBOutlet var lblNombre: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        imgFotoPublicacion.translatesAutoresizingMaskIntoConstraints = false
        imgFotoPublicacion.layer.masksToBounds = true
        imgFotoPublicacion.contentMode = .scaleAspectFill
        imgFotoPublicacion.leftAnchor.constraint(equalTo: imgFotoPublicacion.leftAnchor, constant: 8).isActive = true
        imgFotoPublicacion.centerYAnchor.constraint(equalTo: imgFotoPublicacion.centerYAnchor).isActive = true
        imgFotoPublicacion.widthAnchor.constraint(equalToConstant: imgFotoPublicacion.frame.width).isActive = true
        imgFotoPublicacion.heightAnchor.constraint(equalToConstant: imgFotoPublicacion.frame.height).isActive = true
    }

}
