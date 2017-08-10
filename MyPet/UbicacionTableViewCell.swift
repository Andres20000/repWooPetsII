//
//  UbicacionTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 21/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class UbicacionTableViewCell: UITableViewCell
{
    @IBOutlet var imgUbicacionSelect: UIImageView!
    @IBOutlet var lblDireccionMaps: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
