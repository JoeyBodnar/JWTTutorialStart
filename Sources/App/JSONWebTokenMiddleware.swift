//
//  JWTModdleware.swift
//  JWTTutorial
//
//  Created by Stephen Bodnar on 06/09/2017.
//
//

import Foundation
import Vapor
import JWT
import HTTP


final class JSONWebTokenMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        if let token = request.headers["Authorization"]?.string {
            do { try TokenHelpers.tokenIsVerified(token)
                return try next.respond(to: request) }
            catch let error as JWebTokenError {
                return try Response(status: Status.forbidden, json: JSON(node: ["error": error.description, "status": 403]))
            }
        } else {
            return try Response(status: Status.forbidden, json: JSON(node: ["error": "no auth token", "status": 403]))
        }
    }
}
