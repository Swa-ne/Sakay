'use client';
import { login } from '@/service/auth';
import Image from 'next/image';
import { useState } from 'react';
import { LoginUserSchema } from '@/schema/auth.schema';

export default function LoginPage() {
    const [userIdentifier, setUserIdentifier] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');

    const onLogin = async (e: React.FormEvent) => {
        e.preventDefault();

        const input = LoginUserSchema.safeParse({
            user_identifier: userIdentifier,
            password,
        });

        if (!input.success) {
            const formatted = input.error.format();
            const firstError = formatted.user_identifier?._errors?.[0] || formatted.password?._errors?.[0] || 'Invalid input';
            setError(firstError);
            return;
        }
        const result = await login(input.data);

        if (result === 'Success') {
            window.location.reload();
        } else {
            setPassword('');
            setError('Incorrect email or password');
        }
    };

    return (
        <main className='bg-primary w-screen h-screen flex justify-between'>
            <div className='w-1/2 flex justify-center items-center'>
                <Image src='/logo.png' width={360} height={160} alt='Sakay Logo' />
            </div>
            <div className='w-1/2 bg-background rounded-4xl m-8 flex flex-col justify-center items-center'>
                <h1 className='text-5xl font-bold text-gray-900 mb-7'>Login</h1>
                <form className='w-[45%] flex flex-col space-y-2' onSubmit={onLogin}>
                    {error && <p className='text-red-600 text-sm text-center mb-2'>{error}</p>}
                    <input className='w-full border-2 border-secondary p-3 rounded-md text-text' type='email' placeholder='Email' value={userIdentifier} onChange={(e) => setUserIdentifier(e.target.value)} />
                    <input className='w-full border-2 border-secondary p-3 rounded-md text-text' type='password' placeholder='Password' value={password} onChange={(e) => setPassword(e.target.value)} />
                    <div className='flex justify-between items-center text-sm text-text mb-5'>
                        <label className='flex items-center space-x-1'>
                            <input type='checkbox' className='accent-primary' />
                            <span>Remember me</span>
                        </label>
                        <a href='/forgot-password' className='text-red-600 hover:underline'>
                            Forgot password?
                        </a>
                    </div>
                    <button type='submit' className='w-full bg-primary text-background font-semibold py-3 rounded-md hover:bg-opacity-90 transition'>
                        Login
                    </button>
                </form>
            </div>
        </main>
    );
}
