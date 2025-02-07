//
//  ForecastTableViewCell.swift
//  MyUIkit2025
//
//  Created by Willy Hsu on 2025/2/6.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
