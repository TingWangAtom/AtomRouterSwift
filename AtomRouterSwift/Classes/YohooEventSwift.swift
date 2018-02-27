//
//  YohooEventSwift.swift
//  FBSnapshotTestCase
//
//  Created by 王霄 on 2017/11/6.
//

import UIKit

open class YohooEventSwift: NSObject {

    open var eventName:String!  // 事件名称
    open var identifier:String! // 事件标识，用于移除事件使用，因为可能多个地方注册同一个事件通知，需要唯一标识来判断移除哪一个，请使用需要获取事件的类名来定义
    open var target:NSObject!   // 事件主体，用户SEL获取
    open var selector:Selector! // 事件发生时的处理方法
    open var removeWhenSend:Bool!   // 事件发送后是否移除
    
    public func initWithName(eventName:String, identifier:String, target:NSObject?, selector:Selector?, removeWhenSend:Bool) -> Any {
        
        self.eventName = eventName;
        self.identifier = identifier;
        self.target = target;
        self.selector = selector;
        self.removeWhenSend = removeWhenSend;
        
        return self;
    }
    
    func isEqual(object:AnyObject) -> Bool {
        
        if !object.isKind(of: YohooEventSwift.self) {
            
            return false
        }
        
        let event:YohooEventSwift = object as! YohooEventSwift
        
        return event.eventName == eventName && event.identifier == identifier
    }
    
}
