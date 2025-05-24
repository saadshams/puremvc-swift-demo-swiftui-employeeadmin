//
//  UserFormMediator.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine
import PureMVC

class UserFormMediator: ObservableObject, IMediator {
    
    @Published var user: User?
    
    @Published var confirm: String?
    
    @Published var departments: [Department] = [Department(id: 0, name: "--None Selected--")]
    
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    let name: String = "UserFormMediator"
    
    var viewComponent: AnyObject?
    
    private var userProxy: UserProxy?
    
    open lazy var facade = Facade.getInstance(ApplicationFacade.KEY) { k in Facade(key: k) }
    
    init() {
        facade?.registerMediator(self)
    }
    
    func onRegister() {
        userProxy = facade?.retrieveProxy(UserProxy.NAME) as? UserProxy
    }
    
    func fetch() {
        guard let userProxy else { return }
        var publishers = Publishers.Zip(userProxy.findAllDepartments(),
                                        Just(User(id: 0)).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        if let user, user.id != 0 { // existing user
            publishers = Publishers.Zip(userProxy.findAllDepartments(), userProxy.findUserById(user.id)) // User Data (conditional)
        }
        
        publishers // Parallelize UI and User Data requests
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] departments, user in // Bind UI and User Data
                self?.departments.append(contentsOf: departments)
                self?.user = user
                self?.confirm = user.password
            })
            .store(in: &cancellables)
    }
    
    func findAllDepartments() async {
        do {
            let _: [Department] = try await withCheckedThrowingContinuation { continuation in
                userProxy?.findAllDepartments()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                         if case let .failure(error) = completion { continuation.resume(throwing: error) }
                    } receiveValue: { departments in
                        self.departments = departments
                        continuation.resume(returning: departments)
                    }
                    .store(in: &cancellables)
            }
        } catch {
            self.fault(error)
        }
    }
    
    func findAllDepartments2() {
        userProxy?.findAllDepartments()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] departments in
                self?.departments = departments
            })
            .store(in: &cancellables)
    }

    func findUserById(_ id: Int) async {
        do {
            let _: User = try await withCheckedThrowingContinuation { continuation in
                userProxy?.findUserById(id)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        if case let .failure(error) = completion { continuation.resume(throwing: error) }
                    } receiveValue: { user in
                        self.user = user
                        continuation.resume(returning: user)
                    }
                    .store(in: &cancellables)
            }
        } catch {
            self.fault(error)
        }
    }
    
    func saveOrUpdate() {
        
    }
    
    func fault(_ error: Error) {
        self.error = (error as? Exception).map { "Code: \($0.code) Message: \($0.message)" } ?? "Error: \(error.localizedDescription)"
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        facade?.removeMediator(self.name)
    }
    
    func listNotificationInterests() -> [String] { [] }
    
    func handleNotification(_ notification: any PureMVC.INotification) {}
    
    func onRemove() {print("onRemove UserForm")}
    
    func initializeNotifier(_ key: String) {}
    
    func sendNotification(_ notificationName: String, body: Any?, type: String?) {}
    
}
