//
//  StartupCommand.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import PureMVC

class StartupCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        let session = URLSession(configuration: configuration)
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        facade?.registerProxy(UserProxy(session: session, encoder: encoder, decoder: decoder))

    }
    
}
