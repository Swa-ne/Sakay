'use client';
import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Filter, MoreHorizontal, Plus, Search, Send, Star } from 'lucide-react';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';

interface Message {
    id: string;
    sender: string;
    email: string;
    subject: string;
    preview: string;
    timestamp: string;
    avatar: string;
    isNew?: boolean;
    type?: string;
}

interface Conversation {
    id: string;
    sender: string;
    message: string;
    timestamp: string;
    isOwn: boolean;
    attachment?: {
        name: string;
        size: string;
    };
}

const messages: Message[] = [
    {
        id: '1',
        sender: 'Jane McCarthy',
        email: 'jane@lunaagency.com',
        subject: 'Proposal Follow-up',
        preview: 'Q2_Campaign_Proposal.pdf',
        timestamp: '5m ago',
        avatar: '/placeholder.svg?height=40&width=40',
    },
    {
        id: '2',
        sender: 'Maya Roswell',
        email: 'maya@company.com',
        subject: 'New Inquiry',
        preview: "I'd like to learn more about your...",
        timestamp: '15m ago',
        avatar: '/placeholder.svg?height=40&width=40',
        isNew: true,
    },
    {
        id: '3',
        sender: '[AI Suggestion]',
        email: '',
        subject: 'Upsell Opportunity: Darren L...',
        preview: 'AI detected a potential upsell...',
        timestamp: '20m ago',
        avatar: '/placeholder.svg?height=40&width=40',
        isNew: true,
        type: 'ai',
    },
    {
        id: '4',
        sender: 'Cynthia Tan',
        email: 'cynthia@company.com',
        subject: 'New Product Inquiry',
        preview: "Hi, I'd love to know more about...",
        timestamp: '30m ago',
        avatar: '/placeholder.svg?height=40&width=40',
        isNew: true,
    },
    {
        id: '5',
        sender: 'Leonard Smith',
        email: 'leonard@company.com',
        subject: 'Feedback on Last Meeting',
        preview: 'Thanks for your time yesterday, I...',
        timestamp: '1hr ago',
        avatar: '/placeholder.svg?height=40&width=40',
    },
    {
        id: '6',
        sender: 'Marcus Lee',
        email: 'marcus@company.com',
        subject: 'Campaign Analytics Request',
        preview: 'Could you send me the perfor...',
        timestamp: 'Yesterday',
        avatar: '/placeholder.svg?height=40&width=40',
    },
    {
        id: '7',
        sender: 'Karla Iskander',
        email: 'karla@company.com',
        subject: 'Event Invite for Webinar Series',
        preview: "You're invited to join our upco...",
        timestamp: 'Yesterday',
        avatar: '/placeholder.svg?height=40&width=40',
    },
    {
        id: '8',
        sender: 'Samuel Park',
        email: 'samuel@company.com',
        subject: 'Payment Confirmation',
        preview: 'Thank you for your recent respo...',
        timestamp: '1d ago',
        avatar: '/placeholder.svg?height=40&width=40',
    },
];

const conversation: Conversation[] = [
    {
        id: '1',
        sender: 'Jane McCarthy',
        message: 'Hi Faris, I wanted to check in about the proposal we discussed last week. Has there been any update from your end? Looking forward to hearing from you.',
        timestamp: 'April 10, 2025, 2:13 PM',
        isOwn: false,
    },
    {
        id: '2',
        sender: 'You',
        message: "Hi Jane, thank you for sending over the proposal. I've reviewed the initial outline and forwarded it to our finance team for approval. I'll keep you posted once I get their feedback.",
        timestamp: 'April 8, 2025, 11:04 AM',
        isOwn: true,
    },
    {
        id: '2',
        sender: 'You',
        message: "Hi Jane, thank you for sending over the proposal. I've reviewed the initial outline and forwarded it to our finance team for approval. I'll keep you posted once I get their feedback.",
        timestamp: 'April 8, 2025, 11:04 AM',
        isOwn: true,
    },
    {
        id: '2',
        sender: 'You',
        message: "Hi Jane, thank you for sending over the proposal. I've reviewed the initial outline and forwarded it to our finance team for approval. I'll keep you posted once I get their feedback.",
        timestamp: 'April 8, 2025, 11:04 AM',
        isOwn: true,
    },
    {
        id: '2',
        sender: 'You',
        message: "Hi Jane, thank you for sending over the proposal. I've reviewed the initial outline and forwarded it to our finance team for approval. I'll keep you posted once I get their feedback.",
        timestamp: 'April 8, 2025, 11:04 AM',
        isOwn: true,
    },
    {
        id: '2',
        sender: 'You',
        message: "Hi Jane, thank you for sending over the proposal. I've reviewed the initial outline and forwarded it to our finance team for approval. I'll keep you posted once I get their feedback.",
        timestamp: 'April 8, 2025, 11:04 AM',
        isOwn: true,
    },
    {
        id: '2',
        sender: 'You',
        message: "Hi Jane, thank you for sending over the proposal. I've reviewed the initial outline and forwarded it to our finance team for approval. I'll keep you posted once I get their feedback.",
        timestamp: 'April 8, 2025, 11:04 AM',
        isOwn: true,
    },
    {
        id: '2',
        sender: 'You',
        message: "Hi Jane, thank you for sending over the proposal. I've reviewed the initial outline and forwarded it to our finance team for approval. I'll keep you posted once I get their feedback.",
        timestamp: 'April 8, 2025, 11:04 AM',
        isOwn: true,
    },
    {
        id: '3',
        sender: 'Jane McCarthy',
        message: "Hi Alex, as discussed, I've attached the proposal for our Q2 digital marketing campaign collaboration. Let me know if you have any questions.",
        timestamp: 'Today, 2:13 PM',
        isOwn: false,
        attachment: {
            name: 'Q2_Campaign_Proposal.pdf',
            size: '345kb',
        },
    },
];

const Inbox = () => {
    const [selectedMessage, setSelectedMessage] = useState(messages[0]);
    const [activeTab, setActiveTab] = useState('All');
    const tabs = ['All', 'Unread', 'Starred', 'AI Suggestions'];
    return (
        <div className='p-5 w-full h-screen flex space-x-5'>
            <div className='w-1/3 bg-background rounded-2xl p-5 overflow-y-auto'>
                <div className='w-full flex justify-between items-center'>
                    <h1 className='text-4xl font-bold mb-2'>Inbox</h1>
                    <div className='flex items-center gap-2'>
                        <Button variant='ghost' size='icon'>
                            <Filter className='w-4 h-4' />
                        </Button>
                        <Button variant='ghost' size='icon'>
                            <Search className='w-4 h-4' />
                        </Button>
                        <Button size='icon' className='bg-primary hover:opacity-90'>
                            <Plus className='w-4 h-4' />
                        </Button>
                    </div>
                </div>
                <div className='flex gap-1'>
                    {tabs.map((tab) => (
                        <Button key={tab} variant={activeTab === tab ? 'secondary' : 'ghost'} size='sm' onClick={() => setActiveTab(tab)} className='text-xs'>
                            {tab}
                        </Button>
                    ))}
                </div>
                <div className='mt-3 flex-1 overflow-y-auto'>
                    {messages.map((message) => (
                        <div key={message.id} className={`p-4 border-b border-gray-100 cursor-pointer hover:bg-gray-50 ${selectedMessage.id === message.id ? 'bg-blue-50 border-l-4 border-l-primary opacity-90' : ''}`} onClick={() => setSelectedMessage(message)}>
                            <div className='flex items-start gap-3'>
                                <Avatar className='w-10 h-10'>
                                    <AvatarImage src={message.avatar || '/placeholder.svg'} />
                                    <AvatarFallback>
                                        {message.sender
                                            .split(' ')
                                            .map((n) => n[0])
                                            .join('')}
                                    </AvatarFallback>
                                </Avatar>
                                <div className='flex-1 min-w-0'>
                                    <div className='flex items-center justify-between mb-1'>
                                        <div className='font-medium text-text truncate'>{message.sender}</div>
                                        <div className='text-xs text-gray-500 flex items-center gap-1'>
                                            {message.timestamp}
                                            {message.isNew && (
                                                <Badge variant='secondary' className='text-xs bg-green-100 text-green-800'>
                                                    New
                                                </Badge>
                                            )}
                                        </div>
                                    </div>
                                    <div className='text-sm text-gray-500 truncate'>{message.preview}</div>
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
                                <AvatarImage src={selectedMessage.avatar || '/placeholder.svg'} />
                                <AvatarFallback>
                                    {selectedMessage.sender
                                        .split(' ')
                                        .map((n) => n[0])
                                        .join('')}
                                </AvatarFallback>
                            </Avatar>
                            <div>
                                <div className='font-medium text-text'>{selectedMessage.sender}</div>
                                <div className='text-sm text-gray-500'>{selectedMessage.email}</div>
                            </div>
                        </div>
                        <div className='flex items-center gap-2'>
                            <Button variant='ghost' size='icon'>
                                <Star className='w-4 h-4' />
                            </Button>
                            <Button variant='ghost' size='icon'>
                                <MoreHorizontal className='w-4 h-4' />
                            </Button>
                        </div>
                    </div>
                </div>
                <div className='flex-1 overflow-y-auto p-4 space-y-4'>
                    {conversation.map((msg) => (
                        <div key={msg.id} className={`flex ${msg.isOwn ? 'justify-end' : 'justify-start'}`}>
                            <div className={`flex items-start space-x-1 max-w-md ${msg.isOwn ? 'order-2' : 'order-1'}`}>
                                {!msg.isOwn && (
                                    <div className='flex items-center gap-2 mb-2'>
                                        <Avatar className='w-10 h-10'>
                                            <AvatarImage src='/placeholder.svg?height=24&width=24' />
                                            <AvatarFallback>JM</AvatarFallback>
                                        </Avatar>
                                    </div>
                                )}
                                <div>
                                    <div className={`p-3 ${msg.isOwn ? 'bg-primary text-white rounded-b-lg rounded-tl-lg' : 'bg-gray-100 text-text rounded-b-lg rounded-tr-lg'}`}>
                                        <p className='text-sm'>{msg.message}</p>
                                        {/* {msg.attachment && (
                                        <div className='mt-3 p-2 bg-white bg-opacity-20 rounded border border-white border-opacity-20'>
                                            <div className='flex items-center gap-2'>
                                                <div className='w-8 h-8 bg-primary rounded flex items-center justify-center'>
                                                    <Download className='w-4 h-4 text-white' />
                                                    </div>
                                                <div>
                                                <div className='text-sm font-medium'>{msg.attachment.name}</div>
                                                    <div className='text-xs opacity-75'>{msg.attachment.size}</div>
                                                </div>
                                                </div>
                                                </div>
                                                )} */}
                                    </div>
                                    <div className='text-xs text-gray-500 mt-1'>{msg.timestamp}</div>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
                <div className='px-4 pb-2'>
                    <div className='bg-gray-50 rounded-lg p-3'>
                        <div className='text-xs text-gray-600 mb-2'>💡 Suggested Reply:</div>
                        <div className='text-sm text-gray-700 mb-2'>Hi Jane, thanks for following up! I&aposve just checked with our finance team and expect their feedback by tomorrow. I'll get back to you as soon as I have their input. Appreciate your patience!</div>
                        <div className='text-xs text-gray-600 mb-2'>📅 Schedule a reminder to follow up if no reply from finance by 5 PM tomorrow.</div>
                    </div>
                </div>
                <div className='p-4 border-t border-gray-200'>
                    <div className='flex items-end gap-2'>
                        <div className='flex-1'>
                            <Input placeholder='Write a message...' className='border-gray-300' />
                        </div>
                        <Button className='bg-primary hover:opacity-80'>
                            <Send className='w-4 h-4' />
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Inbox;
