//
//  UsersViewController.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class UsersViewController: UITableViewController {
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.user.get().onKnownError { error in
            let alert = UIAlertController(title: "Known error handled", message: error.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }.onSuccess { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User")!
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "#\(user.id) \(user.phone) \(user.address.full)"
        return cell
    }
}
