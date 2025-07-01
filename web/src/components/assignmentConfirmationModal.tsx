'use client';

import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import type { Account, Unit } from '@/types';

interface AssignmentConfirmationModalProps {
    isOpen: boolean;
    onClose: () => void;
    onConfirm: () => void;
    driver: Account | null;
    currentUnit: Unit | null;
    newUnit: Unit | null;
}

export function AssignmentConfirmationModal({ isOpen, onClose, onConfirm, driver, currentUnit, newUnit }: AssignmentConfirmationModalProps) {
    if (!driver) return null;

    const isUnassigning = !newUnit;
    const isReassigning = currentUnit && newUnit;
    const isAssigning = !currentUnit && newUnit;

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className='sm:max-w-md'>
                <DialogHeader>
                    <DialogTitle>
                        {isUnassigning && 'Unassign Driver'}
                        {isAssigning && 'Assign Driver to Unit'}
                        {isReassigning && 'Reassign Driver'}
                    </DialogTitle>
                    <DialogDescription>Please confirm the following assignment change:</DialogDescription>
                </DialogHeader>

                <div className='space-y-4 py-4'>
                    <div className='grid grid-cols-2 gap-4 text-sm'>
                        <div>
                            <span className='font-medium text-muted-foreground'>Driver:</span>
                            <p className='font-medium'>{driver.name}</p>
                        </div>
                    </div>

                    <div className='border-t pt-4'>
                        <div className='grid grid-cols-2 gap-4 text-sm'>
                            <div>
                                <span className='font-medium text-muted-foreground'>Current Assignment:</span>
                                <p className={currentUnit ? 'font-medium' : 'text-muted-foreground italic'}>{currentUnit ? currentUnit.name : 'None'}</p>
                            </div>
                            <div>
                                <span className='font-medium text-muted-foreground'>New Assignment:</span>
                                <p className={newUnit ? 'font-medium text-green-600' : 'text-muted-foreground italic'}>{newUnit ? newUnit.name : 'Unassigned'}</p>
                            </div>
                        </div>
                    </div>

                    {isReassigning && (
                        <div className='bg-yellow-50 border border-yellow-200 rounded-md p-3'>
                            <p className='text-sm text-yellow-800'>
                                <strong>Warning:</strong> This driver will be reassigned from {currentUnit?.name} to {newUnit?.name}.
                            </p>
                        </div>
                    )}
                </div>

                <DialogFooter className='flex gap-2'>
                    <Button variant='outline' onClick={onClose}>
                        Cancel
                    </Button>
                    <Button onClick={onConfirm} className='bg-primary hover:bg-blue-700 text-background'>
                        {isUnassigning && 'Confirm Unassignment'}
                        {isAssigning && 'Confirm Assignment'}
                        {isReassigning && 'Confirm Reassignment'}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
}
