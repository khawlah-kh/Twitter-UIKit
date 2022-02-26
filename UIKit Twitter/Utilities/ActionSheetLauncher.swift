//
//  ActionSheetLauncher.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 26/02/2022.
//

import UIKit


class ActionSheetLauncher :NSObject{
    
    //MARK: - Properties
    let user : User
    let tableView = UITableView()
    var window : UIWindow?
    
    lazy var blackView : UIView = {
        
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelDismissal))
        view.addGestureRecognizer(tap)
        return view
        
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = UIColor.systemGroupedBackground
        button.addTarget(self, action: #selector(handelDismissal), for: .touchUpInside)
        

        
        return button
        
    }()
    
    
    lazy var footerView : UIView = {
        
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor( left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        return view
        
        
        
    }()
    
    //MARK: - Lifecycle
    init (user : User){

        self.user = user
        super.init()
        configreTableView()

    }
    
    //MARK: - Selectors
    
    @objc func handelDismissal(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
    
    
    
    //MARK: - Helpers
    func show(){
                
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat( 3 * 60 ) + 50
        tableView.frame = CGRect(x: 0, y: window.frame.height , width: window.frame.width, height:height)
        
        UIView.animate(withDuration: 0.5) {
            
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= height
        }
        
    }
    
    
    func configreTableView(){
        
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: actionSheetCellId)
        
    }

}

//MARK: - UITableViewDelegate
extension ActionSheetLauncher : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
}

//MARK: - UITableViewDataSource
extension ActionSheetLauncher : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: actionSheetCellId, for: indexPath) as! ActionSheetCell
        
        return cell
    }
    
    
    
    
}
