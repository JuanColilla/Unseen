//
//  BeaconsViewController.swift
//  Beacon Test
//
//  Created by Juan Colilla on 11/12/2019.
//  Copyright © 2019 Juan Colilla. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

/**
 Este controlador se encarga de la vista correspondiente a la disposición de los beacons o balizas bluetooth detectados en pantalla. En este controlador se interactua directamente tanto con **"BeaconManager.swift"** como con **"SpeechManager.swift"**. El controlador a su vez actúa como "delegate" del modelo **"BeaconManaer"**.
 */

class BeaconsViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let beaconManager = BeaconManager()
    let speechManager = SpeechManager()
    
    /// Array de **CLBeacon** que contiene TODOS los beacons detectados, ordenados en base a su proximidad.
    var beaconsInRange = [CLBeacon]()
    
    /// Esta variable sirve como validación para comprobar si el usuario permanece dentro o no de una zona monitorizada (al alcance de un beacon). Su valor es **false** por defecto.
    var inside: Bool = false
    
    /// Vista que contiene la imagen del dispositivo, ubicada en el centro de la pantalla.
    @IBOutlet weak var deviceImage: UIImageView!
    /// Array de vistas destinadas a contener una imagen que represente de forma visual la intensidad de señal de los beacons detectados.
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var valuesDisplay: [UITextField]!
    
    
    //@IBOutlet weak var beaconImageViews: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        beaconManager.setDelegate(delegate: self)
        beaconManager.checkUserPermissions()
        beaconManager.setRegion()
        beaconManager.scanForBeacons()
        
        
        //imageViews.forEach { $0.image = UIImage(named: "Beacon_OFF") } //-> Establece todas las imágenes en BEACON_OFF cuando la primera vista se carga.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        beaconManager.checkUserPermissions()
    }

    // Escanea continuamente beacons próximos y proporciona un array con estos.
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        // Filtramos los beacons cuya intensidad de señal sea tan débil que no nos sirvan de nada.
        beaconsInRange = beaconManager.filterUnknownBeacons(beacons: beacons)
        
        if beaconsInRange.count == 0  {
            sendNotification(mode: "exit", region: beaconManager.region)
        } else {
            sendNotification(mode: "entry", region: beaconManager.region)
        }
        // Pasamos a organizar los beacons que nos sirven en la pantalla.
        imageViews.forEach { $0.image = UIImage(named: "Beacon_OFF") }
        valuesDisplay.forEach { $0.text = "0" }
        for ((beacon, imageView), display) in zip(zip(beaconsInRange, imageViews), valuesDisplay) {
            orderAndDisplayBeaconsOnScreen(beacon: beacon, imageView: imageView, display: display)
            // Por decidir, actualmente se muestra la distancia en metros encima de cada imagen/beacon.
        }
            
    }
    
    // Se necesita una función que compruebe la ubicación del usuario y en base a cambios en esta hable y diga si se ha entrado o salido de la zona que se quiere monitorizar (punto de interés). Podría ser posible hacer esto sin necesidad de la ubicación? Basándose en la disponibilidad de un beacon?
    
    // Detecta la entrada en una región monitorizada. -> Estos dos métodos no funcionan en base a un perímetro viertual bluetooth, sino en base a un perímetro geodelimitado (GPS).
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        sendNotification(mode: "entry", region: region)
    }
    
    // Detecta la salida de una región monitorizada.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        sendNotification(mode: "exit", region: region)
    }
    
    // Clasifica los beacons detectados y los distribuye en la pantalla asignandoles una imagen en base a su intensidad de señal.
    func orderAndDisplayBeaconsOnScreen(beacon: CLBeacon, imageView: UIImageView, display: UITextField) {
        switch beacon.accuracy {
        case 0...1.5:
            imageView.image = UIImage(named: "Max_Signal_Beacon")
            break;
        case 1.5...10:
            imageView.image = UIImage(named: "Reg_Signal_Beacon")
            break;
        case 10...100:
            imageView.image = UIImage(named: "Min_Signal_Beacon")
            break;
        case nil:
            imageView.image = nil
            break;
        default:
            imageView.image = nil
            break;
        }
        display.text = String(beacon.rssi)
        
    }
    
    func sendNotification(mode: String, region: CLRegion) {
        let content = UNMutableNotificationContent()
        let notificationTrigger = UNLocationNotificationTrigger(region: region, repeats: true)
       
        if (mode == "entry") {
            content.title = "Entrada en rango."
            content.body = "Se ha detectado la entrada en una región monitorizada."
        } else {
            content.title = "Fuera de rango."
            content.body = "Se ha abandonado el rango de la región monitorizada."
        }
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "Region Beacon", content: content, trigger: notificationTrigger)
        
        UNUserNotificationCenter
            .current()
            .add(request) { (error) in
            
            if (error != nil) {
                print("Error = \(error?.localizedDescription ?? "Error no especificado (JC).")")
            }
        }
        speakToTheUser(whatToSpeak: mode)
    }
    
    func speakToTheUser(whatToSpeak: String) {

        var messageToTheUser: String = ""
        var validation = false
        
        switch whatToSpeak {
        case "entry":
            messageToTheUser = "Detected the entrance on a monitored perimeter."
            if (!inside) {
                validation = true
            }
            inside = true
        case "exit":
            messageToTheUser = "You have gone the monitored perimeter."
            if (inside) {
                validation = true
            }
            inside = false
        default:
            print("Yep, nothing received.")
        }
        if validation {speechManager.speak(textToSpeak: messageToTheUser)}
    }

}

