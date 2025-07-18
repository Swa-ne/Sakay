'use client';

import type React from 'react';

import { Button } from '@/components/ui/button';
import { DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { useState } from 'react';
import { ImageIcon, Loader2, X } from 'lucide-react';
import { Announcement, File as FileType } from '@/types';
import useAnnouncement from '@/hooks/useAnnouncement';
import { AnnouncementModel } from '@/schema/announcement.schema';

interface EditAnnouncementModalProps {
    announcement: Announcement;
    onSave: () => void;
    setOpen: (open: boolean) => void;
}

export default function EditAnnouncementModal({ announcement, onSave, setOpen }: EditAnnouncementModalProps) {
    const { handleEditSubmit, files, setFiles, loading, errors, setErrors, handleFileSelect } = useAnnouncement();
    const [formData, setFormData] = useState({
        headline: announcement.headline,
        content: announcement.content,
        audience: announcement.audience,
        existing_files: announcement.files.filter((file) => typeof file !== 'string').map((file) => (file as { _id: string })._id),
        files: announcement.files,
    });

    const handleInputChange = (field: keyof AnnouncementModel, value: string) => {
        setFormData((prev) => ({ ...prev, [field]: value }));
        if (errors[field]) {
            setErrors((prev) => ({ ...prev, [field]: '' }));
        }
    };

    const isLocalFile = (file: string | File | FileType): file is File => file instanceof Blob;

    return (
        <DialogContent className='sm:max-w-[600px] max-h-[80vh] overflow-y-auto'>
            <DialogHeader>
                <DialogTitle>Edit Announcement</DialogTitle>
            </DialogHeader>

            <form onSubmit={(e) => handleEditSubmit(e, onSave, setOpen, formData, announcement)} className='space-y-6'>
                <div className='space-y-2'>
                    <Label htmlFor='headline'>Headline *</Label>
                    <Input id='headline' value={formData.headline} onChange={(e) => handleInputChange('headline', e.target.value)} placeholder='Enter announcement headline' className={errors.headline ? 'border-destructive' : ''} />
                    {errors.headline && <p className='text-sm text-destructive'>{errors.headline}</p>}
                </div>

                <div className='space-y-2'>
                    <Label htmlFor='content'>Content *</Label>
                    <Textarea id='content' value={formData.content} onChange={(e) => handleInputChange('content', e.target.value)} placeholder='Enter announcement content' rows={6} className={errors.content ? 'border-destructive' : ''} />
                    {errors.content && <p className='text-sm text-destructive'>{errors.content}</p>}
                </div>

                <div className='space-y-2'>
                    <Label htmlFor='audience'>Target Audience *</Label>
                    <Select value={formData.audience} onValueChange={(value: 'EVERYONE' | 'DRIVER' | 'COMMUTER') => handleInputChange('audience', value)}>
                        <SelectTrigger className={errors.audience ? 'border-destructive' : ''}>
                            <SelectValue placeholder='Select target audience' />
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem value='EVERYONE'>Everyone</SelectItem>
                            <SelectItem value='DRIVER'>Drivers</SelectItem>
                            <SelectItem value='COMMUTER'>Commuters</SelectItem>
                        </SelectContent>
                    </Select>
                    {errors.audience && <p className='text-sm text-destructive'>{errors.audience}</p>}
                </div>

                <div className='space-y-2'>
                    <Label>Attach Files</Label>
                    <input type='file' multiple className='hidden' id='fileInput' onChange={(e) => handleFileSelect(e.target.files)} />
                    <Button type='button' onClick={() => document.getElementById('fileInput')?.click()}>
                        Upload Files
                    </Button>
                </div>

                {(formData.files.length > 0 || files.length > 0) && (
                    <div className='space-y-2 mt-6'>
                        <Label>Attached Files</Label>
                        <div className='max-h-32 overflow-x-auto border rounded-md p-2 bg-gray-50/50'>
                            <div className='flex gap-2 flex-wrap'>
                                {[...formData.files, ...files].map((file: string | File | FileType, index: number) => {
                                    const isLocal = isLocalFile(file);
                                    const previewUrl = isLocal ? URL.createObjectURL(file) : (file as FileType).file_url;
                                    const fileName = isLocal ? file.name : (file as FileType).file_name;

                                    return (
                                        <div key={index} className='relative flex-shrink-0 w-20 h-20 border rounded-lg overflow-hidden bg-white shadow-sm'>
                                            {(file as File).type?.startsWith('image/') || (file as FileType).file_type?.startsWith('image/') ? (
                                                // eslint-disable-next-line @next/next/no-img-element
                                                <img src={previewUrl} alt={fileName} className='w-full h-full object-cover' />
                                            ) : (
                                                <div className='w-full h-full flex flex-col items-center justify-center p-1'>
                                                    <ImageIcon className='w-6 h-6 text-gray-500' />
                                                    <span className='text-xs text-gray-500 text-center truncate w-full'>{fileName?.split('.').pop()?.toUpperCase()}</span>
                                                </div>
                                            )}
                                            <button
                                                type='button'
                                                onClick={() => {
                                                    if (index < formData.files.length) {
                                                        setFormData((prev) => ({
                                                            ...prev,
                                                            files: prev.files.filter((_, i) => i !== index),
                                                            existing_files: prev.existing_files.filter((_, i) => i !== index),
                                                        }));
                                                    } else {
                                                        const localIndex = index - formData.files.length;
                                                        setFiles((prev) => prev.filter((_, i) => i !== localIndex));
                                                    }
                                                }}
                                                className='absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white rounded-full flex items-center justify-center hover:bg-red-600 transition-colors'
                                            >
                                                <X className='w-3 h-3' />
                                            </button>
                                        </div>
                                    );
                                })}
                            </div>
                        </div>
                    </div>
                )}

                <DialogFooter className='gap-2'>
                    <Button type='button' variant='outline' onClick={() => setOpen(false)} disabled={loading}>
                        Cancel
                    </Button>
                    <Button type='submit' disabled={loading}>
                        {loading ? (
                            <>
                                <Loader2 className='w-4 h-4 mr-2 animate-spin' />
                                Saving...
                            </>
                        ) : (
                            'Save Changes'
                        )}
                    </Button>
                </DialogFooter>
            </form>

            <div className='bg-muted/50 p-4 rounded-lg mt-4'>
                <div className='text-sm text-muted-foreground space-y-1'>
                    <p>
                        <strong>Original Author:</strong> {announcement.posted_by ? `${announcement.posted_by.first_name} ${announcement.posted_by.last_name}` : 'Unknown Author'}
                    </p>
                    <p>
                        <strong>Created:</strong> {new Date(announcement.createdAt || '').toLocaleDateString()}
                    </p>
                    {announcement.updatedAt && (
                        <p>
                            <strong>Last Updated:</strong> {new Date(announcement.updatedAt).toLocaleDateString()}
                        </p>
                    )}
                </div>
            </div>
        </DialogContent>
    );
}
