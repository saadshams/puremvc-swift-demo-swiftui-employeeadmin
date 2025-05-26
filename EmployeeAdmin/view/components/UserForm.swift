//
//  UserForm.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI

struct UserForm: View {
    
    @ObservedObject var delegate: EmployeeAdminMediator
    var id: Int?
    var responder: ((User?) -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var confirm: String?
    @State private var isSheetPresented: Bool = false
    @State private var error: Error?
    
    var body: some View {
        VStack {
            
            HStack {
                TextField("First", text: Binding(
                    get: { delegate.user?.first ?? "" },
                    set: { delegate.user?.first = $0 }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
                .autocapitalization(.none)
                
                TextField("Last", text: Binding(
                    get: { delegate.user?.last ?? "" },
                    set: { delegate.user?.last = $0 }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
                .autocapitalization(.none)
            }
            
            HStack {
                TextField("Email", text: Binding(
                    get: { delegate.user?.email ?? "" },
                    set: { delegate.user?.email = $0 }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
                .autocapitalization(.none)
                
                TextField("Username", text: Binding(
                    get: { delegate.user?.username ?? "" },
                    set: { delegate.user?.username = $0 }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
                .autocapitalization(.none)
            }
 
            HStack {
                SecureField("Password", text: Binding(
                    get: { delegate.user?.password ?? "" },
                    set: { delegate.user?.password = $0 }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                SecureField("Confirm Password", text: Binding(
                    get: { self.confirm ?? "" },
                    set: { self.confirm = $0 }))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            }
            
            HStack {
                Picker(selection: Binding(
                    get: { delegate.user?.department ?? nil },
                    set: { delegate.user?.department = $0 }
                ), label: Text("")) {
                    ForEach(delegate.departments, id: \.id) { department in
                        Text(department.name ?? "").tag(Optional(department))
                    }
                }
                .pickerStyle(.wheel)
                .padding()
            }
            
            HStack {
                Button(action: { isSheetPresented.toggle() }) { // User Roles
                    HStack {
                        Text("User Roles")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
            }
            .background(Color(UIColor.systemGray6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .navigationTitle("User Form")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if delegate.user?.isValid(confirm: self.confirm) == true {
                        delegate.saveOrUpdate()
                        dismiss()
                    } else {
                        self.error = Exception(code: 1, message: "Invalid Form Data.")
                    }
                }) {
                    Text(self.id == nil ? "Save" : "Update")
                }
            }
        }
        .task(id: id) {
            if delegate.departments.count <= 1 {
                delegate.findAllDepartments()
            }
            if let id = self.id {
                delegate.findUserById(id)
            } else {
                delegate.user = User(id: 0)
            }
        }
        .onReceive(delegate.$user) { user in // sync state
            self.confirm = user?.password ?? ""
        }
        .onDisappear { // cleanup
            delegate.user = nil
            self.confirm = nil
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                UserRole(delegate: delegate, onComplete: { roles in
                    delegate.user?.roles = roles
                })
            }
        }
        .alert(isPresented: Binding(get:{ error != nil }, set:{ _ in error = nil })) {
            Alert(
                title: Text("Error"),
                message: Text(((error as? Exception)?.message ?? error?.localizedDescription) ?? "An unknown error occurred."),
                primaryButton: .default(Text("OK")),
                secondaryButton: .cancel()
            )
        }

    }
    
}

#Preview {
    UserForm(delegate: EmployeeAdminMediator())
}
