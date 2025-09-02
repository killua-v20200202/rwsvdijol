//
//  musicmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//
//
import SwiftUI

struct MusicMainView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 400
            
            ScrollView {
                VStack(spacing: isCompact ? 20 : 32) {
                    // Header
                    Text("Focus Music")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.black)
                        .minimumScaleFactor(0.8)
                        .padding(.top, isCompact ? 16 : 24)
                    
                    // Compact Music Player
                    CompactMusicPlayerView(isCompact: isCompact)
                    
                    // Music Categories
                    VStack(alignment: .leading, spacing: isCompact ? 12 : 20) {
                        Text("FOCUS PLAYLISTS")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                            .padding(.horizontal, isCompact ? 16 : 32)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(musicPlayer.focusPlaylists.prefix(4)) { track in
                                TrackCard(track: track, isCompact: isCompact)
                            }
                        }
                        .padding(.horizontal, isCompact ? 16 : 32)
                    }
                    
                    Spacer(minLength: isCompact ? 16 : 32)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct CompactMusicPlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    let isCompact: Bool
    
    var body: some View {
        VStack(spacing: isCompact ? 12 : 16) {
            // Album Art
            RoundedRectangle(cornerRadius: isCompact ? 16 : 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.8),
                            Color.orange.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: isCompact ? 60 : 80, height: isCompact ? 60 : 80)
                .overlay(
                    Image(systemName: "music.note")
                        .font(.title2.weight(.light))
                        .foregroundColor(.white.opacity(0.8))
                )
                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // Track Info
            VStack(spacing: 2) {
                Text(musicPlayer.currentTrack?.title ?? "No track selected")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.black)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Text(musicPlayer.currentTrack?.artist ?? "Select music to focus")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
            
            // Controls
            HStack(spacing: isCompact ? 12 : 20) {
                Button(action: { musicPlayer.previousTrack() }) {
                    Image(systemName: "backward.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { musicPlayer.togglePlayPause() }) {
                    Image(systemName: musicPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: isCompact ? 28 : 36))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(
                                    Color.red
                                )
                                .frame(width: isCompact ? 36 : 44, height: isCompact ? 36 : 44)
                                .shadow(color: .red.opacity(0.3), radius: 6, x: 0, y: 3)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { musicPlayer.nextTrack() }) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(isCompact ? 16 : 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color.gray.opacity(0.05)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, isCompact ? 16 : 32)
    }
}

struct TrackCard: View {
    let track: Track
    let isCompact: Bool
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        Button(action: {
            musicPlayer.selectTrack(track)
        }) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: isCompact ? 32 : 40, height: isCompact ? 32 : 40)
                    .overlay(
                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                            .font(isCompact ? .caption2 : .caption)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .foregroundColor(.black)
                        .font(.subheadline.weight(.medium))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                    Text(track.artist)
                        .foregroundColor(.gray)
                        .font(.caption)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: musicPlayer.currentTrack?.id == track.id ? "speaker.wave.2.fill" : "play.fill")
                    .foregroundColor(musicPlayer.currentTrack?.id == track.id ? .orange : .gray)
                    .font(.subheadline)
            }
            .padding(isCompact ? 12 : 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
