//
//  UserRole.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI

struct UserRole: View {
    
    @ObservedObject var delegate: EmployeeAdminMediator
    
    let onComplete: (([Role]) -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            List(delegate.roles) { role in
                HStack {
                    Text(role.name).foregroundColor(.black)
                    Spacer()
                    if delegate.user?.roles.contains(where: { $0.id == role.id }) == true {
                       Image(systemName: "checkmark").foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let index = delegate.user?.roles.firstIndex(where: { $0.id == role.id }) {
                        delegate.user?.roles.remove(at: index)
                    } else {
                        delegate.user?.roles.append(role)
                    }
                }
            }
        }
        .navigationTitle("User Roles")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    onComplete?(delegate.user?.roles ?? [])
                    dismiss()
                }
            }
        }
        .task(id: delegate.user?.id) {
            delegate.findAllRoles()
            if let id = delegate.user?.id {
                delegate.findAllUserRoles(id)
            }
         }
    }
}

#Preview {
    UserRole(delegate: EmployeeAdminMediator(), onComplete: nil)
}
