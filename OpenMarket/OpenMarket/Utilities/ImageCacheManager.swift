//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/31.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
