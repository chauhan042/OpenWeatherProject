//
//  DailyCollectionViewCell.swift
//  Assignment
//
//  Created by Nitin Singh on 11/05/21.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var conditionImg: UIImageView!
    @IBOutlet weak var dayImageLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
}


class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourConditionImg: UIImageView!
    @IBOutlet weak var hourImageLbl: UILabel!
    @IBOutlet weak var hourDegreeLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    
}
