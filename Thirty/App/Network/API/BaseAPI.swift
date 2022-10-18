//
//  BaseAPI.swift
//  Thirty
//
//  Created by hakyung on 2022/04/07.
//
import Moya

protocol BaseAPI: TargetType {}

extension BaseAPI {
    var baseURL: URL { URL(string: "")! }
    
    var method: Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? { nil }
}
