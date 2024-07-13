//
//  DispatchQueue+extension.swift
//  MovieDatabase
//
//  Created by Sandeep kushwaha on 14/07/24.
//

import Foundation

extension DispatchQueue {
    func asyncDeduped(target: AnyObject, after delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        let dedupeIdentifier = DispatchQueue.dedupeIdentifierFor(target)
        if let existingWorkItem = DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier) {
            existingWorkItem.cancel()
            NSLog("Deduped work item: \(dedupeIdentifier)")
        }
        let workItem = DispatchWorkItem {
            DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier)
            for ptr in DispatchQueue.weakTargets.allObjects where dedupeIdentifier == DispatchQueue.dedupeIdentifierFor(ptr as AnyObject) {
                work()
                NSLog("Ran work item: \(dedupeIdentifier)")
                break
            }
        }
        
        DispatchQueue.workItems[dedupeIdentifier] = workItem
        DispatchQueue.weakTargets.addPointer(Unmanaged.passUnretained(target).toOpaque())
        
        asyncAfter(deadline: .now() + delay, execute: workItem)
    }
    
}

// MARK: - Static Properties for De-Duping
private extension DispatchQueue {
    
    static var workItems = [AnyHashable : DispatchWorkItem]()
    
    static var weakTargets = NSPointerArray.weakObjects()
    
    static func dedupeIdentifierFor(_ object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())." + String(describing: object)
    }
    
}
