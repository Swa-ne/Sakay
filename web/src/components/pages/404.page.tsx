'use client';

import React from 'react';
import Lottie from 'lottie-react';
import notFoundAnimation from '@/assets/animations/404-animation.json'; 
const NotFoundPage: React.FC = () => {
    return (
        <div
            className='flex flex-col md:flex-row items-center justify-center min-h-screen bg-white text-black px-6'
            style={{ minHeight: '100vh', minWidth: '100vw' }}
        >

            <div className='flex flex-col items-center mt-10 md:mt-0'>
                <div className='bg-white p-4 rounded-md shadow-lg w-100 h-100 flex items-center justify-center'>
                    <Lottie animationData={notFoundAnimation} loop autoplay className="w-full h-full" />
                </div>
            </div>

            <div className="flex flex-col items-center md:items-start text-center md:text-left md:ml-16 mt-10 md:mt-0">
                <h1 className="text-4xl md:text-5xl font-bold mb-4">
                    OOPS! PAGE NOT FOUND.
                </h1>
                <p className="text-gray-400 text-xl max-w-xl">
                    You must have picked the wrong door because I haven't been able to
                    lay my eye on the page you’ve been searching for.
                </p>

                <a
                    href="/"
                    className="mt-6 bg-blue-500 hover:bg-blue-600 text-white px-8 py-3 rounded-full transition duration-300"
                >
                    BACK TO HOME
                </a>
            </div>
        </div>
    );
};

export default NotFoundPage;
