//
//  Token.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/04.
//

import Foundation

struct Token: Codable {
    var access_token: String?
    var refresh_token: String?
}
