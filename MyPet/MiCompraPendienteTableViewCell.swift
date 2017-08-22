//
//  MiCompraPendienteTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class MiCompraPendienteTableViewCell: UITableViewCell
{
    @IBOutlet var imgPublicacion: UIImageView!
    @IBOutlet var lblTextoInfo: UILabel!
    @IBOutlet var lblNombrePublicacion: UILabel!
    @IBOutlet var btnConfirmar: UIButton!
    @IBOutlet var btnRechazar: UIButton!
    
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
        
        btnConfirmar.layer.cornerRadius = 5.0
        btnRechazar.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
