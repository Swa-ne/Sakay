import { PieChart } from 'lucide-react';

const Report = () => {
    return (
        <div className='w-full h-full bg-white flex items-center justify-center flex-col text-center'>
            <div className='relative mb-8'>
                <div className='absolute top-4 left-8 w-2 h-2 bg-orange-300 rounded-full opacity-60'></div>
                <div className='absolute top-12 right-6 w-1.5 h-1.5 bg-pink-300 rounded-full opacity-60'></div>
                <div className='absolute bottom-4 left-12 w-1 h-1 bg-blue-300 rounded-full opacity-60'></div>

                <div className='relative mx-auto w-60 h-60 mb-6'>
                    <div className='w-full h-full rounded-2xl flex items-center justify-center relative' style={{ background: 'linear-gradient(135deg, #00A2FF 0%, #0088CC 100%)' }}>
                        <div className='absolute top-6 left-1/2 transform -translate-x-1/2 flex space-x-2'>
                            <div className='w-5 h-5 bg-white rounded-full flex items-center justify-center'>
                                <div className='w-3 h-3 bg-black rounded-full'></div>
                            </div>
                            <div className='w-5 h-5 bg-white rounded-full flex items-center justify-center'>
                                <div className='w-3 h-3 bg-black rounded-full'></div>
                            </div>
                        </div>

                        <PieChart className='w-20 h-20 text-white mt-2' />

                        <div className='absolute -bottom-5 left-1/2 transform -translate-x-1/2 flex space-x-4'>
                            <div className='w-3 h-7 rounded-full transform rotate-12' style={{ backgroundColor: '#00A2FF' }}></div>
                            <div className='w-3 h-7 rounded-full transform -rotate-12' style={{ backgroundColor: '#00A2FF' }}></div>
                        </div>

                        <div className='absolute top-1/2 -left-5 transform -translate-y-1/2'>
                            <div className='w-7 h-3 rounded-full transform -rotate-45' style={{ backgroundColor: '#00A2FF' }}></div>
                        </div>
                        <div className='absolute top-1/2 -right-5 transform -translate-y-1/2'>
                            <div className='w-7 h-3 rounded-full transform rotate-45' style={{ backgroundColor: '#00A2FF' }}></div>
                        </div>
                    </div>
                </div>
            </div>

            <div className='space-y-3 mb-8'>
                <h2 className='text-2xl font-semibold mb-2'>No Reports Yet</h2>
                <p className='text-sm leading-relaxed px-2'>{"We'll generate your first report as soon as you have enough data to analyze"}</p>
            </div>
        </div>
    );
};

export default Report;
