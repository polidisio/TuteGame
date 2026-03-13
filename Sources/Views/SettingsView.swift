import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = SettingsManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                // Sound Section
                Section {
                    Toggle("Sonidos", isOn: $settings.soundEnabled)
                    
                    if settings.soundEnabled {
                        VStack(alignment: .leading) {
                            Text("Volumen de efectos")
                            Slider(value: $settings.soundVolume, in: 0...1)
                        }
                    }
                } header: {
                    Label("🔊 Sonido", systemImage: "speaker.wave.2.fill")
                }
                
                // Haptics Section
                Section {
                    Toggle("Vibración", isOn: $settings.hapticEnabled)
                } header: {
                    Label("📳 Vibración", systemImage: "iphone.radiowaves.left.and.right")
                }
                
                // Music Section
                Section {
                    Toggle("Música", isOn: $settings.musicEnabled)
                    
                    if settings.musicEnabled {
                        VStack(alignment: .leading) {
                            Text("Volumen de música")
                            Slider(value: $settings.musicVolume, in: 0...1)
                        }
                    }
                } header: {
                    Label("🎵 Música", systemImage: "music.note")
                }
                
                // Difficulty Section
                Section {
                    Picker("Dificultad", selection: $settings.difficulty) {
                        Text("Fácil").tag(0)
                        Text("Medio").tag(1)
                        Text("Difícil").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    Text(difficultyDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } header: {
                    Label("🎯 Dificultad", systemImage: "brain.head.profile")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Desarrollador")
                        Spacer()
                        Text("TuteGame")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Label("ℹ️ Acerca de", systemImage: "info.circle")
                }
                
                // Danger Zone
                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Label("Borrar estadísticas", systemImage: "trash")
                    }
                } header: {
                    Label("⚠️ Peligro", systemImage: "exclamationmark.triangle")
                }
            }
            .navigationTitle("⚙️ Configuración")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("Borrar estadísticas", isPresented: $showResetAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Borrar", role: .destructive) {
                    resetStatistics()
                }
            } message: {
                Text("¿Estás seguro de que quieres borrar todas las estadísticas? Esta acción no se puede deshacer.")
            }
        }
    }
    
    var difficultyDescription: String {
        switch settings.difficulty {
        case 0:
            return "La IA juega de forma aleatoria. Ideal para principiantes."
        case 1:
            return "La IA usa estrategia básica. Un reto moderado."
        case 2:
            return "La IA optimiza cada movimiento. ¡Para expertos!"
        default:
            return ""
        }
    }
    
    func resetStatistics() {
        if let data = UserDefaults.standard.data(forKey: "gameStats"),
           var stats = try? JSONDecoder().decode(GameStatistics.self, from: data) {
            stats.reset()
            if let encoded = try? JSONEncoder().encode(stats) {
                UserDefaults.standard.set(encoded, forKey: "gameStats")
            }
        }
    }
}

#Preview {
    SettingsView()
}
