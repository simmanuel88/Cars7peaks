//
//  CarTableViewCell.swift
//  Cars
//
//  Created by Roche on 13/05/21.
//

import UIKit

class CarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgLoadCar: UIImageView!
    @IBOutlet weak var lblShowIngress: UILabel!
    @IBOutlet weak var lblShowDate: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblShowTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradient = CAGradientLayer()

        gradient.frame = viewBackground.bounds
        gradient.colors = [UIColor.black.cgColor]

        viewBackground.layer.insertSublayer(gradient, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
