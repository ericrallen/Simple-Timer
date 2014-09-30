//
//  AppDelegate.swift
//  Simple Timer
//
//  Created by Eric Allen on 9/29/14.
//  Copyright (c) 2014 InternetAlche.Me. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //variables for setting up our menu
    var statusBar = NSStatusBar.systemStatusBar();
    var statusBarItem : NSStatusItem = NSStatusItem();
    var menu: NSMenu = NSMenu();

    //array of items for our menus and the functions they should trigger when clicked
    var menuItems = [
        (name : "Start Timer", act : Selector("toggleTimer")),
        (name : "Reset Timer", act : Selector("resetTimer"))
    ];
    
    //timer
    var timer = NSTimer();

    //start without any seconds recorded
    var totalSeconds = 0;
    
    //boolean flags for paused or running status
    var timerRunning : Bool = false;
    var timerPaused : Bool = false;

    //this adds our menu to the menu bar
    //borrowed from:  http://www.johnmullins.co/blog/2014/08/08/menubar-app/
    override func awakeFromNib() {
        //Add statusBarItem
        statusBarItem = statusBar.statusItemWithLength(-1);
        statusBarItem.menu = menu;
        statusBarItem.title = "[00:00:00]";

        //iterate through menu items and add them to the status bar menu
        for item in menuItems {
            var menuItem : NSMenuItem = NSMenuItem();

            //Add menuItem to menu
            menuItem.title = "\(item.name)";
            menuItem.action = item.act;
            menuItem.keyEquivalent = "";
            menu.addItem(menuItem);
        }
    }
    
    //check to see what status our timer has
    //0 = not running or paused; 1 = running; 2 = paused
    func checkStatus() -> Int {
        var status = 0;
        
        if(timerRunning) {
            status = 1;
        } else if(timerPaused) {
            status = 2;
        }
        
        return status;
    }
    
    //start/stop the timer
    func toggleTimer() {
        let sel : Selector = "updateTime";

        //get status
        var status = checkStatus();
        
        //get first menu item so we can change the text based on status
        var menuItem = menu.itemAtIndex(0);
        
        //if we are not running
        if(status == 0 || status == 2) {
            //switch flags
            timerRunning = true;
            timerPaused = false;
            
            //change menu item to say Pause
            menuItem.title = "Pause Timer";
            
            //start timer
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: sel, userInfo: nil, repeats: true);
        //if we are running
        } else {
            //change menu item to say Resume
            menuItem.title = "Resume Timer";

            //pause the timer
            stopTimer();
        }
        
    }
    
    //pause the timer
    func stopTimer() {
        timer.invalidate();

        //switch flags
        timerRunning = false;
        timerPaused = true;
    }
    
    //increase timer
    func updateTime() {
        totalSeconds++;

        //get # of seconds, minutes, and hours
        //borrowed from:  http://iphonedev.tv/blog/2013/7/7/getting-started-part-3-adding-a-stopwatch-with-nstimer-and-our-first-class
        var seconds : Int = totalSeconds % 60;
        var minutes : Int = (totalSeconds / 60) % 60;
        var hours : Int = totalSeconds / 3600;
        
        
        //concatenate minuets, seconds and milliseconds
        statusBarItem.title = buildStr(hours : hours, minutes : minutes, seconds : seconds);
    }
    
    //add leading zeros and concatenate values into a string
    func buildStr(#hours : Int, #minutes : Int, #seconds : Int) -> String {
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        //borrowed from:  http://rshankar.com/simple-stopwatch-app-in-swift/
        let strHours = hours > 9 ? String(hours):"0" + String(hours);
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes);
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds);
        
        //build string with surrounding brackets and colons between values
        var timeStr = "[\(strHours):\(strMinutes):\(strSeconds)]";
        
        //return the time string
        return timeStr;
    }

    //reset timer
    func resetTimer() {
        timer.invalidate();
        
        statusBarItem.title = "[00:00:00]";
        
        //if the timer is already running, we want to reset it and start it
        if(timerRunning) {
            timerRunning = false;
            totalSeconds = 0;
            toggleTimer();
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
}