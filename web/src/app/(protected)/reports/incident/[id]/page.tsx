import IncidentReport from '@/components/icons/incidentReport';
import PlaceOfIncident from '@/components/icons/placeOfIncident';
import Image from 'next/image';

const IncidentPage = () => {
    return (
        <div className='h-full overflow-hidden overflow-y-auto'>
            <div className='w-full flex justify-between items-center'>
                <label className='text-4xl font-bold mb-2'>Incident Report</label>
                <span>12:22 PM | 05/03/2025</span>
            </div>
            <div className='w-full flex items-center space-x-1.5 p-2'>
                <IncidentReport />
                <h2 className='text-xl font-bold'>UNIT1-17A</h2>
            </div>
            <p className='m-5'>
                Lorem ipsum dolor sit amet consectetur adipisicing elit. Ratione, dignissimos nisi qui ab consequatur enim possimus natus iusto, hic aliquid perspiciatis ipsa fugit quaerat itaque molestias neque architecto? Hic, minus.consequat exercitation sunt irure nostrud mollit sed veniam sint ipsum eu deserunt et amet tempor aliquip ipsum lorem et anim dolore cillum Duis nostrud exercitation
                quis exercitation adipiscing veniam fugiat fugiat mollit ad elit eiusmod mollit dolore nostrud ex laboris sunt reprehenderit proident pariatur veniam culpa esse mollit veniam ad nostrud anim magna enim anim in sunt ut consectetur est eu reprehenderit non ullamco aliqua cillum sit mollit dolor laboris reprehenderit sit pariatur enim veniam cillum fugiat aute fugiat veniam nostrud eu
                cupidatat non est Duis laborum irure mollit pariatur officia nisi ut reprehenderit id ex laborum Excepteur esse magna enim commodo consequat adipiscing occaecat minim nostrud anim adipiscing Duis et et ipsum anim lorem amet deserunt eiusmod commodo enim do enim aute magna laborum laboris cupidatat eiusmod occaecat incididunt Duis pariatur ullamco officia esse Duis eu amet
                exercitation sint id elit esse Duis et enim minim anim est velit ea laborum minim lorem ea tempor sed minim lorem exercitation nisi culpa proident ex culpa cillum ullamco Excepteur cillum magna laborum exercitation reprehenderit Excepteur qui eu laboris et ad mollit nulla veniam labore cillum nisi culpa lorem velit consectetur magna dolor anim eiusmod ad exercitation officia est
                exercitation sint id elit esse Duis et enim minim anim est velit ea laborum minim lorem ea tempor sed minim lorem exercitation nisi culpa proident ex culpa cillum ullamco Excepteur cillum magna laborum exercitation reprehenderit Excepteur qui eu laboris et ad mollit nulla veniam labore cillum nisi culpa lorem velit consectetur magna dolor anim eiusmod ad exercitation officia est
                exercitation sint id elit esse Duis et enim minim anim est velit ea laborum minim lorem ea tempor sed minim lorem exercitation nisi culpa proident ex culpa cillum ullamco Excepteur cillum magna laborum exercitation reprehenderit Excepteur qui eu laboris et ad mollit nulla veniam labore cillum nisi culpa lorem velit consectetur magna dolor anim eiusmod ad exercitation officia est
                eiusmod aute occaecat Excepteur sunt sunt officia reprehenderit magna non quis aliquip eu esse ipsum est irure ullamco ullamco culpa aute ipsum mollit laboris lorem qui cupidatat cupidatat tempor aute esse anim cillum eiusmod sint sit deserunt eu occaecat irure consectetur proident cupidatat nisi ad dolor id aute nisi eiusmod Duis consequat fugiat
            </p>
            <div className='flex'>
                <div className='w-1/2 border-t-2 p-3 mt-2'>
                    <h3 className='text-lg font-semibold'>Reported by:</h3>
                    <div className='flex items-center m-5 space-x-1'>
                        <div className='relative w-15 rounded-md overflow-hidden aspect-square border-2 border-black'>
                            <Image src='/profile.jpg' fill className='object-fill scale-110' alt='Sakay user profile picture' />
                        </div>
                        <div className='ml-3'>
                            <h3 className='text-lg font-semibold'>Rigor Bartolome</h3>
                            <h3 className='text-lg font-semibold'>093827126374</h3>
                        </div>
                    </div>
                </div>
                <div className='w-1/2 border-t-2 p-3 mt-2'>
                    <h3 className='text-lg font-semibold'>Place of Incident:</h3>
                    <div className='flex items-center m-5 space-x-1 cursor-pointer'>
                        <PlaceOfIncident />
                        <div className='ml-3'>
                            <h3 className='text-lg font-semibold'>Lingayen</h3>
                            <h3 className='text-lg font-semibold opacity-50 hover:underline hover:opacity-100'>View Location</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default IncidentPage;
