//
//  TokenManager.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/17.
//

import Foundation

public final class TokenManager {
  public static let shared = TokenManager()
  private static let accessTokenKey: String = "access_token"
  private static let refreshTokenKey: String = "refresh_token"
  private static let tempTokenKey: String = "temp_token"
  
  private let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
  
  private var jsonEncoder: JSONEncoder {
    return JSONEncoder()
  }
  
  private var jsonDecoder: JSONDecoder {
    return JSONDecoder()
  }
  
  private init() { }
  
  // MARK: - Save Token
  public func saveTempToken(_ token: String) throws {
    let tempTokenData = try jsonEncoder.encode(token)
    let tempToken = String(data: tempTokenData, encoding: .utf8)
    try keychain.set(tempToken ?? "", key: Self.tempTokenKey)
  }
  
  public func saveAccessToken(_ token: String) throws {
    let accessTokenData = try jsonEncoder.encode(token)
    let accessToken = String(data: accessTokenData, encoding: .utf8)
    try keychain.set(accessToken ?? "", key: Self.accessTokenKey)
  }
  
  public func saveRefreshToken(_ token: String) throws {
    let refreshTokenData = try jsonEncoder.encode(token)
    let refreshToken = String(data: refreshTokenData, encoding: .utf8)
    try keychain.set(refreshToken ?? "", key: Self.refreshTokenKey)
  }
  
  // MARK: - Load Token
  public func loadTempToken() -> String? {
    guard let tempTokenData = keychain[Self.tempTokenKey]?.data(using: .utf8),
          let tempToken = try? jsonDecoder.decode(String.self, from: tempTokenData)
    else { return nil }
    
    return tempToken
  }
  
  public func loadAccessToken() -> String? {
    guard let accessTokenData = keychain[Self.accessTokenKey]?.data(using: .utf8),
          let accessToken = try? jsonDecoder.decode(String.self, from: accessTokenData)
    else { return nil }
    
    return accessToken
  }
  
  public func loadRefreshToken() -> String? {
    guard let refreshTokenData = keychain[Self.refreshTokenKey]?.data(using: .utf8),
          let refreshToken = try? jsonDecoder.decode(String.self, from: refreshTokenData)
    else { return nil }
    
    return refreshToken
  }
  
  // MARK: - Delete Token
  public func deleteToken() {
    try? keychain.remove(Self.accessTokenKey)
    try? keychain.remove(Self.refreshTokenKey)
  }
  
  public func deleteTempToken() {
    try? keychain.remove(Self.tempTokenKey)
  }
  
  public func resetKeychain() {
    deleteToken()
    deleteTempToken()
  }
}
