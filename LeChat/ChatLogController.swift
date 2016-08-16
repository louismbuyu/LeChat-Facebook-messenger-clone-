//
//  ChatLogController.swift
//  LeChat
//
//  Created by Louis Nelson Levoride on 28/07/16.
//  Copyright © 2016 LouisNelson. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var messages: [Message]?
    var bottomConstraint: NSLayoutConstraint?
    
    var friend: Friend?
    {
        didSet
        {
            navigationItem.title = friend?.name
            messages = friend?.message?.allObjects as? [Message]
            messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedAscending})
        }
    }
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Send", forState: .Normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(ChatLogController.handleSend), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    @objc private func handleSend()
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let message = FriendsController.createMessageText(inputTextField.text!, friend: friend!, mintuesAgo: 0, context: context, isSender: true)
        messages?.append(message)

        let item = (messages?.count)! - 1
        let insertionIndex = NSIndexPath(forItem: item, inSection: 0)
        
        collectionView?.insertItemsAtIndexPaths([insertionIndex])
        collectionView?.scrollToItemAtIndexPath(insertionIndex, atScrollPosition: .Bottom, animated: true)
        inputTextField.text = nil
        
        do
        {
            try context.save()
        } catch let err {
            print(err)
        }
    }
    
    /*this function is to simulate the scenario when a user receives a message while offline, the message is then placed in the right order */
    func simulate()
    {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let message = FriendsController.createMessageText("here is a testing text message just to see where it fits in, 5 minutes ago...", friend: friend!, mintuesAgo: 1, context: context)
        
        do {
            try context.save()
            messages?.append(message)
            messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedAscending})
            
            if let item = messages?.indexOf(message)
            {
                let receivingIndexPath = NSIndexPath(forItem: item, inSection: 0)
                collectionView?.insertItemsAtIndexPaths([receivingIndexPath])
            }
        }catch let err {
            ShowAlert(controller: self).show("Something went wrong, please try again later", title: "Oops")
            print("\(err)")
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .Plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.hidden = true
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat("H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat("V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /*handle when the keyboard appears and the collectionview should adjust accordingly*/
    func handleKeyboardNotification(notificion: NSNotification) {
        
        if let userInfo = notificion.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            print(keyboardFrame)
            
            let isKeyboardshowing = notificion.name == UIKeyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardshowing ? -keyboardFrame!.height : 0
            
            UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    
                    if isKeyboardshowing{
                        let indexPath = NSIndexPath(forItem: self.messages!.count - 1, inSection: 0)
                        self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                    }
                    
            })
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        inputTextField.endEditing(true)
    }
    
    /*setups up and adds constraints to ui views*/
    private func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintsWithFormat("H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraintsWithFormat("H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0(0.5)]", views: topBorderView)
        
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.row].text
        
        if let message = messages?[indexPath.item], messageText = message.text, profileImageName = message.friend?.profileImageName
        {
            cell.profileImageView.image = UIImage(named: profileImageName)
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil)
            
            /*check if you are the sender and then adjust the message to the left or to the right*/
            if let message_bool = message.isSender
            {
                if message_bool.boolValue == true
                {
                    cell.messageTextView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 16 - 16,0, estimatedFrame.width + 16, estimatedFrame.height + 20)
                    cell.textBubbleView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 16 - 8 - 16,0, estimatedFrame.width + 16 + 8, estimatedFrame.height + 20)
                    cell.profileImageView.hidden = true
                    cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                    cell.messageTextView.textColor = UIColor.whiteColor()
                    
                }else{
                    
                    cell.messageTextView.frame = CGRectMake(48 + 8,0, estimatedFrame.width + 16, estimatedFrame.height + 20)
                    cell.textBubbleView.frame = CGRectMake(48,0, estimatedFrame.width + 16 + 8, estimatedFrame.height + 20)
                    cell.profileImageView.hidden = false
                    cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                    cell.messageTextView.textColor = UIColor.blackColor()
                }
            }
        }
        return cell
    }
    
    /*Adjust the cell size to the text*/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text{
            
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil)
            
            return CGSizeMake(view.frame.width, estimatedFrame.height + 20)
        }
        return CGSizeMake(view.frame.width, 100)
    }
    
    /*appropriate spacing at the top of the collectionView*/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
}

/*setup up the chat bubbles for each cell*/
class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clearColor()
        return textView
    }()
    
    let textBubbleView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintsWithFormat("H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat("V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = UIColor.redColor()
        
    }
}
