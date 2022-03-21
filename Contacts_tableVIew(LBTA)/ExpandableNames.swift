//
//  ExpandableNames.swift
//  Contacts_tableVIew(LBTA)
//
//  Created by Bekzhan Talgat on 06.03.2022.
//

import Foundation
import Contacts


struct ExpandableNames {
    var isExpanded: Bool
    var contacts: [Person]
}

struct Person {
    let person: CNContact
    var isFavorite: Bool
}

