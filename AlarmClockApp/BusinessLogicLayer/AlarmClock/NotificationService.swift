//
//  NotificationService.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 12.02.2021.
//

import UIKit
import UserNotifications

protocol NotificationService {
    func userRequest()
    func scheduleNotification(title: String, date: Date)
    func deleteNotifications(identifier: String)
}

final class NotificationServiceImpl: NSObject, NotificationService  {
    
    // MARK: - Properties
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    private let playingService: PlayingService = PlayingServiceImpl()
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        notificationCenter.delegate = self
    }
    
    // MARK: - Actions
    
    func userRequest() {
        notificationCenter.requestAuthorization(options: options) { didAllow, error in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func scheduleNotification(title: String, date: Date) {
        let contenT = content(title: "Будильник", categoryIdentifier: "User Actions")
        let triggeR = trigger(on: date)
        
        schedule(identifier: title, content: contenT, trigger: triggeR)
    }
    
    func deleteNotifications(identifier: String) {
        var withIdentifiers: [String] = []
        withIdentifiers.append(identifier)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: withIdentifiers)
        notificationCenter.removeDeliveredNotifications(withIdentifiers: withIdentifiers)
    }
    
    private func schedule(identifier: String,
                          content: UNMutableNotificationContent,
                          trigger: UNCalendarNotificationTrigger) {
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    private func content(title: String,
                         categoryIdentifier: String) -> UNMutableNotificationContent {
        
        let soundName = UNNotificationSoundName(rawValue: "bell.mp3")
        let sound = UNNotificationSound(named: soundName)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Пора вставать"
        content.sound = sound
        content.badge = 1
        content.categoryIdentifier = categoryIdentifier
        
        return content
    }
    
    private func trigger(on date: Date) -> UNCalendarNotificationTrigger {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
}

extension NotificationServiceImpl: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let path = Bundle.main.path(forResource: "bell", ofType: "mp3") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        playingService.start(with: url) { _ in }
        
        presentAlert()
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    private func presentAlert() {
        let alert = AlertWindowController(title: "Будильник", message: "Пора вставать", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self] alert in
            self?.playingService.stop()
        }
        
        alert.addAction(action)
        alert.show()
    }
}
