# Sakay - Real-Time Bus Tracking System

## Project Overview

**Research Title:** Sakay - Developing a Real-Time Bus Tracking System for LDTC to Enhance Operational Efficiency

## Rationale

Public transportation is essential for urban mobility, particularly along the Lingayen-Dagupan route. However, inefficiencies such as delays, overcrowding, and lack of real-time information create significant challenges for both passengers and drivers. The **Sakay** project aims to address these issues by implementing a real-time vehicle tracking system, enhancing commuter experience, reducing waiting times, and improving operational efficiency.

## Objectives

-   Integrate **GPS technology** for real-time tracking of public vehicles, allowing passengers to view vehicle locations and estimated arrival times.
-   Provide a **proximity alarm feature** to notify passengers when they are nearing their destination.
-   Assist drivers in **identifying high-demand areas**, optimizing routes, and reducing idle time.
-   Design a **user-friendly interface** for both passengers and drivers.
-   Promote the use of **public transportation** by improving reliability, efficiency, and accessibility.
-   Contribute to **sustainable urban mobility** by reducing congestion.
-   Ensure **data accuracy and security** through robust backend systems.

## Methodology

The project follows the **Waterfall methodology**, ensuring a structured and sequential development process with clear documentation at each stage.

## Expected Output

-   A fully functional **mobile application** available on **Android and iOS**.
-   Features include:
    -   **Real-time vehicle tracking** with an interactive map.
    -   **Estimated Time of Arrival (ETA)** for approaching vehicles.
    -   **Proximity alert notifications**.
    -   **Optimized route identification** for drivers.

## Potential Impact

-   **Enhanced Commuter Experience**
    -   Reduced waiting time with real-time vehicle tracking.
    -   Better commute planning.
-   **Increased Efficiency for Drivers**
    -   Optimized routes based on high-demand areas.
    -   Reduced idle time and improved income potential.

## Users/Beneficiaries

-   **Commuters:** Students, employees, and tourists who need reliable public transport.
-   **Bus Drivers & Conductors:** Improve route efficiency, maintain schedules, and enhance communication with the operations center.

## Technologies Used

-   **Frontend:** Flutter, Figma
-   **Backend:** TypeScript, Node.js, Express.js, Python
-   **Database:** MongoDB, Redis
-   **Real-Time Communication:** `Socket.io`
-   **Cloud Storage:** Firebase

## Installation & Setup

1. **Clone the repository**:
    ```bash
    git clone https://github.com/Swa-ne/Sakay.git
    cd Sakay
    ```

### Setting up and Running the Flutter App

1. **Install Flutter** by following the instructions at [Flutter's official site](https://flutter.dev/docs/get-started/install).
2. **Navigate to the client directory**:
    ```bash
    cd client
    ```
3. **Install dependencies**:
    ```bash
    flutter pub get
    ```
4. **Open a new terminal** and **run the app** on an emulator or physical device:
    ```bash
    flutter run
    ```

### Setting up and Running the Node.js Backend

1. **Install Node.js** from [Node.js official site](https://nodejs.org/).
2. **Navigate to the API directory**:
    ```bash
    cd api/javascript
    ```
3. **Install dependencies**:
    ```bash
    npm install
    ```
4. **Set up environment variables** by creating a `.env` file and adding necessary configurations. To obtain the required environment variables, message the owner of the repository.
5. **Open a separate terminal** and **start the server**:
    ```bash
    npm run dev
    ```

### Setting up and Running the Python API

1. **Navigate to the Python API directory**:
    ```bash
    cd api/python
    ```
2. **Create a Virtual Environment**:
    ```bash
    python -m venv venv
    ```
3. **Activate the Virtual Environment**:
    - On Windows:
        ```bash
        venv\Scripts\activate
        ```
    - On macOS/Linux:
        ```bash
        source venv/bin/activate
        ```
4. **Install Dependencies**:
    ```bash
    pip install -r requirements.txt
    ```
5. **Set up environment variables** by creating a `.env` file and adding necessary configurations. To obtain the required environment variables, message the owner of the repository.
6. **Run the Application**:
    ```bash
    flask run
    ```

## Contributors

-   [Stephen Paul B. Bautista](https://github.com/Swa-ne) - Full-stack Developer & Team Manager
-   [Christian Joesh C. Majin](https://github.com/ChristianMajin) - Frontend Developer
-   [Lance Matthew G. Manaois](https://github.com/Lance-Matthew) - Project Manager & Full-stack Developer
-   [Mark Joshua B. Sarmiento](https://github.com/mojsarmiento) - Frontend Developer
-   [Jaspher P. Tania](https://github.com/Jaspherr) - UI/UX Designer & Frontend Developer
<!-- ## Contribution Guidelines

To be added.

## License

To be added. -->
