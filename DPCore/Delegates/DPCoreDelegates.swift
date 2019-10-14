//
//  DPCoreDelegates.swift
//  DPCore
//
//  Created by Amirhesam Rayatnia on 2018-10-28.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

final private class DPCoreDelegate {
    static fileprivate var shared: DPCoreDelegate!
    
    fileprivate final let deviceIsJailBorken: Bool
    
    private final let willResignActiveObserver: NSObjectProtocol
    private final let didEnterBackgroundObserver: NSObjectProtocol
    private final let willTerminateObserver: NSObjectProtocol
    private final let willEnterForegroundObserver: NSObjectProtocol
    private final let didBecomeActiveObserver: NSObjectProtocol
    private final let didReceiveMemoryWarning: NSObjectProtocol
    
    init() {
        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        deviceIsJailBorken = DPCoreDelegate.checkForSomethingSpecial()
        
        willResignActiveObserver = center.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: mainQueue) { _ in
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        }
        
        didEnterBackgroundObserver = center.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: mainQueue) { _ in
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
        willTerminateObserver = center.addObserver(forName: .UIApplicationWillTerminate, object: nil, queue: mainQueue) { _ in
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        }
        
        willEnterForegroundObserver = center.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: mainQueue) { _ in
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }
        
        didBecomeActiveObserver = center.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: mainQueue) { _ in
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
        didReceiveMemoryWarning = center.addObserver(forName: .UIApplicationDidReceiveMemoryWarning, object: nil, queue: mainQueue) { _ in
            // Called when the application received memory warning. It is strongly recommended that you implement this method. If your app does not release enough memory during low-memory conditions, the system may terminate it outright.
        }
    }
    
    deinit {
        let center = NotificationCenter.default
        center.removeObserver(willResignActiveObserver)
        center.removeObserver(didEnterBackgroundObserver)
        center.removeObserver(willTerminateObserver)
        center.removeObserver(willEnterForegroundObserver)
        center.removeObserver(didBecomeActiveObserver)
        center.removeObserver(didReceiveMemoryWarning)
    }
    
    fileprivate static func checkForSomethingSpecial() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        if Bundle.main.infoDictionary?["SignerIdentity"] != nil {
            return true
        }
        
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath: "/etc/apt")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt") {
            
            return true
        }
        
        let stringToWrite = "something weird has been appeared"
        do {
            try stringToWrite.write(toFile: "/private/JailbreakTest.txt", atomically: true, encoding: String.Encoding.utf8)
            return true
        }
        catch { }
        return false
        #endif
    }
}

internal func printDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        print(items, separator: separator, terminator: terminator)
    #endif
}
