//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTWebRequestProtocol {
    func parse(data: Data?)
}

extension WOTWEBRequest: WOTWebRequestProtocol {
    
    struct WOTWEBRequestError: Error {
        enum ErrorKind {
            case dataIsNull
            case emptyJSON
            case invalidStatus
            case parseError
        }
        
        let kind: ErrorKind
    }
    
    public func parse(data: Data?) {
        
        var mutableData: [AnyHashable: Any] = .init()
        let error = json(from: data) { (json) in
            mutableData.append(with: self.userInfo ?? [:])
            mutableData.append(with: json ?? [:])
        }
        
        self.notifyListenersAboutFinish()
        WOTRequestExecutor.sharedInstance()?.removeRequest(self)
        self.callback(mutableData, error, data)
    }
    
    private func json(from data: Data?, completion: (([AnyHashable: Any]?)->Void)? ) -> Error? {

        guard let data = data else {
            return WOTWEBRequestError(kind: .dataIsNull)
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves, .mutableContainers])
            guard let json = jsonObject as? [AnyHashable: Any] else {
                return WOTWEBRequestError(kind: .emptyJSON)
            }
            
            let response = WOTWebResponse()
            response.mapping(fromJSON: json)
            switch response.status {
            case .ok: completion?(response.data)
            default: return WOTWEBRequestError(kind: .invalidStatus)
            }
        } catch {
            return WOTWEBRequestError(kind: .parseError)
        }
        
        return nil
    }
}


/*
 - (NSError *)parseData:(NSData *)data {
     
     __block NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
     NSError *error = [self jsonFrom:data callback:^(NSDictionary * json) {
         [result addEntriesFromDictionary:json];
         [result addEntriesFromDictionary: self.userInfo];
     }];

     [self notifyListenersAboutFinish];
     
     [[WOTRequestExecutor sharedInstance] removeRequest:self];
     
     if (self.callback) {
         
         self.callback(result, error, data);
     }
     return error;
 }

 - (NSError *)jsonFrom:(NSData *)data callback:(void (^)(NSDictionary *data))block{

     NSMutableDictionary *result = nil;
     NSError *serializationError = nil;
     NSError *error = nil;
     NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves)
                                                                       error:&serializationError];
     if (serializationError) {
         error = serializationError;
     } else {
     #warning make validator
         id status = jsonData[WOT_KEY_STATUS];
         if ([status isEqualToString:WOT_KEY_ERROR]) {
             error = [NSError errorWithDomain:@"WOT" code:1 userInfo:jsonData[WOT_KEY_ERROR]];
         } else {
             if (jsonData) {
                 result = [jsonData mutableCopy];
                 [result clearNullValues];
             }
         }
     }
     block(result);
     return error;
 }

 */
