//
//  ChatModel.swift
//  Snapchat
//
//  Created by Kholod Sultan on 10/04/1443 AH.
//


import Foundation
import MessageKit
import UIKit
import CoreLocation

//MARK:- مودلز للمسج كيت
struct SenderMKit: SenderType {
    var senderId: String
    var displayName: String
}

struct MessageKit: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct User {
    var id: String
    var name: String
    var status: String
    var userEmail: String
}


struct LocationMKit: LocationItem{
    var location: CLLocation
    
    var size: CGSize
    
}






