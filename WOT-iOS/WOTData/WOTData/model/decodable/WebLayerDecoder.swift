//
//  WebLayerDecoder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 6/5/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation


@objc public class WebLayerDecoder: NSObject {
    
    @objc public static func decodeVehicles(binary: NSData?) {
        
        var result: WebLayer.Vehicles?
        
        DispatchQueue.global().async {
            let decoder = JSONDecoder()
            if let binary = binary as Data? {
                result = try? decoder.decode(WebLayer.Vehicles.self, from: binary)
                DispatchQueue.main.async {
                    print(result?.status ?? "fail")
                }
            }
        }
    }
    
    
}
