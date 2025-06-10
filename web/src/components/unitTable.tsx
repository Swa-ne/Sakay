import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Checkbox } from '@/components/ui/checkbox';
import { useState } from 'react';
import { Account, Unit } from '@/app/(protected)/account_and_units/page';

export function UnitsTable({ units, drivers }: { units: Unit[]; drivers: Account[] }) {
    const [selectedUnitIds, setSelectedUnitIds] = useState<number[]>([]);

    const toggleUnit = (id: number) => {
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
        <div className='overflow-auto'>
            <Table>
                <TableHeader>
                    <TableRow>
                        <TableHead className='w-4'>
                            <Checkbox checked={selectedUnitIds.length === units.length && units.length > 0} onCheckedChange={toggleAllUnits} />
                        </TableHead>
                        <TableHead>Unit Name</TableHead>
                        <TableHead>Bus Number</TableHead>
                        <TableHead>Plate Number</TableHead>
                        <TableHead>Assigned Driver</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {units.length === 0 ? (
                        <TableRow>
                            <TableCell colSpan={5} className='text-center italic text-muted-foreground'>
                                No units found.
                            </TableCell>
                        </TableRow>
                    ) : (
                        units.map((unit) => (
                            <TableRow key={unit.id}>
                                <TableCell>
                                    <Checkbox checked={selectedUnitIds.includes(unit.id)} onCheckedChange={() => toggleUnit(unit.id)} />
                                </TableCell>
                                <TableCell className='font-medium'>{unit.name}</TableCell>
                                <TableCell>{unit.bus_number || '-'}</TableCell>
                                <TableCell>{unit.plate_number || '-'}</TableCell>
                                <TableCell>{unit.assignedDriverId ? drivers.find((d) => d.id === unit.assignedDriverId)?.name || 'Unknown' : 'None'}</TableCell>
                            </TableRow>
                        ))
                    )}
                </TableBody>
            </Table>
        </div>
    );
}
