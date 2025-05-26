//
//  RoleProxy.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine
import PureMVC

class RoleProxy: Proxy {
    
    override class var NAME: String { "RoleProxy" }
    
    private var session: URLSession
    
    private var encoder: JSONEncoder
    
    private var decoder: JSONDecoder
    
    init(session: URLSession, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        super.init(name: RoleProxy.NAME)
    }
    
    func findAll() -> AnyPublisher<[Role], Error> {
        guard let url = URL(string: "http://localhost/roles") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { [decoder] data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw (try? decoder.decode(Exception.self, from: data)) ?? URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [Role].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func findRolesById(_ id: Int) -> AnyPublisher<[Role], Error> {
        guard let url = URL(string: "http://localhost/users/\(id)/roles") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .tryMap { [decoder] data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw (try? decoder.decode(Exception.self, from: data)) ?? URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [Role].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
