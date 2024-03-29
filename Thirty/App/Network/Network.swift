//
//  Network.swift
//  Thirty
//
//  Created by hakyung on 2022/04/07.
//

import RxSwift
import Moya

class Network<API: TargetType>: MoyaProvider<API> {
    init(plugins: [PluginType] = []) {
        let session = MoyaProvider<API>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        
        super.init(session: session, plugins: plugins)
    }
    
//    func request(_ api: API) -> Single<Response> {
//        return self.rx.request(api)
//            .filterSuccessfulStatusCodes()
//    }
}

enum ThirtyService {
    case challenge
    case explore(_ exploreIdx: String)
}

extension Network {
//    func requestWithoutMapping(_ target: API) -> Single<Void> {
//        return request(target)
//            .map { _ in }
//    }
    
//    func requestObject<T: Codable>(_ target: API, type: T.Type) -> Single<T> {
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return request(target)
//            .map(T.self, using: decoder)
//            .map(T.self, decoder)
//    }
//
//    func requestArray<T: Codable>(_ target: API, type: T.Type) -> Single<[T]> {
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return request(target)
//            .map([T].self, using: decoder)
//    }
}
