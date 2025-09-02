//
//  websiteblockersettingsview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI

struct WebsiteBlockerSettingsView: View {
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @Environment(\.dismiss) var dismiss
    @State private var blockedWebsitesText = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Website Blocker")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .font(.headline.weight(.medium))
                .foregroundColor(.orange)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )
                .buttonStyle(PlainButtonStyle())
            }
            
            // Enable/Disable Toggle
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    Image(systemName: "shield.slash.fill")
                        .font(.title2)
                        .foregroundColor(blockerService.isEnabled ? .red : .gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable Website Blocker")
                            .font(.headline.weight(.medium))
                            .foregroundColor(.white)
                        
                        Text("Block distracting websites during focus sessions")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $blockerService.isEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                        .onChange(of: blockerService.isEnabled) { _ in
                            blockerService.saveBlockedWebsites()
                        }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
            
            // Website List Input
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Blocked Websites")
                        .font(.headline.weight(.medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(blockerService.blockedWebsites.count) websites")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter one website per line (e.g., twitter.com)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextEditor(text: $blockedWebsitesText)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 200)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                }
            }
            
            // Action Buttons
            HStack(spacing: 16) {
                Button("Reset to Defaults") {
                    blockedWebsitesText = [
                        "twitter.com",
                        "facebook.com",
                        "instagram.com",
                        "youtube.com",
                        "reddit.com",
                        "tiktok.com",
                        "netflix.com"
                    ].joined(separator: "\n")
                }
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button("Save Changes") {
                    blockerService.updateBlockedWebsites(from: blockedWebsitesText)
                    dismiss()
                }
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.red, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .red.opacity(0.4), radius: 12, x: 0, y: 6)
                )
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
        .padding(32)
        .frame(width: 600, height: 700)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.08, blue: 0.12),
                            Color(red: 0.05, green: 0.05, blue: 0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        )
        .onAppear {
            blockedWebsitesText = blockerService.blockedWebsites.joined(separator: "\n")
        }
    }
}