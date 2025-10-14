'use client';

import { useEffect, useState } from 'react';
import { AlertTriangle, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

interface AdminSOSAlertProps {
    isOpen: boolean;
    onClose: () => void;
    userName?: string;
    timestamp?: Date;
}

export function AdminSOSAlert({ isOpen, onClose, userName = 'User', timestamp = new Date() }: AdminSOSAlertProps) {
    const [isVisible, setIsVisible] = useState(false);

    useEffect(() => {
        if (isOpen) {
            setIsVisible(true);
        }
    }, [isOpen]);

    if (!isVisible) return null;

    const handleClose = () => {
        setIsVisible(false);
        setTimeout(onClose, 300);
    };

    return (
        <div className='fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm animate-in fade-in duration-200'>
            <Card className='w-full max-w-md border-destructive shadow-2xl animate-in zoom-in-95 duration-200'>
                <CardHeader className='bg-destructive text-destructive-foreground'>
                    <div className='flex items-start justify-between'>
                        <div className='flex items-center gap-3'>
                            <AlertTriangle className='h-8 w-8 animate-pulse' />
                            <div>
                                <CardTitle className='text-2xl font-bold'>SOS Alert Activated!</CardTitle>
                                <CardDescription className='text-destructive-foreground/90'>Emergency assistance requested</CardDescription>
                            </div>
                        </div>
                        <Button variant='ghost' size='icon' onClick={handleClose} className='text-destructive-foreground hover:bg-destructive-foreground/20'>
                            <X className='h-5 w-5' />
                        </Button>
                    </div>
                </CardHeader>
                <CardContent className='pt-6'>
                    <div className='space-y-4'>
                        <div className='rounded-lg bg-muted p-4'>
                            <div className='flex justify-between text-sm'>
                                <span className='font-medium'>User:</span>
                                <span className='text-muted-foreground'>{userName}</span>
                            </div>
                            <div className='mt-2 flex justify-between text-sm'>
                                <span className='font-medium'>Time:</span>
                                <span className='text-muted-foreground'>{timestamp.toLocaleTimeString()}</span>
                            </div>
                        </div>
                        <div className='flex gap-2'>
                            <Button variant='outline' className='flex-1 bg-transparent' onClick={handleClose}>
                                Respond
                            </Button>
                        </div>
                    </div>
                </CardContent>
            </Card>
        </div>
    );
}
