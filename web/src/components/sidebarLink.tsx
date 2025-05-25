import Link from 'next/link';
import { useState } from 'react';

interface SidebarLinkProps {
    icon: React.ReactNode;
    hoverIcon: React.ReactNode;
    name: string;
    route: string;
    collapsed: boolean;
}

const SidebarLink = ({ icon, hoverIcon, name, route, collapsed }: SidebarLinkProps) => {
    const [isHovered, setIsHovered] = useState(false);

    return (
        <li className='w-full px-5 py-2'>
            <Link href={route} className={`w-[95%] h-10 rounded-md flex items-center hover:bg-primary hover:text-background transition-all duration-200 ${collapsed ? 'justify-center' : 'justify-start px-3 space-x-4'}`} onMouseEnter={() => setIsHovered(true)} onMouseLeave={() => setIsHovered(false)}>
                <span className={`flex items-center justify-center w-7 h-7`}>{isHovered ? hoverIcon : icon}</span>
                <label className={`cursor-pointer font-medium ${collapsed ? 'w-0 hidden' : 'w-[80%]'}`}>{name}</label>
            </Link>
        </li>
    );
};

export default SidebarLink;
