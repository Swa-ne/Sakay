'use client';

import React from 'react';

const NotSupportedPage: React.FC = () => {
    return (
        <div className="flex flex-col md:flex-row items-center justify-center min-h-screen bg-black text-white px-6">
            <div className="flex flex-col items-center md:items-start text-center md:text-left md:mr-16">
                <h1 className="text-4xl md:text-5xl font-bold mb-4">
                    Get Sakay for iOS/Android
                </h1>

                <div className="flex space-x-4 mt-6">
                    <a
                        href="#"
                        className="transition transform hover:scale-105"
                    >
                        <img
                            src="/icon/appstore.png"
                            alt="Download on the App Store"
                            className="h-20 w-auto"
                        />
                    </a>
                    <a
                        href="#"
                        className="transition transform hover:scale-105"
                    >
                        <img
                            src="/icon/googleplay.png"
                            alt="Get it on Google Play"
                            className="h-20 w-auto"
                        />
                    </a>
                </div>

                <p className="text-gray-400 text-sm mt-6">
                    🚍 Track your ride in real-time
                </p>
            </div>

            <div className="flex flex-col items-center mt-10 md:mt-0">
                <div className="bg-white p-4 rounded-md shadow-lg">
                    <img
                        src="/icon/qrcode.png"
                        alt="Sakay QR Code"
                        className="w-60 h-60 object-contain"
                    />
                </div>
                <p className="text-white text-sm mt-4">Scan to Download</p>
            </div>
        </div>
    );
};

export default NotSupportedPage;