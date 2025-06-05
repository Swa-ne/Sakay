'use client';

import { StarRating } from '@/components/ui/star-rating';
import Image from 'next/image';
import { useState } from 'react';

const IncidentPage = () => {
    const [value, setValue] = useState<number>(3.5);
    const [feedback, setFeedback] = useState<boolean>(true);

    return (
        <div className='h-full overflow-hidden overflow-y-auto pb-5'>
            <div className='w-full flex justify-between items-center'>
                <label className='text-4xl font-bold mb-2'>Performance Report</label>
                <span>12:22 PM | 05/03/2025</span>
            </div>
            <div className='p-3'>
                <div className='w-full h-36 flex items-center space-x-1.5 rounded-2xl overflow-hidden shadow-[0px_4px_10px_rgba(0,0,0,0.15)]'>
                    <div className='w-1/5 h-full flex justify-center items-center bg-primary'>
                        <div className='relative h-30 rounded-full overflow-hidden aspect-square'>
                            <Image src='/profile.jpg' fill className='object-fill scale-110' alt='Sakay user profile picture' />
                        </div>
                    </div>
                    <div className='flex-1 h-full p-5'>
                        <div className='flex justify-end'>
                            <h3 className='text-lg font-semibold'>UNIT1-17A</h3>
                        </div>
                        <div>
                            <h2 className='text-xl font-bold'>Rigor Bartolome</h2>
                            <span className='text-md opacity-50'>093827126374</span>
                        </div>
                    </div>
                </div>
                <div className='mt-5'>
                    {feedback && (
                        <>
                            <h2 className='text-xl font-bold'>Feedback</h2>
                            <p className='mx-5 my-2'>
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Ratione, dignissimos nisi qui ab consequatur enim possimus natus iusto, hic aliquid perspiciatis ipsa fugit quaerat itaque molestias neque architecto? Hic, minus.consequat exercitation sunt irure nostrud mollit sed veniam sint ipsum eu deserunt et amet tempor aliquip ipsum lorem et anim dolore cillum Duis
                                nostrud exercitation quis exercitation adipiscing veniam fugiat fugiat mollit ad elit eiusmod mollit dolore nostrud ex laboris sunt reprehenderit proident pariatur veniam culpa esse mollit veniam ad nostrud anim magna enim anim in sunt ut consectetur est eu reprehenderit non ullamco aliqua cillum sit mollit dolor laboris reprehenderit sit pariatur enim veniam cillum
                                fugiat aute fugiat veniam nostrud eu cupidatat non est Duis laborum irure mollit pariatur officia nisi ut reprehenderit id ex laborum Excepteur esse magna enim commodo consequat adipiscing occaecat minim nostrud anim adipiscing Duis et et ipsum anim lorem amet deserunt eiusmod commodo enim do enim aute magna laborum laboris cupidatat eiusmod occaecat incididunt Duis
                                pariatur ullamco officia esse Duis eu amet exercitation sint id elit esse Duis et enim minim anim est velit ea laborum minim lorem ea tempor sed minim lorem exercitation nisi culpa proident ex culpa cillum ullamco Excepteur cillum magna laborum exercitation reprehenderit Excepteur qui eu laboris et ad mollit nulla veniam labore cillum nisi culpa lorem velit
                                consectetur magna dolor anim eiusmod ad exercitation officia est exercitation sint id elit esse Duis et enim minim anim est velit ea laborum minim lorem ea tempor sed minim lorem exercitation nisi culpa proident ex culpa cillum ullamco Excepteur cillum magna laborum exercitation reprehenderit Excepteur qui eu laboris et ad mollit nulla veniam labore cillum nisi
                                culpa lorem velit consectetur magna dolor anim eiusmod ad exercitation officia est exercitation sint id elit esse Duis et enim minim anim est velit ea laborum minim lorem ea tempor sed minim lorem exercitation nisi culpa proident ex culpa cillum ullamco Excepteur cillum magna laborum exercitation reprehenderit Excepteur qui eu laboris et ad mollit nulla veniam
                                labore cillum nisi culpa lorem velit consectetur magna dolor anim eiusmod ad exercitation officia est eiusmod aute occaecat Excepteur sunt sunt officia reprehenderit magna non quis aliquip eu esse ipsum est irure ullamco ullamco culpa aute ipsum mollit laboris lorem qui cupidatat cupidatat tempor aute esse anim cillum eiusmod sint sit deserunt eu occaecat irure
                                consectetur proident cupidatat nisi ad dolor id aute nisi eiusmod Duis consequat fugiat
                            </p>
                        </>
                    )}

                    <h2 className='text-xl font-bold mt-5'>Ratings</h2>
                    <div className='mx-5 my-2 flex space-x-2.5 items-center'>
                        <div className='text-center border-r-2 border-black p-2'>
                            <h1 className='text-7xl font-bold'>4.0</h1>
                            <label className='opacity-40'>Based on 23 ratings</label>
                        </div>
                        <StarRating value={value} setValue={setValue} disabled />
                    </div>
                    <div className='mt-8'>
                        <div className='mx-5 my-4 flex space-x-10 items-center'>
                            <h3 className='w-16 text-lg font-semibold'>Driving</h3>
                            <StarRating value={value} setValue={setValue} disabled starSize='size-15' />
                        </div>
                        <div className='mx-5 my-4 flex space-x-10 items-center'>
                            <h3 className='w-16 text-lg font-semibold'>Service</h3>
                            <StarRating value={value} setValue={setValue} disabled starSize='size-15' />
                        </div>
                        <div className='mx-5 my-4 flex space-x-10 items-center'>
                            <h3 className='w-16 text-lg font-semibold'>Reliability</h3>
                            <StarRating value={value} setValue={setValue} disabled starSize='size-15' />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default IncidentPage;
