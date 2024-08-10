import SwiftUI

struct Passenger: Identifiable {
    let id = UUID()
    var currentFloor: Int
    var destinationFloor: Int
}

struct Floor {
    var floorNumber: Int
    var waitingPassengers: [Passenger] = []
}

struct ElevatorView: View {
    @State private var currentFloor = 1
    let totalFloors = 10
    let floorHeight: CGFloat = 50
    @State private var isMoving = false
    
    // Predefined passengers and their destinations
    @State private var elevatorPassengers: [Passenger] = []
    
    @State private var floors: [Floor] = [
        Floor(floorNumber: 1, waitingPassengers: [Passenger(currentFloor: 1, destinationFloor: 2)]),
        Floor(floorNumber: 2, waitingPassengers: [Passenger(currentFloor: 2, destinationFloor: 5)]),
        Floor(floorNumber: 10, waitingPassengers: [Passenger(currentFloor: 10, destinationFloor: 1)]),
        Floor(floorNumber: 3, waitingPassengers: []),
        Floor(floorNumber: 4, waitingPassengers: []),
        Floor(floorNumber: 5, waitingPassengers: []),
        Floor(floorNumber: 6, waitingPassengers: []),
        Floor(floorNumber: 7, waitingPassengers: []),
        Floor(floorNumber: 8, waitingPassengers: []),
        Floor(floorNumber: 9, waitingPassengers: [])
    ]
    
    @State private var moveIndex = 0
    @State private var travelPlan: [Int] = []
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                // Elevator shaft with the elevator and passengers
                ZStack(alignment: .top) {
                    // Fixed elevator shaft covering 10 floors
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: floorHeight * CGFloat(totalFloors))
                        .cornerRadius(10)
                    
                    // Moving elevator
                    VStack {
                        Spacer()
                            .frame(height: CGFloat(totalFloors - currentFloor) * floorHeight)
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(width: 100, height: floorHeight) // Match the floor height
                            
                            VStack {
                                // Inside the elevator
                                ForEach(elevatorPassengers, id: \.id) { passenger in
                                    Text("To \(passenger.destinationFloor)")
                                        .padding(5)
                                        .background(Color.orange)
                                        .cornerRadius(5)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: CGFloat(currentFloor - 1) * floorHeight)
                    }
                }
                
                // Floor numbers
                VStack(spacing: 0) {
                    ForEach((1...totalFloors).reversed(), id: \.self) { floor in
                        VStack(alignment: .leading) {
                            Text("Floor \(floor)")
                                .font(.headline)
                            if let floorIndex = floors.firstIndex(where: { $0.floorNumber == floor }) {
                                ForEach(floors[floorIndex].waitingPassengers, id: \.id) { passenger in
                                    Text("To \(passenger.destinationFloor)")
                                        .foregroundColor(.blue)
                                        .padding(5)
                                        .background(Color.green.opacity(0.7))
                                        .cornerRadius(5)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: floorHeight) // Each floor height
                        Divider()
                    }
                }
                .frame(width: 150, height: floorHeight * CGFloat(totalFloors))
            }
            .padding()
            .frame(height: floorHeight * CGFloat(totalFloors)) // Ensure the entire view is of consistent height
            
            // Play button to start the elevator movement
            Button(action: {
                startElevator()
            }) {
                Text("Play")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(isMoving ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(isMoving) // Disable button while elevator is moving
            .padding(.top, 20)
        }
        .onAppear {
            // Ensure the elevator starts at the bottom floor
            currentFloor = 1
        }
    }
    
    func startElevator() {
        isMoving = true
        planElevatorRoute()
    }
    
    func planElevatorRoute() {
        // Check each floor from 1 to 10
        for floor in 1...totalFloors {
            if let floorIndex = floors.firstIndex(where: { $0.floorNumber == floor }), !floors[floorIndex].waitingPassengers.isEmpty {
                travelPlan.append(floor)
                for passenger in floors[floorIndex].waitingPassengers {
                    travelPlan.append(passenger.destinationFloor)
                }
            }
        }
        
        // Remove duplicates and sort the travel plan
        travelPlan = Array(Set(travelPlan)).sorted()
        
        moveElevator()
    }
    
    func moveElevator() {
        if moveIndex < travelPlan.count {
            let nextDestination = travelPlan[moveIndex]
            
            withAnimation(.easeInOut(duration: 1.0)) {
                currentFloor = nextDestination
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                handlePassengers()
                moveIndex += 1
                moveElevator() // Move to the next destination
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Reset to floor 1 after all passengers have reached their destinations
                withAnimation(.easeInOut(duration: 1.0)) {
                    currentFloor = 1
                }
                moveIndex = 0
                travelPlan.removeAll()
                isMoving = false // Re-enable the Play button
            }
        }
    }
    
    func handlePassengers() {
        // Handle passengers entering or exiting the elevator
        if let floorIndex = floors.firstIndex(where: { $0.floorNumber == currentFloor }) {
            // Passengers enter the elevator
            elevatorPassengers.append(contentsOf: floors[floorIndex].waitingPassengers)
            floors[floorIndex].waitingPassengers.removeAll()
        }
        
        // Passengers exit the elevator
        elevatorPassengers.removeAll { passenger in
            passenger.destinationFloor == currentFloor
        }
    }
}

struct ElevatorView_Previews: PreviewProvider {
    static var previews: some View {
        ElevatorView()
    }
}
