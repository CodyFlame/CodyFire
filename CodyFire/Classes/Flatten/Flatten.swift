//
//  Flatten.swift
//  CodyFire
//
//  Created by Mihael Isaev on 30/10/2018.
//

import Foundation

public class Flatten {
    var progress: Double = 0 {
        didSet {
            progressHandler?(progress)
        }
    }
    var stackSize: Int = 0
    var stack: [Flattenable] = []
    var inProgress: [Flattenable] = []
    
    var cancelOnError = true
    public func avoidCancelOnError() -> Flatten {
        cancelOnError = false
        return self
    }
    
    public typealias ProgressHandler = (Double) -> Void
    var progressHandler: ProgressHandler?
    public typealias ErrorHandler = (Error) -> Void
    var errorHandler: ErrorHandler?
    public typealias SuccessHandler = () -> ()
    var successHandler: SuccessHandler?
    
    var concurrency: UInt = 0
    
    init (stack: [Flattenable]) {
        self.stack = stack
    }
    
    public func onError(_ handler: @escaping ErrorHandler) -> Flatten {
        self.errorHandler = handler
        return self
    }
    
    public func onProgress(_ handler: @escaping ProgressHandler) -> Flatten {
        self.progressHandler = handler
        return self
    }
    
    public func concurrent(by maxAtTheSameTime: UInt) -> Flatten {
        concurrency = maxAtTheSameTime
        return self
    }
    
    public func onSuccess(_ handler: @escaping ()->()) {
        self.successHandler = handler
        execute()
    }
    
    func execute() {
        stackSize = stack.count
        guard concurrency > 0 else {
            runFromStack()
            return
        }
        for _ in 0...concurrency - 1 {
            runFromStack()
        }
    }
    
    func runFromStack() {
        if var task = stack.first {
            stack.removeFirst()
            inProgress.append(task)
            var lastProgressValue: Double = 0
            let handleProgress: (Double)->() = { d in
                let v = Double(d / Double(self.stackSize))
                self.progress += v - lastProgressValue
                lastProgressValue = v
            }
            task.progressCallback = handleProgress
            task.errorCallback = { e in
                guard self.cancelOnError else {
                    self.inProgress.removeAll(where: { f -> Bool in
                        return f.uid == task.uid
                    })
                    self.errorHandler?(e)
                    handleProgress(1)
                    self.runFromStack()
                    return
                }
                self.stack.removeAll()
                self.inProgress.forEach { $0.cancel() }
                self.errorHandler?(e)
                handleProgress(1)
            }
            task.flattenSuccessHandler = {
                self.inProgress.removeAll(where: { f -> Bool in
                    return f.uid == task.uid
                })
                handleProgress(1)
                self.runFromStack()
            }
            task.execute()
        } else if inProgress.count == 0 {
            successHandler?()
        }
    }
}
