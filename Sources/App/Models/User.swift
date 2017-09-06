//
//  User.swift
//  JWTTutorial
//
//  Created by Stephen Bodnar on 06/09/2017.
//
//


import AuthProvider
import FluentProvider
import HTTP
import Vapor
import BCrypt

extension User: ResponseRepresentable {}
extension User: Timestampable {}

final class User: Model, PasswordAuthenticatable {
    let storage = Storage()
    public static let hasher = BCryptHasher(cost: 10)
    
    static let nameKey = "email"
    static let passwordKey = "password"
    
    public static let passwordVerifier: PasswordVerifier? = User.hasher
    
    var username: String
    var password: Bytes
    
    var hashedPassword: String? {
        return password.makeString()
    }
    
    init(username: String, password: Bytes) throws {
        self.username = username
        self.password = password
    }
    
    init(row: Row) throws {
        username = try row.get(User.nameKey)
        let passwordAsString:String = try row.get(User.passwordKey)
        password = passwordAsString.makeBytes()
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.nameKey, username)
        try row.set(User.passwordKey, hashedPassword)
        return row
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(User.nameKey)
            builder.string(User.passwordKey)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        let passwordAsString: String = try json.get(User.passwordKey)
        try self.init(username: json.get(User.nameKey), password: User.hasher.make(passwordAsString))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.nameKey, username)
        return json
    }
}

