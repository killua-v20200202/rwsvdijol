//
//  timermainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var selectedCategory = "General"
    @State private var intention = ""
    @State private var showingCategoryPicker = false
    @State private var showingTimerSettings = false
    
    let categories = ["General", "Deep Work", "Study", "Creative", "Reading"]
    
    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 400
            let isVeryCompact = geometry.size.width < 320
            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height
            
            ScrollView {
                VStack(spacing: isCompact ? 16 : 32) {
                    // Progress dots - hide on very small screens
                    if !isVeryCompact {
                        HStack(spacing: 8) {
                            ForEach(0..<7, id: \.self) { index in
                                Circle()
                                    .fill(index == 0 ? Color.red : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.top, isCompact ? 12 : 24)
                    }
                    
                    // Focus Question Section
                    VStack(spacing: isCompact ? 16 : 24) {
                        Text("What's your focus?")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.black)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        
                        // Category selector
                        Button(action: { showingCategoryPicker = true }) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                
                                Text(selectedCategory)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(.black)
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                                
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, isCompact ? 12 : 20)
                            .padding(.vertical, isCompact ? 8 : 12)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .popover(isPresented: $showingCategoryPicker) {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(categories, id: \.self) { category in
                                    Button(category) {
                                        selectedCategory = category
                                        showingCategoryPicker = false
                                    }
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                }
                            }
                            .padding(8)
                            .background(Color.white)
                        }
                        
                        // Intention input
                        TextField("What will you focus on?", text: $intention)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.horizontal, isCompact ? 12 : 20)
                            .padding(.vertical, isCompact ? 12 : 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .frame(maxWidth: min(availableWidth - (isCompact ? 32 : 64), 300))
                    }
                    
                    // Circular Timer - dynamically sized
                    let timerSize = min(
                        min(availableWidth - (isCompact ? 60 : 100), 280),
                        min(availableHeight * 0.4, 280)
                    )
                    
                    CircularTimerView(size: timerSize)
                        .frame(width: timerSize, height: timerSize)
                    
                    // Time display
                    Text(timerManager.displayTime)
                        .font(.system(
                            size: min(availableWidth / (isCompact ? 8 : 12), isCompact ? 24 : 32),
                            weight: .light,
                            design: .monospaced
                        ))
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                    
                    // Session time range - hide on very small screens
                    if !timerManager.isRunning && !isVeryCompact {
                        Text("21:14 → 09:46")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.gray)
                            .padding(.horizontal, isCompact ? 12 : 16)
                            .padding(.vertical, isCompact ? 4 : 6)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.1))
                            )
                            .minimumScaleFactor(0.8)
                    }
                    
                    // Start Session Button
                    Button(action: toggleTimer) {
                        Text(timerManager.isRunning ? "STOP SESSION" : "START SESSION")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                            .frame(
                                maxWidth: min(availableWidth - (isCompact ? 32 : 64), 250),
                                minHeight: isCompact ? 44 : 50
                            )
                            .background(
                                RoundedRectangle(cornerRadius: isCompact ? 22 : 25)
                                    .fill(Color.red)
                                    .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(timerManager.isRunning ? 0.98 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: timerManager.isRunning)
                    
                    // Timer settings button
                    Button(action: { showingTimerSettings = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "timer")
                                .font(.subheadline)
                            if !isCompact {
                                Text("Timer Settings")
                                    .font(.subheadline.weight(.medium))
                                    .minimumScaleFactor(0.8)
                            }
                        }
                        .foregroundColor(.gray)
                        .padding(.horizontal, isCompact ? 12 : 16)
                        .padding(.vertical, isCompact ? 6 : 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, isCompact ? 16 : 32)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, isCompact ? 16 : 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingTimerSettings) {
            TimerSettingsView()
        }
    }
    
    private func toggleTimer() {
        if timerManager.isRunning {
            timerManager.stop()
            blockerService.unblockAll()
        } else {
            timerManager.start()
            blockerService.blockWebsites()
        }
    }
}

struct CircularTimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    let size: CGFloat
    
    private var circleSize: CGFloat { size * 0.85 }
    private var strokeWidth: CGFloat { max(size * 0.03, 4) }
    private var tickOffset: CGFloat { circleSize / 2 }
    private var dotSize: CGFloat { max(size * 0.06, 12) }
    
    var body: some View {
        ZStack {
            // Tick marks around the circle
            ZStack {
                ForEach(0..<60, id: \.self) { tick in
                    Rectangle()
                        .fill(Color.gray.opacity(tick % 15 == 0 ? 0.8 : (tick % 5 == 0 ? 0.4 : 0.2)))
                        .frame(
                            width: tick % 15 == 0 ? max(size * 0.012, 2) : (tick % 5 == 0 ? max(size * 0.008, 1.5) : max(size * 0.004, 1)),
                            height: tick % 15 == 0 ? max(size * 0.08, 16) : (tick % 5 == 0 ? max(size * 0.05, 10) : max(size * 0.025, 5))
                        )
                        .offset(y: -tickOffset)
                        .rotationEffect(.degrees(Double(tick) * 6))
                }
            }
            
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: strokeWidth)
                .frame(width: circleSize, height: circleSize)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0, to: timerManager.progress)
                .stroke(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Progress indicator dot
            Circle()
                .fill(Color.red)
                .frame(width: dotSize, height: dotSize)
                .offset(y: -tickOffset)
                .rotationEffect(.degrees(-90 + (timerManager.progress * 360)))
                .shadow(color: .red.opacity(0.4), radius: max(size * 0.015, 3), x: 0, y: 2)
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Center content
            VStack(spacing: max(size * 0.03, 6)) {
                Text(timerManager.isRunning ? "LOCKED IN" : "READY")
                    .font(.system(size: max(size * 0.04, 8), weight: .semibold))
                    .foregroundColor(timerManager.isRunning ? .red : .gray)
                    .tracking(2)
                    .minimumScaleFactor(0.6)
                    .animation(.easeInOut, value: timerManager.isRunning)
            }
        }
        .frame(width: size, height: size)
    }
}
