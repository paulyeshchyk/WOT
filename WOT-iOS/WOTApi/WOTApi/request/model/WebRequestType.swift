//
//  WebRequestType.swift
//  WOTApi
//
//  Created by Paul on 30.12.22.
//

public enum WebRequestType: RequestIdType {
    public typealias RawValue = NSInteger
    case unknown = 1
    case login = 2
    case logout = 3
    case suspension = 4
    case turrets = 5
    case guns = 6
    case radios = 7
    case engines = 8
    case vehicles = 9
    case modules = 10
    case moduleTree = 11
    case tankProfile = 12
}
