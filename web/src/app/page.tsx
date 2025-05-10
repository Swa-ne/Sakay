import { cookies } from 'next/headers';
import Login from './auth/page';
import Home from './(protected)/home/page';

export default async function Page() {
    const isLoggedIn = Boolean((await cookies()).get('token')?.value);
    return isLoggedIn ? <Home /> : <Login />;
}
