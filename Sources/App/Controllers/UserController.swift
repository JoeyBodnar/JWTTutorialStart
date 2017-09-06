//
//  UserController.swift
//  JWTTutorial
//
//  Created by Stephen Bodnar on 06/09/2017.
//
//

import Vapor
import FluentProvider
import HTTP

final class UserController {
    let droplet: Droplet
    
    init(droplet: Droplet) {
        self.droplet = droplet
    }
    
    func addRoutes() {
        droplet.post("createuser", handler: createUser)
    }
    
    func createUser(request: Request) throws -> ResponseRepresentable {
        return "create user in this method"
    }
}

