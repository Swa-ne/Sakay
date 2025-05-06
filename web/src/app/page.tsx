import { cookies } from 'next/headers';
import Home from './home/page';
import Login from './auth/page';

export default async function Page() {
    const isLoggedIn = Boolean((await cookies()).get('token')?.value);
    return isLoggedIn ? <Home /> : <Login />;
}
