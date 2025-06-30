'use client';

import { Button } from '@/components/ui/button';
import { DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import useDriverForm from '@/hooks/useDriverForm';
import { getMaxDate } from '@/utils/date.util';

interface AddDriverModalProps {
    setOpen: (bool: boolean) => void;
}

const AddDriverModal = ({ setOpen }: AddDriverModalProps) => {
    const { userFrom, errors, handleInputChange, handleSubmit } = useDriverForm();
    return (
        <>
            <DialogContent className='sm:max-w-md'>
                <DialogHeader>
                    <DialogTitle>Create Driver Account</DialogTitle>
                    <DialogDescription>Fill in the details to create a driver account.</DialogDescription>
                </DialogHeader>
                <form onSubmit={(e) => handleSubmit(e, setOpen)} className='space-y-4'>
                    <div className='grid grid-cols-2 gap-4'>
                        <div className='space-y-2'>
                            <Label htmlFor='first_name'>First Name</Label>
                            <Input id='first_name' value={userFrom.first_name} onChange={(e) => handleInputChange('first_name', e.target.value)} className={errors.first_name ? 'border-red-500' : ''} />
                            {errors.first_name && <p className='text-sm text-red-500'>{errors.first_name}</p>}
                        </div>
                        <div className='space-y-2'>
                            <Label htmlFor='last_name'>Last Name</Label>
                            <Input id='last_name' value={userFrom.last_name} onChange={(e) => handleInputChange('last_name', e.target.value)} className={errors.last_name ? 'border-red-500' : ''} />
                            {errors.last_name && <p className='text-sm text-red-500'>{errors.last_name}</p>}
                        </div>
                    </div>

                    <div className='space-y-2'>
                        <Label htmlFor='middle_name'>Middle Name (Optional)</Label>
                        <Input id='middle_name' value={userFrom.middle_name} onChange={(e) => handleInputChange('middle_name', e.target.value)} />
                    </div>

                    <div className='space-y-2'>
                        <Label htmlFor='email'>Email</Label>
                        <Input id='email' type='email' value={userFrom.email_address} onChange={(e) => handleInputChange('email_address', e.target.value)} className={errors.email ? 'border-red-500' : ''} />
                        {errors.email && <p className='text-sm text-red-500'>{errors.email}</p>}
                    </div>

                    <div className='grid grid-cols-2 gap-4'>
                        <div className='space-y-2'>
                            <Label htmlFor='password'>Password</Label>
                            <Input id='password' type='password' value={userFrom.password_hash} onChange={(e) => handleInputChange('password_hash', e.target.value)} className={errors.password ? 'border-red-500' : ''} />
                            {errors.password && <p className='text-sm text-red-500'>{errors.password}</p>}
                        </div>
                        <div className='space-y-2'>
                            <Label htmlFor='confirm_password'>Confirm Password</Label>
                            <Input id='confirm_password' type='password' value={userFrom.confirmation_password} onChange={(e) => handleInputChange('confirmation_password', e.target.value)} className={errors.confirm_password ? 'border-red-500' : ''} />
                            {errors.confirm_password && <p className='text-sm text-red-500'>{errors.confirm_password}</p>}
                        </div>
                    </div>

                    <div className='space-y-2'>
                        <Label htmlFor='phone_number'>Mobile Number</Label>
                        <div className={'flex'}>
                            <div className='flex items-center gap-2 px-2 border border-r-0 rounded-l-md bg-muted/50'>
                                <span className='text-sm font-bold'>PH</span>
                                <span className='text-sm font-medium'>+63</span>
                            </div>
                            <Input type='tel' value={userFrom.phone_number} onChange={(e) => handleInputChange('phone_number', e.target.value)} className={`${errors.phone_number ? 'border-red-500' : ''} rounded-l-none`} />
                        </div>
                        {errors.phone_number && <p className='text-sm text-red-500'>{errors.phone_number}</p>}
                    </div>

                    <div className='space-y-2'>
                        <Label htmlFor='birthday'>Birthdate</Label>
                        <Input id='birthday' type='date' max={getMaxDate()} value={userFrom.birthday} onChange={(e) => handleInputChange('birthday', e.target.value)} className={errors.birthday ? 'border-red-500' : ''} />
                        {errors.birthday && <p className='text-sm text-red-500'>{errors.birthday}</p>}
                    </div>

                    <Button type='submit' className='w-full text-background'>
                        Create Driver Account
                    </Button>
                </form>
            </DialogContent>
        </>
    );
};

export default AddDriverModal;
