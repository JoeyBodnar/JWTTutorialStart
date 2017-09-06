//
//  TokenHelpers.swift
//  JWTTutorial
//
//  Created by Stephen Bodnar on 06/09/2017.
//
//

import Foundation
import JWT

struct JWTConfig {
    static let signerKey = "e34DfUsxItd6jgB89jH76hl"
    
    static let headers = JSON(["typ": "JWT", "alg": "HS256"])
    static let signer = HS256(key: JWTConfig.signerKey.bytes)
    static let expirationTime: Int = 1000
}

class TokenHelpers {
    
    class func createPayload(from user: User) throws -> JSON {
        if let id = user.id?.int {
            let now = Date()
            let dateAsTimeDouble = now.timeIntervalSince1970
            let createdAt:Int = Int(dateAsTimeDouble)
            let expiration = Int(dateAsTimeDouble) + JWTConfig.expirationTime
            let payLoad = JSON(["iss": "vaporforums", "iat": .number(.int(createdAt)), "username": .string(user.username), "userId": .number(.int(id)), "exp": .number(.int(expiration))])
            return payLoad
        } else { throw JWTError.createKey }
    }
    
    class func createJwt(from user: User) throws -> String {
        do {
            let payLoad = try TokenHelpers.createPayload(from: user)
            let headers = JWTConfig.headers
            let signer = JWTConfig.signer
            let jwt = try JWT(headers: headers, payload: payLoad, signer: signer)
            let token = try jwt.createToken()
            return token
        } catch { throw JWTError.createKey }
    }
}
