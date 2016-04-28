//
//  ResultadosViewController.swift
//  Wisdom Bird
//
//  Created by guitarrkurt on 27/04/16.
//  Copyright © 2016 guitarrkurt. All rights reserved.
//

import UIKit

class ResultadosViewController: UIViewController {
//MARK: - Propertys
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
//MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()

        conclusionPositiva = "La busqueda para la palabra: \(palabraOpinionSocial) tiene un impacto POSITIVO en la opinión social."
        conclusionNegativa = "La busqueda para la palabra: \(palabraOpinionSocial) tiene un impacto NEGATIVO para la opinión social."
        
        if naiveBayes(){
            bandera = true
            cargaPositiva()
        } else {
            bandera = false
            cargaNegativa()
        }
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
        for i in 0 ..< 20000{
            print(i)
        }
        activity.stopAnimating()
        
        return true
    }
    
    
    
    
    
    
    
    
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResultadosTimeIdentifier"{
            let vc = segue.destinationViewController as! TimeLineViewController
                vc.wordOrHashTag = palabraOpinionSocial
        }
    }
 

}
