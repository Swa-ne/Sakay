'use client';

import { Geist, Geist_Mono } from 'next/font/google';
import './globals.css';
import { useAuthenticated } from '@/hooks/useAuthenticated';
import LoadingPage from '@/components/pages/loading.page';
import NotSupportedPage from '@/components/pages/not.supported.page';
import Login from '@/components/pages/login.page';
import Sidebar from '@/components/sidebar';

const geistSans = Geist({
    variable: '--font-geist-sans',
    subsets: ['latin'],
});

const geistMono = Geist_Mono({
    variable: '--font-geist-mono',
    subsets: ['latin'],
});

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    const { isAuthenticated, userType } = useAuthenticated();

    let content: React.ReactNode = children;

    if (isAuthenticated === null) {
        content = <LoadingPage />;
    } else if (!isAuthenticated) {
        content = <Login />;
    } else if (userType !== 'ADMIN') {
        content = <NotSupportedPage />;
    } else {
        content = (
            <main className='flex min-h-screen'>
                <Sidebar />
                <div className='flex-1 transition-all duration-300'>{children}</div>
            </main>
        );
    }

    return (
        <html lang='en'>
            <body className={`${geistSans.variable} ${geistMono.variable} antialiased`}>{content}</body>
        </html>
    );
}
