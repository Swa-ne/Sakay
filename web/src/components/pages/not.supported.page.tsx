'use client';

import React from 'react';
import Lottie from 'lottie-react';

import unsupportedAnimation from '@/assets/animations/warning.json';

const NotSupportedPage: React.FC = () => {
    return (
        <div className="flex flex-col items-center justify-center h-screen bg-gray-100 px-4 text-center">

            <div className="w-64 h-64 mb-6">
                <Lottie animationData={unsupportedAnimation} loop={true} />
            </div>

            <h1 className="text-3xl font-bold text-gray-800 mb-2">Unsupported Device or Browser</h1>

            <p className="text-gray-600 text-lg max-w-md">
                We're sorry, but this application is not supported on your current device or browser.
                Please try using a modern browser like Chrome, Firefox, Safari, or Edge.
            </p>

            <button
                onClick={() => window.location.reload()}
                className="mt-10 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
            >
                Retry
            </button>
        </div>
    );
};

export default NotSupportedPage;


