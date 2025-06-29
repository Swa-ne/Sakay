import { z } from 'zod';
import { isValid, parseISO, differenceInYears } from 'date-fns';

export const BusSchema = z.object({
    bus_number: z
        .string()
        .min(1, 'Bus number is required'),
    plate_number: z
        .string()
        .min(1, 'Plate number is required'),
});

export const UserSchema = z
    .object({
        email: z
            .string()
            .min(1, 'Email is required')
            .email('Enter a valid email address'),
        password: z
            .string()
            .min(8, 'Password must be at least 8 characters long')
            .refine((val) => /[A-Z]/.test(val), {
                message: 'At least one uppercase letter is required',
            })
            .refine((val) => /[a-z]/.test(val), {
                message: 'At least one lowercase letter is required',
            })
            .refine((val) => /\d/.test(val), {
                message: 'At least one number is required',
            })
            .refine((val) => /[^a-zA-Z0-9]/.test(val), {
                message: 'At least one special character is required',
            }),
        confirm_password: z.string().min(1, 'Confirm password is required'),
        first_name: z.string().min(1, 'First name is required'),
        middle_name: z.string(),
        last_name: z.string().min(1, 'Last name is required'),
        phone_number: z
            .string()
            .min(1, 'Phone number is required')
            .regex(/^(\+63|0)?9\d{9}$/, 'Enter a valid phone number'),
        birthday: z
            .string()
            .min(1, 'Birthday is required')
            .refine((val) => {
                const date = parseISO(val);
                return isValid(date) && differenceInYears(new Date(), date) >= 18;
            }, {
                message: 'You must be at least 18 years old',
            }),
    })
    .refine((data) => data.password === data.confirm_password, {
        message: "Passwords don't match",
        path: ['confirm_password'],
    });

export type BusModel = z.infer<typeof BusSchema>;
export type UserModel = z.infer<typeof UserSchema>;