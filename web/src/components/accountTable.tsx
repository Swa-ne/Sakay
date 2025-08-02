'use client';

import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { useState } from 'react';
import type { Account, Unit } from '@/types';
import { AssignmentConfirmationModal } from './assignmentConfirmationModal';

interface PendingAssignment {
    driverId: string;
    newUnitId?: string;
}
interface AccountTableProps {
    filteredAccounts: Account[];
    units: Unit[];
    assignDriverToUnit: (userId: string, unitId?: string) => void;
}

export function AccountTable({ filteredAccounts, units, assignDriverToUnit }: AccountTableProps) {
    const [isConfirmationOpen, setIsConfirmationOpen] = useState(false);
    const [pendingAssignment, setPendingAssignment] = useState<PendingAssignment | null>(null);

    const handleAssignmentChange = (driverId: string, newUnitId?: string) => {
        const driver = filteredAccounts.find((acc) => acc.id === driverId);
        if (!driver) return;

        const currentUnitId = driver.assignedUnitId;
        if (currentUnitId === newUnitId) return;

        setPendingAssignment({ driverId, newUnitId });
        setIsConfirmationOpen(true);
    };

    const handleConfirmAssignment = () => {
        if (pendingAssignment) {
            assignDriverToUnit(pendingAssignment.driverId, pendingAssignment.newUnitId);
        }
        setIsConfirmationOpen(false);
        setPendingAssignment(null);
    };

    const handleCancelAssignment = () => {
        setIsConfirmationOpen(false);
        setPendingAssignment(null);
    };

    const getModalData = () => {
        if (!pendingAssignment) return { driver: null, currentUnit: null, newUnit: null };

        const driver = filteredAccounts.find((acc) => acc.id === pendingAssignment.driverId);
        const currentUnit = driver?.assignedUnitId ? units.find((u) => u.id === driver.assignedUnitId) || null : null;
        const newUnit = pendingAssignment.newUnitId ? units.find((u) => u.id === pendingAssignment.newUnitId) || null : null;

        return { driver: driver || null, currentUnit, newUnit };
    };

    const { driver, currentUnit, newUnit } = getModalData();

    return (
        <>
            <div className='overflow-x-auto'>
                <Table className='min-w-full'>
                    <TableHeader>
                        <TableRow className='h-12'>
                            <TableHead className='text-xs sm:text-sm h-12'>Name</TableHead>
                            <TableHead className='text-xs sm:text-sm hidden sm:table-cell h-12'>Role</TableHead>
                            <TableHead className='text-xs sm:text-sm hidden md:table-cell h-12'>Assigned Unit</TableHead>
                            <TableHead className='text-xs sm:text-sm h-12'>Action</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {filteredAccounts.length === 0 ? (
                            <TableRow className='h-12'>
                                <TableCell colSpan={4} className='text-center italic text-muted-foreground text-xs sm:text-sm h-12'>
                                    No accounts found.
                                </TableCell>
                            </TableRow>
                        ) : (
                            filteredAccounts.map((acc, idx) => (
                                <TableRow key={`${acc.id} + ${idx}`} className='h-12'>
                                    <TableCell className='font-medium text-xs sm:text-sm h-12'>
                                        <div className='flex flex-col justify-center h-full'>
                                            <div className='font-medium'>{acc.name}</div>
                                            <div className='text-xs text-muted-foreground sm:hidden'>{acc.role}</div>
                                        </div>
                                    </TableCell>
                                    <TableCell className='italic text-muted-foreground text-xs sm:text-sm hidden sm:table-cell h-12 flex items-center'>{acc.role}</TableCell>
                                    <TableCell className='text-xs sm:text-sm text-muted-foreground hidden md:table-cell h-12 flex items-center'>{acc.role === 'DRIVER' ? (acc.assignedUnitId ? units.find((u) => u.id === acc.assignedUnitId)?.name || 'Unknown' : 'None') : '-'}</TableCell>
                                    <TableCell className='h-12 flex items-center'>
                                        {acc.role === 'DRIVER' ? (
                                            <select value={acc.assignedUnitId || ''} onChange={(e) => handleAssignmentChange(acc.id, e.target.value)} className='border rounded px-1 sm:px-2 py-1 bg-background text-foreground hover:bg-accent transition-colors text-xs sm:text-sm'>
                                                <option value=''>Unassigned</option>
                                                {units.map((unit) => (
                                                    <option key={unit.id} value={unit.id}>
                                                        {unit.name}
                                                    </option>
                                                ))}
                                            </select>
                                        ) : (
                                            <span className='text-xs sm:text-sm'>-</span>
                                        )}
                                    </TableCell>
                                </TableRow>
                            ))
                        )}
                    </TableBody>
                </Table>
            </div>

            <AssignmentConfirmationModal isOpen={isConfirmationOpen} onClose={handleCancelAssignment} onConfirm={handleConfirmAssignment} driver={driver} currentUnit={currentUnit} newUnit={newUnit} />
        </>
    );
}
