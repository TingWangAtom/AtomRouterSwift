//
//  YohooRouterAppDelegateSwift.swift
//  FBSnapshotTestCase
//
//  Created by 王霄 on 2017/11/6.
//

import UIKit

open class YohooRouterAppDelegateSwift: UIResponder,UIApplicationDelegate {
    
    public var window: UIWindow?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        registerModules()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        initApplication()
        return true
    }
    
    /**
     初始化模块数据:从plist文件中读取RouterModules字段数组进行初始化
     */
    public func registerModules() -> Void {
        
    }
    
    /**
     初始化应用数据，供子类复写，基类调用本方法时已经初始化self.window，子类无需再次初始化
     例如：初始化微信支付，初始化im等
     */
    public func initApplication() -> Void {
        
    }
    
    /**
     添加模块到router manager中
     
     @param moduleName 模块名称，映射
     */
    func addModule(_ moduleName:String) -> Void {
        
        let moduleClass:AnyClass? = NSClassFromString(moduleName)!
        
        if moduleClass != nil {
            return
        }
        let module:Any = moduleClass!.initialize()
        RouterManagerSwift.getInstance().registerModule(module as! RouterModuleSwift)
    }
}
