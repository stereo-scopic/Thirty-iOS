//
//  BucketAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/04.
//

import Foundation
import UIKit
import RxSwift
import Moya

enum BucketAPI {
    case addNewbie(_ challengeId: Int)
    case addCurrent(_ challengeId: Int)
    case getBucketList(_ status: String?)
    case getBucketDetail(_ bucketId: String)
    case enrollBucketAnswer(_ bucketId: String, _ bucketAnswer: BucketAnswer, _ cover_image: UIImage?)
    case getBucketAnswerDetail(_ bucketId: String, _ answerDate: Int)
    case editBucketAnswer(_ bucketId: String, _ answerDate: Int, _ bucketAnswer: BucketAnswer, _ coverImage: UIImage?)
    case stopChallengeByStatus(_ bucketId: String)
    case initChallenge(_ bucketId: String)
}

extension BucketAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.165.64.36:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getBucketList:
            return "/buckets"
        case .addNewbie:
            return "/buckets/add/newbie"
        case .addCurrent:
            return "/buckets/add/current"
        case .getBucketDetail(let bucketId), .initChallenge(let bucketId):
            return "/buckets/\(bucketId)"
        case .enrollBucketAnswer(let bucketId, _, _):
            return "/buckets/\(bucketId)"
        case .getBucketAnswerDetail(let bucketId, let answerDate):
            return "/buckets/\(bucketId)/date/\(answerDate)"
        case .editBucketAnswer(let bucketId, let answerDate, _, _):
            return "/buckets/\(bucketId)/date/\(answerDate)"
        case .stopChallengeByStatus(let bucketId):
            return "/buckets/\(bucketId)/status"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addNewbie, .addCurrent, .enrollBucketAnswer:
            return .post
        case .getBucketList, .getBucketDetail, .getBucketAnswerDetail:
            return .get
        case .editBucketAnswer, .stopChallengeByStatus:
            return .patch
        case .initChallenge:
            return .delete
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .addNewbie(let challengeId):
            return [
                "uuid": UUID().uuidString,
                "challenge": challengeId
            ]
        case .addCurrent(let challengeId):
            return [
                "challenge": challengeId
            ]
        case .stopChallengeByStatus:
            return [
                "status": "ABD"
            ]
//        case .enrollBucketAnswer(_, let bucketAnswer, _):
//            return [
//                "date": bucketAnswer.date,
//                "stamp": bucketAnswer.stamp ?? 0,
//                "image": bucketAnswer.image ?? "",
//                "music": bucketAnswer.music ?? "",
//                "detail": bucketAnswer.detail ?? ""
//            ]
//        case .editBucketAnswer(_, _, let bucketAnswer):
//            return [
//                "date": bucketAnswer.date,
//                "stamp": bucketAnswer.stamp ?? 0,
//                "image": bucketAnswer.image ?? "",
//                "music": bucketAnswer.music ?? "",
//                "detail": bucketAnswer.detail ?? ""
//            ]
        default:
            return nil
        }
    }
    
    var task: Task {
        switch self {
        case .getBucketList(let statusString):
            return .requestParameters(parameters: ["status": statusString ?? ""], encoding: URLEncoding.default)
        case .enrollBucketAnswer(_, let bucketAnswer, let cover_image):
            var formData = MultipartFormData(provider: .data(Data()), name: "")
            if let cover_image = cover_image {
                let imageData = cover_image.jpegData(compressionQuality: 1.0)!
                formData = MultipartFormData(provider: .data(imageData), name: "image", fileName: "cover_image.png", mimeType: "image/jpeg")
            }
            
            let date = "\(bucketAnswer.date)".data(using: String.Encoding.utf8) ?? Data()
            let stamp = "\(bucketAnswer.stamp ?? 0)".data(using: String.Encoding.utf8) ?? Data()
            let music = "".data(using: String.Encoding.utf8) ?? Data()
            let detail = "\(bucketAnswer.detail ?? "")".data(using: String.Encoding.utf8) ?? Data()
            
            let dateData = MultipartFormData(provider: .data(date), name: "date")
            let stampData = MultipartFormData(provider: .data(stamp), name: "stamp")
            let musicData = MultipartFormData(provider: .data(music), name: "music")
            let detailData = MultipartFormData(provider: .data(detail), name: "detail")
            
            var multipartData = [dateData, stampData, musicData, detailData]
            if let _ = cover_image {
                multipartData = [formData, dateData, stampData, musicData, detailData]
            }
            
            return .uploadMultipart(multipartData)
        case .editBucketAnswer(_, _, let bucketAnswer, let cover_image):
            var formData = MultipartFormData(provider: .data(Data()), name: "")
            if let cover_image = cover_image {
                let imageData = cover_image.jpegData(compressionQuality: 1.0)!
                formData = MultipartFormData(provider: .data(imageData), name: "image", fileName: "cover_image.png", mimeType: "image/jpeg")
            }
            
            let date = "\(bucketAnswer.date)".data(using: String.Encoding.utf8) ?? Data()
            let stamp = "\(bucketAnswer.stamp ?? 0)".data(using: String.Encoding.utf8) ?? Data()
            let music = "".data(using: String.Encoding.utf8) ?? Data()
            let detail = "\(bucketAnswer.detail ?? "")".data(using: String.Encoding.utf8) ?? Data()
            
            let dateData = MultipartFormData(provider: .data(date), name: "date")
            let stampData = MultipartFormData(provider: .data(stamp), name: "stamp")
            let musicData = MultipartFormData(provider: .data(music), name: "music")
            let detailData = MultipartFormData(provider: .data(detail), name: "detail")
            
            var multipartData = [dateData, stampData, musicData, detailData]
            if let _ = cover_image {
                multipartData = [formData, dateData, stampData, musicData, detailData]
            }
            
            return .uploadMultipart(multipartData)
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .addCurrent, .getBucketList, .getBucketDetail, .enrollBucketAnswer, .getBucketAnswerDetail, .editBucketAnswer, .stopChallengeByStatus, .initChallenge:
            return [
                "Authorization": "Bearer \(TokenManager.shared.loadAccessToken() ?? "")"
            ]
        case .addNewbie:
            return ["Content-Type": "application/json"]
        }
    }
}
