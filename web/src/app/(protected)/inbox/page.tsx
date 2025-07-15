'use client';
import { useEffect, useRef, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Send } from 'lucide-react';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import useInbox from '@/hooks/useInbox';
import { useAuthStore } from '@/stores';
import { timeAgo } from '@/utils/date.util';

const Inbox = () => {
    const { user_id } = useAuthStore();
    const { messageInput, setMessageInput, handleSendMessage, messages, chatID, setChatID, inboxes, setMessagePage, setInboxPage } = useInbox();

    const [activeTab, setActiveTab] = useState('All');
    const tabs = ['All', 'Unread'];

    const messageRef = useRef<HTMLDivElement>(null);
    const inboxRef = useRef<HTMLDivElement>(null);
    useEffect(() => {
        const container = messageRef.current;
        if (!container) return;
        const handleScroll = () => {
            const isAtTop = container.scrollHeight + container.scrollTop - container.clientHeight <= 5;
            if (isAtTop) {
                setMessagePage((prev) => prev + 1);
            }
        };

        container.addEventListener('scroll', handleScroll);

        return () => {
            container.removeEventListener('scroll', handleScroll);
        };
    }, [setMessagePage]);

    useEffect(() => {
        const container = inboxRef.current;
        if (!container) return;

        const handleInboxScroll = () => {
            const scrollThreshold = 100;
            const isNearBottom = container.scrollHeight - container.scrollTop - container.clientHeight <= scrollThreshold;

            if (isNearBottom) {
                setInboxPage((prev) => prev + 1);
            }
        };

        container.addEventListener('scroll', handleInboxScroll);
        return () => container.removeEventListener('scroll', handleInboxScroll);
    }, [setInboxPage]);

    return (
        <div className='p-5 w-full h-screen flex space-x-5'>
            <div className='w-1/3 bg-background rounded-2xl p-5 overflow-y-auto'>
                <div className='w-full flex justify-between items-center'>
                    <h1 className='text-4xl font-bold mb-2'>Inbox</h1>
                    {/* <div className='flex items-center gap-2'>
                        <Button variant='ghost' size='icon'>
                            <Filter className='w-4 h-4' />
                        </Button>
                        <Button variant='ghost' size='icon'>
                            <Search className='w-4 h-4' />
                        </Button>
                        <Button size='icon' className='bg-primary hover:opacity-90'>
                            <Plus className='w-4 h-4' />
                        </Button>
                    </div> */}
                </div>
                <div className='flex gap-1'>
                    {tabs.map((tab) => (
                        <Button key={tab} variant={activeTab === tab ? 'secondary' : 'ghost'} size='sm' onClick={() => setActiveTab(tab)} className='text-xs'>
                            {tab}
                        </Button>
                    ))}
                </div>
                <div ref={inboxRef} className='mt-3 flex-1 overflow-y-auto'>
                    {inboxes.map((inbox) => (
                        <div
                            key={inbox._id}
                            className={`p-4 border-b border-gray-100 cursor-pointer hover:bg-gray-50 ${chatID === inbox._id ? 'bg-blue-50 border-l-4 border-l-primary opacity-90' : ''}`}
                            onClick={() => {
                                setChatID(inbox._id);
                                setMessagePage(1);
                            }}
                        >
                            <div className='flex items-start gap-3'>
                                <Avatar className='w-10 h-10'>
                                    <AvatarImage src={inbox.user_id.profile_picture_url || '/placeholder.svg'} />
                                </Avatar>
                                <div className='flex-1 min-w-0'>
                                    <div className='flex items-center justify-between mb-1'>
                                        <div className='font-medium text-text truncate'>{inbox.user_id.first_name}</div>
                                        <div className='text-xs text-gray-500 flex items-center gap-1'>
                                            {timeAgo(inbox.last_message.createdAt)}
                                            {!inbox.last_message.is_read && (
                                                <Badge variant='secondary' className='text-xs bg-green-100 text-green-800'>
                                                    New
                                                </Badge>
                                            )}
                                        </div>
                                    </div>
                                    <div className='text-sm text-gray-500 truncate'>{inbox.last_message.message}</div>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
            <div className='w-2/3 h-full flex flex-col bg-background rounded-2xl overflow-hidden relative'>
                <div className='p-4 border-b border-gray-200'>
                    <div className='flex items-center justify-between'>
                        <div className='flex items-center gap-3'>
                            <Avatar className='w-10 h-10'>
                                <AvatarImage src={inboxes.find((inbox) => inbox._id === chatID)?.user_id.profile_picture_url || '/placeholder.svg'} />
                                <AvatarFallback>
                                    {inboxes
                                        .find((inbox) => inbox._id === chatID)
                                        ?.user_id.first_name?.split(' ')
                                        .map((n) => n[0])
                                        .join('')}
                                </AvatarFallback>
                            </Avatar>
                            <div>
                                <div className='font-medium text-text'>{inboxes.find((inbox) => inbox._id === chatID)?.user_id.first_name}</div>
                                <div className='text-sm text-gray-500'>{inboxes.find((inbox) => inbox._id === chatID)?.user_id.email}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div ref={messageRef} className='flex-1 overflow-y-auto p-4 flex flex-col-reverse space-y-reverse space-y-4'>
                    {messages[chatID] &&
                        messages[chatID].map((msg, index) => {
                            const isOwn = msg.sender_id === user_id;
                            const currentTime = new Date(Date.parse(msg.createdAt));
                            const nextMsg = messages[chatID][index + 1];
                            const nextTime = nextMsg ? new Date(Date.parse(nextMsg.createdAt)) : null;

                            const formattedTime = currentTime.toLocaleTimeString([], {
                                hour: '2-digit',
                                minute: '2-digit',
                            });

                            const formattedSeparator = currentTime.toLocaleString([], {
                                month: 'short',
                                day: 'numeric',
                                hour: '2-digit',
                                minute: '2-digit',
                            });

                            let showTimeSeparator = false;

                            if (!nextTime || (currentTime.getTime() - nextTime.getTime()) / (1000 * 60) > 10) {
                                showTimeSeparator = true;
                            }

                            return (
                                <div key={msg._id || `${index}-message-${msg.chat_id}-${msg.createdAt}`} className='flex flex-col space-y-2'>
                                    {showTimeSeparator && <div className='text-center text-xs text-gray-500 py-2'>{formattedSeparator}</div>}
                                    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'}`}>
                                        <div className={`flex items-start space-x-1 max-w-md ${isOwn ? 'order-2' : 'order-1'}`}>
                                            {!isOwn && (
                                                <div className='flex items-center gap-2 mb-2'>
                                                    <Avatar className='w-10 h-10'>
                                                        <AvatarImage src='/placeholder.svg?height=24&width=24' />
                                                    </Avatar>
                                                </div>
                                            )}
                                            <div>
                                                <div className={`p-3 ${isOwn ? 'bg-primary text-white rounded-b-lg rounded-tl-lg' : 'bg-gray-100 text-text rounded-b-lg rounded-tr-lg'}`}>
                                                    <p className='text-sm'>{msg.message}</p>
                                                </div>
                                                <div className='text-xs text-gray-500 mt-1'>{formattedTime}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            );
                        })}
                </div>
                {/* <div className='px-4 pb-2'>
                    <div className='bg-gray-50 rounded-lg p-3'>
                        <div className='text-xs text-gray-600 mb-2'>💡 Suggested Reply:</div>
                        <div className='text-sm text-gray-700 mb-2'>Hi Jane, thanks for following up! I&aposve just checked with our finance team and expect their feedback by tomorrow. I&apos;ll get back to you as soon as I have their input. Appreciate your patience!</div>
                        <div className='text-xs text-gray-600 mb-2'>📅 Schedule a reminder to follow up if no reply from finance by 5 PM tomorrow.</div>
                    </div>
                </div> */}
                <div className='p-4 border-t border-gray-200'>
                    <div className='flex items-end gap-2'>
                        <div className='flex-1'>
                            <Input
                                placeholder='Write a message...'
                                className='border-gray-300'
                                value={messageInput}
                                onChange={(e) => setMessageInput(e.target.value)}
                                onKeyDown={(e) => {
                                    if (e.key === 'Enter' && !e.shiftKey) {
                                        e.preventDefault();
                                        handleSendMessage();
                                    }
                                }}
                            />
                        </div>
                        <Button className='bg-primary text-background hover:opacity-80' onClick={handleSendMessage}>
                            <Send className='w-4 h-4' />
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Inbox;
