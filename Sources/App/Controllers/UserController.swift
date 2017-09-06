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
        droplet.get("verify", handler: verifyToken)
    }
    
    func verifyToken(request: Request) throws -> ResponseRepresentable {
        if let jwt = request.headers["Authorization"]?.string {
            let verified = TokenHelpers.tokenIsVerified(jwt)
            return try JSON(node: ["verified": verified])
        } else { return "Please pass token in Authorization Header" }
    }
    
    func createUser(request: Request) throws -> ResponseRepresentable {
        if let username = request.data[User.nameKey]?.string,
            let password = request.data[User.passwordKey]?.string {
            do { let passwordHashed = try User.hasher.make(password)
                let user = try User(username: username, password: passwordHashed)
                try user.save()
                let token = try TokenHelpers.createJwt(from: user)
                return try JSON(node: ["token": token])
            } catch let error { return try JSON(node: ["error": error])}
        }
        else { return "There was an error" }
    }
}

