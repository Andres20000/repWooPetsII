//
//  CompraTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class CompraTableViewCell: UITableViewCell
{
    @IBOutlet var imgPublicacion: UIImageView!
    @IBOutlet var lblNombrePublicacion: UILabel!
    @IBOutlet var lblCostoPublicacion: UILabel!
    @IBOutlet var btnMenos: UIButton!
    @IBOutlet var lblCantidad: UILabel!
    @IBOutlet var btnMas: UIButton!
    @IBOutlet var lblTotal: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        imgPublicacion.translatesAutoresizingMaskIntoConstraints = false
        imgPublicacion.layer.masksToBounds = true
        imgPublicacion.contentMode = .scaleAspectFill
        imgPublicacion.leftAnchor.constraint(equalTo: imgPublicacion.leftAnchor, constant: 8).isActive = true
        imgPublicacion.centerYAnchor.constraint(equalTo: imgPublicacion.centerYAnchor).isActive = true
        imgPublicacion.widthAnchor.constraint(equalToConstant: imgPublicacion.frame.width).isActive = true
        imgPublicacion.heightAnchor.constraint(equalToConstant: imgPublicacion.frame.height).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
