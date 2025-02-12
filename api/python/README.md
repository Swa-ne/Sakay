# Setup Instructions

To set up the environment and run the app, follow these steps:

1. **Create a Virtual Environment:**

    ```bash
    python -m venv venv
    ```

2. **Activate the Virtual Environment:**

    - On Windows:

    ```bash
    venv\Scripts\activate
    ```

    - On macOS/Linux:

    ```bash
    source venv/bin/activate
    ```

3. **Install Dependencies:**

    ```bash
    pip install -r requirements.txt
    ```

4. **Create a `.env` File:**
   Create a `.env` file in the root directory with the following content:

    - EMAIL_SENDER=(PM me for this)
    - EMAIL_PASSWORD=(PM me for this)

5. **Run the Application:**

```bash
flask run
```
