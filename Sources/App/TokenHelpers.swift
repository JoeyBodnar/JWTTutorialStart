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
    
    class func canVerifySignature(withSigner signer: String, fromToken token: String) -> Bool {
        do { let receivedJWT = try JWT(token: token)
            try receivedJWT.verifySignature(using: HS256(key: signer.bytes))
            return true
        }
        catch { return false }
    }
    
    class func verifyIssuer(_ token: String) -> Bool {
        do { let receivedJWT = try JWT(token: token)
            let issuerClaim = IssuerClaim(string: "vaporfogrums")
            try receivedJWT.verifyClaims([issuerClaim])
            return true
        } catch { return false }
    }
    
    class func tokenIsExpired(_ token: String) -> Bool {
        do { let receivedJWT = try JWT(token: token)
            try receivedJWT.verifyClaims([ExpirationTimeClaim(date: Date())])
            return false
        } catch { return true }
    }
    
    class func tokenIsVerified(_ token: String) -> Bool {
        let expired = TokenHelpers.tokenIsExpired(token)
        let issuerVerified = TokenHelpers.verifyIssuer(token)
        let signatureVerified = TokenHelpers.canVerifySignature(withSigner: JWTConfig.signerKey, fromToken: token)
        if (!expired && issuerVerified && signatureVerified) {
            return true
        } else { return false }
    }
    
    
}
