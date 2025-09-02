//
//  sidebarview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//


import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        GeometryReader { geometry in
            let sidebarHeight = geometry.size.height
            let isCompactHeight = sidebarHeight < 500
            
            VStack(spacing: isCompactHeight ? 12 : 20) {
                // Logo/Icon at top
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.red, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "brain.head.profile")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.top, isCompactHeight ? 12 : 20)
                
                // Navigation Items
                VStack(spacing: isCompactHeight ? 8 : 12) {
                    SidebarItem(
                        icon: "timer",
                        label: "Timer",
                        isSelected: appState.selectedTab == .timer,
                        hasIndicator: timerManager.isRunning,
                        isCompact: isCompactHeight
                    ) {
                        appState.selectedTab = .timer
                    }
                    
                    SidebarItem(
                        icon: "chart.bar.fill",
                        label: "Stats",
                        isSelected: appState.selectedTab == .stats,
                        isCompact: isCompactHeight
                    ) {
                        appState.selectedTab = .stats
                    }
                    
                    SidebarItem(
                        icon: "music.note",
                        label: "Music",
                        isSelected: appState.selectedTab == .music,
                        hasIndicator: musicPlayer.isPlaying,
                        isCompact: isCompactHeight
                    ) {
                        appState.selectedTab = .music
                    }
                }
                
                Spacer()
                
                // Break mode button - hide label on compact
                Button(action: { blockerService.breakMode() }) {
                    VStack(spacing: isCompactHeight ? 2 : 4) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(isCompactHeight ? .subheadline : .title3)
                            .foregroundColor(.green)
                        
                        if !isCompactHeight {
                            Text("Break")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.green)
                        }
                    }
                    .frame(width: 50, height: isCompactHeight ? 40 : 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Settings at bottom
                SidebarItem(
                    icon: "gearshape.fill",
                    label: "Settings",
                    isSelected: appState.selectedTab == .settings,
                    isCompact: isCompactHeight
                ) {
                    appState.selectedTab = .settings
                }
                .padding(.bottom, isCompactHeight ? 12 : 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SidebarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let hasIndicator: Bool
    let isCompact: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    init(icon: String, label: String, isSelected: Bool, hasIndicator: Bool = false, isCompact: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        self.isSelected = isSelected
        self.hasIndicator = hasIndicator
        self.isCompact = isCompact
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: isCompact ? 2 : 4) {
                ZStack {
                    Image(systemName: icon)
                        .font(.system(size: isCompact ? 14 : 16, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? .white : .gray.opacity(0.8))
                        .frame(width: 20, height: 20)
                    
                    if hasIndicator {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 6, height: 6)
                            .offset(x: 12, y: -12)
                    }
                }
                
                if !isCompact {
                    Text(label)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(isSelected ? .white : .gray.opacity(0.8))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
            }
            .frame(width: 50, height: isCompact ? 40 : 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected ?
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                isHovered ? Color.white.opacity(0.15) : Color.clear,
                                isHovered ? Color.white.opacity(0.08) : Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.red.opacity(0.5) : Color.white.opacity(0.1),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isSelected ? .red.opacity(0.4) : .clear,
                        radius: isSelected ? 8 : 0,
                        x: 0,
                        y: isSelected ? 4 : 0
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
    }
}
