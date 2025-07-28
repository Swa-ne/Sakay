import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Checkbox } from '@/components/ui/checkbox';
import { useState } from 'react';
import { Account, Unit } from '@/types';

export function UnitsTable({ units, drivers }: { units: Unit[]; drivers: Account[] }) {
    const [selectedUnitIds, setSelectedUnitIds] = useState<string[]>([]);

    const toggleUnit = (id: string) => {
        setSelectedUnitIds((prev) => (prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id]));
    };

    const toggleAllUnits = () => {
        if (selectedUnitIds.length === units.length) {
            setSelectedUnitIds([]);
        } else {
            setSelectedUnitIds(units.map((u) => u.id));
        }
    };

    return (
        <div className='overflow-x-auto'>
            <Table className='min-w-full'>
                <TableHeader>
                    <TableRow className='h-12'>
                        <TableHead className='w-8 sm:w-12 h-12'>
                            <Checkbox checked={selectedUnitIds.length === units.length && units.length > 0} onCheckedChange={toggleAllUnits} />
                        </TableHead>
                        <TableHead className='text-xs sm:text-sm h-12'>Unit Name</TableHead>
                        <TableHead className='text-xs sm:text-sm hidden sm:table-cell h-12'>Bus Number</TableHead>
                        <TableHead className='text-xs sm:text-sm hidden md:table-cell h-12'>Plate Number</TableHead>
                        <TableHead className='text-xs sm:text-sm hidden lg:table-cell h-12'>Assigned Driver</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {units.length === 0 ? (
                        <TableRow className='h-12'>
                            <TableCell colSpan={5} className='text-center italic text-muted-foreground text-xs sm:text-sm h-12'>
                                No units found.
                            </TableCell>
                        </TableRow>
                    ) : (
                        units.map((unit) => (
                            <TableRow key={unit.id} className='h-12'>
                                <TableCell className='h-12'>
                                    <Checkbox checked={selectedUnitIds.includes(unit.id)} onCheckedChange={() => toggleUnit(unit.id)} />
                                </TableCell>
                                <TableCell className='font-medium text-xs sm:text-sm h-12'>
                                    <div className='flex flex-col justify-center h-full'>
                                        <div className='font-medium'>{unit.name}</div>
                                        <div className='text-xs text-muted-foreground sm:hidden'>
                                            {unit.bus_number || '-'} • {unit.plate_number || '-'}
                                        </div>
                                        <div className='text-xs text-muted-foreground lg:hidden'>{unit.assignedDriverId ? drivers.find((d) => d.id === unit.assignedDriverId)?.name || 'Unknown' : 'None'}</div>
                                    </div>
                                </TableCell>
                                <TableCell className='text-xs sm:text-sm hidden sm:table-cell h-12 flex items-center'>{unit.bus_number || '-'}</TableCell>
                                <TableCell className='text-xs sm:text-sm hidden md:table-cell h-12 flex items-center'>{unit.plate_number || '-'}</TableCell>
                                <TableCell className='text-xs sm:text-sm hidden lg:table-cell h-12 flex items-center'>
                                    {unit.assignedDriverId
                                        ? drivers.find((d) => {
                                              return d.id === unit.assignedDriverId;
                                          })?.name || 'Unknown'
                                        : 'None'}
                                </TableCell>
                            </TableRow>
                        ))
                    )}
                </TableBody>
            </Table>
        </div>
    );
}
