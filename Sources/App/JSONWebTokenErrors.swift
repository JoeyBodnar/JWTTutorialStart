//
//  JSONWebTokenErrors.swift
//  JWTTutorial
//
//  Created by Stephen Bodnar on 07/09/2017.
//
//

import Foundation
import JWT

enum JWebTokenError: CustomStringConvertible, Error {
    case signatureVerificationFailedError
    case issuerVerificationFailedEror
    case tokenIsExpiredError
    case payloadCreationError
    case createJWTError
    
    var description: String {
        switch self {
        case .signatureVerificationFailedError:
            return "Could not verify signature"
        case .issuerVerificationFailedEror:
            return "Could not verify JWT issuer"
        case .tokenIsExpiredError:
            return "Your token is expired"
        case .payloadCreationError:
            return "Error creating JWT payload"
        case .createJWTError:
            return "Error creating JWT"
        }
    }
}
