//
//  Network.swift
//  Thirty
//
//  Created by hakyung on 2022/04/07.
//

import Network
import RxSwift
import Moya

class Network<API: TargetType>: MoyaProvider<API> {
  init(plugins: [PluginType] = []) {
    let session = MoyaProvider<API>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10
    
    super.init(session: session, plugins: plugins)
  }
}

enum ThirtyService {
  case challenge
  case explore(_ exploreIdx: String)
}
//
// extension ThirtyService: TargetType {
//  var baseURL: URL {
//    return URL(string: "")!
//  }
//
//  func request(_ api: API) -> Single<Response>{
//    return self.rx.request(api)
//      .filterSuccessfulStatusCodes()
//  }
// }
//
// extension Network{
//  func requestWithoutMapping(_ target: API) -> Single<Void> {
//    return request(target, completion: <#Completion#>)
//      .map { _ in }
//  }
//
//  func requestObject<T: Codable>(_ target: API, type: T.Type) -> Single<T> {
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = .iso8601
//    return request(target)
//      .map(T.self, using: decoder)
//  }
//
//  func requestArray<T: Codable>(_ target: API, type: T.Type) -> Single<[T]> {
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = .iso8601
//    return request(target)
//      .map([T].self, using: decoder)
//  }
// }
