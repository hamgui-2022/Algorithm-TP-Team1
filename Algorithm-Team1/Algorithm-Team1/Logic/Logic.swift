//
//  Logic.swift
//  Algorithm-Team1
//
//  Created by 이재혁 on 12/2/23.
//

import Foundation

func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
    let R = 6371.0  // Earth's radius (unit: km)

    // Convert latitude and longitude to radians
    let lat1Rad = lat1 * .pi / 180.0
    let lon1Rad = lon1 * .pi / 180.0
    let lat2Rad = lat2 * .pi / 180.0
    let lon2Rad = lon2 * .pi / 180.0

    // Calculate distance using Haversine formula
    let dlat = lat2Rad - lat1Rad
    let dlon = lon2Rad - lon1Rad

    let a = pow(sin(dlat / 2.0), 2) + cos(lat1Rad) * cos(lat2Rad) * pow(sin(dlon / 2.0), 2)
    let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))

    let distance = R * c
    return distance
}

//func findNearestStation(subwayStations: [String: (Double, Double)], coordinates: (Double, Double)) -> String? {
//    do {
//        guard let nearestStation = try subwayStations.min(by: {
//            haversineDistance(lat1: coordinates.0, lon1: coordinates.1, lat2: $0.value.0, lon2: $0.value.1)
//                < haversineDistance(lat1: coordinates.0, lon1: coordinates.1, lat2: $1.value.0, lon2: $1.value.1)
//        })?.key else {
//            print("Error: No nearest station found")
//            return nil
//        }
//        return nearestStation
//    } catch {
//        print("Error: \(error)")
//        return nil
//    }
//}

func findNearestStation(subwayStations: [String: [Double]], coordinates: (Double, Double)) -> String? {
    do {
        guard let nearestStation = try subwayStations.min(by: {
            haversineDistance(lat1: coordinates.0, lon1: coordinates.1, lat2: $0.value[0], lon2: $0.value[1])
                < haversineDistance(lat1: coordinates.0, lon1: coordinates.1, lat2: $1.value[0], lon2: $1.value[1])
        })?.key else {
            print("Error: No nearest station found")
            return nil
        }
        return nearestStation
    } catch {
        print("Error: \(error)")
        return nil
    }
}

//func calculateMidpoint(coordinates: (Double, Double)...) -> (Double, Double) {
//    let numCoordinates = Double(coordinates.count)
//    let midLat = coordinates.map { $0.0 }.reduce(0.0, +) / numCoordinates
//    let midLon = coordinates.map { $0.1 }.reduce(0.0, +) / numCoordinates
//    return (midLat, midLon)
//}

func calculateMidpoint(coordinates: [[Double]]) -> (Double, Double) {
    let numCoordinates = coordinates.count
    let midLat = coordinates.reduce(0.0) { $0 + $1[0] } / Double(numCoordinates)
    let midLon = coordinates.reduce(0.0) { $0 + $1[1] } / Double(numCoordinates)
    return (midLat, midLon)
}

//func createGraph(subwayStations: [String: (Double, Double)]) -> [String: [String: Double]] {
//    var graph = [String: [String: Double]]()
//
//    for (station1, coord1) in subwayStations {
//        graph[station1] = [:]
//
//        for (station2, coord2) in subwayStations {
//            if station1 != station2 {
//                // Add edges with weights representing Haversine distances
//                let distance = haversineDistance(lat1: coord1.0, lon1: coord1.1, lat2: coord2.0, lon2: coord2.1)
//                graph[station1]?[station2] = distance
//            }
//        }
//    }
//
//    return graph
//}

func createGraph(subwayStations: [String: [Double]]) -> [String: [String: Double]] {
    var graph = [String: [String: Double]]()

    for (station1, coord1) in subwayStations {
        graph[station1] = [:]

        for (station2, coord2) in subwayStations {
            if station1 != station2 {
                // Add edges with weights representing Haversine distances
                let distance = haversineDistance(lat1: coord1[0], lon1: coord1[1], lat2: coord2[0], lon2: coord2[1])
                graph[station1]?[station2] = distance
            }
        }
    }

    return graph
}

func dijkstra(graph: [String: [String: Double]], start: String, end: String) -> Double {
    var shortestPaths = [String: Double]()
    var visitedVertices = Set<String>()
    var currentVertex = start

    for vertex in graph.keys {
        shortestPaths[vertex] = Double.infinity
    }

    shortestPaths[start] = 0.0

    while currentVertex != end {
        for (neighbor, weight) in graph[currentVertex]! {
            let candidatePathDistance = shortestPaths[currentVertex]! + weight
            if candidatePathDistance < shortestPaths[neighbor]! {
                shortestPaths[neighbor] = candidatePathDistance
            }
        }

        visitedVertices.insert(currentVertex)

        var candidates = [String: Double]()
        for vertex in shortestPaths.keys {
            if !visitedVertices.contains(vertex) {
                candidates[vertex] = shortestPaths[vertex]
            }
        }

        currentVertex = candidates.min { $0.value < $1.value }!.key
    }

    return shortestPaths[end]!
}

func findStationCoordinates(stationName: String) -> (Double, Double)? {
    guard let coordinates = stationDictionary[stationName] else {
        return nil
    }
    return (coordinates[0], coordinates[1])
}

func main() {
    // Get the number of desired subway stations from user input
    print("Enter the number of subway stations you want:")
    guard let numStationsStr = readLine(),
          let numStations = Int(numStationsStr) else {
        print("Error: Invalid input for the number of subway stations.")
        return
    }

    var selectedStations = [String]()
    for i in 1...numStations {
        print("Enter the \(i)-th subway station:")
        guard let stationName = readLine() else {
            print("Error: Invalid input for subway station name.")
            return
        }
        selectedStations.append(stationName)
    }

    // Check if entered subway station names are valid
    let invalidStations = selectedStations.filter { stationName in !stationDictionary.keys.contains(stationName) }
    if !invalidStations.isEmpty {
        print("Error: The following subway station(s) are not valid: \(invalidStations.joined(separator: ", "))")
        return
    }

//    // Use selectedStations to perform further calculations or operations
//    // For example, find coordinates of the entered stations and print them
//    for station in selectedStations {
//        guard let coordinates = findStationCoordinates(stationName: station) else {
//            print("Error: Coordinates not found for station \(station)")
//            return
//        }
//        print("Coordinates for \(station): \(coordinates)")
//    }
    // Create a graph and add edges
        let graph = createGraph(subwayStations: stationDictionary)

        // Use Dijkstra's algorithm to calculate the shortest paths and distances
        var shortestPaths = [String]()
        var totalDistances = [Double]()
        for i in 0..<numStations - 1 {
            let sourceStation = selectedStations[i]
            let targetStation = selectedStations[i + 1]

            // Check if entered station names are valid
            guard stationDictionary.keys.contains(sourceStation), stationDictionary.keys.contains(targetStation) else {
                print("Error: Invalid subway station names (\(sourceStation) or \(targetStation)).")
                return
            }

            let distance = dijkstra(graph: graph, start: sourceStation, end: targetStation)
            shortestPaths.append("\(sourceStation) -> \(targetStation)")
            totalDistances.append(distance)
        }

        // Calculate midpoint
        let selectedStationsCoordinates = selectedStations.compactMap { stationDictionary[$0] }
        let (midLat, midLon) = calculateMidpoint(coordinates: selectedStationsCoordinates)

        // Find the nearest subway station to the halfway point
        let midpointCoordinates = (midLat, midLon)
        let nearestStation = findNearestStation(subwayStations: stationDictionary, coordinates: midpointCoordinates)

        // Display results
        for i in 0..<numStations - 1 {
            print("The shortest route (\(selectedStations[i]) to \(selectedStations[i + 1])): \(shortestPaths[i])")
            print("Total travel distance (\(selectedStations[i]) to \(selectedStations[i + 1])): \(totalDistances[i]) km")
        }

        print("The midway point: \(midpointCoordinates)")
        if let nearestStation = nearestStation {
            print("The nearest subway station to the halfway point: \(nearestStation)")
        } else {
            print("The shortest route and nearest subway station could not be found")
        }
}
