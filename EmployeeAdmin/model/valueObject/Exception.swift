//
//  Exception.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//


import Foundation

struct Exception: Error, Codable {
    
    let code: Int
    let message: String
    
}
