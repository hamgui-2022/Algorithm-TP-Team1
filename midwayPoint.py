import pandas as pd
import networkx as nx
from math import radians, sin, cos, sqrt, atan2
    
# Function to calculate Haversine distance between two sets of latitude and longitude coordinates
def haversine_distance(lat1, lon1, lat2, lon2):
    R = 6371  # Earth's radius (unit: km)

    # Convert latitude and longitude to radians
    lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])

    # Calculate distance using Haversine formula
    dlat = lat2 - lat1
    dlon = lon2 - lon1

    a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance = R * c
    return distance

# Function to find the nearest subway station in the graph based on Haversine distance
def find_nearest_station(graph, coordinates):
    try:
        nearest_station = min(graph.nodes, key=lambda x: haversine_distance(coordinates[0], coordinates[1], graph.nodes[x]['pos'][0], graph.nodes[x]['pos'][1]))
        return nearest_station
    except ValueError:
        print("Error: No nearest station found")
        return None
    
# Function to calculate the midpoint given a set of coordinates
def calculate_midpoint(*coordinates):
    num_coordinates = len(coordinates)
    mid_lat = sum(coord[0] for coord in coordinates) / num_coordinates
    mid_lon = sum(coord[1] for coord in coordinates) / num_coordinates
    return mid_lat, mid_lon

def main():
    # Excel file path
    excel_file_path = "C:/Users/김소정/Desktop/Algorithm-Project/SubwayStations.xlsx"

    # Read Excel file
    df = pd.read_excel(excel_file_path, header=None, names=['Station', 'Latitude', 'Longitude', 'Line'])

    # Subway station and coordinate information
    subway_stations = {row['Station']: (row['Latitude'], row['Longitude']) for _, row in df.iterrows()}

    # Get the number of desired subway stations from user input
    num_stations = int(input("Enter the number of subway stations you want: "))
    selected_stations = []
    for i in range(num_stations):
        station_name = input(f"Enter the {i + 1}-th subway station: ")
        selected_stations.append(station_name)

    # Check if entered subway station names are valid
    invalid_stations = [station for station in selected_stations if station not in subway_stations]
    if invalid_stations:
        print(f"Error: The following subway station(s) are not valid: {', '.join(invalid_stations)}")
        return

    # Create a graph and add edges
    graph = nx.Graph()
    for station, coordinates in subway_stations.items():
        graph.add_node(station, pos=coordinates)
    for station1 in subway_stations:
        for station2 in subway_stations:
            if station1 != station2:
                # Add edges with weights representing Haversine distances
                distance = haversine_distance(subway_stations[station1][0], subway_stations[station1][1], subway_stations[station2][0], subway_stations[station2][1])
                graph.add_edge(station1, station2, weight=distance)

    # Use Dijkstra's algorithm to calculate the shortest paths and distances
    shortest_paths = []
    total_distances = []
    for i in range(num_stations - 1):
        source_station = selected_stations[i]
        target_station = selected_stations[i + 1]

        # Check if entered station names are valid
        if source_station not in subway_stations or target_station not in subway_stations:
            print(f"Error: Invalid subway station names ({source_station} or {target_station}).")
            return

        shortest_path = nx.shortest_path(graph, source=source_station, target=target_station, weight='weight')
        total_distance = nx.shortest_path_length(graph, source=source_station, target=target_station, weight='weight')
        shortest_paths.append(shortest_path)
        total_distances.append(total_distance)

    # Calculate midpoint
    mid_lat, mid_lon = calculate_midpoint(*[subway_stations[station] for station in selected_stations])

    # Find the nearest subway station to the halfway point
    midpoint_coordinates = (mid_lat, mid_lon)
    nearest_station = find_nearest_station(graph, midpoint_coordinates)

     # Display results
    for i in range(num_stations - 1):
        print(f"The shortest route ({selected_stations[i]} to {selected_stations[i + 1]}): {shortest_paths[i]}")
        print(f"Total travel distance ({selected_stations[i]} to {selected_stations[i + 1]}): {total_distances[i]} km")

    print(f"The midway point: {midpoint_coordinates}")
    if nearest_station is not None:
        print(f"The nearest subway station to the halfway point: {nearest_station}")
    else:
        print("The shortest route and nearest subway station could not be found")

if __name__ == "__main__":
    main()
