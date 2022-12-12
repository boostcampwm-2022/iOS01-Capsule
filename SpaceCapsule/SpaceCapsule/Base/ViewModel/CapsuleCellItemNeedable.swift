//
//  CapsuleCellItemNeedable.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/12.
//

import Foundation

protocol CapsuleCellNeedable {}

extension CapsuleCellNeedable {
    func getCellItem(with uuid: String) -> ListCapsuleCellItem? {
        guard let capsule = AppDataManager.shared.capsule(uuid: uuid) else {
            return nil
        }
        
        let capsuleCellItem = ListCapsuleCellItem (
            uuid: capsule.uuid,
            thumbnailImageURL: capsule.images.first,
            address: capsule.simpleAddress,
            closedDate: capsule.closedDate,
            memoryDate: capsule.memoryDate,
            coordinate: capsule.geopoint.coordinate
        )

        return capsuleCellItem
    }
}
