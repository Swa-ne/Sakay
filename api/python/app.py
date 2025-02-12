from flask import Flask, request, send_file, jsonify
from dotenv import load_dotenv
from email.message import EmailMessage
import os
import ssl
import smtplib

load_dotenv()

app = Flask(__name__)

_emailSender = os.getenv("EMAIL_SENDER")
_emailPassword = os.getenv("EMAIL_PASSWORD")


@app.route("/send-email-code", methods=["POST"])
def sendEmailCode():
    data = request.json
    name = data.get('name')
    code = data.get('code')
    emailReceiver = data.get('receiver')
    
    if not name or not code or not emailReceiver:
        return jsonify(message="Missing required fields"), 400

    em = EmailMessage()

    image_url = request.url_root + 'image-logo'
    body = f"""
    <html>
    <head>
        <style>
            .container {{
                font-family: Arial, sans-serif;
                max-width: 600px;
                margin: 0 auto;
                text-align: center;
                color: #484848;
            }}
            .header-logo img {{
                width: 72px;
                margin-bottom: 20px;
            }}
            .button {{
                background-color: #FF5A5F;
                color: white;
                text-decoration: none;
                padding: 12px 24px;
                border-radius: 4px;
                display: inline-block;
                margin: 20px 0;
                font-weight: bold;
            }}
            .footer {{
                font-size: 12px;
                color: #9E9E9E;
                margin-top: 40px;
            }}
            .footer a {{
                color: #9E9E9E;
                text-decoration: none;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header-logo">
                <img src="{image_url}" alt="Sakay Logo">
            </div>
            <p>Hi {name},</p>
            <p>Verifying your email address improves the security of your Sakay account. Please enter the following code when prompted:</p>
            <p>Please note: This code will expire in 20 minutes</p>
            <h1 style="letter-spacing: 5px;">{code}</h1>
            <p>Thanks,<br>The Sakay Team</p>
        </div>
    </body>
    </html>
    """
    
    em['Subject'] = "Email Verification"
    em['From'] = _emailSender
    em['To'] = emailReceiver
    em.set_content(body, subtype='html')

    try:
        context = ssl.create_default_context()
        with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp_connection:
            smtp_connection.login(_emailSender, _emailPassword)
            smtp_connection.sendmail(_emailSender, emailReceiver, em.as_string())
        return jsonify(message="Email Sent"), 200
    except smtplib.SMTPException as e:
        return jsonify(message=f"Failed to send email: {str(e)}"), 500


@app.route("/send-email-forget-password", methods=["POST"])
def sendEmailForgetPassword():
    data = request.json
    name = data.get('name')
    code = data.get('code')
    emailReceiver = data.get('receiver')
    
    if not name or not code or not emailReceiver:
        return jsonify(message="Missing required fields"), 400

    em = EmailMessage()
    image_url = request.url_root + 'image-logo'
    body = f"""
    <html>
    <head>
        <style>
            .container {{
                font-family: Arial, sans-serif;
                max-width: 600px;
                margin: 0 auto;
                text-align: center;
                color: #484848;
            }}
            .header-logo img {{
                width: 72px;
                margin-bottom: 20px;
            }}
            .button {{
                background-color: #FF5A5F;
                color: white;
                text-decoration: none;
                padding: 12px 24px;
                border-radius: 4px;
                display: inline-block;
                margin: 20px 0;
                font-weight: bold;
            }}
            .footer {{
                font-size: 12px;
                color: #9E9E9E;
                margin-top: 40px;
            }}
            .footer a {{
                color: #9E9E9E;
                text-decoration: none;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header-logo">
                <img src="{image_url}" alt="Sakay Logo">
            </div>
            <p>Hi {name},</p>
            <p>We've received a request to verify your email address for your Sakay account.</p>
            <p>If you didn't make the request, just ignore this message. Otherwise, you can use the code below to verify your email:</p>
            <p>Please note: This code will expire in 2 hours.</p>
            <h1 style="letter-spacing: 5px;">{code}</h1>
            <p>Thanks,<br>The Sakay Team</p>
        </div>
    </body>
    </html>
    """
            # <div class="footer">
            #     <p>Sakay, Inc., 123 Street Name, City, Country</p>
            # </div> 
    
    em['Subject'] = "Email Verification"
    em['From'] = _emailSender
    em['To'] = emailReceiver
    em.set_content(body, subtype='html')

    try:
        context = ssl.create_default_context()
        with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp_connection:
            smtp_connection.login(_emailSender, _emailPassword)
            smtp_connection.sendmail(_emailSender, emailReceiver, em.as_string())
        return jsonify(message="Email Sent"), 200
    except smtplib.SMTPException as e:
        return jsonify(message=f"Failed to send email: {str(e)}"), 500


@app.route('/image-logo')
def display_logo():
    image_path = 'logo.png'
    return send_file(image_path, mimetype='image/png')

@app.route('/')
def index(): 
    return "Hello guys"

if __name__ == "_main_":
    app.run(debug=True)