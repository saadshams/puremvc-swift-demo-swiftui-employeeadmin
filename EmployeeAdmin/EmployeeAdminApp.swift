//
//  EmployeeAdminApp.swift
//  EmployeeAdmin
//
//  Created by Saad Shams on 5/23/25.
//

import SwiftUI

@main
struct EmployeeAdminApp: App {
    var body: some Scene {
        WindowGroup {
            UserList()
        }
    }
    
    init() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY)?.startup()
    }
}
