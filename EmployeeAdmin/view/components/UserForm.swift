//
//  UserForm.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI

struct UserForm: View {
    
    @StateObject private var mediator = UserFormMediator()
    
    var user: User?
    
    var delegate: ((User?) -> Void)?

    
    var body: some View {
        VStack {
            HStack {
                TextField("First", text: Binding(
                        get: { mediator.user?.first ?? "" },
                        set: { mediator.user?.first = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                
                TextField("Last", text: Binding(
                        get: { mediator.user?.last ?? "" },
                        set: { mediator.user?.last = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
            }
            
            HStack {
                TextField("Email", text: Binding(
                        get: { mediator.user?.first ?? "" },
                        set: { mediator.user?.first = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                
                TextField("Username", text: Binding(
                        get: { mediator.user?.last ?? "" },
                        set: { mediator.user?.last = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
            }
            
            HStack {
                SecureField("Password", text: Binding(
                        get: { mediator.user?.password ?? "" },
                        set: { mediator.user?.password = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Confirm Password", text: Binding(
                    get: { mediator.confirm ?? "" },
                    set: { mediator.confirm = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            HStack {
                Picker(selection: Binding(
                    get: { mediator.user?.department ?? nil },
                    set: { mediator.user?.department = $0 }
                ), label: Text("")) {
                    ForEach(mediator.departments, id: \.id) { department in
                        Text(department.name ?? "").tag(Optional(department))
                    }
                }
                .pickerStyle(.wheel)
                .padding()
            }
        }
        .padding()
        .navigationTitle("User Form")
        .navigationBarItems(trailing:
            Button(action: {
            if mediator.user?.isValid(confirm: mediator.confirm) != nil {
                    mediator.saveOrUpdate()
                } else {
                    // fault(Exception(message: "Invalid Form Data."))
                }
            }) {
                Text(mediator.user?.id == 0 ? "Save" : "Update")
            }
        )
        .onAppear {
            Task {
                await mediator.findAllDepartments()
            }
        }
    }
}

#Preview {
    UserForm(user: User(id: 0))
}
