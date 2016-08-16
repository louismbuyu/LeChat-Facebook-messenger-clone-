//
//  ViewController.swift
//  LeChat
//
//  Created by Louis Nelson Levoride on 25/07/16.
//  Copyright © 2016 LouisNelson. All rights reserved.
//

import UIKit



class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellId = "cellId"
    
    var messages: [Message]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tabBarController?.tabBar.hidden = false
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count{
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! MessageCell
        
        if let message = messages?[indexPath.row]{
            cell.message = message
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(view.frame.width, 80)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.friend = messages?[indexPath.row].friend
        navigationController?.pushViewController(controller, animated: true)
        
    }

   
}

class MessageCell: BaseCell {
    
    override var highlighted: Bool {
        didSet{
            /*when a cell is selected, the background will be highlighted blue*/
            backgroundColor = highlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.whiteColor()
            nameLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
            messageLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
            timeLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
            
        }
    }
    
    var message: Message?{
        
        /*initializes the cell with a Message object*/
        didSet {
            nameLabel.text = message?.friend?.name
            
            if let profileImageName = message?.friend?.profileImageName{
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImage.image = UIImage(named: profileImageName)
            }
            
            messageLabel.text = message?.text
            
            if let date = message?.date{
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSeconds = NSDate().timeIntervalSinceDate(date)
                
                let secondInDays: NSTimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondInDays {
                    dateFormatter.dateFormat = "MM/dd/yy"
                } else if elapsedTimeInSeconds > secondInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.stringFromDate(date)
            }
            
        }
    }
    
    /*creating all the ui's programmatically*/
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friends message something else..."
        label.font = UIFont.systemFontOfSize(18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friends message and something else..."
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Right
        return label
    }()
    
    let hasReadImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupView() {
        
        addSubview(profileImageView)
        addSubview(dividerLine)
        
        setupContainerView()
        
        profileImageView.image = UIImage(named: "mark")
        hasReadImage.image = UIImage(named: "mark")
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat("H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat("V:[v0(68)]", views: profileImageView)
        
        addConstraintsWithFormat("H:|-82-[v0]|", views: dividerLine)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLine)
        
    }
    
    private func setupContainerView(){
        
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat("H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat("V:[v0(50)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImage)
        
        containerView.addConstraintsWithFormat("H:|[v0][v1(80)]-12-|", views: nameLabel,timeLabel)
        containerView.addConstraintsWithFormat("V:|[v0][v1(24)]|", views: nameLabel,messageLabel)
        containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(20)]-12-|", views: messageLabel,hasReadImage)
        containerView.addConstraintsWithFormat("V:|[v0(24)]", views: timeLabel)
        containerView.addConstraintsWithFormat("V:[v0(20)]|", views: hasReadImage)
    }
    
}

extension UIView{
    
    /*custome function to create constraints easier*/
    
    func addConstraintsWithFormat(format:String, views: UIView...){
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerate(){
            
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


class BaseCell: UICollectionViewCell
{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("intit coder something went wrong")
    }
    
    func setupView(){
        /*setup up the cell*/
    }
}
