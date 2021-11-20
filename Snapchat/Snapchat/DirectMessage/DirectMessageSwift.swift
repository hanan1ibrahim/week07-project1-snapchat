//
//  DirectMessageSwift.swift
//  Snapchat
//
//  Created by Kholod Sultan on 10/04/1443 AH.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
import FirebaseFirestore
import CoreLocation
import MapKit

class DMScreen: MessagesViewController {
    
    let db = Firestore.firestore()
    var messages: [MessageKit] = []
    var currentUser: SenderMKit!
    var user = ""
    var barTitle = ""
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLocation()
        title = barTitle
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        
        customizeBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageIncomingMessagePadding(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            layout.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
        
        //from inputBarAccessortyView
        messageInputBar.delegate = self
        
        
        fetchMessages()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //present keyboard
        
        self.messageInputBar.inputTextView.becomeFirstResponder()
        
        
    }
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
    }
    
    private func customizeBar() {
    
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.inputTextView.layer.cornerRadius = 15
        messageInputBar.inputTextView.layer.borderColor = UIColor.black.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.inputTextView.clipsToBounds = true
        messageInputBar.inputTextView.placeholder = "Write your message"
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        
    
        messageInputBar.sendButton.setTitleColor(.black, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.black.withAlphaComponent(0.3),
            for: .highlighted
        )
        
        
        
        let image = UIImage(systemName: "mappin.and.ellipse")!.withTintColor(.black, renderingMode: .alwaysOriginal)
        let button = InputBarButtonItem(frame: CGRect(origin: .zero, size: CGSize(width: image.size.width, height: image.size.height)))
        button.image = image
        button.imageView?.contentMode = .scaleAspectFit
        
        button.onTouchUpInside { _ in
            print("tapped")
            self.locationManager.startUpdatingLocation()
        }
        messageInputBar.setStackViewItems([button], forStack: .left, animated: true)
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.leftStackView.alignment = .center //HERE
        
        reloadInputViews()
    }
    
    private func fetchMessages() {
        
        
        db.collection("Messages").whereField("messagesBetween", isEqualTo: [user, barTitle].sorted())
            .order(by: "messageSentDate")
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let messageId = data["messageId"] as? String,
                               let messageSentDate = data["messageSentDate"] as? String,
                               let messageBody = data["messageBody"] as? String,
                               let senderId = data["senderId"] as? String,
                               let displayName = data["displayName"] as? String,
                               let kind = data["kind"] as? String
                            {
                                if kind == "text" {
                                    let messageSentDateNEW = self.stringToDate(messageSentDate)
                                    let newMessage = MessageKit(sender: SenderMKit(senderId: senderId, displayName: displayName), messageId: messageId, sentDate: messageSentDateNEW, kind: .text(messageBody))
                                    
                                    self.messages.append(newMessage)
                                    DispatchQueue.main.async {
                                        
                                        self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                                        self.messagesCollectionView.reloadData()
                                    }
                                }else if kind == "location"{
                                    
                                    let message = messageBody.components(separatedBy: ",")
                                    
                                    
                                    let messageSentDateNEW = self.stringToDate(messageSentDate)
                                    let newMessage = MessageKit(sender: SenderMKit(senderId: senderId, displayName: displayName), messageId: messageId, sentDate: messageSentDateNEW,
                                                                kind: .location(LocationMKit(location: CLLocation(latitude: Double(message[0])!, longitude: Double(message[1])!), size: CGSize(width: 300, height: 330))))
                                    
                                    self.messages.append(newMessage)
                                    DispatchQueue.main.async {
                                        
                                        self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                                        self.messagesCollectionView.reloadData()
                                    }
                                }
                                
                                
                            } else {
                                print("error converting data")
                                return
                                
                            }
                            
                            
                        }
                    }
                }
            }
    }
    
    private func writeData(userNewText: String) {
        
        db.collection("Messages").addDocument(data: [
            "messageId" : UUID().uuidString,
            "messageSentDate" : "\(Date())",
            "messageBody" : userNewText,
            "messagesBetween" : [user , barTitle].sorted(),
            "senderId" : user,
            "displayName" : user,
            "kind" : "text"
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Successfully saved data.")
                DispatchQueue.main.async {
                    self.messageInputBar.inputTextView.text = ""
                }
            }
        }
    }
    
    func stringToDate(_ string: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale    = .current
        
        if formatter.date(from: string) != nil {
            return formatter.date(from: string)!
        }else{
            return Date()
        }
    }
}

extension DMScreen: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate{
    
    func currentSender() -> SenderType {
        return SenderMKit(senderId: user, displayName: user)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.black: UIColor.systemGray4
    }
    
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let date = message.sentDate
        
        print(date)
        return NSAttributedString(
            string: formateDate(date),
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 50
    }
    
    func formateDate(_ date: Date) -> String {
        
        let formatter           = DateFormatter()
        formatter.timeZone      = .current
        formatter.locale        = .current
        formatter.dateFormat    = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
    }
    
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {return}
        let tappedMessage = messages[indexPath.section]
        
        
        switch tappedMessage.kind {
        case .location(let location):
            let userCoordinates = location.location.coordinate
            
            let regionDistance:CLLocationDistance = 200
            let regionSpan = MKCoordinateRegion(center: userCoordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: userCoordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Drive Safely"
            mapItem.openInMaps(launchOptions: options)
            
        default:
            break
        }
    }
    
    
}

extension DMScreen: InputBarAccessoryViewDelegate  {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if !text.isEmpty {
            writeData(userNewText: text)
            messageInputBar.inputTextView.resignFirstResponder()
        }
    }
    
    
}


extension DMScreen: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        print("this is the location \(location.coordinate.latitude), long \(location.coordinate.longitude)")
        saveLocationMessage(location: location)
        locationManager.stopUpdatingLocation()
    }
    
    
    
    private func saveLocationMessage(location: CLLocation) {
        //may have to add kind to a message then if else in read based on it.
        db.collection("Messages").addDocument(data: [
            "messageId" : UUID().uuidString,
            "messageSentDate" : "\(Date())",
            "messageBody" : "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "messagesBetween" : [user , barTitle].sorted(),
            "senderId" : user,
            "displayName" : user,
            "kind" : "location"
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Successfully saved data.")
            }
        }
    }
}



