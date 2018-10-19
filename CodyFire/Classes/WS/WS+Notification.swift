//
//  WS+Notification.swift
//  CodyFire
//
//  Created by Mihael Isaev on 09.07.2018.
//

import Foundation

extension WS {
    func notification(_ data: Data?) {
        if let data = data, let notification = try? JSONDecoder().decode(NotificationMessage.self, from: data) {
            NotificationCenter.default.post(name: NSNotification.Name("notification.type"), object: notification.data)
        }
    }
}
