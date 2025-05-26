//
//  UserList.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI
import Combine

struct UserList: View {
    
    @ObservedObject var delegate: EmployeeAdminMediator
    
    var body: some View {
        List {
            ForEach(delegate.users) { user in
                NavigationLink(value: user) {
                    Text(user.givenName)
                }
            }
            .onDelete { indexes in
                for index in indexes {
                    let user = delegate.users[index]
                    _ = withAnimation {
                        delegate.users.remove(at: index)
                    }
                    delegate.deleteById(user.id)
                }
            }
        }
        .navigationTitle("UserList")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: UserForm(delegate: delegate) { user in // new user
                        guard let user else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                delegate.users.append(user)
                            }
                        }
                    }
                ) {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }
            }
        }
        .navigationDestination(for: User.self, destination: { user in // existing user
            UserForm(delegate: delegate, id: user.id) { user in
                guard let user else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let index = self.delegate.users.firstIndex(of: user) {
                        withAnimation {
                            delegate.users[index] = user
                        }
                    }
                }
            }
        })
        .task {
            delegate.findAllUsers()
        }
        
    }
    
}

#Preview {
    UserList(delegate: EmployeeAdminMediator())
}
