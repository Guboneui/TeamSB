//
//  CheckNicknameResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/30.
//

struct NicknameCheckResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
}



