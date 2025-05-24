//
//  User.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    
    var id: Int
    var username: String?
    var first: String?
    var last: String?
    var email: String?
    var password: String?
    var department: Department?
    var roles: [Role]?
    
    init(id: Int, username: String? = nil, first: String? = nil, last: String? = nil, email: String? = nil, password: String? = nil, department: Department? = nil, roles: [Role]? = nil) {
        self.id = id
        self.username = username
        self.first = first
        self.last = last
        self.email = email
        self.password = password
        self.department = department
        self.roles = roles
    }
    
    func isValid(confirm: String?) -> Bool {
        [username, first, last, email, password].allSatisfy { ($0 ?? "").isEmpty == false }
        && password == confirm
        && department?.isValid() == true
    }
    
    var givenName: String {
        [last, first].compactMap { $0 }.joined(separator: ", ")
    }
}
