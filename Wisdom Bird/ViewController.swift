//
//  ViewController.swift
//  Wisdom Bird
//
//  Created by guitarrkurt on 27/04/16.
//  Copyright © 2016 guitarrkurt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, pickReturnTextSearchBarProtocol {

//MARK: - Outlets
    @IBOutlet weak var solidImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
//MARK: - Protocol
    var esclavo: pickReturnTextSearchBarProtocol? = nil
//MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotateSolidImage()
    }
//MARK: - #viewWill or Did
    override func viewWillAppear(animated: Bool) {
        rotateSolidImage()
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
        button?.setImage(UIImage(named: "trendingTopic"), forState: UIControlState.Normal)
        button?.addTarget(self, action:#selector(ViewController.trendingTopicAction), forControlEvents: UIControlEvents.TouchUpInside)
        button?.frame=CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button!)
        self.navigationItem.rightBarButtonItem = barButton

    }

    func trendingTopicAction(sender: UIBarButtonItem){
        let internet = Internet()
        let alert = SCLAlertView()
        
        if internet.InternetHere()
        {
            performSegueWithIdentifier("MainTrendingIdentifier", sender: self)
        
        }else{
            alert.showError("Error Conexión", subTitle: "Esta aplicación hace uso de internet.\nPor favor activa tus datos o verifica tu conexión Wi-Fi.\nGracias.")
        }

    }
    
    func rotateSolidImage(){
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = M_PI*2
        animation.duration = 2.3
        animation.repeatCount = HUGE
        self.solidImage.layer.addAnimation(animation, forKey: "rotateAnimation")
    }
    //MARK: Shake
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        let internet = Internet()
        let alert = SCLAlertView()
        if motion == .MotionShake {
            print("Agito...")

            
            if internet.InternetHere()
            {
                if self.searchBar.text != ""{
                    performSegueWithIdentifier("MainResultadosIdentifier", sender: self)
                }else{
                    alert.showError("Error Busqueda", subTitle: "Por favor ingresa una PALABRA\n o #HASHTAG para obtener la opinión social.\nPuedes consultar las sugerencias de Trending Topic en el boton superior derecho.")
                }
            }else{
                alert.showError("Error Conexión", subTitle: "Esta aplicación hace uso de internet.\nPor favor activa tus datos o verifica tu conexión Wi-Fi.\nGracias.")
            }
            
        }
    }

    //MARK: - Protocol
    func tableViewSearchBar(text: String){
        self.searchBar.text = text
    }
    //MARK: - Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MainTrendingIdentifier"{
            let vc = segue.destinationViewController as! TrendingTopicViewController
                vc.esclavo = self
        }
        if segue.identifier == "MainResultadosIdentifier"{
            let vc = segue.destinationViewController as! ResultadosViewController
                vc.palabraOpinionSocial = self.searchBar.text!
        }
     }
}

