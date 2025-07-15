import Sidebar from '@/components/sidebar';

export default function ProtectedLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <main className='flex min-h-screen'>
            <Sidebar />
            <div className='flex-1 p-6transition-all duration-300'>{children}</div>
        </main>
    );
}
