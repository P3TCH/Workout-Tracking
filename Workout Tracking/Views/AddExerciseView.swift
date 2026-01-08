import SwiftUI
import SwiftData

struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTab: Int
    
    enum MuscleGroup: String, CaseIterable, Identifiable {
        case chest = "Chest", back = "Back", leg = "Leg", shoulder = "Shoulder"
        var id: String { self.rawValue }
    }
    
    let presets: [MuscleGroup: [String]] = [
        .back: ["Wide Lat Pulldown", "Close Lat Pulldown", "Deadlift", "Row", "Biceps curl", "Bent Over Row", "Pull Ups"],
        .chest: ["Bench Press", "Upper Bench Press", "Incline Fly", "Triceps", "Pull over", "Push Ups", "Chest Press"],
        .leg: ["Leg Press", "Squats", "Lunges", "Calf Raises"],
        .shoulder: ["Overhead Press", "Lateral Raise", "Face Pulls"]
    ]
    
    @State private var selectedGroup: MuscleGroup = .chest
    @State private var exerciseName = ""
    @State private var totalSets = 4
    @State private var isCustomDate = false
    @State private var selectedDate = Date.now
    
    @State private var bounceScale: CGFloat = 1.0
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Picker("Muscle Group", selection: $selectedGroup) {
                        ForEach(MuscleGroup.allCases) { group in
                            Text(group.rawValue).tag(group)
                        }
                    }
                    .pickerStyle(.segmented)
                    .controlSize(.large)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(presets[selectedGroup] ?? [], id: \.self) { preset in
                                Button(preset) {
                                    exerciseName = preset
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                .controlSize(.small)
                            }
                        }
                    }
                }
                .padding()
                .background(.regularMaterial)
                
                Form {
                    Section("Exercise Details") {
                        TextField("Exercise Name", text: $exerciseName)
                            .submitLabel(.done)
                            .padding(.vertical, 4)
                        
                        HStack {
                            Text("Total Sets")
                            Spacer()
                            
                            HStack(spacing: 20) {
                                // Minus Button
                                stepperButton(systemName: "minus") {
                                    if totalSets > 1 { totalSets -= 1; triggerEffect() }
                                }
                                
                                // Number display with Bounce Effect
                                Text("\(totalSets)")
                                    .font(.headline)
                                    .monospacedDigit()
                                    .scaleEffect(bounceScale)
                                
                                // Plus Button
                                stepperButton(systemName: "plus") {
                                    if totalSets < 20 { totalSets += 1; triggerEffect() }
                                }
                            }
                        }
                    }
                    Section("Workout Date") {
                        Toggle("Custom Date", isOn: $isCustomDate.animation(.spring()))
                        
                        if isCustomDate {
                            DatePicker(
                                "Select Date",
                                selection: $selectedDate,
                                in: ...Date.now,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.graphical)
                            .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                                    removal: .opacity))
                        } else {
                            // Optional: Show current date as text when toggle is off
                            HStack {
                                Text("Date")
                                Spacer()
                                Text(Date.now.formatted(date: .long, time: .omitted))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Workout")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let workoutDate = isCustomDate ? selectedDate : Date.now
                        
                        let newWorkout = WorkoutSession(
                            muscleGroup: selectedGroup.rawValue,
                            exerciseName: exerciseName,
                            totalSets: totalSets,
                            completedSets: 0, // Start at 0 for new exercises
                            date: workoutDate //.now
                        )
                        
                        modelContext.insert(newWorkout)
                        
                        do {
                            try modelContext.save()
                            withAnimation {
                                selectedTab = 0
                            }
                        } catch {
                            print("Error saving workout: \(error.localizedDescription)")
                        }
                    }
                    .disabled(exerciseName.isEmpty)
                }

            }
            .onChange(of: selectedGroup) { _, _ in exerciseName = "" }
            .sensoryFeedback(.increase, trigger: totalSets)
        }
    }
    
    func stepperButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.body.bold())
                .frame(width: 32, height: 32)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }
        
    func triggerEffect() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) {
            bounceScale = 1.3
        }
        // 2. Return to normal
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring()) {
                bounceScale = 1.0
            }
        }
    }
}


#Preview {
    AddExerciseView(selectedTab: .constant(0))
        .modelContainer(for: WorkoutSession.self, inMemory: true)
}
