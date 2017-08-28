//
//  MiCompraConfirmadaTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class MiCompraConfirmadaTableViewCell: UITableViewCell
{
    @IBOutlet var imgPublicacion: UIImageView!
    @IBOutlet var lblTextoInfo: UILabel!
    @IBOutlet var lblNombrePublicacion: UILabel!
    @IBOutlet var btnCalificar: UIButton!
    
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
        
        btnCalificar.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
