//
//  SwiftyRSA+ObjC.swift
//  SwiftyRSA
//
//  Created by Lois Di Qual on 3/6/17.
//  Copyright © 2017 Scoop. All rights reserved.
//

import Foundation

/// This files allows the ObjC runtime to access SwiftyRSA classes while keeping the swift code Swiftyish.
/// Things like protocol extensions or throwing and returning booleans are not well supported by ObjC, so instead
/// of giving access to the Swift classes directly, we're wrapping then their `_objc_*` counterpart.
/// They are exposed under the same name to the ObjC runtime, and all methods are present – they're just delegated
/// to the wrapped swift value.

private protocol ObjcBridgeable {
    associatedtype SwiftType
    var swiftValue: SwiftType { get }
    init(swiftValue: SwiftType)
}

// MARK: - PublicKey

@objc(PublicKey)
class _objc_PublicKey: NSObject, Key, ObjcBridgeable { // swiftlint:disable:this type_name
    
    fileprivate let swiftValue: PublicKey
    
    @objc var reference: SecKey {
        return swiftValue.reference
    }
    
    @objc var originalData: Data? {
        return swiftValue.originalData
    }
    
    @objc func pemString() throws -> String {
        return try swiftValue.pemString()
    }
    
    @objc func data() throws -> Data {
        return try swiftValue.data()
    }
    
    @objc func base64String() throws -> String {
        return try swiftValue.base64String()
    }
    
    required init(swiftValue: PublicKey) {
        self.swiftValue = swiftValue
    }
    
    @objc required init(data: Data) throws {
        self.swiftValue = try PublicKey(data: data)
    }
    
    @objc required init(reference: SecKey) throws {
        self.swiftValue = try PublicKey(reference: reference)
    }
    
    @objc required init(base64Encoded base64String: String) throws {
        self.swiftValue = try PublicKey(base64Encoded: base64String)
    }
    
    @objc required init(pemEncoded pemString: String) throws {
        self.swiftValue = try PublicKey(pemEncoded: pemString)
    }
    
    @objc required init(pemNamed pemName: String, in bundle: Bundle) throws {
        self.swiftValue = try PublicKey(pemNamed: pemName, in: bundle)
    }
    
    @objc required init(derNamed derName: String, in bundle: Bundle) throws {
        self.swiftValue = try PublicKey(derNamed: derName, in: bundle)
    }
    
    @objc static func publicKeys(pemEncoded pemString: String) -> [_objc_PublicKey] {
        return PublicKey.publicKeys(pemEncoded: pemString).map { _objc_PublicKey(swiftValue: $0) }
    }
}

// MARK: - PrivateKey

@objc(PrivateKey)
class _objc_PrivateKey: NSObject, Key, ObjcBridgeable { // swiftlint:disable:this type_name
    
    fileprivate let swiftValue: PrivateKey
    
    @objc var reference: SecKey {
        return swiftValue.reference
    }
    
    @objc var originalData: Data? {
        return swiftValue.originalData
    }
    
    @objc func pemString() throws -> String {
        return try swiftValue.pemString()
    }
    
    @objc func data() throws -> Data {
        return try swiftValue.data()
    }
    
    @objc func base64String() throws -> String {
        return try swiftValue.base64String()
    }
    
    required init(swiftValue: PrivateKey) {
        self.swiftValue = swiftValue
    }
    
    @objc required init(data: Data) throws {
        self.swiftValue = try PrivateKey(data: data)
    }
    
    @objc required init(reference: SecKey) throws {
        self.swiftValue = try PrivateKey(reference: reference)
    }
    
    @objc required init(base64Encoded base64String: String) throws {
        self.swiftValue = try PrivateKey(base64Encoded: base64String)
    }
    
    @objc required init(pemEncoded pemString: String) throws {
        self.swiftValue = try PrivateKey(pemEncoded: pemString)
    }
    
    @objc required init(pemNamed pemName: String, in bundle: Bundle) throws {
        self.swiftValue = try PrivateKey(pemNamed: pemName, in: bundle)
    }
    
    @objc required init(derNamed derName: String, in bundle: Bundle) throws {
        self.swiftValue = try PrivateKey(derNamed: derName, in: bundle)
    }
}

// MARK: - VerificationResult

@objc(VerificationResult)
class _objc_VerificationResult: NSObject { // swiftlint:disable:this type_name
    @objc let isSuccessful: Bool
    init(isSuccessful: Bool) {
        self.isSuccessful = isSuccessful
    }
}

// MARK: - ClearMessage

@objc(ClearMessage)
class _objc_ClearMessage: NSObject, Message, ObjcBridgeable { // swiftlint:disable:this type_name
    
    fileprivate let swiftValue: ClearMessage
    
    @objc var base64String: String {
        return swiftValue.base64String
    }
    
    @objc var data: Data {
        return swiftValue.data
    }
    
    required init(swiftValue: ClearMessage) {
        self.swiftValue = swiftValue
    }
    
    @objc required init(data: Data) {
        self.swiftValue = ClearMessage(data: data)
    }
    
    @objc required init(string: String, using rawEncoding: UInt) throws {
        let encoding = String.Encoding(rawValue: rawEncoding)
        self.swiftValue = try ClearMessage(string: string, using: encoding)
    }
    
    @objc required init(base64Encoded base64String: String) throws {
        self.swiftValue = try ClearMessage(base64Encoded: base64String)
    }
    
    @objc func string(encoding rawEncoding: UInt) throws -> String {
        let encoding = String.Encoding(rawValue: rawEncoding)
        return try swiftValue.string(encoding: encoding)
    }
    
    @objc func encrypted(with key: _objc_PublicKey, padding: Padding) throws -> _objc_EncryptedMessage {
        let encryptedMessage = try swiftValue.encrypted(with: key.swiftValue, padding: padding)
        return _objc_EncryptedMessage(swiftValue: encryptedMessage)
    }
    
    @objc func signed(with key: _objc_PrivateKey, digestType: _objc_Signature.DigestType) throws -> _objc_Signature {
        let signature = try swiftValue.signed(with: key.swiftValue, digestType: digestType.swiftValue)
        return _objc_Signature(swiftValue: signature)
    }
    
    @objc func verify(with key: _objc_PublicKey, signature: _objc_Signature, digestType: _objc_Signature.DigestType) throws -> _objc_VerificationResult {
        let isSuccessful = try swiftValue.verify(with: key.swiftValue, signature: signature.swiftValue, digestType: digestType.swiftValue)
        return _objc_VerificationResult(isSuccessful: isSuccessful)
    }
}

// MARK: - EncryptedMessage

@objc(EncryptedMessage)
class _objc_EncryptedMessage: NSObject, Message, ObjcBridgeable { // swiftlint:disable:this type_name
    
    fileprivate let swiftValue: EncryptedMessage
    
    @objc var base64String: String {
        return swiftValue.base64String
    }
    
    @objc public var data: Data {
        return swiftValue.data
    }
    
    required init(swiftValue: EncryptedMessage) {
        self.swiftValue = swiftValue
    }
    
    @objc required init(data: Data) {
        self.swiftValue = EncryptedMessage(data: data)
    }
    
    @objc required init(base64Encoded base64String: String) throws {
        self.swiftValue = try EncryptedMessage(base64Encoded: base64String)
    }
    
    @objc func decrypted(with key: _objc_PrivateKey, padding: Padding) throws -> _objc_ClearMessage {
        let clearMessage = try swiftValue.decrypted(with: key.swiftValue, padding: padding)
        return _objc_ClearMessage(swiftValue: clearMessage)
    }
}

// MARK: - Signature

@objc(Signature)
class _objc_Signature: NSObject, ObjcBridgeable { // swiftlint:disable:this type_name
    
    @objc
    enum DigestType: Int {
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512
        
        fileprivate var swiftValue: Signature.DigestType {
            switch self {
            case .sha1: return .sha1
            case .sha224: return .sha224
            case .sha256: return .sha256
            case .sha384: return .sha384
            case .sha512: return .sha512
            }
        }
    }
    
    fileprivate let swiftValue: Signature
    
    @objc var base64String: String {
        return swiftValue.base64String
    }
    
    @objc var data: Data {
        return swiftValue.data
    }
    
    required init(swiftValue: Signature) {
        self.swiftValue = swiftValue
    }
    
    @objc init(data: Data) {
        self.swiftValue = Signature(data: data)
    }
    
    @objc required init(base64Encoded base64String: String) throws {
        self.swiftValue = try Signature(base64Encoded: base64String)
    }
}
