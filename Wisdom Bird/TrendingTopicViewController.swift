//
//  TrendingTopicViewController.swift
//  Wisdom Bird
//
//  Created by guitarrkurt on 27/04/16.
//  Copyright © 2016 guitarrkurt. All rights reserved.
//

import UIKit
import TwitterKit

protocol pickReturnTextSearchBarProtocol{
    func tableViewSearchBar(text: String)
}
extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}
class TrendingTopicViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate {
    
//MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var activity: UIActivityIndicatorView!
//MARK: - Propertys
    let client = TWTRAPIClient()
//    var arrayDataSource = [String]()
    
    var arrayDataSource = [String]()
    
//MARK: - Protocols
    var esclavo: pickReturnTextSearchBarProtocol? = nil

//MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        trendingTopicCiudadPuebla()
    }
//MARK: - Apariencia
    override func viewWillAppear(animated: Bool) {

    }
//MARK: - Data Source - Table View
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayDataSource.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell!
        cell.textLabel?.text = arrayDataSource[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 54.0/255.0, green: 72.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        cell.backgroundColor = UIColor(red: 196.0/255.0, green: 207.0/255.0, blue: 212.0/255, alpha: 1.0)
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor(red: 20.0/255.0, green: 150.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = colorView
        
        return cell
    }
//MARK: - Delegate - Table View
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        regresarTextoSeleccionado(arrayDataSource[indexPath.row])
    }
    func regresarTextoSeleccionado(texto: String){
        if esclavo != nil{
            esclavo!.tableViewSearchBar(texto)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("ERROR el eclavo (protocolo) es nulo")
        }
    }
//MARK: - Trending Topic Geo

    func trendigTopicCercanos(latitud: String, longitud: String, query: String){
        //#Ciudad de Puebla
        let resourceURL = "https://api.twitter.com/1.1/trends/closest.json"
        let parametros = ["q": query,
                    "lat": "16.65",
                   "long": "-91.8658"]
        
        requestGET(parametros, resourceURL: resourceURL)
    }
    
    func trendingTopicTodoMexico(){
        //# -  Todo Mexico
        let resourceURL = "https://api.twitter.com/1.1/trends/place.json"
        let parametros = ["id":"23424900", "exclude":"#"]
        
        requestGET(parametros, resourceURL: resourceURL)
    }
    
    func trendingTopicDF(){
        //# - DF
        let resourceURL = "https://api.twitter.com/1.1/trends/place.json"
        let parametros = ["id":"116545"]

        requestGET(parametros, resourceURL: resourceURL)
    }
    
    func trendingTopicCiudadPuebla(){
        //# - Ciudad de Puebla
        let resourceURL = "https://api.twitter.com/1.1/trends/place.json"
        let parametros = ["id":"137612"]
        
        requestGET(parametros, resourceURL: resourceURL)
    }
    
    func requestGET(parametros: [NSObject: AnyObject], resourceURL: String){
        activity.startAnimating()
        var clientError : NSError?
        var json: NSArray!
        
        let request: NSURLRequest! = client.URLRequestWithMethod("GET", URL: resourceURL, parameters: parametros, error: &clientError)
        
        self.client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            do {
                //# 😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃😃
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray
                print("json: \(json)")
                let trendings = json[0] as! [String: AnyObject]
                let tweets = trendings["trends"] as! NSArray
                
                for item in tweets{
                    let obj = item as! NSDictionary
                    var query = obj["query"] as! String
                    
                    print(query)
                    query = query.replace("%23", withString:"#")
                    self.arrayDataSource.append(query)

                }
                
                self.activity.stopAnimating()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    
                }
                
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
            
        }

    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    
    // ---- UIViewControllerTransitioningDelegate methods
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return CustomPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return CustomPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return CustomPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }
    
    @IBAction func Cerrar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
