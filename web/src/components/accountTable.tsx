'use client';

import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Checkbox } from '@/components/ui/checkbox';
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
    const [selectedIds, setSelectedIds] = useState<string[]>([]);
    const [isConfirmationOpen, setIsConfirmationOpen] = useState(false);
    const [pendingAssignment, setPendingAssignment] = useState<PendingAssignment | null>(null);

    const toggleCheckbox = (id: string) => {
        setSelectedIds((prev) => (prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id]));
    };

    const toggleAllCheckboxes = () => {
        if (selectedIds.length === filteredAccounts.length) {
            setSelectedIds([]);
        } else {
            setSelectedIds(filteredAccounts.map((acc) => acc.id));
        }
    };

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
            <div className='overflow-auto'>
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead className='w-4'>
                                <Checkbox checked={selectedIds.length === filteredAccounts.length && filteredAccounts.length > 0} onCheckedChange={toggleAllCheckboxes} />
                            </TableHead>
                            <TableHead>Name</TableHead>
                            <TableHead>Role</TableHead>
                            <TableHead>Assigned Unit</TableHead>
                            <TableHead>Action</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {filteredAccounts.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={5} className='text-center italic text-muted-foreground'>
                                    No accounts found.
                                </TableCell>
                            </TableRow>
                        ) : (
                            filteredAccounts.map((acc) => (
                                <TableRow key={acc.id}>
                                    <TableCell>
                                        <Checkbox checked={selectedIds.includes(acc.id)} onCheckedChange={() => toggleCheckbox(acc.id)} />
                                    </TableCell>
                                    <TableCell className='font-medium'>{acc.name}</TableCell>
                                    <TableCell className='italic text-muted-foreground'>{acc.role}</TableCell>
                                    <TableCell className='text-sm text-muted-foreground'>{acc.role === 'DRIVER' ? (acc.assignedUnitId ? units.find((u) => u.id === acc.assignedUnitId)?.name || 'Unknown' : 'None') : '-'}</TableCell>
                                    <TableCell>
                                        {acc.role === 'DRIVER' ? (
                                            <select value={acc.assignedUnitId || ''} onChange={(e) => handleAssignmentChange(acc.id, e.target.value)} className='border rounded px-2 py-1 bg-background text-foreground hover:bg-accent transition-colors'>
                                                <option value=''>Unassigned</option>
                                                {units.map((unit) => (
                                                    <option key={unit.id} value={unit.id}>
                                                        {unit.name}
                                                    </option>
                                                ))}
                                            </select>
                                        ) : (
                                            '-'
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
