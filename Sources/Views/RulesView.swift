import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    overviewSection
                    scoringSection
                    gameplaySection
                    trumpSection
                    tipsSection
                }
                .padding()
            }
            .navigationTitle("Reglas del Tute")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Objetivo", systemImage: "target")
                .font(.headline)
            
            Text("El Tute es un juego de cartas español donde el objetivo es acumular más puntos que el equipo contrario. Gana el primer equipo que llegue a 100 puntos.")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    var scoringSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Puntuación de las Cartas", systemImage: "star.fill")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                scoringRow(card: "As (1)", points: 11)
                scoringRow(card: "Tres", points: 10)
                scoringRow(card: "Rey", points: 4)
                scoringRow(card: "Caballo", points: 3)
                scoringRow(card: "Sota", points: 2)
                scoringRow(card: "7, 6, 5, 4, 2", points: 0)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    func scoringRow(card: String, points: Int) -> some View {
        HStack {
            Text(card)
                .font(.body)
            Spacer()
            Text("+ \(points)")
                .font(.body)
                .fontWeight(points > 0 ? .bold : .regular)
                .foregroundColor(points > 0 ? .green : .secondary)
        }
    }
    
    var gameplaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Cómo se Juega", systemImage: "play.fill")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ruleStep(number: 1, text: "Se reparten 10 cartas a cada jugador (4 jugadores)")
                ruleStep(number: 2, text: "La última carta repartida determina el palo de Triunfo")
                ruleStep(number: 3, text: "El jugador a la derecha del que repartió empieza")
                ruleStep(number: 4, text: "Los jugadores juegan una carta por turno")
                ruleStep(number: 5, text: "Debes seguir el palo de la primera carta (si tienes)")
                ruleStep(number: 6, text: "Si no tienes el palo, puedes jugar cualquier carta")
                ruleStep(number: 7, text: "Gana la baza quien tenga la carta más alta")
            }
        }
    }
    
    func ruleStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number).")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    var trumpSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Los Triunfos", systemImage: "crown.fill")
                .font(.headline)
            
            Text("El 7 del palo de Triunfo es la carta más poderosa. Todas las cartas del palo de Triunfo vencen a cualquier carta de otros palos.")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                VStack {
                    Text("⚔️")
                        .font(.title)
                    Text("Espadas")
                        .font(.caption)
                }
                VStack {
                    Text("🪙")
                        .font(.title)
                    Text("Oros")
                        .font(.caption)
                }
                VStack {
                    Text("🍷")
                        .font(.title)
                    Text("Copas")
                        .font(.caption)
                }
                VStack {
                    Text("🪵")
                        .font(.title)
                    Text("Bastos")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Consejos", systemImage: "lightbulb.fill")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                tipRow(icon: "1.circle.fill", text: "Guarda los 7s de Triunfo para el final")
                tipRow(icon: "2.circle.fill", text: "Cuenta las cartas jugadas para anticipar")
                tipRow(icon: "3.circle.fill", text: "Si tu compañero va ganando, ayuda con cartas bajas")
                tipRow(icon: "4.circle.fill", text: "Si vas perdiendo, juega agresivamente")
            }
        }
    }
    
    func tipRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RulesView()
}
