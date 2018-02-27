//
//  RouterManagerSwift.swift
//  FBSnapshotTestCase
//
//  Created by 王霄 on 2017/11/6.
//

import UIKit

var instance:RouterManagerSwift?

let kOpenModuleActionName:String = "ModuleMainController"
let kOpenUrlModuleName:String = "OpenUrlModule"

open class RouterManagerSwift: NSObject {
    
    var modules:NSMutableDictionary!
    var events:NSMutableDictionary!
    var dataEvents:NSMutableDictionary!
    
    /**
     获取管理单例
     @return 管理器
     */
    public class func getInstance() -> RouterManagerSwift {
        
        if (instance == nil) {
            instance = RouterManagerSwift.init()
        }
        
        return instance!
    }
    
    override init() {
        super.init()
        modules = NSMutableDictionary.init()
        events = NSMutableDictionary.init()
        dataEvents = NSMutableDictionary.init()
    }
    /**
     注册模块
     
     @param module 模块数据
     模块名称不允许为空
     不允许注册相同模块名
     @throw 异常
     */
    public func registerModule(_ module:RouterModuleSwift) -> Void {
        if isEmpty(module.moduleName) {
            // throw "模块名称不允许为空"
            NSLog("模块名称不允许为空")
            return
        }
        let registeredModule:RouterModuleSwift? = module.value(forKey: module.moduleName) as? RouterModuleSwift
        
        if registeredModule != nil {
            NSLog("该模块名已注册")
            return
        }
        module.setValue(module, forKey: module.moduleName)
    }
    
    /**
     打开模块
     
     @param moduleName 模块名称
     @param params 模块需要的参数
     @return 模块主入口viewController
     */
    public func openModule(_ moduleName:String, params:Any) -> UIViewController! {
        let registeredModule:RouterModuleSwift? = modules.value(forKey: moduleName) as? RouterModuleSwift
        
        if registeredModule == nil {
            return nil
        }
        
        return registeredModule?.Action_ModuleMainController(params as! NSDictionary)
    }
    
    /**
     打开外部链接
     
     @param url url
     @param params 参数
     @return viewController
     */
    public func openUrl(_ url:String, params:NSDictionary) -> UIViewController {
        
        return openModule(kOpenUrlModuleName, params: params)
    }
    
    /**
     移除模块
     
     @param moduleName 模块名称
     @return 是否移除成功
     */
    public func removeModule(_ moduleName:String) -> Bool {
        
        modules .removeObject(forKey: moduleName)
        return true;
    }
    
    /**
     添加事件通知响应
     事件响应的事件名称及identifier不允许为空,并且target及selector必须不为空
     允许同一个事件注册多个响应，即事件名称可以一致，但不允许同一个事件的identifier一样
     @param event 事件
     */
    public func addEvent(_ event:YohooEventSwift) -> Void {
        if isEmpty(event.eventName) || isEmpty(event.identifier) {
            // throw
//            let exception:NSException = NSException.init(name: NSExceptionName(rawValue: "addEvent"), reason: "事件名称或标识为空", userInfo: nil)
            NSLog("事件名称或标识为空")
            return
        }
        
        var _events:Array<YohooEventSwift>? = events.value(forKey: event.eventName) as? Array<YohooEventSwift>
        
        if _events == nil {
            
            _events = Array() as Array<YohooEventSwift>
            events.setValue(_events, forKey: event.eventName)
        }
        
        if (_events?.contains(event))! {
            NSLog("事件已经存在")
            return
        }
        
        if event.target == nil || event.selector == nil {
            // @throw [[NSException alloc] initWithName:@"addEvent" reason:@"事件主体或响应事件的方法为空" userInfo:nil];
            NSLog("事件主体或响应事件的方法为空")
            return
        }
        
        _events?.append(event)
        events.setValue(_events, forKey: event.eventName)
    }
    
    /**
     发送事件
     
     @param eventName 事件名称
     @param params 事件参数
     */
    public func postEvent(_ eventName:String, params:NSDictionary) -> Void {
        
        var _events:Array<YohooEventSwift>? = (events.value(forKey: eventName) as? Array<YohooEventSwift>)
        
        if _events == nil {
            return;
        }
        
        var needRemoveEvents:Array<YohooEventSwift> = Array.init()

        for event in _events! {
            
            let target:NSObject = event.target
            
            if target.responds(to: event.selector) {
                
                target.perform(event.selector, with: params)
            } else {
                
            }
            
            if event.removeWhenSend {
                needRemoveEvents.append(event)
            }
        }
        
        if needRemoveEvents.count > 0 {
            
            for event in needRemoveEvents {
                
                let index:Int = (_events!.index(of: event))!
                _events!.remove(at: index)
            }
        }
        
        if _events?.count == 0 {
            events.removeObject(forKey: eventName)
        }
        
    }
    
    /**
     移除事件
     
     @param eventName 事件名称
     @param identifier 事件标识
     */
    public func removeEvent(_ eventName:String, identifier:String) -> Void {
        
        var _events:Array<YohooEventSwift>? = (events.value(forKey: eventName) as? Array<YohooEventSwift>)
        
        if _events == nil || _events?.count == 0 {
            return
        }
        
        let event:YohooEventSwift = YohooEventSwift().initWithName(eventName: eventName, identifier: identifier, target: nil, selector: nil, removeWhenSend: false) as! YohooEventSwift
        
        
        let index:Int = (_events!.index(of: event))!
        _events!.remove(at: index)
        
        if _events?.count == 0 {
            events.removeObject(forKey: eventName)
        }
    }
    
    /**
     根据事件名称获取数据
     
     @param eventName 事件名称
     @param param 参数
     @return 数据
     */
    public func getDataByEventName(_ eventName:String, param:NSDictionary) -> Any! {
        
        if isEmpty(eventName) {
            //throw
            NSLog("事件名不允许为空")
            return nil
        }
        
        let event:YohooDataEventSwift? = dataEvents.object(forKey: eventName) as? YohooDataEventSwift
        
        if event == nil {
            NSLog("未找到该事件，请检查代码或连续相关开发人员");
            return nil
        }
        
        if event?.getDataByEvent == nil {
            
            NSLog("该事件未实现获取数据事件方法，请检查相关代码或联系相关工作人员");
            return nil;
        }
        
        return event!.getDataByEvent(param)
    }
    
    /**
     注册数据获取事件
     
     @param event 事件参数
     */
    public func registerDataEvent(_ event:YohooDataEventSwift) -> Void {
        
        if isEmpty(event.eventName) {
            NSLog("事件名不允许为空")
            return
        }
        
        if event.getDataByEvent == nil {
            NSLog("事件获取方法必须存在")
            return
        }
        
        let oldEvent:YohooDataEventSwift? = dataEvents.object(forKey: event.eventName) as? YohooDataEventSwift
        
        if oldEvent != nil {
            NSLog("该事件已注册，请勿重复注册");
            return;
        }
        
        dataEvents.setValue(event, forKey: event.eventName)
    }
    
    /**
     移除获取数据事件
     
     @param eventName 事件名
     */
    public func removeDataEvent(_ eventName:String) -> Void {
        
        dataEvents.removeObject(forKey: eventName)
    }        
    
    func isEmpty(_ string:String?) -> Bool {
        return string == nil || string!.isEmpty
    }
}
