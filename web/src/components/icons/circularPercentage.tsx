interface CircularPercentageProps {
    percent: number;
    size?: number;
    strokeWidth?: number;
}

const CircularPercentage = ({ percent, size = 80, strokeWidth = 8 }: CircularPercentageProps) => {
    const radius = (size - strokeWidth) / 2;
    const circumference = radius * 2 * Math.PI;
    const offset = circumference - (percent / 100) * circumference;

    return (
        <div className='relative inline-flex items-center justify-center'>
            <svg className='transform -rotate-90' width={size} height={size}>
                <circle cx={size / 2} cy={size / 2} r={radius} stroke='currentColor' strokeWidth={strokeWidth} fill='transparent' className='text-gray-200' />
                <circle cx={size / 2} cy={size / 2} r={radius} stroke='currentColor' strokeWidth={strokeWidth} fill='transparent' strokeDasharray={circumference} strokeDashoffset={offset} className='text-green-500 transition-all duration-300 ease-in-out' strokeLinecap='round' />
            </svg>
            <span className='absolute text-2xl font-bold text-gray-900'>{percent}%</span>
        </div>
    );
};

export default CircularPercentage;
