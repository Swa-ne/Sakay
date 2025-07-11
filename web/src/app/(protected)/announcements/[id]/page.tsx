'use client';

import EditAnnouncementModal from '@/components/editAnnouncementModal';
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from '@/components/ui/alert-dialog';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Dialog, DialogTrigger } from '@/components/ui/dialog';
import { Separator } from '@/components/ui/separator';
import useAnnouncement from '@/hooks/useAnnouncement';
import { timeAgo } from '@/utils/date.util';
import { Calendar, User, Users, Edit, FileText, Edit3, Trash2 } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

export default function AnnouncementDetails() {
    const { id } = useParams();
    const { announcement, loading, error, fetchAnnouncement, handleDelete } = useAnnouncement();

    const getAudienceIcon = (audience: string) => {
        switch (audience) {
            case 'EVERYONE':
                return <Users className='w-4 h-4' />;
            case 'DRIVER':
            case 'COMMUTER':
                return <User className='w-4 h-4' />;
            default:
                return <Users className='w-4 h-4' />;
        }
    };

    const [isEditModalOpen, setIsEditModalOpen] = useState(false);
    useEffect(() => {
        if (typeof id === 'string') {
            fetchAnnouncement(id);
        }
    }, [id, fetchAnnouncement]);

    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;
    if (!announcement) return <div>Report not found</div>;

    return (
        <div className='h-full overflow-y-auto space-y-6'>
            <div className='space-y-4'>
                <div className='flex items-start justify-between'>
                    <h1 className='text-2xl font-bold leading-tight pr-4'>{announcement.headline}</h1>
                    <div className='flex items-center gap-2 shrink-0'>
                        <Badge variant='default' className='flex items-center gap-1 text-background'>
                            {getAudienceIcon(announcement.audience)}
                            {announcement.audience}
                        </Badge>
                    </div>
                </div>

                <div className='flex items-center justify-between'>
                    <div className='flex items-center gap-4 text-sm text-muted-foreground'>
                        <div className='flex items-center gap-1'>
                            <Calendar className='w-4 h-4' />
                            <span>Posted {timeAgo(announcement.createdAt ?? '')}</span>
                        </div>
                        {announcement.updatedAt && announcement.updatedAt !== announcement.createdAt && (
                            <div className='flex items-center gap-1'>
                                <Edit className='w-4 h-4' />
                                <span>Updated {timeAgo(announcement.updatedAt)}</span>
                            </div>
                        )}
                    </div>

                    <div className='flex items-center gap-2'>
                        <Dialog open={isEditModalOpen} onOpenChange={setIsEditModalOpen}>
                            <DialogTrigger asChild>
                                <Button variant='outline' size='sm'>
                                    <Edit3 className='w-4 h-4 mr-1' />
                                    Edit
                                </Button>
                            </DialogTrigger>
                            <EditAnnouncementModal announcement={announcement} onSave={() => setIsEditModalOpen(false)} setOpen={setIsEditModalOpen} />
                        </Dialog>

                        <AlertDialog>
                            <AlertDialogTrigger asChild>
                                <Button variant='destructive' size='sm'>
                                    <Trash2 className='w-4 h-4 mr-1' />
                                    Delete
                                </Button>
                            </AlertDialogTrigger>
                            <AlertDialogContent>
                                <AlertDialogHeader>
                                    <AlertDialogTitle>Delete Announcement</AlertDialogTitle>
                                    <AlertDialogDescription>Are you sure you want to delete &quot;{announcement.headline}&quot;? This action cannot be undone.</AlertDialogDescription>
                                </AlertDialogHeader>
                                <AlertDialogFooter>
                                    <AlertDialogCancel>Cancel</AlertDialogCancel>
                                    <AlertDialogAction onClick={handleDelete} className='bg-destructive text-destructive-foreground hover:bg-destructive/90'>
                                        Delete
                                    </AlertDialogAction>
                                </AlertDialogFooter>
                            </AlertDialogContent>
                        </AlertDialog>
                    </div>
                </div>
            </div>

            <Separator />

            <Card>
                <CardHeader>
                    <div className='flex items-center gap-2'>
                        <FileText className='w-5 h-5' />
                        <h3 className='text-lg font-semibold'>Content</h3>
                    </div>
                </CardHeader>
                <CardContent>
                    <div className='prose prose-sm max-w-none'>
                        <p className='whitespace-pre-wrap leading-relaxed'>{announcement.content}</p>
                    </div>
                </CardContent>
            </Card>

            <Card>
                <CardHeader>
                    <div className='flex items-center gap-2'>
                        <User className='w-5 h-5' />
                        <h3 className='text-lg font-semibold'>Author Information</h3>
                    </div>
                </CardHeader>
                <CardContent className='space-y-3'>
                    <div>
                        <span className='text-sm font-medium'>Posted by:</span>
                        <p className='text-sm text-muted-foreground'>{announcement.posted_by ? `${announcement.posted_by.first_name} ${announcement.posted_by.last_name}` : 'Unknown Author'}</p>
                    </div>

                    {announcement.edited_by && (
                        <div>
                            <span className='text-sm font-medium'>Last edited by:</span>
                            <p className='text-sm text-muted-foreground'>{announcement.edited_by ? `${announcement.edited_by.first_name} ${announcement.edited_by.last_name}` : 'Unknown Editor'}</p>
                        </div>
                    )}
                </CardContent>
            </Card>

            {announcement.files && announcement.files.length > 0 && (
                <Card>
                    <CardHeader>
                        <div className='flex items-center gap-2'>
                            <FileText className='w-5 h-5' />
                            <h3 className='text-lg font-semibold'>Attachments</h3>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className='space-y-2'>
                            {announcement.files.map((file, index) => (
                                <div key={index} className='flex items-center gap-2 p-2 bg-muted/50 rounded-md'>
                                    <FileText className='w-4 h-4 text-muted-foreground' />
                                    <span className='text-sm'>{typeof file === 'string' ? file : file.file_name}</span>
                                </div>
                            ))}
                        </div>
                    </CardContent>
                </Card>
            )}

            <Card>
                <CardHeader>
                    <h3 className='text-lg font-semibold'>Details</h3>
                </CardHeader>
                <CardContent className='space-y-2'>
                    <div className='grid grid-cols-2 gap-4 text-sm'>
                        <div>
                            <span className='font-medium'>ID:</span>
                            <p className='text-muted-foreground font-mono text-xs'>{announcement._id}</p>
                        </div>
                        <div>
                            <span className='font-medium'>Target Audience:</span>
                            <p className='text-muted-foreground'>{announcement.audience.toLowerCase().replace('_', ' ')}</p>
                        </div>
                    </div>
                </CardContent>
            </Card>
        </div>
    );
}
