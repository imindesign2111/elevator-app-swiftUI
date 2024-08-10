import SwiftUI
import UIKit

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
    
    // Dynamically calculate floorHeight based on screen height
    var floorHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        let safeAreaInsets = keyWindow?.safeAreaInsets ?? UIEdgeInsets()
        let safeAreaHeight = screenHeight - safeAreaInsets.top - safeAreaInsets.bottom
        return safeAreaHeight / CGFloat(totalFloors)
    }

    
    @State private var isMoving = false
    
    // Predefined passengers and their destinations
    @State private var elevatorPassengers: [Passenger] = []
    
    @State private var floors: [Floor] = [
        Floor(floorNumber: 1, waitingPassengers: []),
        Floor(floorNumber: 2, waitingPassengers: []),
        Floor(floorNumber: 3, waitingPassengers: []),
        Floor(floorNumber: 4, waitingPassengers: []),
        Floor(floorNumber: 5, waitingPassengers: []),
        Floor(floorNumber: 6, waitingPassengers: []),
        Floor(floorNumber: 7, waitingPassengers: []),
        Floor(floorNumber: 8, waitingPassengers: []),
        Floor(floorNumber: 9, waitingPassengers: []),
        Floor(floorNumber: 10, waitingPassengers: [])
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
                                    Text("\(passenger.destinationFloor)")
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
        }
        .onAppear {
            // Ensure the elevator starts at the bottom floor
            currentFloor = 1
        }
    }
    
    func startElevator() {
    }
    
    func planElevatorRoute() {
    }
    
    func moveElevator() {
    }
    
    func handlePassengers() {
    }
}

struct ElevatorView_Previews: PreviewProvider {
    static var previews: some View {
        ElevatorView()
    }
}
