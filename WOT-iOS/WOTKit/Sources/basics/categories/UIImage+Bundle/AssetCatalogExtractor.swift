//
//  AssetExtractor.swift
//  WOTKit
//
//  Created by https://gist.github.com/mauriciochirino
//  Copyright https://gist.github.com/fahied/d4a99e12914eb3edb074663828240907?permalink_comment_id=3685293#gistcomment-3685293
//

import UIKit

@objc
public class AssetCatalogExtractor: NSObject {
    @objc
    public static func createLocalUrl(forImageNamed name: String, bundle: Bundle) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        guard fileManager.fileExists(atPath: url.path) else {
            guard
                let image = UIImage(named: name, in: bundle, compatibleWith: nil),
                let data = image.pngData()
            else { return nil }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }
        return url
    }

    @objc
    public static func createLocalImage(forImageNamed name: String, bundle: Bundle) -> UIImage? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        guard fileManager.fileExists(atPath: url.path) else {
            guard
                let image = UIImage(named: name, in: bundle, compatibleWith: nil),
                let data = image.pngData()
            else { return nil }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return image
        }

        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
