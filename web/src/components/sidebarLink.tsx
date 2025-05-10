import Link from 'next/link';
import { useState } from 'react';

interface SidebarLinkProps {
    icon: React.ReactNode;
    hoverIcon: React.ReactNode;
    name: string;
    route: string;
}

const SidebarLink = ({ icon, hoverIcon, name, route }: SidebarLinkProps) => {
    const [isHovered, setIsHovered] = useState(false);

    return (
        <li className='w-full px-5 py-1'>
            <Link href={route} className='w-[95%] h-10 px-3 hover:bg-primary hover:text-background rounded-md flex space-x-4 items-center' onMouseEnter={() => setIsHovered(true)} onMouseLeave={() => setIsHovered(false)}>
                <span>{isHovered ? hoverIcon : icon}</span>
                <label>{name}</label>
            </Link>
        </li>
    );
};

export default SidebarLink;
