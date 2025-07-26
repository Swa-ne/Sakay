'use client';

import React from 'react';
import Lottie from 'lottie-react';
import busLoading from '@/assets/animations/bus-loading.json';

const LoadingPage: React.FC = () => {
    return (
        <div className="flex flex-col items-center justify-center h-screen bg-white text-center">
            <div className="w-50 h-40 mb-6">
                <Lottie animationData={busLoading} loop autoplay />
            </div>

            <h1 className="text-4xl font-bold text-blue-600">Sakay</h1>

            <p className="text-gray-500 text-lg mt-2">Tracking your ride...</p>

            <div className="mt-8">
                <div className="w-12 h-12 border-4 border-blue-600 border-dashed rounded-full animate-spin"></div>
            </div>
        </div>
    );
};

export default LoadingPage;
