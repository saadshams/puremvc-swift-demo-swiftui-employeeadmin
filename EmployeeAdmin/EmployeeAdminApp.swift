//
//  EmployeeAdminApp.swift
//  EmployeeAdmin
//
//  Created by Saad Shams on 5/23/25.
//

import SwiftUI
import PureMVC

@main
struct EmployeeAdminApp: App {
    
    @StateObject private var delegate = EmployeeAdminMediator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                UserList(delegate: delegate)
                    .onAppear {
                        ApplicationFacade.getInstance(key: ApplicationFacade.KEY)?.startup(mediator: delegate)
                    }
            }
        }
    }

}
