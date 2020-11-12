//
//  DataLoader.swift
//  moodTrack
//
//  Created by Team on 21/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//


import Cocoa
import p2_OAuth2

public protocol DataLoader {
    
    var oauth2: OAuth2 { get }
    func requestUserdata(callback: @escaping ((_ dict: OAuth2JSON?, _ error: Error?) -> Void))
}
