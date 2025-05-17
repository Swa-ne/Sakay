'use client';
import { useState } from 'react';
import SurveilanceIcon from './icons/surveilanceIcon';
import MapsIcon from './icons/mapsIcon';
import ReportsIcon from './icons/reportsIcon';
import UserVerificationIcon from './icons/userVerificationIcon';
import InboxIcon from './icons/inboxIcon';
import ProfileIcon from './icons/profileIcon';
import ManageAccountsIcon from './icons/manageAccountsIcon';
import RegisteredUnitsIcon from './icons/registeredUnitsIcon';
import SidebarLink from './sidebarLink';
import Image from 'next/image';
import LogoutIcon from './icons/logoutIcon';

export default function Sidebar() {
    const [collapsed, setCollapsed] = useState(false);
    const [isLogoutHovered, setIsLogoutHovered] = useState(false);

    const url_details = [
        { name: 'Surveilance', icon: <SurveilanceIcon />, hoverIcon: <SurveilanceIcon color='white' />, route: '' },
        { name: 'Maps', icon: <MapsIcon />, hoverIcon: <MapsIcon color='white' />, route: 'maps' },
        { name: 'Reports', icon: <ReportsIcon />, hoverIcon: <ReportsIcon color='white' />, route: 'reports' },
        { name: 'User Verification', icon: <UserVerificationIcon />, hoverIcon: <UserVerificationIcon color='white' />, route: 'user_verification' },
        { name: 'Inbox', icon: <InboxIcon />, hoverIcon: <InboxIcon color='white' />, route: 'inbox' },
        { name: 'Profile', icon: <ProfileIcon />, hoverIcon: <ProfileIcon color='white' />, route: 'profile' },
        { name: 'Manage Accounts', icon: <ManageAccountsIcon />, hoverIcon: <ManageAccountsIcon color='white' />, route: 'manage_accounts' },
        { name: 'Registered Units', icon: <RegisteredUnitsIcon />, hoverIcon: <RegisteredUnitsIcon color='white' />, route: 'registered_units' },
    ];

    return (
        <div className={`text-[#888888] transition-all duration-300 ${collapsed ? 'w-20' : 'w-64'}`}>
            <div className='flex items-center justify-end p-4'>
                <svg xmlns='http://www.w3.org/2000/svg' width='18' height='12' viewBox='0 0 18 12' fill='none' onClick={() => setCollapsed(!collapsed)}>
                    <path d='M0 12V10H13V12H0ZM16.6 11L11.6 6L16.6 1L18 2.4L14.4 6L18 9.6L16.6 11ZM0 7V5H10V7H0ZM0 2V0H13V2H0Z' fill='#888888' />
                </svg>
            </div>
            <div className={`w-full h-1/6 flex justify-center mt-2 mb-7 transition-all duration-300 ${collapsed && 'hidden'}`}>
                <div className='aspect-square h-full relative rounded-full overflow-hidden border-2 border-[#888888]'>
                    <Image src='/profile.jpg' fill className='object-contain' alt='Sakay user profile picture' />
                </div>
            </div>
            <ul>
                {url_details.map((url_detail) => (
                    <SidebarLink key={url_detail.name} {...url_detail} />
                ))}
            </ul>
            <div className='w-full flex justify-center'>
                <div className='border-t w-[75%] my-4 border-[#888888]'></div>
            </div>
            <div className='w-full px-5 py-1'>
                <div className='w-full h-10 px-3 hover:bg-primary hover:text-background rounded-md flex space-x-4 items-center' onMouseEnter={() => setIsLogoutHovered(true)} onMouseLeave={() => setIsLogoutHovered(false)}>
                    <span>
                        <LogoutIcon color={isLogoutHovered ? 'white' : '#00A2FF'} />
                    </span>
                    <label>Log out</label>
                </div>
            </div>
        </div>
    );
}
