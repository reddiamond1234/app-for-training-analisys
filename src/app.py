import os
import json
import matplotlib.pyplot as plt
import numpy as np
from fit_tool.fit_file import FitFile
from fit_tool.profile.messages.record_message import RecordMessage
from fit_tool.profile.messages.file_id_message import FileIdMessage

class TrainingZones:
    def __init__(self):
        # Define your training zones here
        self.zones = {
            "Zone 1": (0, 100),
            "Zone 2": (101, 200),
            "Zone 3": (201, 300),
            "Zone 4": (301, 400),
            "Zone 5": (401, 5000)
        }

    def time_in_zones(self, power, time):
        zone_times = {zone: 0 for zone in self.zones}
        for zone, (lower, upper) in self.zones.items():
            zone_times[zone] = np.sum((power >= lower) & (power < upper)) * 1.0 / len(time)
        return zone_times

class Person:
    def __init__(self, height, weight, ftp):
        self.height = height
        self.weight = weight
        self.ftp = ftp
        self.zones = TrainingZones()
        self.fatigue = 0.0
        self.tss = 0.0
        self.form = 0.0
        self.ctl = 0.0  # Chronic Training Load
        self.atl = 0.0  # Acute Training Load

    def update_training_metrics(self, normalized_power, duration):
        # Calculate Intensity Factor
        intensity_factor = calculate_intensity_factor(normalized_power, self.ftp)
        # Calculate Training Stress Score
        tss = calculate_tss(duration, normalized_power, intensity_factor, self.ftp)
        self.tss = tss
        # Update CTL, ATL, and form
        self.ctl = calculate_ctl(self.ctl, tss)
        self.atl = calculate_atl(self.atl, tss)
        self.form = calculate_tsb(self.ctl, self.atl)

def main():
    """ Analyze a FIT file """
    print(f'Loading activity file...')
    
    # Get the current directory of the 'src' folder
    current_directory = os.path.dirname(os.path.abspath(__file__))
    
    # Navigate to the 'activity' folder from the 'src' folder
    activity_directory = os.path.join(current_directory, '..', 'activity')
    
    # Specify the file path relative to the current directory
    file_path = os.path.join(activity_directory, 'indoor.fit')
    
    app_fit = FitFile.from_file(file_path)
    timestamp = []
    power = []
    distance = []
    speed = []
    cadence = []
    elevation = []  # New list for elevation data
    heart_rate = []  # New list for heart rate data
    for record in app_fit.records:
        message = record.message
        if isinstance(message, RecordMessage):
            timestamp.append(message.timestamp)
            distance.append(message.distance)
            power.append(message.power)
            speed.append(message.speed)
            cadence.append(message.cadence)
            elevation.append(message.altitude)  # Extract elevation data
            heart_rate.append(message.heart_rate)  # Extract heart rate data

    start_timestamp = timestamp[0]
    time = np.array(timestamp)
    power = np.array(power)
    speed = np.array(speed)
    cadence = np.array(cadence)
    elevation = np.array(elevation)  # Convert elevation list to numpy array
    heart_rate = np.array(heart_rate)  # Convert heart rate list to numpy array
    distance = np.array(distance)  # Convert distance list to numpy array
    time = (time - start_timestamp) / 1000.0  # seconds

    plot_data(power, time, speed, cadence, elevation, heart_rate)
    print_statistics(speed, cadence, power, heart_rate)

    # Calculate elevation climbed and descended
    elevation_climbed, elevation_descended = calculate_elevation_changes(elevation)
    print(f"Elevation climbed: {elevation_climbed:.2f} meters")
    print(f"Elevation descended: {elevation_descended:.2f} meters")

    # Print maximum values
    print_max_values(power, speed, heart_rate, elevation)
    
    # Initialize training zones
    training_zones = TrainingZones()

    # Calculate time spent in each training zone
    zone_times = training_zones.time_in_zones(power, time)
    for zone, time_in_zone in zone_times.items():
        hours, remainder = divmod(time_in_zone * time[-1], 3600)
        minutes, seconds = divmod(remainder, 60)
        print(f"Time spent in power {zone}: {int(hours)} hours, {int(minutes)} minutes, {int(seconds)} seconds")

    # Calculate the 30-second interval with the highest average power
    calculate_highest_average_power_interval(power, time)

    # Calculate Normalized Power
    normalized_power = calculate_normalized_power(power, time)
    print(f"Normalized Power: {normalized_power:.2f} W")

    # Define a person
    cyclist = Person(height=1.75, weight=70, ftp=250)  # Example values for height (meters), weight (kg), and FTP (watts)

    # Update cyclist's training metrics
    cyclist.update_training_metrics(normalized_power, len(time))

    # Print the person's metrics
    print(f"Person's TSS: {cyclist.tss:.2f}")
    print(f"Person's CTL: {cyclist.ctl:.2f}")
    print(f"Person's ATL: {cyclist.atl:.2f}")
    print(f"Person's Form: {cyclist.form:.2f}")

    # Calculate total distance covered
    total_distance = calculate_total_distance(distance)
    print(f"Total Distance Covered: {total_distance:.2f} meters")

    # Write data to JSON
    write_data_to_json(timestamp, power, speed, cadence, elevation, heart_rate, zone_times, normalized_power, cyclist, elevation_climbed, elevation_descended, total_distance)

def plot_data(power, time, speed, cadence, elevation, heart_rate):
    """ Plot power, speed, cadence, elevation, and heart rate """
    fig, axs = plt.subplots(5, 1, sharex=True, figsize=(8, 12))
    
    axs[0].plot(time, power, label='Power (W)')
    axs[0].set_ylabel('Power (W)')
    axs[0].legend()
    
    axs[1].plot(time, speed, label='Speed (m/s)')
    axs[1].set_ylabel('Speed (m/s)')
    axs[1].legend()
    
    axs[2].plot(time, cadence, label='Cadence (rpm)')
    axs[2].set_ylabel('Cadence (rpm)')
    axs[2].legend()
    
    axs[3].plot(time, elevation, label='Elevation (m)')
    axs[3].set_ylabel('Elevation (m)')
    axs[3].legend()
    
    axs[4].plot(time, heart_rate, label='Heart Rate (bpm)', color='red')
    axs[4].set_ylabel('Heart Rate (bpm)')
    axs[4].set_xlabel('Time (s)')
    axs[4].legend()
    
    plt.tight_layout()
    plt.show()

def print_statistics(speed, cadence, power, heart_rate):
    """ Print average speed, cadence, power, and heart rate """
    avg_speed = np.mean(speed) * 3.6
    avg_cadence = np.mean(cadence)
    avg_power = np.mean(power)
    avg_heart_rate = np.mean(heart_rate)
    
    print(f"Average Speed: {avg_speed:.2f} km/h")
    print(f"Average Cadence: {avg_cadence:.2f} rpm")
    print(f"Average Power: {avg_power:.2f} W")
    print(f"Average Heart Rate: {avg_heart_rate:.2f} bpm")

def calculate_highest_average_power_interval(power, time):
    """ Calculate the 30-second interval with the highest average power """
    # Assuming each interval is 30 seconds
    interval_length = 300
    num_intervals = len(power) // interval_length

    # Calculate the average power for each interval
    averages = [np.mean(power[i*interval_length:(i+1)*interval_length]) for i in range(num_intervals)]

    # Find the maximum average power value
    max_average_power = max(averages)

    print(f"The highest average power in any {interval_length}-second interval is: {max_average_power:.2f}.")

def calculate_normalized_power(power, time):
    """
    Calculate the Normalized Power for the workout.

    Parameters:
        power (numpy.array): Array of power data.
        time (numpy.array): Array of time data.

    Returns:
        float: Normalized Power.
    """
    # Step 1: Calculate a rolling 30-second average power
    rolling_average_power = np.convolve(power, np.ones(30) / 30, mode='valid')
    
    # Step 2: Raise the resulting values to the fourth power
    rolling_average_power_fourth = np.power(rolling_average_power, 4)
    
    # Step 3: Determine the average of these values
    average_power_fourth = np.mean(rolling_average_power_fourth)
    
    # Step 4: Finally, take the fourth root of that average
    normalized_power = np.power(average_power_fourth, 0.25)
    
    return normalized_power

def calculate_elevation_changes(elevation):
    """
    Calculate the elevation climbed and descended for the workout.

    Parameters:
        elevation (numpy.array): Array of elevation data.

    Returns:
        float: Elevation climbed.
        float: Elevation descended.
    """
    elevation_climbed = 0
    elevation_descended = 0
    for i in range(1, len(elevation)):
        diff = elevation[i] - elevation[i-1]
        if diff > 0:
            elevation_climbed += diff
        elif diff < 0:
            elevation_descended -= diff  # Make it positive
    return elevation_climbed, elevation_descended

def calculate_total_distance(distance):
    """
    Calculate the total distance covered during the workout.

    Parameters:
        distance (numpy.array): Array of distance data.

    Returns:
        float: Total distance covered.
    """
    return np.max(distance) - np.min(distance)

def print_max_values(power, speed, heart_rate, elevation):
    """
    Print maximum values of power, speed, heart rate, and elevation.

    Parameters:
        power (numpy.array): Array of power data.
        speed (numpy.array): Array of speed data.
        heart_rate (numpy.array): Array of heart rate data.
        elevation (numpy.array): Array of elevation data.
    """
    max_power = np.max(power)
    max_speed = np.max(speed) * 3.6
    max_heart_rate = np.max(heart_rate)
    max_elevation = np.max(elevation)

    print(f"Max Power: {max_power:.2f} W")
    print(f"Max Speed: {max_speed:.2f} km/h")
    print(f"Max Heart Rate: {max_heart_rate:.1f} bpm")
    print(f"Max Elevation: {max_elevation:.1f} meters")

def calculate_intensity_factor(normalized_power, FTP):
    """
    Calculate the Intensity Factor (IF).

    Parameters:
        normalized_power (float): Normalized Power.
        FTP (float): Functional Threshold Power.

    Returns:
        float: Intensity Factor.
    """
    return normalized_power / FTP

def calculate_tss(seconds, normalized_power, intensity_factor, FTP):
    """
    Calculate the Training Stress Score (TSS).

    Parameters:
        seconds (int): Total duration of the workout in seconds.
        normalized_power (float): Normalized Power.
        intensity_factor (float): Intensity Factor.
        FTP (float): Functional Threshold Power.

    Returns:
        float: Training Stress Score.
    """
    return (seconds * normalized_power * intensity_factor) / (FTP * 3600) * 100

def calculate_ctl(ctl_yesterday, tss_today):
    """
    Calculate the Chronic Training Load (CTL).

    Parameters:
        ctl_yesterday (float): CTL value from yesterday.
        tss_today (float): TSS value for today.

    Returns:
        float: CTL value for today.
    """
    return ctl_yesterday + (tss_today - ctl_yesterday) / 42

def calculate_atl(atl_yesterday, tss_today):
    """
    Calculate the Acute Training Load (ATL).

    Parameters:
        atl_yesterday (float): ATL value from yesterday.
        tss_today (float): TSS value for today.

    Returns:
        float: ATL value for today.
    """
    return atl_yesterday + (tss_today - atl_yesterday) / 7

def calculate_tsb(ctl_today, atl_today):
    """
    Calculate the Training Stress Balance (TSB).

    Parameters:
        ctl_today (float): CTL value for today.
        atl_today (float): ATL value for today.

    Returns:
        float: TSB value for today.
    """
    return ctl_today - atl_today

def write_data_to_json(timestamp, power, speed, cadence, elevation, heart_rate, zone_times, normalized_power, cyclist, elevation_climbed, elevation_descended, total_distance):
    """ Write the training data to a JSON file """
    data = {
        'timestamp': np.array(timestamp).tolist(),  # Convert to NumPy array before calling tolist
        'power': power.tolist(),
        'speed': speed.tolist(),
        'cadence': cadence.tolist(),
        'elevation': elevation.tolist(),
        'heart_rate': heart_rate.tolist(),
        'zone_times': zone_times,
        'normalized_power': normalized_power,
        'cyclist_metrics': {
            'tss': cyclist.tss,
            'ctl': cyclist.ctl,
            'atl': cyclist.atl,
            'form': cyclist.form
        },
        'elevation_climbed': elevation_climbed,
        'elevation_descended': elevation_descended,
        'total_distance': total_distance
    }
    
    with open('training_data.json', 'w') as json_file:
        json.dump(data, json_file, indent=4)
    print('Training data written to training_data.json')

if __name__ == "__main__":
    main()
