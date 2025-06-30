'use client';

import { Button } from '@/components/ui/button';
import { DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import useUnitForm from '@/hooks/useUnitForm';

interface AddUnitModalProps {
    setOpen: (bool: boolean) => void;
}

const AddUnitModal = ({ setOpen }: AddUnitModalProps) => {
    const { unitForm, errors, handleInputChange, handleSubmit } = useUnitForm();
    return (
        <>
            <DialogContent className='sm:max-w-md'>
                <DialogHeader>
                    <DialogTitle>Create Unit Account</DialogTitle>
                    <DialogDescription>Fill in the details to create a driver account.</DialogDescription>
                </DialogHeader>
                <form onSubmit={(e) => handleSubmit(e, setOpen)} className='space-y-4'>
                    <div className='grid grid-cols-2 gap-4'>
                        <div className='space-y-2'>
                            <Label htmlFor='bus_number'>Bus Number</Label>
                            <Input id='bus_number' value={unitForm.bus_number} onChange={(e) => handleInputChange('bus_number', e.target.value)} className={errors.bus_number ? 'border-red-500' : ''} />
                            {errors.bus_number && <p className='text-sm text-red-500'>{errors.bus_number}</p>}
                        </div>
                        <div className='space-y-2'>
                            <Label htmlFor='plate_number'>Plate Number</Label>
                            <Input id='plate_number' value={unitForm.plate_number} onChange={(e) => handleInputChange('plate_number', e.target.value)} className={errors.plate_number ? 'border-red-500' : ''} />
                            {errors.plate_number && <p className='text-sm text-red-500'>{errors.plate_number}</p>}
                        </div>
                    </div>

                    {/* <div className='space-y-2'>
                        <Label htmlFor='email'>Email</Label>
                        <Input id='email' type='email' value={unitForm.email_address} onChange={(e) => handleInputChange('email_address', e.target.value)} className={errors.email ? 'border-red-500' : ''} />
                        {errors.email && <p className='text-sm text-red-500'>{errors.email}</p>}
                    </div> */}
                    <Button type='submit' className='w-full text-background'>
                        Create Unit Account
                    </Button>
                </form>
            </DialogContent>
        </>
    );
};

export default AddUnitModal;
