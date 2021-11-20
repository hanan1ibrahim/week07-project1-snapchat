//
//  ChatScreen.swift
//  Snapchat
//
//  Created by Kholod Sultan on 10/04/1443 AH.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ChatScreen : UIViewController{
    
    var users: [User] = []
    var filterUsers: [User] = []
    let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let search = UISearchController()
    private var currentUserName = ""
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)

        table.register(ChatScreenTableViewCell.self,
                       forCellReuseIdentifier: ChatScreenTableViewCell.cellId)

        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
        navigationItem.title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.backgroundColor = .systemGray6
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        setupSearchBar()
        setupTableView()
        fetchAllUsers()
    }
    
   

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120

    }
    private func setupSearchBar() {
        search.loadViewIfNeeded()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.returnKeyType = .done
        search.searchBar.sizeToFit()
        search.searchBar.placeholder = "Search"
        search.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchBar.delegate = self
    }

    

    
    private func fetchAllUsers() {
       
        db.collection("Profiles")
            .addSnapshotListener { (querySnapshot, error) in
                self.users.removeAll()

                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    
                    
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let userName = data["name"] as? String,
                               let userIsOnline = data["status"] as? String,
                               let userId = data["userID"] as? String,
                               let userEmail = data["email"] as? String
                            {
                                
                                  
                                      guard let currentUser = FirebaseAuth.Auth.auth().currentUser else { return}
                                      if userId != currentUser.uid {
                                          
                                          print("userName: \(userName)")
                                          let newUser = User(id: userId, name: userName, status: userIsOnline, userEmail: userEmail)
                                          self.users.append(newUser)
                                          DispatchQueue.main.async {
                                              self.tableView.reloadData()
                                          }
                                      }else {
                                          self.currentUserName = userName
                                      }
                                    
                               
                                

                            }
                        }
                    }
                }
            }
    }
    
}


extension ChatScreen: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.isActive && !search.searchBar.text!.isEmpty {
            return filterUsers.count
        }else{
            return users.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ChatScreenTableViewCell.cellId, for: indexPath) as! ChatScreenTableViewCell
        
        
        if search.isActive && !search.searchBar.text!.isEmpty {
            cell.backgroundColor = .white
            cell.userNameLabel.text = filterUsers[indexPath.row].name
            cell.userEmail.text     = filterUsers[indexPath.row].userEmail
            cell.circleImage.tintColor = filterUsers[indexPath.row].status == "1" ? UIColor.green : UIColor.gray
            
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .white
            return cell
        }else{
            cell.backgroundColor = .white
            cell.userNameLabel.text = users[indexPath.row].name
            cell.userEmail.text     = users[indexPath.row].userEmail
            cell.circleImage.tintColor  =  users[indexPath.row].status == "1" ? UIColor.green.withAlphaComponent(0.4) : UIColor.gray

            
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .white
            return cell
        }
        
       
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Unhighlights what you have selected
        tableView.deselectRow(at: indexPath, animated: true)

        let dmScreen = DMScreen()
        dmScreen.user = currentUserName
        dmScreen.barTitle = users[indexPath.row].name ?? ""
        dmScreen.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(dmScreen, animated: true)

    }

}



extension ChatScreen: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            return
        }
        
        let searchBar = search.searchBar
        
        if let userEnteredSearchText = searchBar.text {
            findResultsBasedOnSearch(with: userEnteredSearchText)
        }
        
        
    }
    private func findResultsBasedOnSearch(with text: String)  {
        filterUsers.removeAll()
        if !text.isEmpty {
            filterUsers = users.filter{$0.name!.lowercased().contains(text.lowercased()) }
            tableView.reloadData()
        }else{
            tableView.reloadData()
        }
    }
}



