'use client';

import React from 'react';
import Lottie from 'lottie-react';
import busLoading from '@/assets/animations/bus-loading.json';

const LoadingPage: React.FC = () => {
    return (
        <div className='relative h-screen w-full inset-0 z-50 flex flex-col items-center justify-center bg-white bg-opacity-95 text-center'>
            <div className='w-40 max-w-xs h-32 mb-6 flex items-center justify-center mx-auto'>
                <Lottie animationData={busLoading} loop autoplay style={{ width: '100%', height: '100%' }} />
            </div>

            <h1 className='text-4xl md:text-5xl font-bold text-blue-600'>Sakay</h1>

            <p className='text-gray-500 text-lg md:text-xl mt-2'>Tracking your ride...</p>

            <div className='mt-8 flex items-center justify-center'>
                <div className='w-12 h-12 border-4 border-blue-600 border-dashed rounded-full animate-spin'></div>
            </div>
        </div>
    );
};

export default LoadingPage;
