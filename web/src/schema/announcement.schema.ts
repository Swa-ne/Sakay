import { z } from 'zod';

export const AnnouncementSchema = z.object({
    headline: z.string().min(1, 'Headline is required'),
    content: z.string().min(1, 'Content is required'),
    audience: z.enum(['EVERYONE', 'DRIVER', 'COMMUTER']),
});


export type AnnouncementModel = z.infer<typeof AnnouncementSchema>;