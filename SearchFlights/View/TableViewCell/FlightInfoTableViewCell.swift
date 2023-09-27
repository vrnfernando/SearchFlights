//
//  FlightInfoTableViewCell.swift
//  SearchFlights
//
//  Created by Vishwa Fernando on 2023-08-20.
//

import UIKit

class FlightInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_flightNumber: UILabel!
    
    @IBOutlet weak var lb_regularFair: UILabel!
    
    @IBOutlet weak var lb_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
