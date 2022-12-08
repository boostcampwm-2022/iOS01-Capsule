//
//  ProfileResource.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/07.
//

import UIKit

struct ProfileResource {
    static var randomEmoji: UIImage? {
        let names = Set([
            "bear",
            "cat",
            "chick",
            "cow",
            "dog",
            "dragon",
            "fox",
            "frog",
            "hamster",
            "koala",
            "lion",
            "monkey",
            "octopus",
            "panda",
            "pig",
            "rabbit",
            "tiger"
        ])

        return UIImage(named: names.randomElement() ?? "emptyImage")
    }
}
