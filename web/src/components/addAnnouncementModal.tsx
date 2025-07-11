'use client';

import { Button } from '@/components/ui/button';
import { DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import useAnnouncement from '@/hooks/useAnnouncement';
import { Textarea } from './ui/textarea';
import { ImageIcon, X } from 'lucide-react';

interface AddAnnouncementModalProps {
    setOpen: (bool: boolean) => void;
}

const AddAnnouncementModal = ({ setOpen }: AddAnnouncementModalProps) => {
    const { announcementForm, errors, handleInputChange, handleSubmit, files, setFiles } = useAnnouncement();
    return (
        <>
            <DialogContent className='sm:max-w-md'>
                <DialogHeader>
                    <DialogTitle>Post Announcement</DialogTitle>
                    <DialogDescription>Fill in the details to create a driver account.</DialogDescription>
                </DialogHeader>
                <form onSubmit={(e) => handleSubmit(e, setOpen)} className='space-y-4'>
                    <div className='space-y-4'>
                        <div className='space-y-2'>
                            <Label htmlFor='headline'>Headline</Label>
                            <Input id='headline' value={announcementForm.headline} onChange={(e) => handleInputChange('headline', e.target.value)} className={errors.headline ? 'border-red-500' : ''} />
                            {errors.headline && <p className='text-sm text-red-500'>{errors.headline}</p>}
                        </div>
                        <div className='space-y-2'>
                            <Label htmlFor='content'>Content</Label>
                            <Textarea id='content' value={announcementForm.content} onChange={(e) => handleInputChange('content', e.target.value)} className={`min-h-[120px] resize-none ${errors.content ? 'border-red-500' : ''}`} rows={5} placeholder='Enter your announcement content...' />
                            {errors.content && <p className='text-sm text-red-500'>{errors.content}</p>}
                        </div>
                        <div className='space-y-2'>
                            <Label htmlFor='file'>Upload File</Label>
                            <Input id='file' type='file' multiple onChange={(e) => setFiles(Array.from(e.target.files || []))} accept='image/*,.pdf,.doc,.docx' />
                        </div>
                    </div>

                    {files && files.length > 0 && (
                        <div className='space-y-2'>
                            <Label>Selected Files</Label>
                            <div className='max-h-32 overflow-x-auto border rounded-md p-2 bg-gray-50/50'>
                                <div className='flex gap-2 flex-wrap'>
                                    {files.map((file, index) => (
                                        <div key={index} className='relative flex-shrink-0 w-20 h-20 border rounded-lg overflow-hidden bg-white shadow-sm'>
                                            {file.type.startsWith('image/') ? (
                                                // eslint-disable-next-line @next/next/no-img-element
                                                <img src={URL.createObjectURL(file) || '/placeholder.svg'} alt={file.name} className='w-full h-full object-cover' />
                                            ) : (
                                                <div className='w-full h-full flex flex-col items-center justify-center p-1'>
                                                    <ImageIcon className='w-6 h-6 text-gray-500' />
                                                    <span className='text-xs text-gray-500 text-center truncate w-full'>{file.name.split('.').pop()?.toUpperCase()}</span>
                                                </div>
                                            )}
                                            <button
                                                type='button'
                                                onClick={() => {
                                                    const newFiles = files.filter((_, i) => i !== index);
                                                    setFiles(newFiles);
                                                }}
                                                className='absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white rounded-full flex items-center justify-center hover:bg-red-600 transition-colors'
                                            >
                                                <X className='w-3 h-3' />
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    )}

                    <Button type='submit' className='w-full text-background'>
                        Post
                    </Button>
                </form>
            </DialogContent>
        </>
    );
};

export default AddAnnouncementModal;
