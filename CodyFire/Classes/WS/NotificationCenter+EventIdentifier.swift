//
//  NotificationCenter+EventIdentifier.swift
//  CodyFire
//
//  Created by Mihael Isaev on 19/02/2019.
//

import Foundation

extension NotificationCenter {
    public func addObserver<Model: WSEventModel>(forEvent event: WSEventIdentifier<Model>, using: @escaping (Model) -> Void) {
        addObserver(forName:  event.notification, object: nil, queue: nil) { notification in
            if let payload = notification.object as? Model {
                using(payload)
            }
        }
    }
    
    func post<Model: WSEventModel>(forEvent event: WSEventIdentifier<Model>, object anObject: Model) {
        post(name: event.notification, object: anObject)
    }
}

extension WSEventIdentifier {
    fileprivate var notification: NSNotification.Name {
        NSNotification.Name(rawValue: "ws.event." + self.uid)
    }
}
