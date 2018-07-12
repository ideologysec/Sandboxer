//
//  SwiftScript.swift
//  LockRattler
//
//  Created by Howard Oakley on 26/12/2016.
//  Copyright © 2016 EHN & DIJ Oakley. All rights reserved.
//

/// A collection of utilities to aid 'scripting' use of Swift on macOS 10.12.x

import Foundation
import Cocoa
import Security

/// Obtains the short version number for a bundle.
///
/// - Parameter path: a String containing the POSIX path to the bundle.
/// - Returns: a String containing the short version number of the bundle.
func getBundleVersion(path: String) -> String {
    let theVerKey = "CFBundleShortVersionString"
    let myBundle = Bundle.init(path: path)
    let myVer = myBundle?.object(forInfoDictionaryKey: theVerKey)
    return myVer as! String
}

/// Runs a shell command with its arguments, capturing standard output.
///
/// *See also* `doShellScriptWithPrivileges` which runs with elevated privileges.
/// - Note: You cannot use `sudo` in this func to elevate privileges.
///
/// - Parameters:
///   - launchPath: a String containing full path to the tool to be run, e.g. `/usr/bin/spctl`
///   - arguments: array of String arguments including command line options.
///
///     Note that each element in that array contains a single command line option.
/// - Returns: 2-element array containing:
///   - if successful, stdout and an empty string,
///   - if unsuccessful, an empty string and an error message.
func doShellScript(launchPath: String, arguments: [String]?) -> [String] {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    let outPipe = Pipe()
    task.standardOutput = outPipe
    task.launch()
    let fileHandle = outPipe.fileHandleForReading
    let data = fileHandle.readDataToEndOfFile()
    task.waitUntilExit()
    let status = task.terminationStatus
    if (status != 0) {
        return ["", "Failed, error = " + String(status)]
    }
    else {
        return [(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String), ""]
    }
}

/// Runs a shell command with its arguments, capturing error output.
///
/// *See also* `doShellScript` which captures standard output.
/// - Note: You cannot use `sudo` in this func to elevate privileges.
///
/// - Parameters:
///   - launchPath: a String containing full path to the tool to be run, e.g. `/usr/bin/spctl`
///   - arguments: array of String arguments including command line options.
///
///     Note that each element in that array contains a single command line option.
/// - Returns: 2-element array containing:
///   - if successful, stderr and an empty string,
///   - if unsuccessful, an empty string and an error message.
func doShellScriptErr(launchPath: String, arguments: [String]?) -> [String] {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    let outPipe = Pipe()
    task.standardError = outPipe
    task.launch()
    let fileHandle = outPipe.fileHandleForReading
    let data = fileHandle.readDataToEndOfFile()
    task.waitUntilExit()
    let status = task.terminationStatus
    if (status != 0) {
        return ["", "Failed, error = " + String(status)]
    }
    else {
        return [(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String), ""]
    }
}

/// Runs a shell command *with elevated privileges,* displaying an authentication dialog.
///
/// *See also* `doShellScript` which runs with normal privileges.
/// - Warning: Currently this calls AppleScript to execute the command,
///   which is inefficient and potentially hazardous.
///
/// - Parameter source: a String containing the command line to be run (without `sudo`).
/// - Returns: a String containing: 
///   - `ERROR`, if the command failed or was cancelled by the user,
///   - the returned text from running the command, if successful.
func doShellScriptWithPrivileges(source: String) -> String {
    let appleScript = NSAppleScript(source: source)
    let eventResult = appleScript?.executeAndReturnError(nil)
    if (eventResult == nil) {
        return "ERROR"
    } else {
        return (eventResult?.stringValue)!
    }
}

func doErrorAlertSheet(message: String, window: NSWindow) {
    let alert: NSAlert = NSAlert()
    alert.messageText = "An error occurred in your last action:"
    alert.informativeText = message
    alert.alertStyle = NSAlertStyle.critical
    alert.addButton(withTitle: "OK")
    alert.beginSheetModal(for: window, completionHandler: nil)
}

func doErrorAlertModal(message: String) {
    let alert: NSAlert = NSAlert()
    alert.messageText = "An error occurred in your last action:"
    alert.informativeText = message
    alert.alertStyle = NSAlertStyle.critical
    alert.addButton(withTitle: "OK")
    alert.runModal()
}
