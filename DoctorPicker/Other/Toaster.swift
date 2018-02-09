//
//  Toaster.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 09.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

// Author - Nikita Ignatenko
// Simple convinience "Show message" tool

class Toaster {
    
    // MARK: - Properties
    
    //var font: UIFont = UIFont(name: "", size: 12)!
    fileprivate var timer: Timer?
    fileprivate var executionBlock: (() -> ())?
    fileprivate var messageQueue = [String]()
    
    
    // MARK: - Init
    
    init() {}
    
    
    // MARK: - Singleton
    
    static var shared = Toaster()
}


// MARK: - Actions

extension Toaster {
    
    /** Will display the text message. Can regulate certain parameters, such as pause duration before activation, text color, background color & a completion block delay. */
    func showMessage(_ message : String,
                     duration: Double,
                     activationPause: Double = 0.0,
                     textColor: UIColor = .black,
                     backgroundColor: UIColor = .white,
                     delayCompletion: Double = 0.0,
                     completion: (() -> ())? = nil) {
        // Message queue
        if doesMessageQueueContainMessage(message) {
            return
        } else {
            addMessageToQueue(message)
        }
        
        // Presenter
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Create label
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.text = message
        label.font = UIFont(name: "", size: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.backgroundColor =  backgroundColor.withAlphaComponent(0.6)
        label.textColor = textColor
        
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: appDelegate.window!.frame.size.width, y: 64, width: appDelegate.window!.frame.size.width, height: 44)
        
        label.alpha = 1
        label.layer.cornerRadius = 10;
        label.clipsToBounds = true
        appDelegate.window?.addSubview(label)
        
        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;
        
        // Animate right after waiting duration has been exceeded
        wait(duration: activationPause,
             execution: { [weak self] in
                // Appear
                self?.animate(duration: duration/2.0, //1.0,
                    delay: 0.0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0.1,
                    options: .curveEaseOut,
                    animations: {
                        label.frame = basketTopFrame
                },
                    completion: {
                        self?.removeMessageFromQueue(message)
                        // Dissapear
                        self?.animate(duration: duration/2.0, //1.0,
                            delay: 0.1, //1.5,
                            usingSpringWithDamping: 0.5,
                            initialSpringVelocity: 0.1,
                            options: .curveEaseIn,
                            animations: {
                                label.alpha = 0
                        },
                            completion: {
                                label.removeFromSuperview()
                                // Completion
                                self?.wait(duration: delayCompletion, execution: { completion?() })
                        })
                })
        })
    }
}


// MARK: - Actions (convenience)

extension Toaster {
    
    func showPositiveMessage(_ message: String,
                             duration: Double = 2.0,
                             activationPause: Double = 0.0,
                             delayCompletion: Double = 0.0,
                             completion: (() -> ())? = nil) {
        showMessage(message, duration: duration, activationPause: activationPause, textColor: .white, backgroundColor: .green, delayCompletion: delayCompletion, completion: completion)
    }
    
    func showAlertMessage(_ message: String,
                          duration: Double = 2.0,
                          activationPause: Double = 0.0,
                          delayCompletion: Double = 0.0,
                          completion: (() -> ())? = nil) {
        showMessage(message, duration: duration, activationPause: activationPause, textColor: .white, backgroundColor: UIColor.init(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0), delayCompletion: delayCompletion, completion: completion)
    }
    
    func showErrorMessage(_ message: String,
                          duration: Double = 2.0,
                          activationPause: Double = 0.0,
                          delayCompletion: Double = 0.0,
                          completion: (() -> ())? = nil) {
        showMessage(message, duration: duration, activationPause: activationPause, textColor: .white, backgroundColor: .red, delayCompletion: delayCompletion, completion: completion)
    }
}


// MARK: - Message queue

fileprivate extension Toaster {
    
    func doesMessageQueueContainMessage(_ message: String) -> Bool {
        if let index = messageQueue.index(of: message) {
            let mes = messageQueue[index]
            if message.elementsEqual(mes) {
                return true
            }
        }
        return false
    }
    
    func addMessageToQueue(_ message: String) {
        messageQueue.append(message)
    }
    
    func removeMessageFromQueue(_ message: String) {
        if let index = messageQueue.index(of: message) {
            messageQueue.remove(at: index)
        }
    }
}


// MARK: - Animation

fileprivate extension Toaster {
    
    /** 'UIView.animate()' wrapper function. */
    func animate(duration: Double,
                 delay: Double = 0.0,
                 usingSpringWithDamping: CGFloat = 0.0,
                 initialSpringVelocity: CGFloat = 0.0,
                 options: UIViewAnimationOptions = .curveEaseOut,
                 animations: @escaping (() -> ()),
                 completion: @escaping (() -> ())) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: options,
                       animations: { () -> Void in
                        animations()
        },
                       completion: { (value: Bool) in
                        completion()
        })
    }
    
    /** Wait for a specified amount of time. */
    func wait(duration: Double, execution: @escaping () -> ()) {
        guard timer == nil else { return }
        executionBlock = execution
        if duration <= 0.0 {
            executionBlock?()
        } else {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(runExecutionBlock), userInfo: nil, repeats: false)
        }
    }
    
    /** Execution block...executed. */
    @objc func runExecutionBlock() {
        executionBlock?()
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
}
