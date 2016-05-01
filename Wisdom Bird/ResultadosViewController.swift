//
//  ResultadosViewController.swift
//  Wisdom Bird
//
//  Created by guitarrkurt on 27/04/16.
//  Copyright © 2016 guitarrkurt. All rights reserved.
//

import UIKit
import TwitterKit

class ResultadosViewController: UIViewController {
    
//MARK: - Propertys
    let client = TWTRAPIClient()
    var palabraOpinionSocial = String()
    var conclusionPositiva: String!
    var conclusionNegativa: String!
    var bandera = true
//MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var manitaResultado: UIImageView!
    @IBOutlet weak var progressVerde: UIProgressView!
    @IBOutlet weak var progressRosa: UIProgressView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
//MARK: - Arrays
    var arrayTweets = [String]()
//MARK: - Constructor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        conclusionPositiva = "La busqueda para la palabra: \"\(palabraOpinionSocial)\" tiene un impacto POSITIVO en la opinión social."
        conclusionNegativa = "La busqueda para la palabra: \"\(palabraOpinionSocial)\" tiene un impacto NEGATIVO para la opinión social."
        
        if naiveBayes(){
            bandera = true
            cargaPositiva()
        } else {
            bandera = false
            cargaNegativa()
        }
        
        
//        textFromFile = readFileFromBundle("diana", typeFile: "txt")
//        if textFromFile != ""{
//            print(textFromFile)
//        } else {
//            print("error al leer textFromFile")
//        }
        
        
//        arrayCorpus = textFromFile.componentsSeparatedByString("\n")
//        print("arrayCorpus: \(arrayCorpus)")
//        
//        
//        
//        for var i = 0; i < arrayCorpus.count-10; ++i{
//            
//            let index = arrayCorpus[i]
//            let palabra = index.componentsSeparatedByString(" ")
//            print("richi: \(palabra)")
//            
//            
//            
//            let pala = palabra[1] as! String
//            print(pala)
//            let key = "\(palabra[0]) - \(palabra[2])"
//            print(key)
//            
//            if (index as! String) != ""{
//                mutableDictionary.setValue(pala, forKey: key)
//            }
//        }
//
//        print("jose: \(mutableDictionary)")
        
        
    }
    override func viewWillAppear(animated: Bool) {
        if bandera {
            cargaPositiva()
        } else {
            cargaNegativa()
        }
    }
    override func viewDidAppear(animated: Bool) {
        //#Color Navigation Bar
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        //#Logo Title
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        //        imageView.contentMode = .ScaleAspectFit
        //        let image = UIImage(named: "larry2")
        //        imageView.image = image
        //        navigationItem.titleView = imageView
        
        //#Button Right
        let button = UIButton(type: UIButtonType.Custom) as UIButton!
        button?.setImage(UIImage(named: "timeLine"), forState: UIControlState.Normal)
        button?.addTarget(self, action:#selector(ResultadosViewController.timeLineAction), forControlEvents: UIControlEvents.TouchUpInside)
        button?.frame=CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button!)
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    func timeLineAction(sender: UIBarButtonItem){
        let internet = Internet()
        let alert = SCLAlertView()
        
        if internet.InternetHere()
        {
            performSegueWithIdentifier("ResultadosTimeIdentifier", sender: self)
        
        }else{
            alert.showError("Error Conexión", subTitle: "Esta aplicación hace uso de internet.\nPor favor activa tus datos o verifica tu conexión Wi-Fi.\nGracias.")
        }
        
    }
    func rotateManitaResultado(estado: String){
        if estado == "positivo"{
            self.manitaResultado.image = UIImage(named: "manitaArriba")
        }
        if estado == "negativo"{
            self.manitaResultado.image = UIImage(named: "manitaAbajo")
        }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = M_PI*2
        animation.duration = 2.3
        animation.repeatCount = HUGE
        self.manitaResultado.layer.addAnimation(animation, forKey: "rotateAnimation")
    }
//MARK: Carga Positiva
    func cargaPositiva(){
        self.label.text = conclusionPositiva
        rotateManitaResultado("positivo")
        
        
    }
//MARK: - Carga Negativa
    func cargaNegativa(){
        self.label.text = conclusionNegativa
        rotateManitaResultado("negativo")
        
        
    }
//MARK: - Naive Bayes
    func naiveBayes() -> Bool{
        activity.startAnimating()
        getTweets(palabraOpinionSocial, numeroTweets: 100)
        activity.stopAnimating()
        
        return true
    }
    
    func getTweets(query: String, numeroTweets: Int){
        let resourceURL = "https://api.twitter.com/1.1/search/tweets.json"
        let parametros = ["q": query,
                          "result_type": "mixed",
                          "lang": "es",
                          "count" : "\(numeroTweets)"]
        
        requestGET(parametros, resourceURL: resourceURL)
    }
    
    func requestGET(parametros: [NSObject: AnyObject], resourceURL: String){
        //        activity.startAnimating()
        var clientError : NSError?
        //var json: NSArray!
        
        let request: NSURLRequest! = client.URLRequestWithMethod("GET", URL: resourceURL, parameters: parametros, error: &clientError)
        
        self.client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            do {
                //# ⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏌⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏌⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏌⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏌
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                //print("json: \(json)")
                let array = json?.objectForKey("statuses") as! NSArray
                
                for index in 0..<array.count {
                    let tweet = array[index] as! NSDictionary
                    let text = tweet.objectForKey("text") as! String
                    print("\(index) - \(text)")
                    self.arrayTweets.append(text)
                }
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
            
        }
        

    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResultadosTimeIdentifier"{
            let vc = segue.destinationViewController as! TimeLineViewController
                vc.wordOrHashTag = palabraOpinionSocial
        }
    }

}
