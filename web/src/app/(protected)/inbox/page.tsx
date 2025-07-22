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
import { Inbox as InboxType } from '@/types';

const Inbox = () => {
    const messageRef = useRef<HTMLDivElement>(null);
    const inboxRef = useRef<HTMLDivElement>(null);
    const [showChat, setShowChat] = useState(false); // Mobile state for chat view

    const { user_id } = useAuthStore();
    const [currentUser, setCurrentUser] = useState<InboxType>();
    const { messageInput, setMessageInput, handleSendMessage, messages, chatID, setChatID, inboxes, setMessagePage, setInboxPage } = useInbox(messageRef);

    const [activeTab, setActiveTab] = useState('All');
    const tabs = ['All', 'Unread'];

    useEffect(() => {
        setCurrentUser(inboxes.find((inbox) => inbox._id === chatID));
    }, [inboxes, chatID]);

    useEffect(() => {
        const container = inboxRef.current;
        if (!container) return;

        const handleInboxScroll = () => {
            const scrollThreshold = 100;
            const isNearTop = container.scrollHeight - container.scrollTop - container.clientHeight <= scrollThreshold;

            if (isNearTop) {
                setInboxPage((prev) => prev + 1);
            }
        };

        container.addEventListener('scroll', handleInboxScroll);
        return () => container.removeEventListener('scroll', handleInboxScroll);
    }, [setInboxPage]);

    return (
        <div className='p-2 md:p-5 w-full h-screen flex flex-col lg:flex-row gap-2 md:gap-5'>
            {/* Inbox List - Hidden on mobile when chat is open */}
            <div className={`${showChat ? 'hidden lg:flex' : 'flex'} lg:w-1/3 w-full bg-background rounded-xl md:rounded-2xl p-3 md:p-5 overflow-y-auto flex-col`}>
                <div className='w-full flex justify-between items-center mb-2 md:mb-3'>
                    <h1 className='text-2xl md:text-3xl font-bold'>Inbox</h1>
                </div>
                
                {/* Tabs - Responsive sizing */}
                <div className='flex gap-1 mb-2 md:mb-3'>
                    {tabs.map((tab) => (
                        <Button 
                            key={tab} 
                            variant={activeTab === tab ? 'secondary' : 'ghost'} 
                            size='sm' 
                            onClick={() => setActiveTab(tab)} 
                            className='text-xs md:text-sm'
                        >
                            {tab}
                        </Button>
                    ))}
                </div>
                
                {/* Inbox Items */}
                <div ref={inboxRef} className='flex-1 overflow-y-auto'>
                    {inboxes.map((inbox) => (
                        <div
                            key={inbox._id}
                            className={`p-3 md:p-4 border-b border-gray-100 cursor-pointer hover:bg-gray-50 ${
                                chatID === inbox._id ? 'bg-blue-50 border-l-2 md:border-l-4 border-l-primary' : ''
                            }`}
                            onClick={() => {
                                setChatID(inbox._id);
                                setMessagePage(1);
                                setShowChat(true); // Show chat on mobile
                            }}
                        >
                            <div className='flex items-start gap-2 md:gap-3'>
                                <Avatar className='w-8 h-8 md:w-10 md:h-10'>
                                    <AvatarImage src={inbox.user_id.profile_picture_url || '/placeholder.svg'} />
                                </Avatar>
                                <div className='flex-1 min-w-0'>
                                    <div className='flex items-center justify-between mb-1'>
                                        <div className='font-medium text-sm md:text-base text-text truncate'>
                                            {inbox.user_id.first_name} {inbox.user_id.last_name}
                                        </div>
                                        <div className='text-xs text-gray-500 flex items-center gap-1'>
                                            {timeAgo(inbox.last_message.createdAt)}
                                            {inbox.last_message.sender_id !== user_id && !inbox.last_message.isRead && (
                                                <Badge variant='secondary' className='text-xs bg-green-100 text-green-800'>
                                                    New
                                                </Badge>
                                            )}
                                        </div>
                                    </div>
                                    <div className='text-xs md:text-sm text-gray-500 truncate'>{inbox.last_message.message}</div>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            {/* Chat Area - Hidden on mobile when not selected */}
            <div className={`${!showChat ? 'hidden lg:flex' : 'flex'} lg:w-2/3 w-full h-full flex-col bg-background rounded-xl md:rounded-2xl overflow-hidden relative`}>
                {/* Chat Header with Back Button for mobile */}
                <div className='p-3 md:p-4 border-b border-gray-200 flex items-center justify-between'>
                    <div className='flex items-center gap-2 md:gap-3'>
                        <Button 
                            variant='ghost' 
                            size='icon' 
                            className='lg:hidden'
                            onClick={() => setShowChat(false)}
                        >
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="m12 19-7-7 7-7"/>
                                <path d="M19 12H5"/>
                            </svg>
                        </Button>
                        <Avatar className='w-8 h-8 md:w-10 md:h-10'>
                            <AvatarImage src={currentUser?.user_id.profile_picture_url || '/placeholder.svg'} />
                            <AvatarFallback>
                                {currentUser?.user_id.first_name?.split(' ')
                                    .map((n) => n[0])
                                    .join('')}
                            </AvatarFallback>
                        </Avatar>
                        <div>
                            <div className='font-medium text-sm md:text-base text-text'>
                                {currentUser?.user_id.first_name} {currentUser?.user_id.last_name}
                            </div>
                            <div className='text-xs md:text-sm text-gray-500'>{currentUser?.user_id.email}</div>
                        </div>
                    </div>
                </div>

                {/* Messages Area */}
                <div 
                    ref={messageRef} 
                    className='flex-1 overflow-y-auto p-2 md:p-4 flex flex-col-reverse space-y-reverse space-y-2 md:space-y-4'
                >
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
                                <div key={msg._id || `${index}-message-${msg.chat_id}-${msg.createdAt}`} className='flex flex-col space-y-1 md:space-y-2'>
                                    {showTimeSeparator && <div className='text-center text-xs text-gray-500 py-1 md:py-2'>{formattedSeparator}</div>}
                                    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'}`}>
                                        <div className={`flex items-start space-x-1 max-w-xs md:max-w-md ${isOwn ? 'order-2' : 'order-1'}`}>
                                            {!isOwn && (
                                                <div className='flex items-center gap-2 mb-1 md:mb-2'>
                                                    <Avatar className='w-6 h-6 md:w-10 md:h-10'>
                                                        <AvatarImage src='/placeholder.svg?height=24&width=24' />
                                                    </Avatar>
                                                </div>
                                            )}
                                            <div>
                                                <div className={`p-2 md:p-3 text-xs md:text-sm ${
                                                    isOwn 
                                                        ? 'bg-primary text-white rounded-b-lg rounded-tl-lg' 
                                                        : 'bg-gray-100 text-text rounded-b-lg rounded-tr-lg'
                                                }`}>
                                                    <p>{msg.message}</p>
                                                </div>
                                                <div className='text-xs text-gray-500 mt-0.5 md:mt-1'>{formattedTime}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            );
                        })}
                </div>

                {/* Message Input */}
                <div className='p-2 md:p-4 border-t border-gray-200'>
                    <div className='flex items-end gap-2'>
                        <div className='flex-1'>
                            <Input
                                placeholder='Write a message...'
                                className='border-gray-300 text-sm md:text-base'
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
                        <Button 
                            size='sm' 
                            className='bg-primary text-background hover:opacity-80 h-9 md:h-10'
                            onClick={handleSendMessage}
                        >
                            <Send className='w-4 h-4' />
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Inbox;