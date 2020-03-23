//
//  WOTWebProxyRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebProxyRequest: WOTWEBRequest {
    public func dataFrom(proxyData: NSData?) -> NSData? {
        guard let proxyData = proxyData else { return nil }
        var result: Data?
        let iso = String(data: proxyData as Data, encoding: String.Encoding.utf8)
        let unescaped = iso?.removingPercentEncoding
        let dutf8 = unescaped?.data(using: String.Encoding.utf8)
        guard let data = dutf8 else {
            return result as NSData?
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [AnyHashable: Any] {
                if let success = json["Text"] as? String {
                    result = success.data(using: String.Encoding.utf8)
                }
            }

        } catch {}
        return result as NSData?
    }

    public func proxyRequest(for request: NSURLRequest) -> URLRequest? {
        let url = request.url
        let urlItem = URLQueryItem(name: "url", value: url?.absoluteString)
        let toItem = URLQueryItem(name: "to", value: "to-txt")

        guard let proxyURL = URL(string: "https://countwordsfree.com/loadweb") else {
            return nil
        }

        var components = URLComponents(url: proxyURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [urlItem, toItem]
        guard let finalUrl = components?.url else {
            return nil
        }
        var result = URLRequest(url: finalUrl)
        result.httpMethod = "POST"
        return result
    }

//    override public var request: URLRequest {
//        guard let url = self.composedURL() else {
//            fatalError("request not created")
//        }
//        let httpBody = self.httpBodyData
//        let request = NSMutableURLRequest(url: url)
//        request.httpBody = httpBody
//        request.timeoutInterval = 0
//        request.httpMethod = self.method
//        guard let result = self.proxyRequest(for: request) else {
//            fatalError("request not created")
//        }
//        return result
//    }

//    override public func connectionDidFinishLoading(_ connection: NSURLConnection) {
//        let clearData = self.dataFrom(proxyData: self.data as NSData?)
//        self.parse(data: clearData as! Data)
//        self.data = nil
//        self.notifyListenersAboutFinish()
//    }

    /*
     NSData *clearData = [self dataFromProxyData:self.data];
     [self parseData:clearData];
     self.data = nil;

     [self notifyListenersAboutFinish];

     */
}
