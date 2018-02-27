//
//  YohooDataEventSwift.swift
//  FBSnapshotTestCase
//
//  Created by 王霄 on 2017/11/6.
//

import UIKit

public typealias GetDataByEvent = (_ param:NSDictionary) -> Any

open class YohooDataEventSwift: NSObject {
    
    open var eventName:String!
    open var getDataByEvent:GetDataByEvent!
    
    
    public func initWithEventName(eventName:String, getDataByEvent:@escaping GetDataByEvent) -> YohooDataEventSwift! {
        self.eventName = eventName
        self.getDataByEvent = getDataByEvent
        return self
    }
}
