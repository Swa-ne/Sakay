import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Checkbox } from '@/components/ui/checkbox';
import { useState } from 'react';
import { Account, Unit } from '@/app/(protected)/account_and_units/page';

export function AccountTable({ filteredAccounts, units, assignDriverToUnit }: { filteredAccounts: Account[]; units: Unit[]; assignDriverToUnit: (userId: number, unitId?: number) => void }) {
    const [selectedIds, setSelectedIds] = useState<number[]>([]);

    const toggleCheckbox = (id: number) => {
        setSelectedIds((prev) => (prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id]));
    };

    const toggleAllCheckboxes = () => {
        if (selectedIds.length === filteredAccounts.length) {
            setSelectedIds([]);
        } else {
            setSelectedIds(filteredAccounts.map((acc) => acc.id));
        }
    };

    return (
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
                                <TableCell className='text-sm text-muted-foreground'>{acc.role === 'driver' ? (acc.assignedUnitId ? units.find((u) => u.id === acc.assignedUnitId)?.name || 'Unknown' : 'None') : '-'}</TableCell>
                                <TableCell>
                                    {acc.role === 'driver' ? (
                                        <select value={acc.assignedUnitId || ''} onChange={(e) => assignDriverToUnit(acc.id, Number(e.target.value) || undefined)} className='border rounded px-2 py-1 bg-background text-foreground'>
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
    );
}
