//
//  RouterModuleSwift.swift
//  FBSnapshotTestCase
//
//  Created by 王霄 on 2017/11/6.
//

import UIKit

/**
 项目模块数据模型
 子类复写时请在注释中添加该模块需要的参数名称及类型以便其他人员能清晰的了解,
 参数名请使用const nsstring的方式在m文件中定义，
 在h文件中用extern const nsstring的方式,
 子类继承该model时必须以Target_为开头命名,
 需要执行的action必须以Action_开头
 */

//暂时没用，先定义
public enum OpenModuleViewControllerType:NSInteger {
    case OpenModuleViewControllerTypePush = 0, OpenModuleViewControllerTypePresent
}

// 模块类型
public enum ModuleType:NSInteger {
    case ModuleTypeAction = 0, ModuleTypeUrl
}

open class RouterModuleSwift: NSObject {
    
    open var moduleName:String!  // 模块名称，英文，驼峰命名法
    open var moduleDescription:String!   // 模块描述，请尽量详细的描述
    open var openType:OpenModuleViewControllerType!  // viewController的打开方式
    open var moduleType:ModuleType!  // 模块类型：原生或url
    
    public func initComponment() -> Void {
        
    }
    
    /**
     模块主入口ViewController
     
     @param params 参数
     @return 主入口controller
     */
    public func Action_ModuleMainController(_ params:NSDictionary) -> UIViewController! {
        return nil
    }
    
    override init() {
        super.init()
        initComponment()
    }
    
    func isEqual(_ object:AnyObject) -> Bool {
        if !object.isKind(of: RouterModuleSwift.self) {
            return false
        }
        let module:RouterModuleSwift = object as! RouterModuleSwift
        return module.moduleName == moduleName
    }
}
