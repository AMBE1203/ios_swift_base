//
//  CurrencyViewCell.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/21/20.
//  Copyright © 2020 news. All rights reserved.
//

import UIKit

class CurrencyViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var currencyName: UILabel!
    @IBOutlet fileprivate weak var currencyCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ currency: CurrencyModel) {
        self.currencyName.text = currency.name
        self.currencyCode.text = currency.code
    }
}
