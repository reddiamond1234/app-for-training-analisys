import os
import matplotlib.pyplot as plt
import numpy as np
from fit_tool.fit_file import FitFile
from fit_tool.profile.messages.record_message import RecordMessage
from fit_tool.profile.messages.file_id_message import FileIdMessage

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
    time = (time - start_timestamp) / 1000.0  # seconds

    plot_data(power, time, speed, cadence, elevation, heart_rate)
    print_statistics(speed, cadence, power, heart_rate)


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

if __name__ == "__main__":
    main()
