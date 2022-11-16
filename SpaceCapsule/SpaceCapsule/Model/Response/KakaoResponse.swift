//
//  KakaoResponse.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/16.
//

import Foundation

struct KakaoResponse: Codable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Codable {
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

struct Document: Codable {
    let roadAddress: RoadAddress?
    let address: Address
    
    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

struct Address: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String
    let mountainYn, mainAddressNo, subAddressNo: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case mountainYn = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
    }
}

struct RoadAddress: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String
    let roadName, undergroundYn, mainBuildingNo, subBuildingNo: String
    let buildingName, zoneNo: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case undergroundYn = "underground_yn"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case buildingName = "building_name"
        case zoneNo = "zone_no"
    }
}
