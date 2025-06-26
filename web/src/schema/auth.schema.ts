import { z } from 'zod';

export const LoginUserSchema = z.object({
    user_identifier: z
        .string()
        .min(1, 'Email is required')
        .email('Enter a valid email address'),
    password: z.string().min(1, 'Password is required'),
});

export type LoginUserModel = z.infer<typeof LoginUserSchema>;