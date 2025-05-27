interface CircularPercentage {
    percent: number;
}
const CircularPercentage = ({ percent }: CircularPercentage) => {
    return (
        <>
            <svg className='w-32 h-32 transform -rotate-90' viewBox='0 0 120 120'>
                <circle cx='60' cy='60' r='50' stroke='#e5e7eb' strokeWidth='8' fill='none' />
                <circle cx='60' cy='60' r='50' stroke='#10b981' strokeWidth='8' fill='none' strokeDasharray={`${percent * 3.14159} ${(100 - percent) * 3.14159}`} strokeLinecap='round' />
            </svg>
            <div className='absolute inset-0 flex items-center justify-center'>
                <span className='text-2xl font-bold text-gray-900'>{percent}%</span>
            </div>
        </>
    );
};

export default CircularPercentage;
