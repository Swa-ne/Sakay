'use client';
import { useState } from 'react';
import SurveilanceIcon from './icons/surveilanceIcon';
import ReportsIcon from './icons/reportsIcon';
import UserVerificationIcon from './icons/userVerificationIcon';
import InboxIcon from './icons/inboxIcon';
import ManageAccountsIcon from './icons/manageAccountsIcon';
import SidebarLink from './sidebarLink';
import Image from 'next/image';
import LogoutIcon from './icons/logoutIcon';
import Link from 'next/link';

export default function Sidebar() {
    const [collapsed, setCollapsed] = useState(false);
    const [isLogoutHovered, setIsLogoutHovered] = useState(false);

    const url_details = [
        { name: 'Surveilance', icon: <SurveilanceIcon />, hoverIcon: <SurveilanceIcon color='white' />, route: '' },
        { name: 'Reports', icon: <ReportsIcon />, hoverIcon: <ReportsIcon color='white' />, route: 'reports' },
        { name: 'User Verification', icon: <UserVerificationIcon />, hoverIcon: <UserVerificationIcon color='white' />, route: 'user_verification' },
        { name: 'Inbox', icon: <InboxIcon />, hoverIcon: <InboxIcon color='white' />, route: 'inbox' },
        { name: 'Accounts & Units', icon: <ManageAccountsIcon />, hoverIcon: <ManageAccountsIcon color='white' />, route: 'account_and_units' },
    ];

    return (
        <div className={`h-screen text-text transition-all duration-300 border-r-1 border-primary ${collapsed ? 'w-20' : 'w-72'} flex justify-between flex-col`}>
            <div>
                <div className='flex items-center justify-end p-4'>
                    <svg xmlns='http://www.w3.org/2000/svg' width='18' height='12' viewBox='0 0 18 12' fill='none' onClick={() => setCollapsed(!collapsed)}>
                        <path d='M0 12V10H13V12H0ZM16.6 11L11.6 6L16.6 1L18 2.4L14.4 6L18 9.6L16.6 11ZM0 7V5H10V7H0ZM0 2V0H13V2H0Z' fill='#00a2ff' />
                    </svg>
                </div>
                <div className={`w-full px-5 py-1 mb-7`}>
                    <Link href='/profile' className={`w-[95%] transition-all duration-300 ${collapsed ? 'h-10 w-10' : 'h-12'} flex items-center rounded-md hover:bg-primary hover:text-background ${collapsed ? 'justify-center' : 'justify-start px-3 space-x-4'}`}>
                        <div className='relative w-7 h-7 rounded-full overflow-hidden aspect-square'>
                            <Image src='/profile.jpg' fill className='object-cover ' alt='Sakay user profile picture' />
                        </div>
                        <label className={`cursor-pointer  ${collapsed ? 'w-0 hidden' : 'w-[70%]'} flex flex-col`}>
                            <span className='font-semibold text-ellipsis whitespace-nowrap overflow-hidden'>Swaners</span>
                            <span className='text-sm text-ellipsis whitespace-nowrap overflow-hidden'>swane@gmail.com</span>
                        </label>
                    </Link>
                </div>
                <ul>
                    {url_details.map((url_detail) => (
                        <SidebarLink key={url_detail.name} {...url_detail} collapsed={collapsed} />
                    ))}
                </ul>
            </div>

            <div className='w-full px-5 py-1 mb-3'>
                <div className={`w-[95%] h-10 rounded-md flex items-center hover:bg-primary hover:text-background transition-all duration-200 ${collapsed ? 'justify-center' : 'justify-start px-3 space-x-4'}`} onMouseEnter={() => setIsLogoutHovered(true)} onMouseLeave={() => setIsLogoutHovered(false)}>
                    <span className={`flex items-center justify-center w-7 h-7`}>
                        <LogoutIcon color={isLogoutHovered ? 'white' : '#00A2FF'} />
                    </span>
                    <label className={`cursor-pointer font-medium ${collapsed ? 'w-0 hidden' : 'w-[80%]'}`}>Log out</label>
                </div>
            </div>
        </div>
    );
}
