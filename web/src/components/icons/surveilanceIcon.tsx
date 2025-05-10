const SurveilanceIcon = ({ color = '#00A2FF' }: { color?: string }) => {
    return (
        <svg width='25' height='25' viewBox='28 20 15 15' fill='none' xmlns='http://www.w3.org/2000/svg'>
            <g filter='url(#filter0_d_1206_350)'>
                <path d='M38.4112 20.8799C39.2173 20.3932 40.188 21.1889 39.8689 22.0748L36.1308 32.454C35.8347 33.2762 34.7006 33.3498 34.3008 32.5727L32.7153 29.4915C32.5818 29.2322 32.3419 29.044 32.0582 28.9763L29.375 28.3361C28.5047 28.1284 28.3243 26.9698 29.0903 26.5073L38.4112 20.8799Z' fill={color === 'white' ? '#00A2FF' : 'white'} />
                <path d='M38.6696 21.308C39.0474 21.0799 39.4972 21.415 39.4207 21.8227L39.3984 21.9054L35.6608 32.2847C35.522 32.6699 35.0149 32.7264 34.7873 32.4122L34.7458 32.3441L33.1603 29.2627C32.9851 28.9222 32.6868 28.6638 32.3299 28.5365L32.1748 28.4901L29.4911 27.8497C29.0832 27.7524 28.9785 27.2375 29.2824 26.9829L29.3492 26.9353L38.6696 21.308Z' stroke={color} />
            </g>
            <defs>
                <filter id='filter0_d_1206_350' x='-11.1451' y='0.856049' width='90.828' height='91.8868' filterUnits='userSpaceOnUse' colorInterpolationFilters='sRGB'>
                    <feFlood floodOpacity='0' result='BackgroundImageFix' />
                    <feColorMatrix in='SourceAlpha' type='matrix' values='0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0' result='hardAlpha' />
                    <feOffset dy='19.8759' />
                    <feGaussianBlur stdDeviation='19.8759' />
                    <feColorMatrix type='matrix' values='0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.28 0' />
                    <feBlend mode='normal' in2='BackgroundImageFix' result='effect1_dropShadow_1206_350' />
                    <feBlend mode='normal' in='SourceGraphic' in2='effect1_dropShadow_1206_350' result='shape' />
                </filter>
            </defs>
        </svg>
    );
};

export default SurveilanceIcon;
