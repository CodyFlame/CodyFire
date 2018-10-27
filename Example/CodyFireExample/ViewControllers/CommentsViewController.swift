//
//  CommentsViewController.swift
//  CodyFireExample
//
//  Created by Mihael Isaev on 27/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class CommentsViewController: UITableViewController {
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.comment.get().onKnownError { error in
            let alert = UIAlertController(title: "Known error handled", message: error.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            }.onSuccess { comments in
                self.comments = comments
                self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comment")!
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.name + " " + comment.email
        cell.detailTextLabel?.text = comment.body
        return cell
    }
}
