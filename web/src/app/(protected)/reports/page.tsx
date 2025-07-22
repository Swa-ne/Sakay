import { PieChart } from 'lucide-react';

const Report = () => {
    return (
        <div className='w-full h-full bg-white flex items-center justify-center flex-col text-center p-4 md:p-8'>
            <div className='relative mb-6 md:mb-8 max-w-md mx-auto'>
                {/* Decorative dots */}
                <div className='absolute top-2 md:top-4 left-4 md:left-8 w-1.5 md:w-2 h-1.5 md:h-2 bg-orange-300 rounded-full opacity-60'></div>
                <div className='absolute top-8 md:top-12 right-3 md:right-6 w-1 md:w-1.5 h-1 md:h-1.5 bg-pink-300 rounded-full opacity-60'></div>
                <div className='absolute bottom-2 md:bottom-4 left-6 md:left-12 w-1 h-1 bg-blue-300 rounded-full opacity-60'></div>

                {/* Main chart container */}
                <div className='relative mx-auto w-40 h-40 sm:w-52 sm:h-52 md:w-60 md:h-60 mb-4 md:mb-6'>
                    <div 
                        className='w-full h-full rounded-xl md:rounded-2xl flex items-center justify-center relative shadow-lg' 
                        style={{ background: 'linear-gradient(135deg, #00A2FF 0%, #0088CC 100%)' }}
                    >
                        {/* Eyes */}
                        <div className='absolute top-3 md:top-6 left-1/2 transform -translate-x-1/2 flex space-x-1 md:space-x-2'>
                            <div className='w-3 h-3 md:w-4 md:h-4 bg-white rounded-full flex items-center justify-center'>
                                <div className='w-1.5 h-1.5 md:w-2 md:h-2 bg-black rounded-full'></div>
                            </div>
                            <div className='w-3 h-3 md:w-4 md:h-4 bg-white rounded-full flex items-center justify-center'>
                                <div className='w-1.5 h-1.5 md:w-2 md:h-2 bg-black rounded-full'></div>
                            </div>
                        </div>

                        {/* Chart icon */}
                        <PieChart className='w-12 h-12 sm:w-16 sm:h-16 md:w-20 md:h-20 text-white mt-1 md:mt-2' />

                        {/* Bottom decorations */}
                        <div className='absolute -bottom-3 md:-bottom-5 left-1/2 transform -translate-x-1/2 flex space-x-2 md:space-x-4'>
                            <div className='w-2 h-4 md:w-3 md:h-7 rounded-full transform rotate-12' style={{ backgroundColor: '#00A2FF' }}></div>
                            <div className='w-2 h-4 md:w-3 md:h-7 rounded-full transform -rotate-12' style={{ backgroundColor: '#00A2FF' }}></div>
                        </div>

                        {/* Side decorations */}
                        <div className='absolute top-1/2 -left-3 md:-left-5 transform -translate-y-1/2'>
                            <div className='w-4 h-1.5 md:w-7 md:h-3 rounded-full transform -rotate-45' style={{ backgroundColor: '#00A2FF' }}></div>
                        </div>
                        <div className='absolute top-1/2 -right-3 md:-right-5 transform -translate-y-1/2'>
                            <div className='w-4 h-1.5 md:w-7 md:h-3 rounded-full transform rotate-45' style={{ backgroundColor: '#00A2FF' }}></div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Text content */}
            <div className='space-y-2 md:space-y-3 mb-6 md:mb-8 max-w-md'>
                <h2 className='text-xl sm:text-2xl font-semibold text-gray-800'>Choose a Report</h2>
                <p className='text-xs sm:text-sm text-gray-600 leading-relaxed px-2'>
                    We'll generate visual reports as soon as you have enough data to analyze.
                    Check back later or start adding more data to see insights.
                </p>
            </div>

            {/* Optional action button */}
            <button className='px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white text-sm sm:text-base rounded-lg transition-colors shadow-sm'>
                Learn About Reports
            </button>
        </div>
    );
};

export default Report;