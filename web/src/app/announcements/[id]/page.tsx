'use client';

import EditAnnouncementModal from '@/components/editAnnouncementModal';
import FilePreview from '@/components/filePreview';
import LoadingPage from '@/components/pages/loading.page';
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from '@/components/ui/alert-dialog';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Dialog, DialogTrigger } from '@/components/ui/dialog';
import { Separator } from '@/components/ui/separator';
import useAnnouncement from '@/hooks/useAnnouncement';
import { File } from '@/types';
import { timeAgo } from '@/utils/date.util';
import { getActualFileType, getFileExtension } from '@/utils/file.preview';
import { Calendar, User, Users, Edit, FileText, Edit3, Trash2, Eye, Download, Video, Archive, FileSpreadsheet, Music, FileImage, Code } from 'lucide-react';
import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

export default function AnnouncementDetails() {
    const { id } = useParams();
    const { announcement, loading, error, fetchAnnouncement, handleDelete } = useAnnouncement();
    const [previewFile, setPreviewFile] = useState<File | string | null>(null);
    const [isEditModalOpen, setIsEditModalOpen] = useState(false);

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

    const getFileIcon = (file: File | string) => {
        const fileName = typeof file === 'string' ? file.split('/').pop() || 'Unknown' : file.file_name;
        const extension = getFileExtension(fileName);
        const actualFileType = getActualFileType(fileName);

        if (actualFileType.startsWith('image/')) {
            return <FileImage className='w-4 h-4 text-blue-500' />;
        }

        if (actualFileType.startsWith('video/')) {
            return <Video className='w-4 h-4 text-purple-500' />;
        }

        if (actualFileType.startsWith('audio/')) {
            return <Music className='w-4 h-4 text-green-500' />;
        }

        if (['xls', 'xlsx', 'csv'].includes(extension)) {
            return <FileSpreadsheet className='w-4 h-4 text-emerald-500' />;
        }

        if (['js', 'ts', 'jsx', 'tsx', 'html', 'css', 'json', 'xml'].includes(extension)) {
            return <Code className='w-4 h-4 text-indigo-500' />;
        }

        if (['zip', 'rar', '7z', 'tar', 'gz'].includes(extension)) {
            return <Archive className='w-4 h-4 text-orange-500' />;
        }

        return <FileText className='w-4 h-4 text-muted-foreground' />;
    };

    const getFileName = (file: File | string) => {
        return typeof file === 'string' ? file.split('/').pop() || 'Unknown' : file.file_name;
    };

    const getFileTypeDisplay = (file: File | string) => {
        const fileName = getFileName(file);
        const extension = getFileExtension(fileName);
        const actualType = getActualFileType(fileName);

        if (actualType.startsWith('image/')) return 'Image';
        if (actualType.startsWith('video/')) return 'Video';
        if (actualType.startsWith('audio/')) return 'Audio';
        if (actualType === 'application/pdf') return 'PDF';
        if (actualType.includes('word')) return 'Word Document';
        if (actualType.includes('excel') || actualType.includes('spreadsheet')) return 'Spreadsheet';
        if (actualType.includes('powerpoint') || actualType.includes('presentation')) return 'Presentation';
        if (actualType.startsWith('text/') || ['js', 'ts', 'jsx', 'tsx'].includes(extension)) return 'Text/Code';
        if (actualType.includes('zip') || actualType.includes('compressed')) return 'Archive';

        return extension.toUpperCase() || 'File';
    };

    const getFileSize = (file: File | string) => {
        if (typeof file === 'string') return null;
        const bytes = file.file_size;
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return Number.parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
    };

    useEffect(() => {
        if (typeof id === 'string') {
            fetchAnnouncement(id);
        }
    }, [id, fetchAnnouncement]);

    // if (loading) return <LoadingPage />;
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

            {announcement.files && announcement.files.length > 0 && (
                <Card>
                    <CardHeader>
                        <div className='flex items-center gap-2'>
                            <FileText className='w-5 h-5' />
                            <h3 className='text-lg font-semibold'>Attachments ({announcement.files.length})</h3>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className='space-y-2'>
                            {announcement.files.map((file, index) => {
                                const fileName = getFileName(file);
                                const fileSize = getFileSize(file);
                                const fileCategory = typeof file !== 'string' ? file.file_category : null;
                                const fileTypeDisplay = getFileTypeDisplay(file);

                                return (
                                    <div key={typeof file === 'string' ? index : file._id} className='flex items-center justify-between p-3 bg-muted/50 rounded-md hover:bg-muted/70 transition-colors border'>
                                        <div className='flex items-center gap-3'>
                                            {getFileIcon(file)}
                                            <div className='flex-1'>
                                                <div className='flex items-center gap-2 flex-wrap'>
                                                    <span className='text-sm font-medium'>{fileName}</span>
                                                    <Badge variant='outline' className='text-xs'>
                                                        {fileTypeDisplay}
                                                    </Badge>
                                                    {fileCategory && (
                                                        <Badge variant='secondary' className='text-xs'>
                                                            {fileCategory}
                                                        </Badge>
                                                    )}
                                                </div>
                                                {fileSize && <p className='text-xs text-muted-foreground mt-1'>{fileSize}</p>}
                                            </div>
                                        </div>
                                        <div className='flex items-center gap-2'>
                                            <Button variant='ghost' size='sm' onClick={() => setPreviewFile(file)}>
                                                <Eye className='w-4 h-4 mr-1' />
                                                Preview
                                            </Button>
                                            <Button variant='ghost' size='sm' asChild>
                                                <a href={typeof file === 'string' ? file : file.file_url} download={fileName} target='_blank' rel='noopener noreferrer'>
                                                    <Download className='w-4 h-4 mr-1' />
                                                    Download
                                                </a>
                                            </Button>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </CardContent>
                </Card>
            )}

            <Card>
                <CardHeader>
                    <h3 className='text-lg font-semibold'>Details</h3>
                </CardHeader>
                <CardContent className='space-y-2'>
                    <div className='grid grid-cols-3 gap-4 text-sm'>
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
                        <div>
                            <span className='font-medium'>Target Audience:</span>
                            <p className='text-muted-foreground'>{announcement.audience.toUpperCase().replace('_', ' ')}</p>
                        </div>
                    </div>
                </CardContent>
            </Card>
            <Dialog open={!!previewFile} onOpenChange={() => setPreviewFile(null)}>
                {previewFile && <FilePreview file={previewFile} onClose={() => setPreviewFile(null)} />}
            </Dialog>
        </div>
    );
}
