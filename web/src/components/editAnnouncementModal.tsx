'use client';

import type React from 'react';

import { Button } from '@/components/ui/button';
import { DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { useState } from 'react';
import { Loader2 } from 'lucide-react';
import { Announcement } from '@/types';
import useAnnouncement from '@/hooks/useAnnouncement';

interface EditAnnouncementModalProps {
    announcement: Announcement;
    onSave: () => void;
    setOpen: (open: boolean) => void;
}

export default function EditAnnouncementModal({ announcement, onSave, setOpen }: EditAnnouncementModalProps) {
    const { handleEdit } = useAnnouncement();
    const [formData, setFormData] = useState({
        headline: announcement.headline,
        content: announcement.content,
        audience: announcement.audience,
    });
    const [isLoading, setIsLoading] = useState(false);
    const [errors, setErrors] = useState<Record<string, string>>({});

    const validateForm = () => {
        const newErrors: Record<string, string> = {};

        if (!formData.headline.trim()) {
            newErrors.headline = 'Headline is required';
        }

        if (!formData.content.trim()) {
            newErrors.content = 'Content is required';
        }

        if (!formData.audience) {
            newErrors.audience = 'Audience is required';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        if (!validateForm()) {
            return;
        }

        setIsLoading(true);

        try {
            const updatedAnnouncement: Announcement = {
                ...announcement,
                headline: formData.headline.trim(),
                content: formData.content.trim(),
                audience: formData.audience,
                updatedAt: new Date().toISOString(),
            };
            await handleEdit(updatedAnnouncement);

            onSave();
        } catch (error) {
            console.error('Error updating announcement:', error);
            // Handle error appropriately
        } finally {
            setIsLoading(false);
        }
    };

    const handleInputChange = (field: string, value: string) => {
        setFormData((prev) => ({ ...prev, [field]: value }));
        // Clear error when user starts typing
        if (errors[field]) {
            setErrors((prev) => ({ ...prev, [field]: '' }));
        }
    };

    return (
        <DialogContent className='sm:max-w-[600px] max-h-[80vh] overflow-y-auto'>
            <DialogHeader>
                <DialogTitle>Edit Announcement</DialogTitle>
            </DialogHeader>

            <form onSubmit={handleSubmit} className='space-y-6'>
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

                <div className='bg-muted/50 p-4 rounded-lg'>
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

                <DialogFooter className='gap-2'>
                    <Button type='button' variant='outline' onClick={() => setOpen(false)} disabled={isLoading}>
                        Cancel
                    </Button>
                    <Button type='submit' disabled={isLoading}>
                        {isLoading ? (
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
        </DialogContent>
    );
}
