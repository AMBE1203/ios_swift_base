//
//  ExCurrencyResultCell.swift
//  PayBaymaxChallenge
//
//  Created by Tung Vu on 12/23/20.
//  Copyright © 2020 news. All rights reserved.
//

import UIKit

class ExCurrencyResultCell: UITableViewCell {

    @IBOutlet private weak var txtCurrency:         UILabel!
    @IBOutlet private weak var txtExRate:           UILabel!
    @IBOutlet private weak var txtAmount:           UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        txtCurrency.text = ""
        txtExRate.text = ""
        txtAmount.text = ""
    }

    func updateCell(currency data: ExchangeCurrencyModel) {
        txtCurrency.text = data.exCode
        let formatted = String(format: "%.2f", data.exAmount)
        txtAmount.text = formatted.currencyFormatted
        txtExRate.text = "\(data.exRate)"
    }
}
