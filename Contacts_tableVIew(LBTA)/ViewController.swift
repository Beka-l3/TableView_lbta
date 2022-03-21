//
//  ViewController.swift
//  Contacts_tableVIew(LBTA)
//
//  Created by Bekzhan Talgat on 06.03.2022.
//

import UIKit
import Contacts


class ViewController: UITableViewController {
    
    fileprivate let cellId = "CellId"
    
    private var names = [ExpandableNames]()
//    private var names = [
//        ExpandableNames(isExpanded: true, contacts: ["Beka", "Aibek", "Zhangir", "Nurhzan", "Beknur", "Shalkar", "Vanya"].map({Contact(name: $0, isFavorite: false)})),
//        ExpandableNames(isExpanded: true, contacts: ["Zhandos", "Daniyar", "Ulan", "Aslan"].map({Contact(name: $0, isFavorite: false)})),
//        ExpandableNames(isExpanded: true, contacts: ["Timmy", "John"].map({Contact(name: $0, isFavorite: false)}))
//    ]
    
    private var isPhoneNumbersShown = true
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContacts()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Phone numbers", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.title = "Hello MF"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        tableView.sectionHeaderTopPadding = 0
    }
    
    
    private func fetchContacts() {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let _ = err {
                print("Failed to access \(String(describing: err))")
                return
            }
            
            
            
            if granted {
                print("User gave permission: \(granted)")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    var contacts = [Person]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStop) in
                        contacts.append(Person(person: contact, isFavorite: false))
                    })
                    
                    self.names.append(ExpandableNames(isExpanded: true, contacts: contacts))
                    self.names.append(ExpandableNames(isExpanded: true, contacts: contacts))
                } catch let err {
                    print("Failed to enumerate: \(String(describing: err))")
                }
                
            } else {
                print("User did not give permission: \(granted)")
            }
            
        }
        
    }
    
    
    @objc func handleShowIndexPath() {
        var indexPaths = [IndexPath]()
        
        for section in names.indices {
            if names[section].isExpanded {
                for item in names[section].contacts.indices {
                    indexPaths.append(IndexPath(item: item, section: section))
                }
            }
        }
        
        isPhoneNumbersShown.toggle()
        let animationStyle = isPhoneNumbersShown ? UITableView.RowAnimation.left : .right
        tableView.reloadRows(at: indexPaths, with: animationStyle)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let btn = UIButton(type: .system)
        btn.setTitle("Close", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .systemPink
        btn.tag = section
        btn.addTarget(self, action: #selector(handleHeaderButton), for: .touchUpInside)
        
        return btn
    }
    
    @objc func handleHeaderButton(btn: UIButton) {
        let section = btn.tag
        var indexPaths = [IndexPath]()
        
        for item in names[section].contacts.indices {
            indexPaths.append(IndexPath(item: item, section: section))
        }
        
        names[section].isExpanded.toggle()
        if names[section].isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
            btn.setTitle("Close", for: .normal)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
            btn.setTitle("Open", for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if names[section].isExpanded {
            return names[section].contacts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = names[indexPath.section].contacts[indexPath.item]
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        cell.cellDelegate = self
        cell.textLabel?.text = contact.person.givenName + contact.person.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        if isPhoneNumbersShown {
            cell.detailTextLabel?.text = contact.person.phoneNumbers.first?.value.stringValue
        }
        
        cell.tintColor = contact.isFavorite ? .systemYellow : .systemGray4
        
        return cell
    }


}

extension ViewController: ContactCellDelegate {
    func toggleFavorite(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        names[indexPath.section].contacts[indexPath.item].isFavorite.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
