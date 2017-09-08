//
//  MiCompraFinalizadaTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 8/09/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class MiCompraFinalizadaTableViewCell: UITableViewCell
{
    @IBOutlet var imgPublicacion: UIImageView!
    @IBOutlet var lblTextoInfo: UILabel!
    @IBOutlet var lblNombrePublicacion: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    var ratingValue = 0
    
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
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "imgEstrellaVacia")
        self.floatRatingView.fullImage = UIImage(named: "imgEstrellaCompleta")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.minRating = 0
        self.floatRatingView.maxRating = 5
        self.floatRatingView.rating = Float(ratingValue)
        self.floatRatingView.editable = false
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
