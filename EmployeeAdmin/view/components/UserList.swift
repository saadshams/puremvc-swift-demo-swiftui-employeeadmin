//
//  UserList.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI

struct UserList: View {
    
    @StateObject private var mediator = UserListMediator()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(mediator.users) { user in
                    NavigationLink(value: user) {
                        Text(user.givenName)
                    }
                }
                .onDelete { indexes in
                    for index in indexes {
                        print(index)
                    }
                }
            }
            .navigationTitle("UserList")
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: UserForm(user: User(id: 0)) { user in
                        guard let user else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                mediator.users.append(user)
                            }
                        }
                    }
                ) {
                    Image(systemName: "plus.circle").imageScale(.large)
                }
            )
            .navigationDestination(for: User.self, destination: { user in
                UserForm(user: User(id: user.id)) { user in
                    guard let user else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let index = self.mediator.users.firstIndex(of: user) {
                            withAnimation {
                                mediator.users[index] = user
                            }
                        }
                    }
                }
            })
            .task {
                mediator.findAllUsers()
            }
        }
    }
    
}

#Preview {
    UserList()
}
