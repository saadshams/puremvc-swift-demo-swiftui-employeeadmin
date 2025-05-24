//
//  UserListMediator.swift
//  PureMVC SWIFT UI Demo - EmployeeAdmin
//
//  Copyright(c) 2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine
import PureMVC

class UserListMediator: ObservableObject, IMediator {
    
    @Published var users: [User] = []
    
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    let name: String =  "UserListMediator"
     
    var viewComponent: AnyObject?
    
    open lazy var facade = Facade.getInstance(ApplicationFacade.KEY) { k in Facade(key: k) }

    private var userProxy: UserProxy?
    
    init() {
        facade?.registerMediator(self)
    }
    
    func onRegister() {
        userProxy = facade?.retrieveProxy(UserProxy.NAME) as? UserProxy
    }
    
    func findAllUsers() {
        userProxy?.findAllUsers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            } receiveValue: { users in
                self.users = users
            }
            .store(in: &cancellables)
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
    
    func onRemove() {print("onRemove UserList")}
    
    func initializeNotifier(_ key: String) {}
    
    func sendNotification(_ notificationName: String, body: Any?, type: String?) {}
}
