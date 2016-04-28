//
//  TimeLineViewController.swift
//  Wisdom Bird
//
//  Created by guitarrkurt on 27/04/16.
//  Copyright © 2016 guitarrkurt. All rights reserved.
//

import UIKit
import TwitterKit

class TimeLineViewController: TWTRTimelineViewController {
    
//MARK: - Propertys
    let client = TWTRAPIClient()
    var user = "guitarrkurt"
    var wordOrHashTag = "buap"
//MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTweet(wordOrHashTag)
    }
    override func viewWillAppear(animated: Bool) {
        TWTRTweetView.appearance().backgroundColor = UIColor(colorLiteralRed: 78.0/255.0, green: 106.0/255.0, blue: 120.0/255, alpha: 1.0)
    }
    func timeLineOfUser(user: String){
        self.dataSource = TWTRUserTimelineDataSource(screenName: user, APIClient: client)
    }
    
    func searchTweet(wordOrHashTag: String){
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: wordOrHashTag, APIClient: client)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
