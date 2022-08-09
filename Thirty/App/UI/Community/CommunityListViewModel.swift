//
//  CommunityListViewModel.swift
//  Thirty
//
//  Created by 송하경 on 2022/07/24.
//

import Foundation
import RxSwift

class CommunityListViewModel {
    let friendChallengeList: [CommunityChallenge] = [
        CommunityChallenge(userNickname: "하갱", challengeTitle: "마라톤 챌린지", challengeOrder: 0, challengeName: "1일차", challengeDetail: "힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1힘드러1", challengeDate: "07.24", challengeImage: nil, isExpanded: false),
        CommunityChallenge(userNickname: "하갱", challengeTitle: "마라톤 챌린지", challengeOrder: 1, challengeName: "2일차", challengeDetail: "힘드러2", challengeDate: "07.25", challengeImage: nil, isExpanded: false),
        CommunityChallenge(userNickname: "하갱", challengeTitle: "마라톤 챌린지", challengeOrder: 2, challengeName: "3일차", challengeDetail: "힘드러3", challengeDate: "07.26", challengeImage: nil, isExpanded: false),
        CommunityChallenge(userNickname: "하갱", challengeTitle: "마라톤 챌린지", challengeOrder: 3, challengeName: "4일차", challengeDetail: "힘드러4", challengeDate: "07.27", challengeImage: nil, isExpanded: false)
    ]
    
    let everyoneChallengeList: [CommunityChallenge] = [
        CommunityChallenge(userNickname: "익명1", challengeTitle: "덕질 챌린지", challengeOrder: 0, challengeName: "닮은 버릇이 있다면?", challengeDetail: "지성이는 코 찡긋거리는 버릇이 있는데, 이렇게 해서 손을 대지 않고 코를 긁는 것 같다. 나도 안경을 올리려고 얼굴을 찌뿌릴 때가 있는데", challengeDate: "08.08", challengeImage: nil, isExpanded: false),
        CommunityChallenge(userNickname: "뉸뉴", challengeTitle: "회사 챌린지", challengeOrder: 1, challengeName: "집에갈래", challengeDetail: "회사는 왜 다녀야할까 돈 많은 백수가 옛날엔 하나도 안부러웠는데 누구보다 부러울수가 없다 흐흐흐흐", challengeDate: "08.01", challengeImage: nil, isExpanded: false),
        CommunityChallenge(userNickname: "난나", challengeTitle: "날씨 챌린지", challengeOrder: 2, challengeName: "하늘에 구멍뚫림", challengeDetail: "비가 엄청 많이 온다 나갔다가 흠뻑쇼 하고 돌아온 성으니", challengeDate: "07.26", challengeImage: nil, isExpanded: false),
        CommunityChallenge(userNickname: "송송", challengeTitle: "노래 챌린지", challengeOrder: 3, challengeName: "비오는날 플리", challengeDetail: "비오는날에는 우산 듣기", challengeDate: "07.27", challengeImage: nil, isExpanded: false)
    ]
    
    lazy var friendChallengeObservable = BehaviorSubject<[CommunityChallenge]>(value: friendChallengeList)
    lazy var everyoneChallengeObservable = BehaviorSubject<[CommunityChallenge]>(value: everyoneChallengeList)
}
