# LoRa Modulation on iOS Project

This repository contains the necessary backend code and MATLAB scripts to simulate the transmission and decoding of binary datagrams using LoRa modulation. This setup is designed to work with an iOS application that captures and sends audio data to a backend server where it is processed to retrieve the encoded data.

## Repository Contents
- `modulation.m`: MATLAB script for generating LoRa modulated audio signals based on binary datagrams.
- `api_code/`: Directory containing the Node.js API and associated MATLAB scripts for demodulation.
- `api_code/api.js`: Node.js server script to handle requests and trigger MATLAB processing.
- `api_code/binary_lora_converter.m`: MATLAB script called by the API to demodulate received audio and extract the binary datagram.

## Getting Started

Follow these steps to set up and run the project:

### 1. Clone the Repository
Start by cloning this repository to your local machine. Use the following command:
```bash
git clone https://github.com/Stuartwastaken/lora-modulation-ios.git
```

### 2. Set Up the Node.js API
Navigate to the `api_code` directory and install the required Node.js packages:
```
cd loramodulation-ios/api_code
npm install
```
Start the API server:
```
node api.js
```
The server will start on `http://localhost:3000`.

### 3. Configure ngrok for External Access
To allow the iOS app to communicate with your local API server, use ngrok to expose your server to the internet:
1. Download and install ngrok from [https://ngrok.com/](https://ngrok.com/).
2. In a new terminal within the `api_code` directory, run:
   ```
   ngrok http 3000
   ```
3. Copy the generated ngrok URL (e.g., `https://12345.ngrok.io`). This URL forwards to your local server.

### 4. Integrate with the iOS App
The iOS application, `ContentView.swift`, is a crucial part of our system, managing the audio capture, playback, and data transmission processes. The app utilizes the SwiftUI framework and AVFoundation for handling audio functionalities.

You can view and utilize the complete Swift application code from the following GitHub repository:
[ContentView.swift](https://github.com/Stuartwastaken/SoundController/blob/recieve-audio/underwater/underwater/ContentView.swift)

#### Functionality Overview:
- **Recording Audio:** Users can start and stop audio recording through the app interface. The audio is recorded in m4a format and saved locally.
- **Playing Audio:** Recorded audio can be played back to ensure the recording's quality and integrity.
- **Sending Audio:** The app sends the recorded audio file to a specified server endpoint. It constructs a multipart/form-data request and handles the response asynchronously, displaying server feedback in the app interface.

#### Key Swift Code Explanation:
- The `ContentView` struct defines the user interface and state management for recording, playing, and sending audio.
- `AVAudioRecorder` is used for recording audio, and `AVAudioPlayer` for playback.
- Network requests are made using `URLSession` to upload audio files to a remote server via HTTP POST requests.
- Error handling and user feedback are provided through the app's UI in response to various events such as successful transmission or errors.

Ensure that the iOS app is set up to record audio and send it to this endpoint:
```
<ngrok_url>/upload
```
Replace `<ngrok_url>` with your actual ngrok URL configured in previous steps.


### 5. Using the MATLAB Script
Modify the `modulation.m` script to change the binary datagram:
```
binary_data = [1 1 0 0]; % Change this line to modify the datagram
```
Run the script in MATLAB to generate a new LoRa modulated audio signal based on your binary data. The modulation uses a Spreading Factor (SF) of 18 and a frequency band of 125 kHz.

### 6. Receive and Process Audio on the Server
When the iOS app sends an audio file to the server, `api.js` processes it using `binary_lora_converter.m`, which demodulates the audio and extracts the binary datagram, returning it as a string to the iOS app.

