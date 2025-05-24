//
//  ApplicationFacade.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import SwiftUI
import PureMVC

class ApplicationFacade: Facade {
    
    static let KEY: String = "ApplicationFacade"
    
    static let STARTUP = "startup"
    
    override func initializeController() {
        super.initializeController()
        registerCommand(ApplicationFacade.STARTUP) { StartupCommand() }
    }
    
    class func getInstance(key: String) -> ApplicationFacade? {
        Facade.getInstance(key) { k in ApplicationFacade(key: k)} as? ApplicationFacade
    }
    
    func startup() {
        sendNotification(ApplicationFacade.STARTUP)
    }
}
