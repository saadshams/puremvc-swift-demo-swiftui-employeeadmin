//
//  UserProxy.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine
import PureMVC

class UserProxy: Proxy {
    
    override class var NAME: String { "UserProxy" }
    
    private let session: URLSession
    
    private let encoder: JSONEncoder
    
    private let decoder: JSONDecoder
    
    init(session: URLSession, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        super.init(name: UserProxy.NAME, data: nil)
    }
    
    func findAllUsers() -> AnyPublisher<[User], Error> {
        guard let url = URL(string: "http://localhost/users") else {
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
            .decode(type: [User].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func findUserById(_ id: Int) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "http://localhost/users/\(id)") else {
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
            .decode(type: User.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func save(user: User) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "http://localhost/users") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { [decoder] data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard httpResponse.statusCode == 201 else {
                    throw (try? decoder.decode(Exception.self, from: data)) ?? URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: User.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func update(user: User) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "http://localhost/users/\(user.id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { [decoder] data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw (try? decoder.decode(Exception.self, from: data)) ?? URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: User.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func deleteById(_ id: Int) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "http://localhost/users/\(id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return session.dataTaskPublisher(for: request)
            .tryMap { [decoder] data, response -> Void in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
            
                guard httpResponse.statusCode == 204 else {
                    throw (try? decoder.decode(Exception.self, from: data)) ?? URLError(.badServerResponse)
                }
                
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func findAllDepartments() -> AnyPublisher<[Department], Error> {
        guard let url = URL(string: "http://localhost/departments") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { [decoder] data, response  -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw (try? decoder.decode(Exception.self, from: data)) ?? URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: [Department].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
