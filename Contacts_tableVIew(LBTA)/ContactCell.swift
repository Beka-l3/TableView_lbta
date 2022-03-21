//
//  ContactCell.swift
//  Contacts_tableVIew(LBTA)
//
//  Created by Bekzhan Talgat on 06.03.2022.
//

import UIKit


protocol ContactCellDelegate: AnyObject {
    func toggleFavorite(cell: UITableViewCell)
}


class ContactCell: UITableViewCell {
    
    public var cellDelegate : ViewController?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let favButton = UIButton(type: .system)
        favButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        favButton.setImage(UIImage(named: "star"), for: .normal)
//        favButton.tintColor = .systemGray4
        favButton.addTarget(self, action: #selector(handleFavButton), for: .touchUpInside)
        accessoryView = favButton
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func handleFavButton(btn: UIButton) {
        cellDelegate?.toggleFavorite(cell: self)
    }
}

