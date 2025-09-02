//
//  settingsmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//


//
//  settingsmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI

struct SettingsMainView: View {
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var showingBlockList = false
    @State private var showingWebsiteBlockerSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 400
            
            ScrollView {
                VStack(spacing: isCompact ? 20 : 24) {
                    // Header
                    Text("Settings")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.black)
                        .minimumScaleFactor(0.8)
                        .padding(.top, isCompact ? 16 : 24)
                    
                    VStack(alignment: .leading, spacing: isCompact ? 12 : 16) {
                        Text("WEBSITE BLOCKING")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                            .padding(.horizontal, isCompact ? 16 : 32)
                        
                        VStack(spacing: 12) {
                            SettingsRow(
                                title: "Manage Block List",
                                subtitle: blockerService.isEnabled ? "\(blockerService.blockedWebsites.count) websites blocked" : "Website blocker disabled",
                                icon: "shield.slash.fill",
                                color: blockerService.isEnabled ? .red : .gray,
                                isCompact: isCompact
                            ) {
                                showingWebsiteBlockerSettings = true
                            }
                            
                            SettingsRow(
                                title: "Break Mode",
                                subtitle: "5 minute unblock periods",
                                icon: "cup.and.saucer.fill",
                                color: .green,
                                isCompact: isCompact
                            ) {
                                blockerService.breakMode()
                            }
                        }
                        .padding(.horizontal, isCompact ? 16 : 32)
                    }
                    
                    VStack(alignment: .leading, spacing: isCompact ? 12 : 16) {
                        Text("NOTIFICATIONS")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                            .padding(.horizontal, isCompact ? 16 : 32)
                        
                        VStack(spacing: 12) {
                            SettingsToggleRow(
                                title: "Session Reminders",
                                subtitle: "Get notified when sessions end",
                                icon: "bell.fill",
                                color: .blue,
                                isOn: .constant(true),
                                isCompact: isCompact
                            )
                            
                            SettingsToggleRow(
                                title: "Break Reminders",
                                subtitle: "Gentle nudges to take breaks",
                                icon: "moon.fill",
                                color: .purple,
                                isOn: .constant(false),
                                isCompact: isCompact
                            )
                        }
                        .padding(.horizontal, isCompact ? 16 : 32)
                    }
                    
                    Spacer(minLength: isCompact ? 16 : 32)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(isPresented: $showingBlockList) {
            BlockListView()
        }
        .sheet(isPresented: $showingWebsiteBlockerSettings) {
            WebsiteBlockerSettingsView()
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    let isCompact: Bool
    
    init(title: String, subtitle: String, icon: String, color: Color, isCompact: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.isCompact = isCompact
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(isCompact ? .title3 : .title2)
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline.weight(.medium))
                        .foregroundColor(.black)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.8)
                        .lineLimit(isCompact ? 2 : 1)
                }
                
                Spacer()
                
                if !isCompact {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(isCompact ? 16 : 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    @Binding var isOn: Bool
    let isCompact: Bool
    
    init(title: String, subtitle: String, icon: String, color: Color, isOn: Binding<Bool>, isCompact: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self._isOn = isOn
        self.isCompact = isCompact
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(isCompact ? .title3 : .title2)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline.weight(.medium))
                    .foregroundColor(.black)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .minimumScaleFactor(0.8)
                    .lineLimit(isCompact ? 2 : 1)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: color))
        }
        .padding(isCompact ? 16 : 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
