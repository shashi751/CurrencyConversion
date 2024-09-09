//
//  CurrencyCollectionViewCell.swift
//  CurrencyConversion
//
//  Created by Shashi Gupta on 26/08/24.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {

    //MARK: - IBOUTLETS
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var stackViewCOntainer: UIStackView!
    
    //MARK: - VARIABLES
    static var reusableIdentifier = "CurrencyCollectionViewCell"
    
    //MARK: - INTERNAL FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - FUNCTIONS
    func setData(currency:CurrecnyModel){
        
        let amount = String(format: "%0.2f", currency.amount)
        self.lblAmount.text = amount
        self.lblCurrency.text = currency.key
        
        self.stackViewCOntainer.layer.borderColor = UIColor.gray.cgColor
        self.stackViewCOntainer.layer.borderWidth = 1
        self.stackViewCOntainer.layer.cornerRadius = 5
    }

}
