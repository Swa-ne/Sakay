'use client';

import Home from '@/components/pages/home.page';
import Login from '@/components/pages/login.page';
import ProtectedLayout from '@/app/(protected)/layout';
import NotSupportedPage from '@/components/pages/not.supported.page';
import { useAuthenticated } from '@/hooks/useAuthenticated';
import LoadingPage from '@/components/pages/loading.page';

export default function Page() {
    const { isAuthenticated, userType } = useAuthenticated();

    if (isAuthenticated === null) return <LoadingPage />;

    return isAuthenticated ? (
        userType == 'ADMIN' ? (
            <ProtectedLayout>
                <Home />
            </ProtectedLayout>
        ) : (
            <NotSupportedPage />
        )
    ) : (
        <Login />
    );
}
